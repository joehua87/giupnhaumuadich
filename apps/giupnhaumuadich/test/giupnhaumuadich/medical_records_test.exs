defmodule Giupnhaumuadich.MedicalRecordsTest do
  use Giupnhaumuadich.DataCase
  import Giupnhaumuadich.{AccountsFixtures, Fixtures}
  alias Giupnhaumuadich.MedicalRecords

  describe "create" do
    test "valid" do
      category = category_fixture()

      assert {:ok, %{state: :pending}} =
               MedicalRecords.create(%{
                 name: "Người dùng A",
                 phone: "0909090909",
                 birthday: "2000-01-01",
                 region: %{
                   address: "100 Đường Mai Thị Lưu, Phường 11, Quận 1, TP.HCM"
                 },
                 category_id: category.id
               })
    end
  end

  describe "transit medical record" do
    test "process", %{medical_record: medical_record, doctor: doctor = %{id: doctor_id}} do
      assert {:ok,
              %{
                doctor_id: ^doctor_id,
                state: :in_process
              }} = MedicalRecords.transit(medical_record, :process, doctor)
    end

    test "complete", %{medical_record: medical_record, doctor: doctor = %{id: doctor_id}} do
      {:ok, medical_record} = MedicalRecords.transit(medical_record, :process, doctor)

      assert {:ok,
              %{
                doctor_id: ^doctor_id,
                state: :completed
              }} = MedicalRecords.transit(medical_record, :complete, doctor)
    end

    test "return", %{medical_record: medical_record, doctor: doctor} do
      {:ok, medical_record} = MedicalRecords.transit(medical_record, :process, doctor)

      assert {:ok,
              %{
                doctor_id: nil,
                state: :pending
              }} = MedicalRecords.transit(medical_record, :return, doctor)
    end

    setup do
      category = category_fixture()
      user = user_fixture()
      doctor = doctor_fixture(%{user_id: user.id})
      medical_record = medical_record_fixture(%{category_id: category.id})
      {:ok, category: category, user: user, doctor: doctor, medical_record: medical_record}
    end
  end
end
