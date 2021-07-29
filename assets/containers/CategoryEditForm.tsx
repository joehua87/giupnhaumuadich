import React, { useCallback } from 'react'
import { render } from 'react-dom'
import { ViewHook } from 'phoenix_live_view'
import { TagsInput } from '~/components/TagsInput'
import { Category } from '~/types/core'
import { useForm, Controller } from 'react-hook-form'
import { FormGroup } from '~/components/FormGroup'
import { JsonEditor } from '~/components/JsonEditor'

export function CategoryEditForm({
  liveViewHook: live,
  entity,
}: {
  liveViewHook: ViewHook
  entity: Category
}) {
  const {
    control,
    register,
    formState: { errors },
    handleSubmit,
  } = useForm({
    defaultValues: {
      ...entity,
      tags: entity.tags || [],
      symptoms: entity.symptoms || [],
    },
  })

  return (
    <form
      onSubmit={handleSubmit((v) => {
        live.pushEvent('save_entity', { data: v })
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
      <Controller
        control={control}
        name="tags"
        render={({ field: { onChange, value } }) => (
          <FormGroup label="Tags">
            <TagsInput value={value} onChange={onChange} />
          </FormGroup>
        )}
      />
      <Controller
        control={control}
        name="symptoms"
        render={({ field: { onChange, value } }) => (
          <FormGroup label="Symptoms">
            <TagsInput value={value} onChange={onChange} />
          </FormGroup>
        )}
      />
      <Controller
        control={control}
        name="medical_record_fields"
        render={({ field: { onChange, value } }) => (
          <FormGroup label="Medical record fields">
            <JsonEditor value={value} onSubmit={onChange} />
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

export function renderCategoryEditForm(
  liveViewHook: ViewHook,
  { entity }: { entity: Category },
) {
  render(
    <CategoryEditForm liveViewHook={liveViewHook} entity={entity} />,
    liveViewHook.el,
  )
}
