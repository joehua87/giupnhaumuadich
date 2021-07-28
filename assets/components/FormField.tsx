import React from 'react'
import {
  Controller,
  Control,
  UseFormRegister,
  DeepMap,
  UseFormGetValues,
} from 'react-hook-form'
import { Field } from '../types/form'
import { MultiSelect } from './MultiSelect'
import { FormGroup } from './FormGroup'
import { Select } from './Select'

export function FormField({
  field,
  prefix,
  register,
  control,
  getValues,
  errors,
}: {
  field: Field
  prefix: string
  control: Control<any>
  register: UseFormRegister<any>
  getValues: UseFormGetValues<any>
  errors: DeepMap<any, any>
}) {
  const key = `${prefix}.${field.name}`
  const errorText = errors[prefix]?.[field.name]?.message

  if (field.showIf) {
    const value = getValues([prefix, ...field.showIf.field].join('.'))
    if (value !== field.showIf.value) {
      return null
    }
  }

  switch (field.type) {
    case 'text':
      return (
        <FormGroup
          label={field.label}
          errorText={errorText}
          helpText={field.helpText}
        >
          <input
            className="w-full input"
            {...register(key, field.validations)}
          />
        </FormGroup>
      )
    case 'number':
      return (
        <FormGroup
          label={field.label}
          errorText={errorText}
          helpText={field.helpText}
        >
          <input
            className="w-full input"
            type="number"
            {...register(key, field.validations)}
          />
        </FormGroup>
      )
    case 'textarea':
      return (
        <FormGroup
          label={field.label}
          errorText={errorText}
          helpText={field.helpText}
        >
          <textarea
            className="w-full input"
            {...register(key, field.validations)}
          />
        </FormGroup>
      )
    case 'multi_select':
      return (
        <FormGroup
          label={field.label}
          errorText={errorText}
          helpText={field.helpText}
        >
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
        <FormGroup
          label={field.label}
          errorText={errorText}
          helpText={field.helpText}
        >
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
