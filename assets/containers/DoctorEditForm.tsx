import React, { useCallback, useEffect } from 'react'
import { render } from 'react-dom'
import { ViewHook } from 'phoenix_live_view'
import { Category, Doctor } from '~/types/core'
import CategorySelect from '~/components/CategorySelect'

export function DoctorEditForm({
  liveViewHook: live,
  entity,
  categories,
}: {
  liveViewHook: ViewHook
  entity: Doctor
  categories: Category[]
}) {
  const handleSave = useCallback(() => {
    live.pushEvent('save_entity', { data: entity }, ({ entity }) => {})
  }, [])

  return (
    <div>
      <div>{entity.name}</div>
      <CategorySelect entities={categories} />
      <button onClick={handleSave}>Save</button>
    </div>
  )
}

export function renderDoctorEditForm(
  liveViewHook: ViewHook,
  { entity, categories }: { entity: Doctor; categories: Category[] },
) {
  render(
    <DoctorEditForm
      liveViewHook={liveViewHook}
      entity={entity}
      categories={categories}
    />,
    liveViewHook.el,
  )
}
