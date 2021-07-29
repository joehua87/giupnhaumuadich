import React from 'react'
import { MultiSelectField } from '../types/form'

export function MultiSelect({
  field,
  value = [],
  onChange,
}: {
  field: MultiSelectField
  value: string[]
  onChange: (value: string[]) => void
}) {
  return (
    <div className="grid gap-2 grid-cols-1 lg:grid-cols-3">
      {field.options
        // .sort((a, b) => a.localeCompare(b))
        .map((x) => (
          <label key={x} className="flex items-baseline">
            <input
              type="checkbox"
              checked={value.includes(x)}
              onChange={(e) => {
                if (e.target.checked) {
                  onChange([...value, x])
                } else {
                  onChange(value.filter((v) => v != x))
                }
              }}
            />
            <span className="ml-2">{x}</span>
          </label>
        ))}
    </div>
  )
}
