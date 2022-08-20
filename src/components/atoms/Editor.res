module Monaco = {
  type create_editor_options = {
    value: option<string>,
    language: string,
    automaticLayout: option<bool>,
  }

  type idim = {height: int, width: int}

  type editor
  @send external layout: (editor, idim) => unit = "layout"

  type editorNs
  @send external create: (editorNs, Dom.element, create_editor_options) => editor = "create"

  @module("monaco-editor/esm/vs/editor/editor.main.js") external editor: editorNs = "editor"
}
