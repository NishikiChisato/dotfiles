;; extends

(import_declaration
  "import" @keyword.import.cpp)
(import_declaration
  name: (module_name) @string)


(module_declaration
  "export" @keyword
  "module" @keyword
  name: (module_name) @namespace)

(export_declaration
  "export" @keyword)
