import React from 'react'
import { render } from 'react-dom'
import { useForm, Controller } from 'react-hook-form'

export interface BaseField {
  name: string
  label: string
  type: 'text' | 'number' | 'multi_select' | 'textarea'
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

type Field = TextField | TextAreaField | NumberField | MultiSelectField

const fields: Field[] = [
  {
    name: 'name',
    label: 'Họ tên',
    type: 'text',
  },
  {
    name: 'age',
    label: 'Tuổi',
    type: 'number',
  },
  {
    name: 'address',
    label: 'Địa chỉ',
    type: 'text',
  },
  {
    name: 'facebook_uid',
    label: 'Link Facebook',
    type: 'text',
  },
  {
    name: 'Họ tên',
    label: 'Số điện thoại / Zalo',
    type: 'text',
  },
  {
    name: 'symptoms',
    label: 'Triệu chứng',
    type: 'multi_select',
    options: [
      'Đau tai',
      'Chảy mủ tai',
      'Ù tai',
      'Nghe kém',
      'Nghẹt mũi',
      'Chảy mũi',
      'Chảy mũi sau',
      'Đau mũi',
      'Hắt hơi (nhảy mũi)',
      'Đau mặt - nặng mặt',
      'Đau họng',
      'Nuốt đau',
      'Nuốt khó',
      'Khàn tiếng',
      'Khối vùng cổ',
      'Khối vùng đầu mặt',
    ],
  },
  {
    name: 'note',
    label: 'Mô tả thêm về bệnh',
    type: 'textarea',
  },
  {
    name: 'other_desease',
    label: 'Bệnh nền',
    type: 'multi_select',
    options: [
      'Tiểu đường',
      'Tăng huyết áp',
      'Viêm gan mạn tính',
      'Thiếu máu cơ tim',
      'Ung thư',
    ],
  },
]

function MultiSelect({
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
        .sort((a, b) => a.localeCompare(b))
        .map((x) => (
          <label key={x}>
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

export function Form() {
  const {
    register,
    handleSubmit,
    control,
    formState: { errors },
  } = useForm()

  return (
    <form onSubmit={handleSubmit(console.log)}>
      {fields.map((field) => {
        switch (field.type) {
          case 'text':
            return (
              <div key={field.name} className="form-group">
                <label className="label">{field.label}</label>
                <input className="w-full input" {...register(field.name)} />
              </div>
            )
          case 'number':
            return (
              <div key={field.name} className="form-group">
                <label className="label">{field.label}</label>
                <input
                  className="w-full input"
                  type="number"
                  {...register(field.name)}
                />
              </div>
            )
          case 'textarea':
            return (
              <div key={field.name} className="form-group">
                <label className="label">{field.label}</label>
                <textarea className="w-full input" {...register(field.name)} />
              </div>
            )
          case 'multi_select':
            return (
              <div key={field.name} className="form-group">
                <label className="label">{field.label}</label>
                <Controller
                  control={control}
                  name={field.name}
                  render={({ field: { onChange, value } }) => (
                    <MultiSelect
                      field={field}
                      onChange={onChange}
                      value={value}
                    />
                  )}
                ></Controller>
              </div>
            )
        }
      })}

      {errors.exampleRequired && <span>This field is required</span>}

      <div>
        <button
          type="submit"
          className="rounded bg-brand-600 text-white text-lg py-1 px-4 hover:bg-brand-700"
        >
          Đăng ký
        </button>
      </div>
    </form>
  )
}

export function renderForm(ele: HTMLElement) {
  render(<Form />, ele)
}
