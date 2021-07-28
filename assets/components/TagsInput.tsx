import clsx from 'clsx'
import React, { ReactElement, useRef, useState } from 'react'

import { Tag, TagTheme } from './Tag'

type HtmlDivProps = JSX.IntrinsicElements['div']

export interface TagsInputTheme {
  root?: string
  tag?: TagTheme
  input?: string
}

export interface TagsInputProps
  extends Omit<HtmlDivProps, 'value' | 'onChange'> {
  value: string[]
  onChange: (value: string[]) => void
  removeIcon?: string | ReactElement
  theme?: TagsInputTheme
}

export function TagsInput({
  value,
  onChange,
  removeIcon,
  className,
  theme,
  ...rest
}: TagsInputProps) {
  const [current, setCurrent] = useState('')
  const ref = useRef<HTMLInputElement>(null)

  return (
    <div
      {...rest}
      data-component="tags-input"
      className={clsx(theme?.root, className)}
      onClick={(e) => {
        ref.current?.focus()
        rest.onClick?.(e)
      }}
    >
      {value.map((v, idx) => (
        <Tag
          data-element="tag"
          className="mr-2 mb-2"
          key={idx}
          removeIcon={removeIcon}
          onRemove={() => {
            onChange([...value.slice(0, idx), ...value.slice(idx + 1)])
          }}
          theme={theme?.tag}
        >
          {v}
        </Tag>
      ))}
      <input
        className="border rounded px-2"
        value={current}
        ref={ref}
        placeholder="Thêm, xong gõ enter"
        onChange={(e) => {
          setCurrent(e.target.value)
        }}
        onKeyDown={(e) => {
          if (e.key === 'Enter') {
            e.preventDefault()
            e.stopPropagation()
          }
        }}
        onKeyUp={(e) => {
          if (e.key === 'Enter') {
            if (current.trim() === '') {
              return
            }
            e.preventDefault()
            e.stopPropagation()
            onChange([...value, current])
            setCurrent('')
          }
        }}
        data-element="input"
      />
    </div>
  )
}
