defmodule Credo.Check.Readability.NamedImportsTest do
  {:ok, _} = Application.ensure_all_started(:credo)
  use Credo.Test.Case

  alias Credo.Check.Readability.NamedImports

  test "it should not raise an issue" do
    """
    defmodule AModule do 
        import MyApp.Common, only: [hello_world: 0]
    end 
    """
    |> to_source_file()
    |> run_check(NamedImports)
    |> refute_issues()
  end

  test "raises an issue due to unnamed import" do
    """
    defmodule AModule do 
        import MyApp.Common
    end 
    """
    |> to_source_file()
    |> run_check(NamedImports)
    |> assert_issue()
  end

  test "Ecto.Query is whitelisted" do
    """
    defmodule AModule do 
        import Ecto.Query
    end 
    """
    |> to_source_file()
    |> run_check(NamedImports)
    |> refute_issues()
  end

  test "Some types of modules are whitelisted (views, tests, etc)" do
    """
    defmodule AModule do 
      import SomeFancyModuleView
    end 
    """
    |> to_source_file()
    |> run_check(NamedImports)
    |> refute_issues()
  end

  test "Modules can be ignored" do
    """
    defmodule MyApp.ModuleTest do 
      import PacksizeData.ConnCase
    end   
    """
    |> to_source_file()
    |> run_check(NamedImports)
    |> refute_issues()
  end
end
