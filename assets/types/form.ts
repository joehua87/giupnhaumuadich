import { RegisterOptions } from 'react-hook-form'
export interface BaseField {
  name: string
  label: string
  helpText?: string
  type: 'text' | 'number' | 'select' | 'multi_select' | 'textarea'
  showIf?: {
    field: string[]
    value: string
  }
  validations?: RegisterOptions
}

export interface TextField extends BaseField {
  type: 'text'
}
export interface TextAreaField extends BaseField {
  type: 'textarea'
}
export interface NumberField extends BaseField {
  type: 'number'
}

export interface MultiSelectField extends BaseField {
  type: 'multi_select'
  options: string[]
}

export interface SelectField extends BaseField {
  type: 'select'
  options: string[]
}

export type Field =
  | TextField
  | TextAreaField
  | NumberField
  | SelectField
  | MultiSelectField
