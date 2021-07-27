// import { nanoid } from 'nanoid'
import React, { useCallback } from 'react'
import { useDropzone } from 'react-dropzone'

// import { clientEndpoint } from '~/config'

export function MyDropzone({
  value,
  onChange,
  activeText = `Thả file tại đây ...`,
  text = `Kéo thả hoặc click để tải file lên`,
}: {
  value: string[]
  onChange: (value: string[]) => void
  activeText?: string
  text?: string
}) {
  const onDrop = useCallback(
    async (acceptedFiles: File[]) => {
      const token = document
        .querySelector('[name="csrf-token"]')
        ?.getAttribute('content')
      if (!token) {
        throw new Error('Cannot get token')
      }

      const map = acceptedFiles.reduce((acc: Record<string, File>, file) => {
        const [ext, ...tmp] = file.name.split(/\./g).reverse()
        const name = tmp.reverse().join()
        const id = `${name}-${Date.now()}.${ext}`
        return {
          ...acc,
          [id]: file,
        }
      }, {})

      const formData = new FormData()

      Object.entries(map).forEach(([id, file]) => {
        formData.append(`files[]`, file, id)
      })

      const response = await fetch(`/upload`, {
        headers: {
          'x-csrf-token': token,
        },
        method: 'POST',
        body: formData,
      })

      const data: { ids: string[] } = await response.json()
      const nextValue = [...new Set([...value, ...data.ids])]
      onChange(nextValue)
    },
    [value, onChange],
  )

  const { getRootProps, getInputProps, isDragActive } = useDropzone({ onDrop })

  return (
    <div {...getRootProps()} className="my-2 w-full">
      <input
        {...getInputProps()}
        className="flex w-full items-center justify-center"
      />

      {isDragActive ? (
        <p className="border border-dotted rounded-sm cursor-pointer flex bg-neutral-50 border-neutral-600 h-20 mt-3 text-sm p-2 text-neutral-900 items-center justify-center">
          {activeText}
        </p>
      ) : (
        <p className="border border-dotted rounded-sm cursor-pointer flex bg-neutral-50 border-neutral-600 h-20 mt-3 text-sm p-2 text-neutral-600 items-center justify-center">
          {/* <Icon icon="image" className="h-4 mr-1 text-neutral-900 w-4" /> */}
          {text}
        </p>
      )}
      <div className="flex flex-wrap">
        {value.map((x) => (
          <img className="border h-32 w-32" key={x} src={`/upload/${x}`} />
        ))}
      </div>
    </div>
  )
}
