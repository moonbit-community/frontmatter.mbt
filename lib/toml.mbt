// Copyright 2018-2025 the Deno authors. MIT license.
// Copyright 2025 International Digital Economy Academy

///|
/// Extracts and parses TOML from the metadata of front matter content.
///
/// This function handles empty front matter by returning an empty string,
/// and preserves the extracted front matter string for debugging purposes.
/// Note: Until a TOML parser is available, this returns the front matter as a string.
///
/// @param text The text to extract TOML front matter from.
/// @returns The extracted TOML front matter and body content.
pub fn extract_toml(text : String) -> Extract[String] raise FrontMatterError {
  if text.is_empty() {
    raise EmptyInput
  }
  let raw_result = extract_front_matter(text, Toml)

  // Handle empty front matter case (returns empty representation)
  let attrs = if raw_result.front_matter.is_empty() {
    "" // Empty TOML representation
  } else {
    raw_result.front_matter
  }
  Extract::new(raw_result.front_matter, raw_result.body, attrs)
}
