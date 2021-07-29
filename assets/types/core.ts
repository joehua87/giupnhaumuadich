import { Field } from './form'

export type Time = string

export interface User {
  id: string
  email: string
  name?: string
  avatar?: string
}

export interface Category {
  id: string
  slug: string
  name: string
  tags: string[]
  symptoms: string[]
  medical_record_fields: Field[]
}

export interface Doctor {
  id: string
  code: string
  slug: string
  name: string
  facebook_uid?: string | null
  user_id?: string | null
  user?: User
  field_values: any[]
  image?: string
  intro: string
  organizations: string[]
  schedule: Time[]
  other_phones: string[]
  phone: string
  position?: string
  schedule_text?: string
  categories: Category[]
}
export interface MedicalRecord {
  id: string
  name: string
  phone: string
  facebook_uid?: string
  common_field_values: Record<string, any>[]
  specialize_field_values: Record<string, any>[]
  assets: Record<string, string[]>
  category: Category
  dotor: Doctor
  state: string
  token: string
}
