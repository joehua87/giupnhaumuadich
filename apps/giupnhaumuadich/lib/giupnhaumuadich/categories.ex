defmodule Giupnhaumuadich.Categories do
  alias Giupnhaumuadich.{Spreadsheets, Repo, Category}

  @spreadsheet_id "1ngEZPAZ8Ql6D3sKvvnmMuhLFghP5hE09v4f-j_BeIQ4"

  def upsert_from_spreadsheet() do
    conn = Spreadsheets.get_connection()

    categories =
      conn
      |> Spreadsheets.read_doc(@spreadsheet_id, "categories!A:Z")
      |> Enum.map(&parse_category/1)

    Repo.insert_all(Category, categories, on_conflict: :nothing)
  end

  defp parse_category(%{
         "description" => description,
         "medical_record_fields" => "[]",
         "name" => name,
         "symptoms" => symptoms,
         "tags" => tags
       }) do
    slug = Slug.slugify(name)
    symptoms = parse_string_list(symptoms)
    tags = parse_string_list(tags)

    %{
      slug: slug,
      name: name,
      description: description,
      tags: tags,
      symptoms: symptoms
    }
  end

  defp parse_string_list(nil), do: []

  defp parse_string_list("" <> text) do
    String.split(text, ";", trim: true) |> Enum.map(&String.trim/1) |> Enum.filter(&(&1 != ""))
  end
end
