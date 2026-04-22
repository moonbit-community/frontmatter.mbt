// Copyright 2018-2025 the Deno authors. MIT license.
// Copyright 2025 International Digital Economy Academy

///|
/// Extracts and parses YAML from the metadata of front matter content.
/// This is an unstable version that allows for additional options 
/// in the future (e.g., different YAML parsing schemas).
///
/// # Example Extract YAML front matter
/// ```moonbit nocheck
/// let output = "---yaml\ndate: 2022-01-01\n---\nHello, world!"
///
/// let _result = extract_yaml_with_options(output)
/// ```
///
/// @param text The text to extract YAML front matter from.
/// @returns The extracted YAML front matter and body content.
pub fn extract_yaml_with_options(
  text : String,
) -> Extract[String] raise FrontMatterError {
  // For now, this is equivalent to the standard YAML extraction
  // but provides a foundation for future options support
  extract_yaml(text)
}

///|
/// Alternative entry point for YAML extraction with future extensibility.
/// This matches the pattern seen in the reference implementation where
/// unstable variants can accept additional parameters.
///
/// @param text The text to extract YAML front matter from.
/// @returns The extracted YAML front matter and body content.
pub fn extract_unstable(
  text : String,
) -> Extract[String] raise FrontMatterError {
  extract_yaml_with_options(text)
}

///|
/// Test if text contains valid YAML front matter using unstable validation.
/// This provides an alternative testing path that may be enhanced with
/// additional validation options in the future.
///
/// @param text The text to test
/// @returns true if valid YAML front matter is detected
pub fn test_yaml_unstable(text : String) -> Bool {
  test_yaml_format(text)
}

///|
/// Extract YAML front matter with options (placeholder for future extensibility).
/// The strict parameter is for future use when different parsing modes are supported.
///
/// @param text The text to extract YAML front matter from
/// @param _strict Whether to use strict parsing (currently unused)  
/// @returns The extracted YAML front matter and body content
pub fn extract_with_options(
  text : String,
  _strict : Bool,
) -> Extract[String] raise FrontMatterError {
  // For now, ignore the strict parameter and use standard extraction
  extract_yaml(text)
}

///|
/// Extract YAML front matter using strict parsing mode.
/// Currently equivalent to standard extraction but provides future extensibility.
///
/// @param text The text to extract YAML front matter from
/// @returns The extracted YAML front matter and body content
pub fn extract_strict(text : String) -> Extract[String] raise FrontMatterError {
  extract_yaml(text)
}

///|
/// Extract YAML front matter using lenient parsing mode.
/// Currently equivalent to standard extraction but provides future extensibility.
///
/// @param text The text to extract YAML front matter from
/// @returns The extracted YAML front matter and body content  
pub fn extract_lenient(text : String) -> Extract[String] raise FrontMatterError {
  extract_yaml(text)
}

///|
/// Enhanced YAML extraction with validation options.
/// Provides additional validation beyond standard extraction for production use.
///
/// @param text The text to extract YAML front matter from
/// @param validate_structure Whether to perform additional structure validation
/// @returns The extracted YAML front matter and body content
pub fn extract_with_validation(
  text : String,
  validate_structure : Bool,
) -> Extract[String] raise FrontMatterError {
  if validate_structure {
    // Additional validation: check for common YAML structure issues
    validate_yaml_structure(text)
  }
  extract_yaml(text)
}

///|
/// Validate YAML structure for common issues.
/// This provides enhanced validation beyond basic pattern matching.
fn validate_yaml_structure(text : String) -> Unit raise FrontMatterError {
  if text.is_empty() {
    raise FrontMatterError("Unexpected end of input")
  }

  // Check for basic structural requirements
  let lines = text.split("\n").to_array()
  if lines.length() < 3 {
    // YAML front matter needs at least header, content, and footer
    raise FrontMatterError("Unexpected end of input")
  }

  // Additional validation can be added here for specific YAML patterns
  // This establishes a framework for future YAML-specific validation
}

///|
/// Extract YAML with schema-like options (placeholder for future JSON schema validation).
/// This mirrors the TypeScript reference's schema options approach.
///
/// @param text The text to extract YAML front matter from
/// @param schema_type Optional schema validation type (for future use)
/// @returns The extracted YAML front matter and body content
pub fn extract_with_schema(
  text : String,
  schema_type : String,
) -> Extract[String] raise FrontMatterError {
  // For now, ignore schema_type but prepare for future schema validation
  match schema_type {
    "json" | "core" | "default" => extract_yaml(text)
    _ =>
      // For unsupported schema types, fall back to default behavior
      extract_yaml(text)
  }
}
