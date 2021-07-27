import React, { ReactNode } from 'react'
import { BaseField } from './types'

export function FormGroup({
  label,
  children,
  helpText,
  errorText,
}: {
  label: string
  children: ReactNode
  helpText?: string
  errorText?: string
}) {
  return (
    <div className="form-group">
      <label className="label">{label}</label>
      {children}
      {helpText ? (
        <div className="text-sm text-green-500">{helpText}</div>
      ) : (
        errorText && <div className="text-sm text-red-500">{errorText}</div>
      )}
    </div>
  )
}
