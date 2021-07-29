import React, { useEffect, useRef } from 'react'
import { EditorView } from '@codemirror/basic-setup'

export function JsonEditor({
  value,
  onSubmit,
}: {
  value: any
  onSubmit: (value: any) => void
}) {
  const editorRef = useRef<EditorView>()
  const ref = useRef<HTMLDivElement>(null)

  useEffect(() => {
    import('./createEditor').then(({ createEditor }) => {
      if (!ref.current) {
        return
      }
      editorRef.current = createEditor(
        ref.current,
        JSON.stringify(value, null, 2),
      )
    })
  }, [])

  return (
    <div>
      <div className="border" ref={ref} />
      <div className="my-2">
        <button
          type="button"
          className="rounded bg-brand-700 text-white px-2 hover:bg-brand-800"
          onClick={() => {
            const editor = editorRef.current
            if (!editor) {
              return
            }
            const json = editor.state.doc.toJSON().join('\n')
            try {
              const v = JSON.parse(json)
              console.log(v)
              onSubmit(v)
            } catch (err) {
              alert('JSON is not valid')
            }
          }}
        >
          Save
        </button>
      </div>
      <p className="bg-yellow-50 my-2 p-2 text-yellow-900">
        Sau khi sửa thông field chuyên khoa, xong vui lòng bấm nút save bên trên
      </p>
    </div>
  )
}
