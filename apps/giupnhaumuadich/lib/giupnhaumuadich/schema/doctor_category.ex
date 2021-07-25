defmodule Giupnhaumuadich.DoctorCategory do
  use Giupnhaumuadich.Schema

  @primary_key false

  schema "doctor_categories" do
    belongs_to :doctor, Giupnhaumuadich.Doctor, primary_key: true
    belongs_to :category, Giupnhaumuadich.Category, primary_key: true
  end
end
