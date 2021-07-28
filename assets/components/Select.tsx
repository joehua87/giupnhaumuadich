import React from 'react'
import { SelectField } from '../types/form'

export function Select({
  field,
  value,
  onChange,
}: {
  field: SelectField
  value: string
  onChange: (value: string) => void
}) {
  return (
    <div className="grid gap-2 grid-cols-1 lg:grid-cols-3">
      {field.options
        // .sort((a, b) => a.localeCompare(b))
        .map((x) => (
          <label key={x}>
            <input
              type="radio"
              checked={value == x}
              onChange={() => {
                onChange(x)
              }}
            />
            <span className="ml-2">{x}</span>
          </label>
        ))}
    </div>
  )
}
