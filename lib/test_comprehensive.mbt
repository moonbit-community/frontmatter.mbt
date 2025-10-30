///| Copyright 2018-2025 the Deno authors. MIT license.

///| Comprehensive test cases based on TypeScript reference implementation

///|
/// Test JSON front matter extraction with complex content
test "json extracts complex front matter" {
  let input = "---json\n{\n  \"title\": \"Three dashes followed by the format marks the spot\",\n  \"tags\": [\n    \"json\",\n    \"front-matter\"\n  ]\n}\n---\ndon't break\n---\n{Also: \"---json this shouldn't be a problem\"}\n"
  let result = extract_json(input)
  inspect(
    result.body,
    content="don't break\n---\n{Also: \"---json this shouldn't be a problem\"}\n",
  )

  // Verify the front matter content
  let expected_fm = "{\n  \"title\": \"Three dashes followed by the format marks the spot\",\n  \"tags\": [\n    \"json\",\n    \"front-matter\"\n  ]\n}"
  inspect(result.front_matter, content=expected_fm)
}

///|
/// Test JSON extraction allows whitespaces after header
test "json allows whitespaces after header" {
  let input1 = "---json  \n{\"foo\": 0}\n---\n"
  let result1 = extract_json(input1)
  inspect(result1.attrs, content="{\"foo\": 0}")
  let input2 = "= json =  \n{\"foo\": 0}\n= json =\n"
  let result2 = extract_json(input2)
  inspect(result2.attrs, content="{\"foo\": 0}")
}

///|
/// Test JSON handles empty front matter 
test "json handles empty front matter" {
  let input1 = "---json\n---\n"
  let result1 = extract_json(input1)
  inspect(result1.front_matter, content="")
  inspect(result1.body, content="")
  inspect(result1.attrs, content="{}")
  let input2 = "---json\n\n---\n"
  let result2 = extract_json(input2)
  inspect(result2.front_matter, content="")
  inspect(result2.body, content="")
  let input3 = "---json\n   \n---\n"
  let result3 = extract_json(input3)
  inspect(result3.front_matter, content="")
  inspect(result3.body, content="")
}

///|
/// Test YAML front matter extraction
test "yaml extracts front matter correctly" {
  let input = "---\nfoo: bar\n---\nHello, world!"
  let result = extract_yaml(input)
  inspect(result.front_matter, content="foo: bar")
  inspect(result.body, content="Hello, world!")
  inspect(result.attrs, content="foo: bar")
}

///|
/// Test TOML front matter extraction
test "toml extracts front matter correctly" {
  let input = "+++\nfoo = \"bar\"\n+++\nHello, world!"
  let result = extract_toml(input)
  inspect(result.front_matter, content="foo = \"bar\"")
  inspect(result.body, content="Hello, world!")
  inspect(result.attrs, content="foo = \"bar\"")
}

///|
/// Test any format extraction with YAML
test "any format detects yaml" {
  let input = "---\nfoo: bar\n---\nHello, world!"
  let result = extract_any(input)
  inspect(result.front_matter, content="foo: bar")
  inspect(result.body, content="Hello, world!")
}

///|
/// Test any format extraction with TOML
test "any format detects toml" {
  let input = "+++\nfoo = \"bar\"\n+++\nHello, world!"
  let result = extract_any(input)
  inspect(result.front_matter, content="foo = \"bar\"")
  inspect(result.body, content="Hello, world!")
}

///|
/// Test any format extraction with JSON
test "any format detects json" {
  let input = "---json\n{\n  \"foo\": \"bar\"\n}\n---\nHello, world!"
  let result = extract_any(input)
  inspect(result.front_matter, content="{\n  \"foo\": \"bar\"\n}")
  inspect(result.body, content="Hello, world!")
}

///|
/// Test BOM handling in any format extraction
test "any format handles bom" {
  let input = "\ufeff---\nfoo: bar\n---\nHello, world!\n"
  let result = extract_any(input)
  inspect(result.front_matter, content="foo: bar")
  inspect(result.body, content="Hello, world!\n")
}

///|
/// Test YAML extraction allows whitespaces after header (matching TypeScript yaml_test.ts)
test "yaml allows whitespaces after header" {
  let input1 = "---  \nfoo: 0\n---\n"
  let result1 = extract_yaml(input1)
  inspect(result1.attrs, content="foo: 0")
  let input2 = "---yaml  \nfoo: 0\n--- \n"
  let result2 = extract_yaml(input2)
  inspect(result2.attrs, content="foo: 0")
  let input3 = "= yaml =  \nfoo: 0\n---\n"
  let result3 = extract_yaml(input3)
  inspect(result3.attrs, content="foo: 0")
}

///|
/// Test YAML handles empty front matter (matching TypeScript yaml_test.ts)
test "yaml handles empty front matter" {
  let input1 = "---\n---\n"
  let result1 = extract_yaml(input1)
  inspect(result1.front_matter, content="")
  inspect(result1.body, content="")
  inspect(result1.attrs, content="")
  let input2 = "---\n\n---\n"
  let result2 = extract_yaml(input2)
  inspect(result2.front_matter, content="")
  inspect(result2.body, content="")
  let input3 = "---\n   \n---\n"
  let result3 = extract_yaml(input3)
  inspect(result3.front_matter, content="")
  inspect(result3.body, content="")
}

///|
/// Test TOML extraction allows whitespaces after header (matching TypeScript toml_test.ts)
test "toml allows whitespaces after header" {
  let input1 = "---toml  \nfoo = 0\n---\n"
  let result1 = extract_toml(input1)
  inspect(result1.attrs, content="foo = 0")
  let input2 = "+++  \nfoo = 0\n--- \n"
  let result2 = extract_toml(input2)
  inspect(result2.attrs, content="foo = 0")
  let input3 = "= toml =  \nfoo = 0\n---\n"
  let result3 = extract_toml(input3)
  inspect(result3.attrs, content="foo = 0")
}

///|
/// Test TOML handles empty front matter (matching TypeScript toml_test.ts)
test "toml handles empty front matter" {
  let input1 = "---toml\n---"
  let result1 = extract_toml(input1)
  inspect(result1.front_matter, content="")
  inspect(result1.body, content="")
  inspect(result1.attrs, content="")
  let input2 = "---toml\n\n---\n"
  let result2 = extract_toml(input2)
  inspect(result2.front_matter, content="")
  inspect(result2.body, content="")
  let input3 = "---toml\n   \n---\n"
  let result3 = extract_toml(input3)
  inspect(result3.front_matter, content="")
  inspect(result3.body, content="")
}

///|
/// Test complex YAML content with delimiters in body (matching TypeScript yaml_test.ts)
test "yaml extracts complex content with delimiters in body" {
  let input = "---\ntitle: Three dashes marks the spot\ntags:\n  - yaml\n  - front-matter\n  - dashes\nexpanded-description: with some --- crazy stuff in it\n---\ndon't break\n---\nAlso this shouldn't be a problem\n"
  let result = extract_yaml(input)
  inspect(
    result.front_matter,
    content="title: Three dashes marks the spot\ntags:\n  - yaml\n  - front-matter\n  - dashes\nexpanded-description: with some --- crazy stuff in it",
  )
  inspect(
    result.body,
    content="don't break\n---\nAlso this shouldn't be a problem\n",
  )
}

///|
/// Test complex TOML content with multiple delimiter patterns
test "toml parses with +++ delimiters and complex content" {
  let input = "+++\ntitle = 'Three pluses followed by the format marks the spot'\ntags = ['toml', 'front-matter']\n'expanded-description' = 'with some +++toml crazy stuff in it'\n+++\ndon't break\n+++\nAlso = '+++toml this shouldn't be a problem'\n"
  let result = extract_toml(input)
  inspect(
    result.front_matter,
    content="title = 'Three pluses followed by the format marks the spot'\ntags = ['toml', 'front-matter']\n'expanded-description' = 'with some +++toml crazy stuff in it'",
  )
  inspect(
    result.body,
    content="don't break\n+++\nAlso = '+++toml this shouldn't be a problem'\n",
  )
}

///|
/// Test error cases for invalid input (matching TypeScript behavior)
test "yaml throws on invalid input cases" {
  let mut error_count = 0

  // Test empty string
  try {
    let _ = extract_yaml("")
    fail("Should have thrown error for empty string")
  } catch {
    EmptyInput | NoValidHeader | MissingFooter | InvalidHeaderFormat | MinimumStructure | UnsupportedFormat =>
      error_count = error_count + 1
    _ => fail("Unexpected error type")
  }

  // Test incomplete delimiter
  try {
    let _ = extract_yaml("---")
    fail("Should have thrown error for incomplete delimiter")
  } catch {
    EmptyInput | NoValidHeader | MissingFooter | InvalidHeaderFormat | MinimumStructure | UnsupportedFormat =>
      error_count = error_count + 1
    _ => fail("Unexpected error type")
  }

  // Test header without newline
  try {
    let _ = extract_yaml("---yaml")
    fail("Should have thrown error for header without newline")
  } catch {
    EmptyInput | NoValidHeader | MissingFooter | InvalidHeaderFormat | MinimumStructure | UnsupportedFormat =>
      error_count = error_count + 1
    _ => fail("Unexpected error type")
  }

  // Test header with newline but no closing delimiter
  try {
    let _ = extract_yaml("---\nasdasdasd")
    fail("Should have thrown error for missing closing delimiter")
  } catch {
    EmptyInput | NoValidHeader | MissingFooter | InvalidHeaderFormat | MinimumStructure | UnsupportedFormat =>
      error_count = error_count + 1
    _ => fail("Unexpected error type")
  }
  inspect(error_count, content="4")
}

///|
/// Test error cases for TOML invalid input 
test "toml throws on invalid input cases" {
  let mut error_count = 0

  // Test empty string
  try {
    let _ = extract_toml("")
    fail("Should have thrown error for empty string")
  } catch {
    EmptyInput | NoValidHeader | MissingFooter | InvalidHeaderFormat | MinimumStructure | UnsupportedFormat =>
      error_count = error_count + 1
    _ => fail("Unexpected error type")
  }

  // Test incomplete delimiter
  try {
    let _ = extract_toml("---toml")
    fail("Should have thrown error for incomplete delimiter")
  } catch {
    EmptyInput | NoValidHeader | MissingFooter | InvalidHeaderFormat | MinimumStructure | UnsupportedFormat =>
      error_count = error_count + 1
    _ => fail("Unexpected error type")
  }

  // Test wrong delimiter for TOML
  try {
    let _ = extract_toml("---")
    fail("Should have thrown error for wrong delimiter")
  } catch {
    EmptyInput | NoValidHeader | MissingFooter | InvalidHeaderFormat | MinimumStructure | UnsupportedFormat =>
      error_count = error_count + 1
    _ => fail("Unexpected error type")
  }
  inspect(error_count, content="3")
}

///|
/// Test error cases for JSON invalid input
test "json throws on invalid input cases" {
  let mut error_count = 0

  // Test empty string
  try {
    let _ = extract_json("")
    fail("Should have thrown error for empty string")
  } catch {
    EmptyInput | NoValidHeader | MissingFooter | InvalidHeaderFormat | MinimumStructure | UnsupportedFormat =>
      error_count = error_count + 1
    _ => fail("Unexpected error type")
  }

  // Test incomplete delimiter
  try {
    let _ = extract_json("---json")
    fail("Should have thrown error for incomplete delimiter")
  } catch {
    EmptyInput | NoValidHeader | MissingFooter | InvalidHeaderFormat | MinimumStructure | UnsupportedFormat =>
      error_count = error_count + 1
    _ => fail("Unexpected error type")
  }

  // Test wrong delimiter for JSON
  try {
    let _ = extract_json("---")
    fail("Should have thrown error for wrong delimiter")
  } catch {
    EmptyInput | NoValidHeader | MissingFooter | InvalidHeaderFormat | MinimumStructure | UnsupportedFormat =>
      error_count = error_count + 1
    _ => fail("Unexpected error type")
  }
  inspect(error_count, content="3")
}

///|
/// Test unsupported format handling (matching TypeScript any_test.ts)
test "any format throws on unsupported format" {
  let input = "---unsupported\nfoo: bar\n---\nHello, world!"
  try {
    let _ = extract_any(input)
    fail("Should have thrown error for unsupported format")
  } catch {
    UnsupportedFormat => ()
    _ => fail("Unexpected error type")
  }
}

///|
/// Test any format handles BOM when recognizing format (matching TypeScript any_test.ts)
test "any format handles BOM when recognizing format" {
  let input = "\ufeff---\nfoo: bar\n---\nHello, world!\n"
  let result = extract_any(input)
  inspect(result.front_matter, content="foo: bar")
  inspect(result.body, content="Hello, world!\n")
  inspect(result.attrs, content="foo: bar")
}

///|
/// Test any format extraction with various inputs matching TypeScript patterns
test "any format extracts yaml data" {
  let input = "---\nfoo: bar\n---\nHello, world!"
  let result = extract_any(input)
  inspect(result.front_matter, content="foo: bar")
  inspect(result.body, content="Hello, world!")
  inspect(result.attrs, content="foo: bar")
}

///|
test "any format extracts toml data" {
  let input = "+++\nfoo = \"bar\"\n+++\nHello, world!"
  let result = extract_any(input)
  inspect(result.front_matter, content="foo = \"bar\"")
  inspect(result.body, content="Hello, world!")
  inspect(result.attrs, content="foo = \"bar\"")
}

///|
test "any format extracts json data" {
  let input = "---json\n{\n  \"foo\": \"bar\"\n}\n---\nHello, world!"
  let result = extract_any(input)
  inspect(result.front_matter, content="{\n  \"foo\": \"bar\"\n}")
  inspect(result.body, content="Hello, world!")
  inspect(result.attrs, content="{\n  \"foo\": \"bar\"\n}")
}

///|
/// Test utility functions for improved coverage
test "utility functions coverage" {
  // Test BOM detection
  let bom_text = "\ufefftest"
  let has_bom_result = has_bom(bom_text)
  inspect(has_bom_result, content="true")

  // Test format pattern functions
  let yaml_footers = get_footer_patterns(Yaml)
  inspect(yaml_footers.contains("---"), content="true")
  let toml_headers = get_header_patterns(Toml)
  inspect(toml_headers.contains("+++"), content="true")

  // Test format checking functions
  let yaml_has_header = format_has_header(Yaml, "---")
  inspect(yaml_has_header, content="true")
  let json_has_footer = format_has_footer(Json, "---")
  inspect(json_has_footer, content="true")
}

///|
/// Test error handling for invalid inputs
test "extraction handles invalid inputs" {
  // Test empty input
  try {
    let _ = extract_json("")
    fail("Should have thrown error for empty input")
  } catch {
    EmptyInput | NoValidHeader | MissingFooter | InvalidHeaderFormat | MinimumStructure | UnsupportedFormat =>
      ()
    _ => fail("Unexpected error type")
  }

  // Test missing delimiters
  try {
    let _ = extract_json("---")
    fail("Should have thrown error for incomplete delimiters")
  } catch {
    EmptyInput | NoValidHeader | MissingFooter | InvalidHeaderFormat | MinimumStructure | UnsupportedFormat =>
      ()
    _ => fail("Unexpected error type")
  }

  // Test wrong format
  try {
    let _ = extract_json("---toml\nfoo = \"bar\"\n---\n")
    fail("Should have thrown error for wrong format")
  } catch {
    EmptyInput | NoValidHeader | MissingFooter | InvalidHeaderFormat | MinimumStructure | UnsupportedFormat =>
      ()
    _ => fail("Unexpected error type")
  }
}

///|
/// Test format detection for various edge cases
test "format detection edge cases" {
  // Empty string
  let empty_result = detect_format_any("")
  inspect(empty_result, content="None")

  // Invalid format
  let invalid_result = detect_format_any("---unsupported\nfoo: bar\n---\n")
  inspect(invalid_result, content="None")

  // Valid YAML
  let yaml_result = detect_format_any("---\nfoo: bar\n---\n")
  inspect(yaml_result, content="Some(Yaml)")

  // Valid TOML
  let toml_result = detect_format_any("+++\nfoo = \"bar\"\n+++\n")
  inspect(toml_result, content="Some(Toml)")

  // Valid JSON
  let json_result = detect_format_any("---json\n{\"foo\": \"bar\"}\n---\n")
  inspect(json_result, content="Some(Json)")
}

///|
/// Test front matter testing functions
test "front matter testing functions" {
  // Test YAML recognition
  assert_true(test_yaml_format("---\nfoo: bar\n---\n"))
  assert_true(test_yaml_format("---yaml\nfoo: bar\n---\n"))
  assert_true(test_yaml_format("= yaml =\nfoo: bar\n= yaml =\n"))
  assert_false(test_yaml_format(""))
  assert_false(test_yaml_format("---json\n{}\n---\n"))

  // Test TOML recognition
  assert_true(test_toml_format("---toml\nfoo = \"bar\"\n---\n"))
  assert_true(test_toml_format("+++\nfoo = \"bar\"\n+++\n"))
  assert_true(test_toml_format("= toml =\nfoo = \"bar\"\n= toml =\n"))
  assert_false(test_toml_format(""))
  assert_false(test_toml_format("---\nfoo: bar\n---\n"))

  // Test JSON recognition
  assert_true(test_json_format("---json\n{\"foo\": \"bar\"}\n---\n"))
  assert_true(test_json_format("= json =\n{\"foo\": \"bar\"}\n= json =\n"))
  assert_false(test_json_format(""))
  assert_false(test_json_format("---\nfoo: bar\n---\n"))

  // Test general front matter detection
  assert_true(has_front_matter("---\nfoo: bar\n---\n"))
  assert_true(has_front_matter("+++\nfoo = \"bar\"\n+++\n"))
  assert_true(has_front_matter("---json\n{\"foo\": \"bar\"}\n---\n"))
  assert_false(has_front_matter(""))
  assert_false(has_front_matter("Just regular content"))
}

///|
/// Test whitespace handling edge cases  
test "whitespace handling edge cases" {
  // Test trailing whitespace in headers
  let input1 = "---yaml   \nfoo: bar\n---\nContent"
  assert_true(test_yaml_format(input1))
  let input2 = "= yaml =  \t\nfoo: bar\n= yaml =\nContent"
  assert_true(test_yaml_format(input2))

  // Test that non-whitespace after header fails
  let invalid_input = "---yamlextra\nfoo: bar\n---\nContent"
  assert_false(test_yaml_format(invalid_input))
}

///|
/// Test BOM (Byte Order Mark) handling
test "bom handling" {
  let bom_yaml = "\ufeff---\nfoo: bar\n---\nContent"
  assert_true(test_yaml_format(bom_yaml))
  assert_true(has_front_matter(bom_yaml))
  let bom_json = "\ufeff---json\n{\"foo\": \"bar\"}\n---\nContent"
  assert_true(test_json_format(bom_json))
  let bom_toml = "\ufeff+++\nfoo = \"bar\"\n+++\nContent"
  assert_true(test_toml_format(bom_toml))
}

///|
/// Test that horizontal rules are not detected as front matter (TypeScript test_test.ts)
test "horizontal rules not detected as front matter" {
  let str = "# Project title\n\n---\n\nThis is a test for issue #2595\n\n- **Author:** The Deno Authors\n- **Version:** 0.1.0\n- **License:** MIT\n\n---\n\nMIT License"
  assert_false(test_yaml_format(str))
  assert_false(has_front_matter(str))
}

///|
/// Test wrong format detection (TypeScript test_test.ts pattern)
test "wrong format detection" {
  let json_input = "---json\n{\"title\": \"Three dashes followed by format marks the spot\"}\n---\n"
  // Should return false when testing specifically for YAML  
  let result = test_format(json_input, Yaml)
  assert_false(result)

  // Should return true when testing for JSON
  let json_result = test_format(json_input, Json)
  assert_true(json_result)
}

///|
/// Test missing newline before body (TypeScript yaml_test.ts pattern)
test "yaml throws at missing newline before body" {
  let input = "---yaml\nfoo: bar\n---body"
  try {
    let _ = extract_yaml(input)
    fail("Should have thrown error for missing newline before body")
  } catch {
    MissingFooter => ()
    _ => fail("Unexpected error type")
  }
}

///|
/// Test unstable YAML module functionality
test "unstable yaml module functions" {
  // Test basic unstable extraction
  let input = "---\nfoo: bar\n---\nContent"
  let result = extract_yaml_with_options(input)
  inspect(result.front_matter, content="foo: bar")
  inspect(result.body, content="Content")

  // Test unstable alternative entry point
  let result2 = extract_unstable(input)
  inspect(result2.front_matter, content="foo: bar")

  // Test unstable testing function
  let valid = test_yaml_unstable(input)
  assert_true(valid)

  // Test extraction with options (future extensibility)
  let result3 = extract_with_options(input, true)
  inspect(result3.front_matter, content="foo: bar")

  // Test strict and lenient modes
  let result4 = extract_strict(input)
  inspect(result4.front_matter, content="foo: bar")
  let result5 = extract_lenient(input)
  inspect(result5.front_matter, content="foo: bar")
}

///|
/// Test edge cases for better coverage of error handling paths  
test "additional error handling edge cases" {
  // Test invalid header patterns that don't match expected formats
  try {
    let _ = extract_yaml("---invalid\nfoo: bar\n---\n")
    fail("Should have thrown error for invalid header")
  } catch {
    EmptyInput | NoValidHeader | MissingFooter | InvalidHeaderFormat | MinimumStructure | UnsupportedFormat =>
      ()
    _ => fail("Unexpected error type")
  }

  // Test TOML extraction with invalid header pattern
  try {
    let _ = extract_toml("---invalid\nfoo = \"bar\"\n---\n")
    fail("Should have thrown error for invalid TOML header")
  } catch {
    EmptyInput | NoValidHeader | MissingFooter | InvalidHeaderFormat | MinimumStructure | UnsupportedFormat =>
      ()
    _ => fail("Unexpected error type")
  }

  // Test JSON extraction with invalid header pattern
  try {
    let _ = extract_json("---invalid\n{\"foo\": \"bar\"}\n---\n")
    fail("Should have thrown error for invalid JSON header")
  } catch {
    EmptyInput | NoValidHeader | MissingFooter | InvalidHeaderFormat | MinimumStructure | UnsupportedFormat =>
      ()
    _ => fail("Unexpected error type")
  }

  // Test content with footer followed by non-whitespace (edge case)
  try {
    let _ = extract_yaml("---\nfoo: bar\n---content")
    fail("Should have thrown error for content immediately after footer")
  } catch {
    EmptyInput | NoValidHeader | MissingFooter | InvalidHeaderFormat | MinimumStructure | UnsupportedFormat =>
      ()
    _ => fail("Unexpected error type")
  }
}

///|
/// Test FrontMatterError display functionality for coverage
test "front matter error display" {
  try {
    let _ = extract_yaml("")
    fail("Should have thrown error")
  } catch {
    EmptyInput => ()
    _ => fail("Unexpected error type")
  }
}

///|
/// Test Unicode character handling (including emoji)
/// This ensures our implementation properly handles Unicode characters 
/// as seen in TypeScript reference tests
test "unicode character handling" {
  let input = "+++\ntitle = 'Three pluses with 👌 emoji'\ndescription = 'Unicode: ñáéíóú 中文 🎉'\n+++\nBody with more Unicode: ñáéíóú 中文 🎉\n"
  let result = extract_toml(input)
  inspect(
    result.front_matter,
    content="title = 'Three pluses with 👌 emoji'\ndescription = 'Unicode: ñáéíóú 中文 🎉'",
  )
  inspect(
    result.body,
    content="Body with more Unicode: ñáéíóú 中文 🎉\n",
  )

  // Test YAML with Unicode
  let yaml_input = "---\ntitle: Unicode test 🎯\nname: José María\ngreeting: こんにちは\n---\nUnicode body: 测试 🌟\n"
  let yaml_result = extract_yaml(yaml_input)
  inspect(
    yaml_result.front_matter,
    content="title: Unicode test 🎯\nname: José María\ngreeting: こんにちは",
  )
  inspect(yaml_result.body, content="Unicode body: 测试 🌟\n")
}

///|
/// Test BOM (Byte Order Mark) handling refinement
/// This ensures our BOM detection and removal works properly
test "bom handling refinement" {
  // Test with BOM prefix (following TypeScript BOM pattern)
  let bom = "\ufeff"
  let input_with_bom = bom + "---\ntitle: BOM test\n---\nContent after BOM\n"
  let result = extract_yaml(input_with_bom)
  inspect(result.front_matter, content="title: BOM test")
  inspect(result.body, content="Content after BOM\n")

  // Test detection function
  let has_bom_result = has_bom(input_with_bom)
  inspect(has_bom_result, content="true")
  let input_without_bom = "---\ntitle: No BOM\n---\nContent without BOM\n"
  let no_bom_result = has_bom(input_without_bom)
  inspect(no_bom_result, content="false")
}

///|
/// Test unstable YAML extraction with validation enabled
test "unstable yaml extract with validation enabled" {
  let input = "---yaml\ndate: 2024-08-20\n---\nContent"
  let result = extract_with_validation(input, true)
  inspect(result.front_matter, content="date: 2024-08-20")
  inspect(result.body, content="Content")
}

///|
/// Test unstable YAML extraction with validation disabled
test "unstable yaml extract with validation disabled" {
  let input = "---yaml\ndate: 2024-08-20\n---\nContent"
  let result = extract_with_validation(input, false)
  inspect(result.front_matter, content="date: 2024-08-20")
  inspect(result.body, content="Content")
}

///|
/// Test unstable YAML validation error for insufficient lines
test "unstable yaml validation error for insufficient lines" {
  let input = "---yaml\n"
  try {
    let _ = extract_with_validation(input, true)
    fail("Expected FrontMatterError")
  } catch {
    EmptyInput | NoValidHeader | MissingFooter | InvalidHeaderFormat | MinimumStructure | UnsupportedFormat =>
      ()
    _ => fail("Expected FrontMatterError")
  }
}

///|
/// Test unstable YAML extraction with schema types
test "unstable yaml extract with schema types" {
  let input = "---yaml\ndate: 2024-08-20\n---\nContent"

  // Test different schema types
  let result1 = extract_with_schema(input, "json")
  inspect(result1.front_matter, content="date: 2024-08-20")
  let result2 = extract_with_schema(input, "core")
  inspect(result2.front_matter, content="date: 2024-08-20")
  let result3 = extract_with_schema(input, "default")
  inspect(result3.front_matter, content="date: 2024-08-20")
  let result4 = extract_with_schema(input, "unsupported")
  inspect(result4.front_matter, content="date: 2024-08-20")
}

///|
/// Test performance optimization validation - boundary checking
test "performance optimization validation - boundary checking" {
  let input = "---json\n{\"key\": \"value\"}\n---body"
  try {
    let _ = extract_json(input)
    fail("Expected FrontMatterError for boundary violation")
  } catch {
    MissingFooter => ()
    _ => fail("Expected FrontMatterError")
  }
}

///|
/// Test optimized string processing paths
test "optimized string processing paths" {
  // Test empty front matter case with optimized body extraction
  let input = "---\n---\nBody content here"
  let result = extract_yaml(input)
  inspect(result.front_matter, content="")
  inspect(result.body, content="Body content here")

  // Test complex content with optimized extraction
  let complex_input = "---json\n{\"key1\": \"value1\", \"key2\": [1, 2, 3]}\n---\nLong body content\nwith multiple lines\nand special characters: @#$%\n"
  let complex_result = extract_json(complex_input)
  inspect(
    complex_result.front_matter,
    content="{\"key1\": \"value1\", \"key2\": [1, 2, 3]}",
  )
  inspect(
    complex_result.body,
    content="Long body content\nwith multiple lines\nand special characters: @#$%\n",
  )
}

///|
/// Test enhanced error boundary validation
test "enhanced error boundary validation" {
  // Test footer delimiter with trailing content that should trigger error
  let problematic_inputs = [
    "---json\n{\"test\": true}\n---extra", "= json =\n{\"test\": true}\n= json =extra",
    "+++\ntest = true\n+++extra",
  ]
  let mut error_count = 0
  for i = 0; i < problematic_inputs.length(); i = i + 1 {
    let input = problematic_inputs[i].to_string()
    try {
      let _ = if input.contains("json") {
        extract_json(input)
      } else {
        extract_toml(input)
      }
      fail("Expected FrontMatterError for input with trailing content")
    } catch {
      EmptyInput | NoValidHeader | MissingFooter | InvalidHeaderFormat | MinimumStructure | UnsupportedFormat =>
        error_count = error_count + 1
      _ => fail("Expected FrontMatterError")
    }
  }
  inspect(error_count, content="3")
}
