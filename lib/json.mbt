// Copyright 2018-2025 the Deno authors. MIT license.
// Copyright 2025 International Digital Economy Academy

///|
/// Extracts and parses JSON from the metadata of front matter content.
///
/// This function handles empty front matter by returning an empty object,
/// and preserves the extracted front matter string for debugging purposes.
/// It matches the behavior of the reference implementation.
///
/// @param text The text to extract JSON front matter from.
/// @returns The extracted JSON front matter and body content.
pub fn extract_json(text : String) -> Extract[String] raise FrontMatterError {
  if text.is_empty() {
    raise EmptyInput
  }
  let raw_result = extract_front_matter(text, Json)

  // Handle empty front matter case (returns empty object equivalent)
  let attrs = if raw_result.front_matter.is_empty() {
    "{}" // Empty JSON object as string representation
  } else {
    raw_result.front_matter
  }
  Extract::new(raw_result.front_matter, raw_result.body, attrs)
}
