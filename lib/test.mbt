///| Copyright 2018-2025 the Deno authors. MIT license.

///|
/// Tests if a string has valid front matter.
/// Supports YAML, TOML and JSON.
///
/// This follows the TypeScript reference implementation's test function approach,
/// using pattern matching similar to the EXTRACT_REGEXP_MAP logic.
///
/// @param text String to test.
/// @param formats A list of formats to test for. Defaults to all supported formats.
/// @returns `true` if the string has valid front matter, otherwise `false`.
/// 
/// # Example Test for valid YAML front matter
/// ```moonbit nocheck
/// let _result = test_front_matter(
///   "---\ntitle: Three dashes marks the spot\n---\n",
/// )
/// // _result should be true
/// ```
///
/// # Example Test for valid TOML front matter  
/// ```moonbit nocheck
/// let _result = test_front_matter(
///   "---toml\ntitle = 'Three dashes followed by format marks the spot'\n---\n",
/// )
/// // _result should be true
/// ```
///
/// # Example Test for valid JSON front matter
/// ```moonbit nocheck
/// let _result = test_front_matter(
///   "---json\n{\"title\": \"Three dashes followed by format marks the spot\"}\n---\n",
/// )
/// // _result should be true
/// ```
///
/// # Example JSON front matter is not valid as YAML
/// ```moonbit nocheck
/// // This would return false when testing specifically for YAML
/// let _text = "---json\n{\"title\": \"Test\"}\n---\n"
/// // Would return false when testing only for YAML format
/// ```
pub fn test_front_matter(
  text : String,
  formats~ : Array[Format] = [Yaml, Toml, Json],
) -> Bool {
  // Follow TypeScript reference: test each format and return true on first match
  for i = 0; i < formats.length(); i = i + 1 {
    let format = formats[i]
    try {
      // Attempt to extract using the format - if successful, format is valid
      let _ = extract_front_matter(text, format)
      return true
    } catch {
      // If extraction fails, continue to next format
      _ => continue
    }
  }
  false
}

///|
/// Test if a string has valid front matter of the specified format.
/// This is an improved version that follows the TypeScript reference's
/// regexp-based validation approach more closely.
///
/// @param text String to test
/// @param format The specific format to test for
/// @returns true if the format matches, false otherwise
pub fn test_format(text : String, format : Format) -> Bool {
  try {
    let _ = extract_front_matter(text, format)
    true
  } catch {
    _ => false
  }
}

///|
/// Test if a string has valid front matter (any format).
/// This is a convenience function that tests for all supported formats.
/// Equivalent to calling test_front_matter with default formats.
///
/// @param text String to test
/// @returns true if any supported front matter format is detected  
pub fn has_front_matter(text : String) -> Bool {
  test_front_matter(text)
}

///|
/// Test for YAML front matter with improved pattern recognition
/// Following the TypeScript reference's RECOGNIZE_YAML_REGEXP logic
pub fn test_yaml_format(text : String) -> Bool {
  if text.is_empty() {
    return false
  }
  let clean_text = remove_bom_prefix(text)

  // Check each YAML header pattern
  let headers = get_header_patterns(Yaml)
  for i = 0; i < headers.length(); i = i + 1 {
    let header = headers[i]
    if test_header_pattern(clean_text, header) {
      return true
    }
  }
  false
}

///|
/// Test for TOML front matter with improved pattern recognition
/// Following the TypeScript reference's RECOGNIZE_TOML_REGEXP logic
pub fn test_toml_format(text : String) -> Bool {
  if text.is_empty() {
    return false
  }
  let clean_text = remove_bom_prefix(text)

  // Check each TOML header pattern
  let headers = get_header_patterns(Toml)
  for i = 0; i < headers.length(); i = i + 1 {
    let header = headers[i]
    if test_header_pattern(clean_text, header) {
      return true
    }
  }
  false
}

///|
/// Test for JSON front matter with improved pattern recognition  
/// Following the TypeScript reference's RECOGNIZE_JSON_REGEXP logic
pub fn test_json_format(text : String) -> Bool {
  if text.is_empty() {
    return false
  }
  let clean_text = remove_bom_prefix(text)

  // Check each JSON header pattern
  let headers = get_header_patterns(Json)
  for i = 0; i < headers.length(); i = i + 1 {
    let header = headers[i]
    if test_header_pattern(clean_text, header) {
      return true
    }
  }
  false
}

///|
/// Test if text starts with a valid header pattern
/// This follows the TypeScript reference's header recognition approach
fn test_header_pattern(text : String, header : String) -> Bool {
  let lines = text.split("\n").to_array()
  if lines.length() == 0 {
    return false
  }
  let first_line = lines[0].to_owned()
  matches_header_pattern(first_line, header)
}
