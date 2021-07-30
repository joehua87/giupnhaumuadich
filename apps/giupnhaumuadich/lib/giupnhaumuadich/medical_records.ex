defmodule Giupnhaumuadich.MedicalRecords do
  alias Giupnhaumuadich.{Repo, MedicalRecord, Doctor}
  import Ecto.Changeset

  def create(params) do
    params
    |> MedicalRecord.new()
    |> Repo.insert()
  end

  def transit(%MedicalRecord{state: :completed}, _action, %Doctor{}) do
    {:error, "Cannot transit completed record"}
  end

  def transit(
        %MedicalRecord{state: :in_process, doctor_id: doctor_id} = entity,
        :return,
        %Doctor{id: doctor_id}
      ) do
    entity
    |> change(state: :pending, doctor_id: nil)
    |> Repo.update()
  end

  def transit(
        %MedicalRecord{state: :in_process, doctor_id: doctor_id} = entity,
        :complete,
        %Doctor{id: doctor_id}
      ) do
    entity
    |> change(state: :completed)
    |> Repo.update()
  end

  def transit(%MedicalRecord{state: :in_process}, _action, %Doctor{}) do
    {:error, "Cannot transit record of another doctor"}
  end

  def transit(%MedicalRecord{state: :pending} = entity, :process, %Doctor{id: doctor_id}) do
    entity
    |> change(state: :in_process, doctor_id: doctor_id)
    |> Repo.update()
  end

  def get_next_states(%MedicalRecord{state: :completed}, %Doctor{}), do: []

  def get_next_states(
        %MedicalRecord{state: :in_process, doctor_id: doctor_id},
        %Doctor{id: doctor_id}
      ) do
    [:process, :complete]
  end

  def get_next_states(%MedicalRecord{state: :pending}, %Doctor{}), do: [:process]
end
