import React from 'react'
import { Controller, Control, UseFormRegister } from 'react-hook-form'
import { Field } from './types'
import { MultiSelect } from './MultiSelect'
import { FormGroup } from './FormGroup'
import { Select } from './Select'

export function FormField({
  field,
  prefix,
  register,
  control,
}: {
  field: Field
  prefix: string
  control: Control<any>
  register: UseFormRegister<any>
}) {
  switch (field.type) {
    case 'text':
      return (
        <FormGroup label={field.label}>
          <input
            className="w-full input"
            {...register(`${prefix}.${field.name}`, field.validations)}
          />
        </FormGroup>
      )
    case 'number':
      return (
        <FormGroup label={field.label}>
          <input
            className="w-full input"
            type="number"
            {...register(`${prefix}.${field.name}`, field.validations)}
          />
        </FormGroup>
      )
    case 'textarea':
      return (
        <FormGroup label={field.label}>
          <textarea
            className="w-full input"
            {...register(`${prefix}.${field.name}`, field.validations)}
          />
        </FormGroup>
      )
    case 'multi_select':
      return (
        <FormGroup label={field.label}>
          <Controller
            control={control}
            name={`${prefix}.${field.name}`}
            rules={field.validations}
            render={({ field: { onChange, value } }) => (
              <MultiSelect field={field} onChange={onChange} value={value} />
            )}
          />
        </FormGroup>
      )
    case 'select':
      return (
        <FormGroup label={field.label}>
          <Controller
            control={control}
            name={`${prefix}.${field.name}`}
            rules={field.validations}
            render={({ field: { onChange, value } }) => (
              <Select field={field} onChange={onChange} value={value} />
            )}
          />
        </FormGroup>
      )
  }
}
