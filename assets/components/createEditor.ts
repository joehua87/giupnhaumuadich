import { EditorState, Compartment } from '@codemirror/state'
import { json } from '@codemirror/lang-json'
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
