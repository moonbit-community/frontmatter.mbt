// Copyright 2018-2025 the Deno authors. MIT license.
// Copyright 2025 International Digital Economy Academy

///|
/// Extracts and parses YAML from the metadata of front matter content.
///
/// This function handles empty front matter by returning an empty string,
/// and preserves the extracted front matter string for debugging purposes.
/// Note: Until a YAML parser is available, this returns the front matter as a string.
///
/// @param text The text to extract YAML front matter from.
/// @returns The extracted YAML front matter and body content.
pub fn extract_yaml(text : String) -> Extract[String] raise FrontMatterError {
  if text.is_empty() {
    raise EmptyInput
  }
  let raw_result = extract_front_matter(text, Yaml)

  // Handle empty front matter case (returns empty representation)
  let attrs = if raw_result.front_matter.is_empty() {
    "" // Empty YAML representation
  } else {
    raw_result.front_matter
  }
  Extract::new(raw_result.front_matter, raw_result.body, attrs)
}
