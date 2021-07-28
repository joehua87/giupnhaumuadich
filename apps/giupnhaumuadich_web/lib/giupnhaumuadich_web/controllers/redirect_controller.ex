defmodule GiupnhaumuadichWeb.RedirectController do
  use GiupnhaumuadichWeb, :controller

  def get(conn = %{path_info: [prefix | _]}, %{"path" => path}) do
    external_url = "https://localhost:3000/#{prefix}/#{Enum.join(path, "/")}"
    redirect(conn, external: external_url)
  end
end
