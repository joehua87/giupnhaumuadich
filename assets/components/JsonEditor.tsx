import { EditorState, Compartment } from '@codemirror/state'
import { json } from '@codemirror/lang-json'
import React, { useEffect, useRef } from 'react'
import { basicSetup, EditorView } from '@codemirror/basic-setup'

let language = new Compartment()
let tabSize = new Compartment()

export function createEditor(ele: Element, doc = '') {
  let state = EditorState.create({
    doc: doc,
    extensions: [
      basicSetup,
      language.of(json()),
      tabSize.of(EditorState.tabSize.of(8)),
    ],
  })
  return new EditorView({
    parent: ele,
    state,
  })
}

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
    if (!ref.current) {
      return
    }

    editorRef.current = createEditor(
      ref.current,
      JSON.stringify(value, null, 2),
    )
  }, [])

  return (
    <div>
      <div className="border" ref={ref} />
      <button
        type="button"
        onClick={() => {
          console.log(editorRef.current)
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
  )
}
