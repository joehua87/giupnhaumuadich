import React from 'react'
import { Category } from '~/types/core'

export default function CategorySelect({ entities }: { entities: Category[] }) {
  return (
    <div>
      {entities.map((cat) => (
        <div key={cat.id}>{cat.name}</div>
      ))}
    </div>
  )
}
