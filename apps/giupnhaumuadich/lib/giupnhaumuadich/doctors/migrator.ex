defmodule Giupnhaumuadich.Doctors.Migrator do
  def parse_item(%{
        "cellValuesByColumnId" => item
      }) do
    name = item["fldaka7LTsxd2ZaTI"]
    phone = item["fld8llIMbpEthLK4x"]
    categories = item["fldOd5BV8kS6ecWUa"]
    facebook_group_link = item["fldWrYeKIMnCwRkuV"]

    schedule_text =
      case get_in(item, ["fldiSbhuoVg9dtjvb", "documentValue"]) do
        nil -> nil
        [] -> nil
        [%{"insert" => v} | _] -> String.trim(v)
      end

    %{
      name: name,
      phone: phone,
      schedule_text: schedule_text,
      categories: categories,
      links:
        case facebook_group_link do
          nil -> []
          _ -> [%{type: "facebook_group", url: facebook_group_link}]
        end
    }
  end

  def parse_item(_), do: nil

  @doc """
  Parse doctors from AirTable
  """
  def parse_doctors(input_file, output_file) do
    json =
      input_file
      |> File.read!()
      |> Jason.decode!()
      |> Enum.map(&parse_item/1)
      |> Jason.encode!()

    File.write(output_file, json)
  end
end
