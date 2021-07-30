defmodule Giupnhaumuadich.Fixtures do
  alias Giupnhaumuadich.{Categories, Doctors, MedicalRecords}

  def category_fixture(params \\ %{}) do
    {:ok, entity} =
      params
      |> Enum.into(%{name: "tiểu đường"})
      |> Categories.create()

    entity
  end

  def doctor_fixture(params \\ %{}) do
    {:ok, entity} =
      params
      |> Enum.into(%{name: "Trần Văn An", phone: "0909090909"})
      |> Doctors.create()

    entity
  end

  def medical_record_fixture(params \\ %{})

  def medical_record_fixture(params = %{category_id: _}) do
    {:ok, entity} =
      params
      |> Enum.into(%{
        name: "Người dùng A",
        phone: "0909090909",
        birthday: "2000-01-01",
        region: %{
          address: "100 Đường Mai Thị Lưu, Phường 11, Quận 1, TP.HCM"
        }
      })
      |> MedicalRecords.create()

    entity
  end

  def medical_record_fixture(params) do
    category = category_fixture()

    params
    |> Map.put(:category_id, category.id)
    |> medical_record_fixture()
  end
end
