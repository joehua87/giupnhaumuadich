import React from 'react'
import { render } from 'react-dom'
import { useForm, Controller } from 'react-hook-form'
import { ViewHook } from 'phoenix_live_view'
import DatePicker from 'react-datepicker'
import { Field } from '../types/form'
import { MyDropzone } from '~/components/Dropzone'
import { FormField } from '~/components/FormField'
import { FormGroup } from '~/components/FormGroup'
import { commonFields } from '~/data/medical'
import { Category } from '~/types/core'

export function MedicalRecordForm({
  liveViewHook: live,
  category: { medical_record_fields },
}: {
  category: Category
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
  watch('common_field_values.di_ung_thuoc')

  return (
    <form
      onSubmit={handleSubmit((params) => {
        live.pushEvent('submit', params)
      })}
    >
      <div className="bg-white border rounded-md mb-4 p-3">
        <h3 className="mb-4 heading-3">Thông tin liên lạc</h3>
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
        {/* <FormGroup label="Link Facebook (không bắt buộc)">
          <input className="w-full input" {...register('facebook_uid')} />
        </FormGroup> */}
        <FormGroup label="Địa chỉ (không bắt buộc)">
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
      <div className="bg-white border rounded-md mb-4 p-3">
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
      <div className="bg-white border rounded-md mb-4 p-3">
        <h3 className="mb-4 heading-3">Thông tin chuyên khoa</h3>
        {medical_record_fields?.map((field) => {
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
      <div className="bg-white border rounded-md mb-4 p-3">
        <h3 className="mb-4 heading-3">Hình ảnh đính kèm</h3>
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
            <FormGroup label="Hình ảnh các kết quả xét nghiệm gần nhất">
              <MyDropzone value={value || []} onChange={onChange} />
            </FormGroup>
          )}
        />
        <Controller
          control={control}
          name="assets.currentSymptoms"
          render={({ field: { onChange, value } }) => (
            <FormGroup label="Hình ảnh triệu chứng nếu có">
              <MyDropzone value={value || []} onChange={onChange} />
            </FormGroup>
          )}
        />
      </div>
      <div>
        <button
          type="submit"
          className="rounded bg-brand-600 text-white text-lg w-full py-3 px-4 hover:bg-brand-700"
        >
          Gửi đề nghị trợ giúp y khoa
        </button>
      </div>
    </form>
  )
}

export function renderForm(
  liveViewHook: ViewHook,
  { category }: { category: Category },
) {
  render(
    <MedicalRecordForm liveViewHook={liveViewHook} category={category} />,
    liveViewHook.el,
  )
}
