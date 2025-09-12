// Copyright 2018-2025 the Deno authors. MIT license.
// Copyright 2025 International Digital Economy Academy

///|
/// Supported format for front matter. "unknown" would be used when auto format
/// detection logic fails (keeping it simple for now).
pub enum Format {
  Yaml
  Toml
  Json
} derive(Eq, Show)

///|
/// Constants for regex-like pattern matching
/// Following the TypeScript reference's BOM and pattern structure

///|
/// BOM (Byte Order Mark) pattern equivalent
let bom_pattern = "\ufeff"

///|
/// YAML header patterns (equivalent to TypeScript YAML_HEADER)
pub let yaml_header_patterns = ["---yaml", "= yaml =", "---"]

///|
/// YAML footer patterns (equivalent to TypeScript YAML_FOOTER)  
pub let yaml_footer_patterns = ["= yaml =", "---"]

///|
/// TOML header patterns (equivalent to TypeScript TOML_HEADER)
pub let toml_header_patterns = ["---toml", "+++", "= toml ="]

///|
/// TOML footer patterns (equivalent to TypeScript TOML_FOOTER)
pub let toml_footer_patterns = ["---", "+++", "= toml ="]

///|
/// JSON header patterns (equivalent to TypeScript JSON_HEADER)
pub let json_header_patterns = ["---json", "= json ="]

///|
/// JSON footer patterns (equivalent to TypeScript JSON_FOOTER)
pub let json_footer_patterns = ["---", "= json ="]

///|
/// Newline patterns
pub let newline_chars = "\r\n\n"

///|
/// Check if text starts with BOM
pub fn has_bom(text : String) -> Bool {
  match text.strip_prefix(bom_pattern) {
    Some(_) => true
    None => false
  }
}

///|
/// Remove BOM from text if present
pub fn remove_bom_prefix(text : String) -> String {
  match text.strip_prefix(bom_pattern) {
    Some(rest) => rest.to_string()
    None => text
  }
}

///|
/// Check if a character is whitespace
fn is_whitespace_char(c : Char) -> Bool {
  c == ' ' || c == '\t' || c == '\r' || c == '\n'
}

///|
/// Check if a line matches a header pattern with proper whitespace handling
/// This follows the TypeScript reference's approach of checking header + whitespace + newline
pub fn matches_header_pattern(line : String, pattern : String) -> Bool {
  match line.strip_prefix(pattern) {
    Some(rest) => {
      // The rest should only contain whitespace (following TypeScript WHITESPACES pattern)
      let rest_str = rest.to_string()
      let chars = rest_str.to_array()
      let mut all_whitespace = true
      for i = 0; i < chars.length(); i = i + 1 {
        if !is_whitespace_char(chars[i]) {
          all_whitespace = false
          break
        }
      }
      all_whitespace
    }
    None => false
  }
}

///|
/// Check if a line matches a footer pattern with proper whitespace handling
pub fn matches_footer_pattern(line : String, pattern : String) -> Bool {
  let trimmed = line.trim_space()
  trimmed == pattern
}

///|
/// Get header patterns for a format
pub fn get_header_patterns(format : Format) -> Array[String] {
  match format {
    Yaml => yaml_header_patterns
    Toml => toml_header_patterns
    Json => json_header_patterns
  }
}

///|
/// Get footer patterns for a format
pub fn get_footer_patterns(format : Format) -> Array[String] {
  match format {
    Yaml => yaml_footer_patterns
    Toml => toml_footer_patterns
    Json => json_footer_patterns
  }
}

///|
/// Check if format has a specific header pattern
pub fn format_has_header(format : Format, header : String) -> Bool {
  get_header_patterns(format).contains(header)
}

///|
/// Check if format has a specific footer pattern  
pub fn format_has_footer(format : Format, footer : String) -> Bool {
  get_footer_patterns(format).contains(footer)
}
