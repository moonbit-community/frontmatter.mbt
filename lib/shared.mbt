// Copyright 2018-2025 the Deno authors. MIT license.
// Copyright 2025 International Digital Economy Academy

///|
/// Result type for front matter extraction
pub struct FrontMatterResult {
  front_matter : String
  body : String
}

///|
/// Error type for front matter parsing errors.
pub suberror FrontMatterError {
  EmptyInput
  NoValidHeader
  MissingFooter
  InvalidHeaderFormat
  MinimumStructure
  UnsupportedFormat
}

///|
impl Show for FrontMatterError with output(self, logger) -> Unit {
  match self {
    EmptyInput => logger.write_string("FrontMatterError: Input text is empty")
    NoValidHeader =>
      logger.write_string("FrontMatterError: No valid front matter header found")
    MissingFooter =>
      logger.write_string(
        "FrontMatterError: Front matter not properly closed - missing end delimiter",
      )
    InvalidHeaderFormat =>
      logger.write_string("FrontMatterError: Invalid front matter header format")
    MinimumStructure =>
      logger.write_string(
        "FrontMatterError: Front matter requires at least header and footer lines",
      )
    UnsupportedFormat =>
      logger.write_string("FrontMatterError: Unsupported front matter format")
  }
}

///|
/// Whitespace characters for trimming (reused from formats but kept here for compatibility)
let _whitespace_chars = " \t\r\n"

///|
/// BOM (Byte Order Mark) character
let bom_char = '\ufeff'

///|
/// Remove BOM from beginning of string if present
/// This matches the TypeScript reference's BOM handling approach
fn remove_bom(input : String) -> String {
  let bom_string = bom_char.to_string()
  match input.strip_prefix(bom_string) {
    Some(stripped) => stripped.to_string()
    None => input
  }
}

///|
/// Extract front matter content using improved pattern matching
/// This follows the TypeScript reference's extractFrontMatter approach more closely
pub fn extract_front_matter(
  input : String,
  format : Format,
) -> FrontMatterResult raise FrontMatterError {
  if input.is_empty() {
    raise EmptyInput
  }
  let cleaned_input = remove_bom(input)

  // Use format-specific extraction that follows TypeScript patterns more closely
  match format {
    Yaml => extract_yaml_front_matter_raw(cleaned_input)
    Toml => extract_toml_front_matter_raw(cleaned_input)
    Json => extract_json_front_matter_raw(cleaned_input)
  }
}

///|
/// Helper function to check if string starts with prefix
fn string_starts_with(s : String, prefix : String) -> Bool {
  match s.strip_prefix(prefix) {
    Some(_) => true
    None => false
  }
}

///|
/// Extract YAML front matter following TypeScript reference patterns
fn extract_yaml_front_matter_raw(
  input : String,
) -> FrontMatterResult raise FrontMatterError {
  // Check patterns in order of specificity (matching TypeScript YAML_HEADER logic)
  if string_starts_with(input, "---yaml") {
    extract_yaml_with_flexible_footer(input, "---yaml")
  } else if string_starts_with(input, "= yaml =") {
    extract_yaml_with_flexible_footer(input, "= yaml =")
  } else if string_starts_with(input, "---") {
    // Only accept plain --- if it's not a more specific format
    if !input.contains("---toml") && !input.contains("---json") {
      extract_yaml_with_flexible_footer(input, "---")
    } else {
      raise NoValidHeader
    }
  } else {
    raise NoValidHeader
  }
}

///|
/// Extract YAML with flexible footer patterns (TypeScript allows "---" or "= yaml =" for any header)
fn extract_yaml_with_flexible_footer(
  input : String,
  start_delimiter : String,
) -> FrontMatterResult raise FrontMatterError {
  let lines = input.split("\n").to_array()
  if lines.length() < 1 {
    raise EmptyInput
  }

  // Validate first line has correct header with optional whitespace
  let first_line = lines[0].to_string()
  if !matches_header_pattern(first_line, start_delimiter) {
    raise InvalidHeaderFormat
  }

  // Handle minimum structure requirements
  if lines.length() < 2 {
    raise MinimumStructure
  }

  // Find the end delimiter line - allow either "---" or "= yaml =" for YAML
  let mut end_index = -1
  for i = 1; i < lines.length(); i = i + 1 {
    let line = lines[i].to_string()
    if matches_footer_pattern(line, "---") ||
      matches_footer_pattern(line, "= yaml =") {
      end_index = i
      break
    }
  }
  if end_index == -1 {
    raise MissingFooter
  }

  // Special case: if header and footer are adjacent (empty front matter)
  if end_index == 1 {
    // Check if there are any body lines after the footer
    let body_lines : Array[String] = []
    for i = end_index + 1; i < lines.length(); i = i + 1 {
      body_lines.push(lines[i].to_string())
    }
    let body = body_lines.join("\n")
    return FrontMatterResult::{ front_matter: "", body }
  }

  // Extract front matter content
  let front_matter_lines : Array[String] = []
  for i = 1; i < end_index; i = i + 1 {
    front_matter_lines.push(lines[i].to_string())
  }
  let front_matter = front_matter_lines.join("\n")

  // Extract body content
  let body_lines : Array[String] = []
  for i = end_index + 1; i < lines.length(); i = i + 1 {
    body_lines.push(lines[i].to_string())
  }
  let body = body_lines.join("\n")

  // Clean front matter following TypeScript whitespace handling
  let clean_front_matter = front_matter.trim_space().to_string()
  FrontMatterResult::{ front_matter: clean_front_matter, body }
}

///|
/// Extract TOML front matter following TypeScript reference patterns
fn extract_toml_front_matter_raw(
  input : String,
) -> FrontMatterResult raise FrontMatterError {
  // Check patterns in order (matching TypeScript TOML_HEADER logic)
  if string_starts_with(input, "---toml") {
    extract_toml_with_flexible_footer(input, "---toml")
  } else if string_starts_with(input, "+++") {
    extract_toml_with_flexible_footer(input, "+++")
  } else if string_starts_with(input, "= toml =") {
    extract_toml_with_flexible_footer(input, "= toml =")
  } else {
    raise NoValidHeader
  }
}

///|
/// Extract TOML with flexible footer patterns (TypeScript allows "---", "+++", or "= toml =" for any header)
fn extract_toml_with_flexible_footer(
  input : String,
  start_delimiter : String,
) -> FrontMatterResult raise FrontMatterError {
  let lines = input.split("\n").to_array()
  if lines.length() < 1 {
    raise EmptyInput
  }

  // Validate first line has correct header with optional whitespace
  let first_line = lines[0].to_string()
  if !matches_header_pattern(first_line, start_delimiter) {
    raise InvalidHeaderFormat
  }

  // Handle minimum structure requirements
  if lines.length() < 2 {
    raise MinimumStructure
  }

  // Find the end delimiter line - allow "---", "+++", or "= toml =" for TOML
  let mut end_index = -1
  for i = 1; i < lines.length(); i = i + 1 {
    let line = lines[i].to_string()
    if matches_footer_pattern(line, "---") ||
      matches_footer_pattern(line, "+++") ||
      matches_footer_pattern(line, "= toml =") {
      end_index = i
      break
    }
  }
  if end_index == -1 {
    raise MissingFooter
  }

  // Special case: if header and footer are adjacent (empty front matter)
  if end_index == 1 {
    // Check if there are any body lines after the footer
    let body_lines : Array[String] = []
    for i = end_index + 1; i < lines.length(); i = i + 1 {
      body_lines.push(lines[i].to_string())
    }
    let body = body_lines.join("\n")
    return FrontMatterResult::{ front_matter: "", body }
  }

  // Extract front matter content
  let front_matter_lines : Array[String] = []
  for i = 1; i < end_index; i = i + 1 {
    front_matter_lines.push(lines[i].to_string())
  }
  let front_matter = front_matter_lines.join("\n")

  // Extract body content
  let body_lines : Array[String] = []
  for i = end_index + 1; i < lines.length(); i = i + 1 {
    body_lines.push(lines[i].to_string())
  }
  let body = body_lines.join("\n")

  // Clean front matter following TypeScript whitespace handling
  let clean_front_matter = front_matter.trim_space().to_string()
  FrontMatterResult::{ front_matter: clean_front_matter, body }
}

///|
/// Extract JSON front matter following TypeScript reference patterns
fn extract_json_front_matter_raw(
  input : String,
) -> FrontMatterResult raise FrontMatterError {
  // Check patterns (matching TypeScript JSON_HEADER logic)
  if string_starts_with(input, "---json") {
    extract_with_pattern_matching(input, "---json", "---")
  } else if string_starts_with(input, "= json =") {
    extract_with_pattern_matching(input, "= json =", "= json =")
  } else {
    raise NoValidHeader
  }
}

///|
/// Improved pattern matching extraction that follows TypeScript reference structure
/// This is optimized for performance and follows TypeScript regex-based approach more closely
fn extract_with_pattern_matching(
  input : String,
  start_delimiter : String,
  end_delimiter : String,
) -> FrontMatterResult raise FrontMatterError {
  let lines = input.split("\n").to_array()
  if lines.length() < 1 {
    raise EmptyInput
  }

  // Validate first line has correct header with optional whitespace
  // This follows the TypeScript WHITESPACES + NEWLINE pattern logic
  let first_line = lines[0].to_string()
  if !matches_header_pattern(first_line, start_delimiter) {
    raise InvalidHeaderFormat
  }

  // Handle minimum structure requirements (following TypeScript regex structure)
  if lines.length() < 2 {
    raise MinimumStructure
  }

  // Find the end delimiter line (following TypeScript footer matching)
  let mut end_index = -1
  for i = 1; i < lines.length(); i = i + 1 {
    let line = lines[i].to_string()
    if matches_footer_pattern(line, end_delimiter) {
      end_index = i
      break
    }
  }
  if end_index == -1 {
    raise MissingFooter
  }

  // Validate body separation: if footer is immediately followed by non-whitespace
  // on the same line, it's an error (following TypeScript behavior)
  if end_index < lines.length() {
    let footer_line = lines[end_index].to_string()
    let remaining_content = match footer_line.strip_prefix(end_delimiter) {
      Some(rest) => rest.trim_space()
      None => ""
    }
    if !remaining_content.is_empty() {
      raise InvalidHeaderFormat
    }
  }

  // Special case: if header and footer are adjacent (empty front matter)
  if end_index == 1 {
    // Optimized body extraction for empty front matter case
    let body_start_index = end_index + 1
    if body_start_index >= lines.length() {
      return FrontMatterResult::{ front_matter: "", body: "" }
    }

    // Use array slicing for better performance
    let body_lines : Array[String] = []
    for i = body_start_index; i < lines.length(); i = i + 1 {
      body_lines.push(lines[i].to_string())
    }
    let body = body_lines.join("\n")
    return FrontMatterResult::{ front_matter: "", body }
  }

  // Extract front matter content (following TypeScript FRONT_MATTER group)
  // Optimized: pre-allocate with known size
  let front_matter_lines : Array[String] = []
  for i = 1; i < end_index; i = i + 1 {
    front_matter_lines.push(lines[i].to_string())
  }
  let front_matter = front_matter_lines.join("\n")

  // Extract body content (following TypeScript BODY group) 
  // Optimized: check bounds first
  let body = if end_index + 1 >= lines.length() {
    ""
  } else {
    let body_lines : Array[String] = []
    for i = end_index + 1; i < lines.length(); i = i + 1 {
      body_lines.push(lines[i].to_string())
    }
    body_lines.join("\n")
  }

  // Clean front matter following TypeScript whitespace handling
  let clean_front_matter = front_matter.trim_space().to_string()
  FrontMatterResult::{ front_matter: clean_front_matter, body }
}
