import React from 'react'
import { render } from 'react-dom'
import { ViewHook } from 'phoenix_live_view'
import { Category, Doctor, User } from '~/types/core'
import { useForm, Controller } from 'react-hook-form'
import { FormGroup } from '~/components/FormGroup'
import { MultiDataSelect } from '~/components/MultiDataSelect'
import { DataSelect } from '~/components/DataSelect'

export function DoctorEditForm({
  liveViewHook: live,
  entity,
  categories,
  users,
}: {
  liveViewHook: ViewHook
  entity: Doctor
  categories: Category[]
  users: User[]
}) {
  const {
    control,
    register,
    formState: { errors },
    handleSubmit,
  } = useForm({
    defaultValues: {
      ...entity,
    },
  })

  return (
    <form
      onSubmit={handleSubmit(({ id, name, categories, facebook_uid, user }) => {
        live.pushEvent('save_entity', {
          data: {
            id,
            name,
            facebook_uid,
            categories_id: categories.map((x) => x.id),
            user_id: user?.id,
          },
        })
      })}
    >
      <div className="mb-4 heading-2">{entity.name}</div>
      <FormGroup label="Tên" errorText={errors.name?.message}>
        <input
          className="w-full input"
          {...register('name', {
            required: {
              message: 'Bạn vui lòng điền trường này',
              value: true,
            },
            minLength: {
              value: 4,
              message: 'Tên chuyên ngành phải hơn 4 ký tự',
            },
          })}
        />
      </FormGroup>
      <FormGroup label="Link Facebook" errorText={errors.facebook_uid?.message}>
        <input
          className="w-full input"
          {...register('facebook_uid', {
            // pattern: {
            //   value: /\d+/,
            //   message: 'Facebook id không hợp lệ',
            // },
          })}
        />
      </FormGroup>
      <Controller
        control={control}
        name="categories"
        render={({ field: { onChange, value } }) => (
          <FormGroup label="Chuyên khoa">
            <MultiDataSelect
              items={categories}
              value={value}
              onChange={onChange}
              renderItem={(item) => item.name}
              filterFn={(item, inputValue) => {
                return (
                  (value || []).indexOf(item) < 0 &&
                  item.name.toLowerCase().includes(inputValue.toLowerCase())
                )
              }}
            />
          </FormGroup>
        )}
      />
      <Controller
        control={control}
        name="user"
        render={({ field: { onChange, value } }) => (
          <FormGroup label="Người dùng">
            <DataSelect
              items={users}
              value={value}
              onChange={onChange}
              renderItem={(item) => item.name || item.email}
              filterFn={(item, inputValue) => {
                if (!inputValue) {
                  return true
                }
                return !!(item?.name + item?.email)
                  ?.toLowerCase()
                  .includes(inputValue.toLowerCase())
              }}
            />
          </FormGroup>
        )}
      />
      <div>
        <button
          className="rounded bg-brand-500 text-white py-1 px-4 hover:bg-brand-600"
          type="submit"
        >
          Save
        </button>
      </div>
    </form>
  )
}

export function renderDoctorEditForm(
  liveViewHook: ViewHook,
  {
    entity,
    categories,
    users,
  }: { entity: Doctor; categories: Category[]; users: User[] },
) {
  render(
    <DoctorEditForm
      liveViewHook={liveViewHook}
      entity={entity}
      categories={categories}
      users={users}
    />,
    liveViewHook.el,
  )
}
