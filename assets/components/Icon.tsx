import clsx from 'clsx'
import React, { cloneElement, isValidElement, ReactElement } from 'react'

type HtmlSvgProps = JSX.IntrinsicElements['svg']
export interface IconProps extends Omit<HtmlSvgProps, 'icon'> {
  icon?: string | ReactElement
  url?: string
}
export interface SpriteIconProps extends Omit<HtmlSvgProps, 'icon'> {
  icon?: string
  url?: string
}

export function SpriteIcon({
  icon,
  url: overrideUrl,
  ...rest
}: SpriteIconProps) {
  const defaultUrl = '/assets/sprite-icons.svg'
  const url = overrideUrl || defaultUrl

  return (
    <svg
      width="24"
      height="24"
      fill="none"
      stroke="currentColor"
      strokeWidth="2"
      strokeLinecap="round"
      strokeLinejoin="round"
      {...rest}
    >
      <use href={`${url}#${icon}`} />
    </svg>
  )
}

export const Icon = ({ icon, url, ...rest }: IconProps) => {
  if (isValidElement(icon)) {
    return cloneElement(icon, {
      ...rest,
      ...icon.props,
      className: clsx(rest.className, icon.props.className),
    })
  }

  return <SpriteIcon icon={icon} url={url} {...rest} />
}
