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
    <div>
      {fields.map((field) => {
        const value = fieldValues?.[field.name]

        switch (field.type) {
          case 'text':
          case 'select':
            return (
              <div key={field.name}>
                <label className="font-medium text-gray-600">
                  {field.label}
                </label>
                : {value || 'Không có'}
              </div>
            )
          case 'textarea':
            return (
              <div key={field.name}>
                <label className="font-medium text-gray-600">
                  {field.label}
                </label>
                <div>{value || 'Không có'}</div>
              </div>
            )
          case 'multi_select':
            return (
              <div key={field.name}>
                <label className="font-medium text-gray-600">
                  {field.label}
                </label>
                : {value?.length > 0 ? value?.join(', ') : 'Không có'}
              </div>
            )
        }
      })}
    </div>
  )
}
