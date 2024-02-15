defmodule Postbox.Repo do
  use Ecto.Repo,
    otp_app: :postbox,
    adapter: Ecto.Adapters.Postgres
end
