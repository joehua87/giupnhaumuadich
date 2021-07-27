import React from 'react'
import { Controller, Control, UseFormRegister, DeepMap } from 'react-hook-form'
import { Field } from './types'
import { MultiSelect } from './MultiSelect'
import { FormGroup } from './FormGroup'
import { Select } from './Select'

export function FormField({
  field,
  prefix,
  register,
  control,
  errors,
}: {
  field: Field
  prefix: string
  control: Control<any>
  register: UseFormRegister<any>
  errors: DeepMap<any, any>
}) {
  const key = `${prefix}.${field.name}`
  const errorText = errors[prefix]?.[field.name]?.message

  switch (field.type) {
    case 'text':
      return (
        <FormGroup label={field.label} errorText={errorText}>
          <input
            className="w-full input"
            {...register(key, field.validations)}
          />
        </FormGroup>
      )
    case 'number':
      return (
        <FormGroup label={field.label} errorText={errorText}>
          <input
            className="w-full input"
            type="number"
            {...register(key, field.validations)}
          />
        </FormGroup>
      )
    case 'textarea':
      return (
        <FormGroup label={field.label} errorText={errorText}>
          <textarea
            className="w-full input"
            {...register(key, field.validations)}
          />
        </FormGroup>
      )
    case 'multi_select':
      return (
        <FormGroup label={field.label} errorText={errorText}>
          <Controller
            control={control}
            name={key}
            rules={field.validations}
            render={({ field: { onChange, value } }) => (
              <MultiSelect field={field} onChange={onChange} value={value} />
            )}
          />
        </FormGroup>
      )
    case 'select':
      return (
        <FormGroup label={field.label} errorText={errorText}>
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
