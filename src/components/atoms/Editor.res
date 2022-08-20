module Monaco = {
  type create_editor_options = {
    value: option<string>,
    language: string,
  }
  type monaco_environment = {getWorkerUrl: (string, string) => string}

  type editor = {create: (Dom.element, create_editor_options) => unit}

  @module("monaco-editor/esm/vs/editor/editor.main.js") external editor: editor = "editor"

  @module("monaco-editor/esm/vs/editor/editor.main.js")
  external monacoEnvironment: monaco_environment = "MonacoEnvironment"
}
