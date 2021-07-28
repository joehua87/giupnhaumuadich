defmodule GiupnhaumuadichWeb.UploadController do
  use GiupnhaumuadichWeb, :controller

  def get(conn, %{"id" => id}) do
    file = get_file(id)
    mime = MIME.from_path(file)

    conn
    |> put_resp_header("content-type", mime)
    |> send_file(200, file)
  end

  def create(conn, %{"files" => files}) do
    ids = upload(files)
    json(conn, %{"ids" => ids})
  end

  defp upload(list) when is_list(list) do
    for {:ok, id} <- Task.async_stream(list, &upload/1, max_concurrency: 4), into: [] do
      id
    end
  end

  defp upload(%Plug.Upload{content_type: content_type, path: path}) do
    with [ext | _] <- MIME.extensions(content_type),
         {:ok, content} <- File.read(path),
         hash <- :crypto.hash(:md5, content) |> Base.encode16(case: :lower),
         id <- "#{hash}.#{ext}",
         output_file <- get_file(id),
         :ok <- File.mkdir_p(Path.dirname(output_file)) do
      File.copy(path, output_file)
      id
    end
  end

  defp get_file(id) do
    Path.join([Application.get_env(:giupnhaumuadich, :upload_dir), id])
  end
end
