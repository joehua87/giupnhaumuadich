defmodule Giupnhaumuadich.Spreadsheets do
  import GoogleApi.Sheets.V4.Api.Spreadsheets

  def read_doc(conn, spreadsheet_id, range) when is_bitstring(range) do
    {:ok, %{values: values}} =
      sheets_spreadsheets_values_get(
        conn,
        spreadsheet_id,
        range
      )

    values
    |> rows_to_items()
  end

  def read_sheet_ids(conn, spreadsheet_id) do
    with {:ok, %GoogleApi.Sheets.V4.Model.Spreadsheet{sheets: sheets}} <-
           sheets_spreadsheets_get(conn, spreadsheet_id) do
      {:ok,
       Enum.map(sheets, fn %GoogleApi.Sheets.V4.Model.Sheet{properties: %{title: title}} ->
         title
       end)}
    end
  end

  defp rows_to_items([headers | rows]) when is_list(headers) and is_list(rows) do
    headers = Enum.map(headers, &normalize_cell/1)

    rows
    |> Enum.filter(&(Enum.at(&1, 0) != nil))
    |> Enum.map(fn row ->
      headers
      |> Enum.with_index()
      |> Enum.map(fn {header, index} ->
        {header, normalize_cell(Enum.at(row, index))}
      end)
      |> Enum.into(%{})
    end)
  end

  def get_connection do
    {:ok, token} = Goth.Token.for_scope("https://www.googleapis.com/auth/spreadsheets")
    GoogleApi.Sheets.V4.Connection.new(token.token)
  end

  def valid_key?(code) when is_bitstring(code) do
    String.length(code) >= 2
  end

  defp normalize_cell(nil), do: nil

  defp normalize_cell(value) do
    case String.trim(value) do
      "" ->
        nil

      v ->
        v
        |> String.replace("\b", "")
        |> String.replace("\r", "")
        |> String.replace(<<29>>, "")
        |> String.replace(<<08>>, "")
        |> to_string()
    end
  end
end
