import React from 'react'
import { render } from 'react-dom'
import { ViewHook } from 'phoenix_live_view'
import { commonFields } from '~/data/medical'
import { MedicalRecord } from '~/types/core'
import { FieldValues } from '~/components/FieldValuesView'

export function MedicalRecordView({
  entity,
}: {
  liveViewHook: ViewHook
  entity: MedicalRecord
}) {
  return (
    <div>
      <div className="border my-4 p-2">
        <h3 className="mb-2 heading-3">Thông tin cơ bản</h3>
        <div>Họ tên: {entity.name}</div>
        <div>Số điện thoại: {entity.phone}</div>
      </div>
      <div className="border my-4 p-2">
        <h3 className="mb-2 heading-3">Thông tin bệnh chung</h3>
        <FieldValues
          fieldValues={entity.common_field_values}
          fields={commonFields}
        />
      </div>
      <div className="border my-4 p-2">
        <h3 className="mb-2 heading-3">Thông tin chuyên khoa</h3>
        <FieldValues
          fieldValues={entity.specialize_field_values}
          fields={entity.category.medical_record_fields}
        />
      </div>
    </div>
  )
}

export function renderForm(
  liveViewHook: ViewHook,
  { entity }: { entity: MedicalRecord },
) {
  render(
    <MedicalRecordView liveViewHook={liveViewHook} entity={entity} />,
    liveViewHook.el,
  )
}
