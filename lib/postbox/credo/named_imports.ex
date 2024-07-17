defmodule Credo.Check.Readability.NamedImports do
  @moduledoc """
  Checks that the codebase only has "named" imports ie:

  `import Postbox.Logistics, only: [my_func: 1]`

  Importing entire modules can make code difficult to read/navigate in such cases 
  `alias` should be used so the external module is always at hand.

  Exceptions to this rule are well established libraries like `Ecto.Query` where 
  multiple calls such as `from`, `where`, `join`, etc. in a pipechain are intuitively 
  from `Query` and most people would know that from context.

  You can add exceptions by adding libraries or packages `allowed_modules` below.
  `:Ecto` is a broad exception, `:Query` is specific ;).
  """

  use Credo.Check,
    base_priority: :normal,
    category: :readability,
    exit_status: 0,
    param_defaults: [reject: []],
    explanations: [
      check: """
      For readability and overall comprehension, as much as possible, modules should be 
      aliased rather than imported. Always favour `alias MyApp.MyModule` over `import MyApp.MyModule`
      calling `MyModule.function` is much easier to reason about then calling `function`.
      """,
      params: [reject: "A warning about module imports"]
    ]

  require Logger

  @allowed_imports ~w[Ecto HTML Factory TestFileSupport Config]a
  @allowed_regex ~w[view test factory]
  @allowed_modules ~w[test conn]

  @doc false
  @impl true
  def run(%SourceFile{} = source_file, params) do
    issue_meta = IssueMeta.for(source_file, params)

    issue_template =
      format_issue(issue_meta,
        message: "Consider using an alias or importing specific functions only"
      )

    if skip_file?(source_file),
      do: [],
      else: Credo.Code.prewalk(source_file, &traverse(&1, &2, issue_template))
  end

  defp skip_file?(source_file) do
    source_file
    |> SourceFile.ast()
    |> check_eligibility()
  end

  @doc false
  @spec traverse(Macro.t(), [Credo.Issue.t()], Credo.Issue.t()) :: [Credo.Issue.t()] | []
  def traverse(ast, issues, template),
    do: {ast, add_issue(issues, issue(ast, template))}

  defp add_issue(issues, nil), do: issues
  defp add_issue(issues, issue), do: [issue | issues]

  defp issue({:import, meta, [{:__aliases__, _, modules}]}, template) do
    if module_matching(modules),
      do: nil,
      else: issue_for(template, meta[:line])
  end

  defp issue({:import, meta, [{:__alaises__, _, _}, opts]}, template) do
    if Keyword.has_key?(opts, :only), do: nil, else: issue_for(template, meta[:line])
  end

  defp issue(_line, _meta), do: nil

  defp module_matching([]), do: false

  defp module_matching(modules) do
    check = fn irr ->
      term = Atom.to_string(irr)
      irr in @allowed_imports or Enum.any?(@allowed_regex, &String.match?(term, ~r/#{&1}/i))
    end

    Enum.any?(
      modules,
      &check.(&1)
    )
  end

  defp issue_for(issue_template, line_no) do
    %Credo.Issue{issue_template | line_no: line_no}
  end

  defp check_eligibility({:defmodule, _, [{:__aliases__, _, namespaces} | _]}) do
    [module | _] = Enum.reverse(namespaces)
    Enum.any?(@allowed_modules, &String.match?(Atom.to_string(module), ~r/#{&1}/i))
  end

  defp check_eligibility(_fallback), do: false
end
