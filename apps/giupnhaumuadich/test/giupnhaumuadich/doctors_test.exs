defmodule Giupnhaumuadich.DoctorsTest do
  use Giupnhaumuadich.DataCase
  alias Giupnhaumuadich.Doctors

  describe "create doctor" do
    test "without categories" do
      assert {:ok, _} = Doctors.create(%{name: "Trần Văn An", phone: "0909090909"})
    end

    test "with categories" do
      assert {:ok, %{categories: [_ | _]}} =
               %{
                 name: "Trần Văn An",
                 phone: "0909090909",
                 categories: [%{name: "some category"}]
               }
               |> Doctors.create()
    end
  end
end
