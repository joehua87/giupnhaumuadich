import React from 'react'
import { Field } from '~/types/form'

export function FieldValues({
  fields,
  fieldValues,
}: {
  fields: Field[]
  fieldValues: Record<string, any>
}) {
  return (
    <div className="grid divide-y divide-dotted divide-gray-400">
      {fields.map((field) => {
        const value = fieldValues?.[field.name]

        switch (field.type) {
          case 'text':
          case 'select':
            return (
              <div key={field.name} className="grid grid-cols-3 gap-x-4 py-1.5">
                <label className="font-medium text-gray-600">
                  {field.label}
                </label>
                <div className="col-span-2">{value || 'Mô tả trống'}</div>
              </div>
            )
          case 'textarea':
            return (
              <div key={field.name} className="py-1.5">
                <label className="font-medium text-gray-600 mb-1">
                  {field.label}
                </label>
                <div>{value || 'Mô tả trống'}</div>
              </div>
            )
          case 'multi_select':
            return (
              <div key={field.name} className="grid grid-cols-3 gap-x-4 py-1.5">
                <label className="font-medium text-gray-600">
                  {field.label}
                </label>
                <div className="col-span-2">
                  {value?.length > 0 ? value?.join(', ') : 'Mô tả trống'}
                </div>
              </div>
            )
        }
      })}
    </div>
  )
}
