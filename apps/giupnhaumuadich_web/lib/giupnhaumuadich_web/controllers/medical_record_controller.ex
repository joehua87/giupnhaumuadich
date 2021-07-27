defmodule GiupnhaumuadichWeb.MedicalRecordController do
  use GiupnhaumuadichWeb, :controller

  alias Giupnhaumuadich.{Repo, MedicalRecord}

  def create(conn, params) do
    MedicalRecord.new(params) |> Repo.insert()
    json(conn, %{ok: 1})
  end
end
