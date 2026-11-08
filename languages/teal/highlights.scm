;; Adapted from tree-sitter-teal's queries/highlights.scm
;; (https://github.com/euclidianAce/tree-sitter-teal, MIT, commit ac6b42f).
;; Changes, all to fit Zed's theme capture names:
;;   @conditional, @repeat, @keyword.function -> @keyword
;;   @parameter        -> @variable.parameter
;;   @variable.builtin -> @variable.special
;;   removed (ERROR) @error (Zed has no error highlight)


;; Primitives
(boolean) @boolean
(comment) @comment
(shebang_comment) @comment
(identifier) @variable
((identifier) @variable.special
  (#eq? @variable.special "self"))
(nil) @constant.builtin
(number) @number
(string) @string
(table_constructor ["{" "}"] @constructor)
(varargs "..." @constant.builtin)
[ "," "." ":" ";" ] @punctuation.delimiter

(escape_sequence) @string.escape
(format_specifier) @string.escape

;; Basic statements/Keywords
[ "if" "then" "elseif" "else" ] @keyword
[ "for" "while" "repeat" "until" ] @keyword
[ "in" "local" "return" (break) (goto) "do" "end" ] @keyword
(label) @label

;; Global isn't a real keyword, but it gets special treatment in these places
(var_declaration "global" @keyword)
(type_declaration "global" @keyword)
(function_statement "global" @keyword)
(record_declaration "global" @keyword)
(interface_declaration "global" @keyword)
(enum_declaration "global" @keyword)

(macroexp_statement "macroexp" @keyword)

;; Ops
(bin_op (op) @operator)
(unary_op (op) @operator)
[ "=" "as" ] @operator

;; Functions
(function_statement
  "function" @keyword
  . name: (_) @function)
(anon_function
  "function" @keyword)
(function_body "end" @keyword)

(arg name: (identifier) @variable.parameter)

(function_signature
  (arguments
    . (arg name: (identifier) @variable.special))
  (#eq? @variable.special "self"))

(typeargs
  "<" @punctuation.bracket
  . (_) @variable.parameter
  . ("," . (_) @variable.parameter)*
  . ">" @punctuation.bracket)

(function_call
  (identifier) @function . (arguments))
(function_call
  (index (_) key: (identifier) @function) . (arguments))
(function_call
  (method_index (_) key: (identifier) @function) . (arguments))

;; Types

; Contextual keywords in record bodies
(record_declaration
  . [ "record" ] @keyword
  name: (identifier) @type)
(anon_record . "record" @keyword)
(record_body
  (record_declaration
    . [ "record" ] @keyword
    . name: (identifier) @type))
(record_body
  (enum_declaration
    . [ "enum" ] @keyword
    . name: (identifier) @type))
(record_body
  (interface_declaration
    . [ "interface" ] @keyword
    . name: (identifier) @type))
(record_body
  (typedef
    . "type" @keyword
    . name: (identifier) @type . "="))
(record_body
  (macroexp_declaration
    . [ "macroexp" ] @keyword))
(record_body (metamethod "metamethod" @keyword))
(record_body (userdata) @keyword)

; Contextual keywords in interface bodies
(interface_declaration
  . [ "interface" ] @keyword
  name: (identifier) @type)
(anon_interface . "interface" @keyword)
(interface_body
  (record_declaration
    . [ "record" ] @keyword
    . name: (identifier) @type))
(interface_body
  (enum_declaration
    . [ "enum" ] @keyword
    . name: (identifier) @type))
(interface_body
  (interface_declaration
    . [ "interface" ] @keyword
    . name: (identifier) @type))
(interface_body
  (typedef
    . "type" @keyword
    . name: (identifier) @type . "="))
(interface_body
  (macroexp_declaration
    . [ "macroexp" ] @keyword))
(interface_body (metamethod "metamethod" @keyword))
(interface_body (userdata) @keyword)

(enum_declaration
  "enum" @keyword
  name: (identifier) @type)

(type_declaration "type" @keyword)
(type_declaration (identifier) @type)
(simple_type) @type
(type_index) @type
(type_union "|" @operator)
(function_type "function" @type)

;; The rest of it
(var_declaration
  declarators: (var_declarators
      (var name: (identifier) @variable)))
(var_declaration
  declarators: (var_declarators
    (var
      "<" @punctuation.bracket
      . attribute: (attribute) @attribute
      . ">" @punctuation.bracket)))
[ "(" ")" "[" "]" "{" "}" ] @punctuation.bracket

;; Only highlight format specifiers in calls to string.format
;; string.format('...')
;(function_call
;  called_object: (index
;    (identifier) @base
;    key: (identifier) @entry)
;  arguments: (arguments .
;    (string (format_specifier) @string.escape))
;
;  (#eq? @base "string")
;  (#eq? @entry "format"))

;; ('...'):format()
;(function_call
;  called_object: (method_index
;    (string (format_specifier) @string.escape)
;    key: (identifier) @func-name)
;    (#eq? @func-name "format"))
