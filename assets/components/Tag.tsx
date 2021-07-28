import clsx from 'clsx'
import React, { ReactElement } from 'react'

import { Icon } from './Icon'

export type HtmlSpanProps = JSX.IntrinsicElements['span']

export interface TagTheme {
  root?: string
  text?: string
  removeIcon?: string
}

export interface TagProps extends HtmlSpanProps {
  removeIcon?: string | ReactElement
  onRemove?: () => void
  theme?: TagTheme
}

export function Tag({
  removeIcon = 'x',
  onRemove,
  children,
  className,
  theme,
  ...rest
}: TagProps) {
  return (
    <span
      data-component="tag"
      className={clsx(theme?.root, className)}
      {...rest}
    >
      <span data-element="text" className={theme?.text}>
        {children}
      </span>
      {onRemove && (
        <Icon
          data-element="remove-icon"
          icon={removeIcon}
          className={theme?.removeIcon}
          onClick={onRemove}
        />
      )}
    </span>
  )
}
