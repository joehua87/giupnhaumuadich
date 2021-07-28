export type Time = string

export interface Category {
  id: string
  slug: string
  name: string
  tags: string[]
  symptoms: string[]
}

export interface Doctor {
  id: string
  code: string
  slug: string
  name: string
  facebook_uid?: string | null
  user_id?: string | null
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
