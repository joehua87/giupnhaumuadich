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
    <div className="mt-4">
      <div className="bg-white border rounded-md mb-4 p-3">
        <h3 className="mb-4 heading-3">Thông tin liên lạc</h3>
        <div className="divide-y divide-dotted divide-gray-400 grid">
          <div className="grid py-1.5 gap-x-4 grid-cols-3">
            <label className="font-medium text-gray-600">Họ tên</label>
            <div className="col-span-2">{entity.name}</div>
          </div>
          <div className="grid py-1.5 gap-x-4 grid-cols-3">
            <label className="font-medium text-gray-600">Số điện thoại</label>
            <div className="col-span-2">{entity.phone}</div>
          </div>
        </div>
      </div>
      <div className="bg-white border rounded-md mb-4 p-3">
        <h3 className="mb-4 heading-3">Thông tin bệnh chung</h3>
        <FieldValues
          fieldValues={entity.common_field_values}
          fields={commonFields}
        />
      </div>
      <div className="bg-white border rounded-md mb-4 p-3">
        <h3 className="mb-4 heading-3">Thông tin chuyên khoa</h3>
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

export function renderMedicalRecordView(
  liveViewHook: ViewHook,
  { entity }: { entity: MedicalRecord },
) {
  render(
    <MedicalRecordView liveViewHook={liveViewHook} entity={entity} />,
    liveViewHook.el,
  )
}
