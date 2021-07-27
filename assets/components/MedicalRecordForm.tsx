import React from 'react'
import { render } from 'react-dom'
import { useForm, Controller } from 'react-hook-form'
import { MyDropzone } from './Dropzone'
import { ViewHook } from 'phoenix_live_view'
import { RegionSelect } from './RegionSelect'
import DatePicker from 'react-datepicker'
import { Field } from './types'
import { MultiSelect } from './MultiSelect'
import { FormGroup } from './FormGroup'

const fields: Field[] = [
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

export function MedicalRecordForm({
  liveViewHook: live,
}: {
  liveViewHook: ViewHook
}) {
  const {
    register,
    handleSubmit,
    control,
    formState: { errors },
  } = useForm()

  return (
    <form
      onSubmit={handleSubmit((params) => {
        live.pushEvent('submit', params)
      })}
    >
      <FormGroup label="Họ tên" errorText={errors.name?.message}>
        <input
          className="w-full input"
          {...register('name', {
            required: {
              message: 'Trường bắt buộc, ban vui lòng điền',
              value: true,
            },
            minLength: {
              value: 4,
              message: 'Họ tên phải hơn 4 ký tự',
            },
          })}
        />
      </FormGroup>
      <FormGroup label="Số điện thoại" errorText={errors.phone?.message}>
        <input
          className="w-full input"
          {...register('phone', {
            required: {
              message: 'Trường bắt buộc, ban vui lòng điền',
              value: true,
            },
            pattern: { message: 'Điện thoại không hợp lệ', value: /0\d{8,10}/ },
          })}
        />
      </FormGroup>
      <Controller
        control={control}
        name="birthday"
        rules={{
          required: {
            message: 'Trường bắt buộc, ban vui lòng điền',
            value: true,
          },
        }}
        render={({ field: { onChange, value } }) => (
          <FormGroup label="Năm sinh" errorText={errors.birthday?.message}>
            <DatePicker
              selected={value}
              onChange={onChange}
              dateFormat="dd/MM/yyyy"
              placeholderText="Ví dụ 29/2/2000"
              className="input"
            />
          </FormGroup>
        )}
      />
      <FormGroup label="Link Facebook">
        <input className="w-full input" {...register('facebook_uid')} />
      </FormGroup>
      <Controller
        control={control}
        name="region"
        render={({ field: { onChange, value } }) => (
          <FormGroup label="Địa chỉ" errorText={errors.region?.message}>
            <RegionSelect value={value} onChange={onChange} />
          </FormGroup>
        )}
      />
      {fields.map((field) => {
        switch (field.type) {
          case 'text':
            return (
              <FormGroup key={field.name} label={field.label}>
                <input
                  className="w-full input"
                  {...register(`field_values.${field.name}`)}
                />
              </FormGroup>
            )
          case 'number':
            return (
              <FormGroup key={field.name} label={field.label}>
                <input
                  className="w-full input"
                  type="number"
                  {...register(`field_values.${field.name}`)}
                />
              </FormGroup>
            )
          case 'textarea':
            return (
              <FormGroup key={field.name} label={field.label}>
                <textarea
                  className="w-full input"
                  {...register(`field_values.${field.name}`)}
                />
              </FormGroup>
            )
          case 'multi_select':
            return (
              <FormGroup key={field.name} label={field.label}>
                <Controller
                  control={control}
                  name={`field_values.${field.name}`}
                  render={({ field: { onChange, value } }) => (
                    <MultiSelect
                      field={field}
                      onChange={onChange}
                      value={value}
                    />
                  )}
                />
              </FormGroup>
            )
        }
      })}
      <Controller
        control={control}
        name="assets.prescription"
        render={({ field: { onChange, value } }) => (
          <FormGroup label="Hình ảnh đơn thuốc">
            <MyDropzone value={value || []} onChange={onChange} />
          </FormGroup>
        )}
      />
      <Controller
        control={control}
        name="assets.examination"
        render={({ field: { onChange, value } }) => (
          <FormGroup label="Hình ảnh kết quả xét nghiệm gần nhất">
            <MyDropzone value={value || []} onChange={onChange} />
          </FormGroup>
        )}
      />
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

export function renderForm(liveViewHook: ViewHook) {
  render(<MedicalRecordForm liveViewHook={liveViewHook} />, liveViewHook.el)
}
