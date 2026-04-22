// Copyright 2018-2025 the Deno authors. MIT license.
// Copyright (c) Jason Campbell. MIT license
// Copyright 2025 International Digital Economy Academy

///|
/// Extracts front matter from strings.
/// Adapted from https://github.com/jxson/front-matter/
///
/// ## Supported formats
///
/// ### JSON
/// 
/// Extract and parse JSON from the metadata of front matter content:
/// ```moonbit
/// let str = "---json\n{\"and\": \"this\"}\n---\ndeno is awesome"
/// let result = extract_json(str)
/// // result.front_matter: "{\"and\": \"this\"}"
/// // result.body: "deno is awesome"  
/// // result.attrs: parsed JSON (currently as string)
/// ```
///
/// `extract_json` and `test_format` support the following delimiters:
/// ```
/// ---json
/// {
///   "and": "this"
/// }
/// ---
/// ```
///
/// ```
/// = json =
/// {
///   "is": "JSON"
/// }
/// = json =
/// ```
///
/// ### TOML
/// 
/// Extract and parse TOML from the metadata of front matter content:
/// ```moonbit
/// let str = "---toml\nmodule = 'front_matter'\n---\ndeno is awesome"
/// let result = extract_toml(str)
/// // result.front_matter: "module = 'front_matter'"
/// // result.body: "deno is awesome"
/// // result.attrs: parsed TOML (currently returned as string)
/// ```
///
/// `extract_toml` and `test_format` support the following delimiters:
/// ```
/// ---toml
/// this = 'is'
/// ---
/// ```
///
/// ```
/// = toml =
/// parsed = 'as'
/// toml = 'data'
/// = toml =
/// ```
///
/// ```
/// +++
/// is = 'that'
/// not = 'cool?'
/// +++
/// ```
///
/// ### YAML
/// 
/// Extract and parse YAML from the metadata of front matter content:
/// ```moonbit
/// let str = "---yaml\nmodule: front_matter\n---\ndeno is awesome"
/// let result = extract_yaml(str)
/// // result.front_matter: "module: front_matter"
/// // result.body: "deno is awesome"
/// // result.attrs: parsed YAML (currently returned as string)
/// ```
///
/// `extract_yaml` and `test_format` support the following delimiters:
/// ```
/// ---
/// these: are
/// ---
/// ```
///
/// ```
/// ---yaml
/// all: recognized
/// ---
/// ```
///
/// ```
/// = yaml =
/// as: yaml
/// = yaml =
/// ```

///|
/// Re-export core types from lib module
pub using @lib {type Extract, type Format, type FrontMatterError}

///|
/// Re-export test functions from lib module
pub let test_format : (String, Format) -> Bool = @lib.test_format

///|
pub let has_front_matter : (String) -> Bool = @lib.has_front_matter

///|
/// Re-export format-specific extraction functions
pub let extract_json : (String) -> Extract[String] raise FrontMatterError = @lib.extract_json

///|
pub let extract_toml : (String) -> Extract[String] raise FrontMatterError = @lib.extract_toml

///|
pub let extract_yaml : (String) -> Extract[String] raise FrontMatterError = @lib.extract_yaml

///|
/// Re-export auto-detection functions from lib module
pub let extract_any : (String) -> Extract[String] raise FrontMatterError = @lib.extract_any

///|
pub let detect_format_any : (String) -> Format? = @lib.detect_format_any

///|
pub let has_any_front_matter : (String) -> Bool = @lib.has_any_front_matter

///|
/// Re-export format-specific test functions
pub let test_yaml_format : (String) -> Bool = @lib.test_yaml_format

///|
pub let test_toml_format : (String) -> Bool = @lib.test_toml_format

///|
pub let test_json_format : (String) -> Bool = @lib.test_json_format

///|
/// Alias for detect_format_any for backward compatibility
pub let detect_format : (String) -> Format? = @lib.detect_format_any

///|
/// Alias for extract_yaml for backward compatibility
pub let extract_yaml_front_matter : (String) -> Extract[String] raise FrontMatterError = @lib.extract_yaml

///|
/// Re-export unstable YAML functions for advanced usage
pub let extract_yaml_with_options : (String) -> Extract[String] raise FrontMatterError = @lib.extract_yaml_with_options

///|
pub let extract_yaml_with_validation : (String, Bool) -> Extract[String] raise FrontMatterError = @lib.extract_with_validation

///|
pub let extract_yaml_with_schema : (String, String) -> Extract[String] raise FrontMatterError = @lib.extract_with_schema

///|
/// Advanced YAML parsing options for future extensibility
pub let extract_yaml_strict : (String) -> Extract[String] raise FrontMatterError = @lib.extract_strict

///|
pub let extract_yaml_lenient : (String) -> Extract[String] raise FrontMatterError = @lib.extract_lenient
