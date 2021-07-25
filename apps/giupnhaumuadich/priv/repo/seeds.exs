# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Giupnhaumuadich.Repo.insert!(%Giupnhaumuadich.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Giupnhaumuadich.{Repo, Category, Doctor, DoctorCategory}

dir = Path.dirname(__ENV__.file)

categories =
  dir
  |> Path.join("categories.json")
  |> File.read!()
  |> Jason.decode!()
  |> Enum.map(fn {_, %{"id" => id, "name" => name}} ->
    name = String.downcase(name)

    %{
      id: Ecto.UUID.generate(),
      slug: Slug.slugify(name),
      name: name,
      old_id: id
    }
  end)

categories_map = Enum.map(categories, &{&1.old_id, &1.id}) |> Enum.into(%{})
categories = Enum.map(categories, &Map.delete(&1, :old_id))

doctors =
  dir
  |> Path.join("doctors.json")
  |> File.read!()
  |> Jason.decode!(keys: :atoms)
  |> Enum.filter(&Map.has_key?(&1, :phone))
  |> Enum.map(fn item = %{name: name, categories: categories, phone: phone} ->
    Map.merge(item, %{
      id: Ecto.UUID.generate(),
      code: Doctor.make_code(),
      categories: Enum.map(categories, &Map.get(categories_map, &1)),
      phone: String.replace(phone, ~r/\D/, ""),
      slug: Slug.slugify(name)
    })
  end)
  |> Enum.uniq(& &1.phone)

doctor_categories =
  Enum.flat_map(doctors, fn %{id: id, categories: categories} ->
    Enum.map(categories, &%{category_id: &1, doctor_id: id})
  end)

doctors = Enum.map(doctors, &Map.delete(&1, :categories))

import Ecto.Query, only: [from: 2]

Repo.insert_all(Category, categories, returning: true)
Repo.insert_all(Doctor, doctors)
Repo.insert_all(DoctorCategory, doctor_categories)

Repo.update_all(
  from(c in Category,
    update: [
      set: [
        doctor_count:
          fragment("SELECT COUNT(doctor_id) from doctor_categories WHERE category_id = ?", c.id)
      ]
    ]
  ),
  []
)
