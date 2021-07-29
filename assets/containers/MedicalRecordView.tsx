import React from 'react'
import { render } from 'react-dom'
import { ViewHook } from 'phoenix_live_view'
import { assetsLabels, commonFields } from '~/data/medical'
import { MedicalRecord } from '~/types/core'
import { FieldValues } from '~/components/FieldValuesView'
import { Gallery } from '~/components/Gallery'

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
      {Object.keys(entity.assets).map((k) => {
        const images = entity.assets[k]
        return (
          <div key={k} className="mt-4 mb-8">
            <h3 className="heading-3">{assetsLabels[k]}</h3>
            <Gallery images={images} />
          </div>
        )
      })}
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
