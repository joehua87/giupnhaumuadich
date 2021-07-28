import React from 'react'
import { render } from 'react-dom'
import { useForm, Controller } from 'react-hook-form'
import { ViewHook } from 'phoenix_live_view'
import DatePicker from 'react-datepicker'
import { Field } from '../types/form'
import { MyDropzone } from '~/components/Dropzone'
import { FormField } from '~/components/FormField'
import { FormGroup } from '~/components/FormGroup'

const commonFields: Field[] = [
  {
    name: 'height',
    label: 'Chiều cao (cm)',
    type: 'number',
    validations: {
      required: {
        value: true,
        message: 'Bạn vui lòng điền trường này',
      },
      max: {
        value: 300,
        message: 'Chiều cao không được quả 300cm',
      },
    },
  },
  {
    name: 'weight',
    label: 'Cân nặng (kg)',
    type: 'number',
    validations: {
      required: {
        value: true,
        message: 'Bạn vui lòng điền trường này',
      },
    },
  },
  {
    name: 'sex',
    label: 'Giới tính',
    type: 'select',
    options: ['Nam', 'Nữ', 'Khác'],
    validations: {
      required: {
        value: true,
        message: 'Bạn vui lòng điền trường này',
      },
    },
  },
  {
    name: 'female_only',
    label: 'Dành cho nữ',
    type: 'multi_select',
    showIf: {
      field: ['sex'],
      value: 'Nữ',
    },
    options: ['Đang có thai', 'Đang cho con bú'],
  },
  {
    name: 'thang_co_thai',
    label: 'Đang có thai mấy tháng',
    type: 'number',
    showIf: {
      field: ['sex'],
      value: 'Nữ',
    },
  },
  {
    name: 'huyet_ap_trung_binh',
    label: 'Huyết áp trung bình',
    type: 'number',
  },
  {
    name: 'dang_cho_con_may_thang_bu',
    label: 'Đang cho con mấy tháng bú',
    type: 'number',
  },
  {
    name: 'benh_nen',
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
  {
    name: 'di_ung_thuoc',
    label: 'Tiền sử dị ứng thuốc',
    type: 'select',
    options: ['Không', 'Có'],
  },
  {
    name: 'di_ung_thuoc_chi_tiet',
    label: 'Mô tả chi tiết tên thuốc/biệt dược dị ứng',
    type: 'textarea',
  },
]

const specializedFields: Field[] = [
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
    getValues,
    watch,
  } = useForm()

  watch('common_field_values.sex')

  return (
    <form
      onSubmit={handleSubmit((params) => {
        live.pushEvent('submit', params)
      })}
    >
      <div className="bg-white border mb-8 p-4">
        <h3 className="mb-4 heading-3">Thông tin cơ bản</h3>
        <FormGroup label="Họ tên" errorText={errors.name?.message}>
          <input
            className="w-full input"
            {...register('name', {
              required: {
                message: 'Bạn vui lòng điền trường này',
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
                message: 'Bạn vui lòng điền trường này',
                value: true,
              },
              pattern: {
                message: 'Điện thoại không hợp lệ',
                value: /0\d{8,10}/,
              },
            })}
          />
        </FormGroup>
        <Controller
          control={control}
          name="birthday"
          rules={{
            required: {
              message: 'Bạn vui lòng điền trường này',
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
        <FormGroup label="Địa chỉ">
          <input className="w-full input" {...register('region.address')} />
        </FormGroup>
        {/* <Controller
          control={control}
          name="region"
          render={({ field: { onChange, value } }) => (
            <FormGroup label="Địa chỉ" errorText={errors.region?.message}>
              <RegionSelect value={value} onChange={onChange} />
            </FormGroup>
          )}
        /> */}
      </div>
      <div className="bg-white border mb-8 p-4">
        <h3 className="mb-4 heading-3">Thông tin chung</h3>
        {commonFields.map((field) => {
          return (
            <FormField
              key={field.name}
              field={field}
              prefix="common_field_values"
              errors={errors}
              control={control}
              register={register}
              getValues={getValues}
            />
          )
        })}
      </div>
      <div className="bg-white border mb-8 p-4">
        <h3 className="mb-4 heading-3">Thông tin chuyên khoa</h3>
        {specializedFields.map((field) => {
          return (
            <FormField
              key={field.name}
              field={field}
              prefix="specialized_field_values"
              errors={errors}
              control={control}
              register={register}
              getValues={getValues}
            />
          )
        })}
      </div>
      <div className="bg-white border mb-8 p-4">
        <h3 className="mb-4 heading-3">Hình ảnh</h3>
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
      </div>
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
