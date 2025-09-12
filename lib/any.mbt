// Copyright 2018-2025 the Deno authors. MIT license.
// Copyright 2025 International Digital Economy Academy

///|
/// Extracts and parses YAML, TOML, or JSON from the metadata of front
/// matter content, depending on the format.
///
/// The function automatically detects the format based on the delimiters
/// and parses the content accordingly. Supports YAML, TOML, and JSON formats.
/// This follows the TypeScript reference's any.ts approach using format detection.
///
/// # Example Usage
/// ```moonbit
/// let output = "---json\n{\n  \"title\": \"Three dashes marks the spot\"\n}\n---\nHello, world!"
/// let _result = extract_any(output)
/// // _result.attrs will be parsed JSON object data as string
/// ```
///
/// @param text The text to extract front matter from.
/// @returns The extracted front matter and body content with raw string attrs.
pub fn extract_any(text : String) -> Extract[String] raise FrontMatterError {
  let format = detect_format_any(text)
  match format {
    Some(format_val) =>
      match format_val {
        Json => extract_json(text)
        Toml => extract_toml(text)
        Yaml => extract_yaml(text)
      }
    None => raise FrontMatterError("Unsupported front matter format")
  }
}

///|
/// Detect the format of front matter in text.
/// 
/// This function examines the text to determine which front matter format
/// is being used by checking the delimiters. It follows the TypeScript 
/// reference's RECOGNIZE_REGEXP_MAP approach by testing each format.
///
/// The detection follows this order (similar to TypeScript entries() iteration):
/// 1. YAML (most common and flexible)
/// 2. TOML (more specific patterns)
/// 3. JSON (most specific patterns)
///
/// # Example
/// ```moonbit
/// let _format = detect_format_any("---json\n{\"key\": \"value\"}\n---\nContent")
/// // Returns Some(Json)
/// ```
///
/// @param text The text to analyze
/// @returns Some(Format) if a valid format is detected, None otherwise
pub fn detect_format_any(text : String) -> Format? {
  if text.is_empty() {
    return None
  }

  // Clean input of BOM if present (following TypeScript BOM handling)
  let clean_text = remove_bom_prefix(text)

  // Test each format following TypeScript RECOGNIZE_REGEXP_MAP approach
  // The order matters - we check patterns from most specific to least specific
  // to avoid false matches (similar to how the TypeScript version handles it)

  // Check YAML first (following TypeScript map entries order)
  if test_yaml_recognition(clean_text) {
    Some(Yaml)
  } else if test_toml_recognition(clean_text) {
    Some(Toml)
  } else if test_json_recognition(clean_text) {
    Some(Json)
  } else {
    None
  }
}

///|
/// Test if text contains any supported front matter format.
/// 
/// This is equivalent to calling `detect_format_any(text) is Some(_)` but
/// provides a more semantic name for boolean tests.
/// Mirrors the TypeScript reference's test function behavior.
///
/// # Example
/// ```moonbit
/// let _contains_fm = has_any_front_matter("---\ntitle: Test\n---\nContent")
/// // Returns true
/// ```
///
/// @param text The text to test
/// @returns true if any supported front matter format is detected
pub fn has_any_front_matter(text : String) -> Bool {
  detect_format_any(text) is Some(_)
}

///|
/// Test for YAML format recognition following TypeScript RECOGNIZE_YAML_REGEXP
fn test_yaml_recognition(text : String) -> Bool {
  let headers = get_header_patterns(Yaml)
  for i = 0; i < headers.length(); i = i + 1 {
    let header = headers[i]
    if test_header_pattern_recognition(text, header) {
      return true
    }
  }
  false
}

///|
/// Test for TOML format recognition following TypeScript RECOGNIZE_TOML_REGEXP
fn test_toml_recognition(text : String) -> Bool {
  let headers = get_header_patterns(Toml)
  for i = 0; i < headers.length(); i = i + 1 {
    let header = headers[i]
    if test_header_pattern_recognition(text, header) {
      return true
    }
  }
  false
}

///|
/// Test for JSON format recognition following TypeScript RECOGNIZE_JSON_REGEXP
fn test_json_recognition(text : String) -> Bool {
  let headers = get_header_patterns(Json)
  for i = 0; i < headers.length(); i = i + 1 {
    let header = headers[i]
    if test_header_pattern_recognition(text, header) {
      return true
    }
  }
  false
}

///|
/// Test if text starts with a valid header pattern for recognition
/// This is used specifically for format detection (recognition phase)
fn test_header_pattern_recognition(text : String, header : String) -> Bool {
  let lines = text.split("\n").to_array()
  if lines.length() == 0 {
    return false
  }
  let first_line = lines[0].to_string()
  matches_header_pattern(first_line, header)
}
