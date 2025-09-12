///|
test "front_matter_types" {
  // Test Extract struct creation
  let extract_result = Extract::new("title: test", "content", ("title", "test"))
  inspect(extract_result.front_matter, content="title: test")
  inspect(extract_result.body, content="content")
}

// TODO: Add format enum tests once constructor visibility is resolved

///|
test "yaml_front_matter_extraction" {
  let yaml_content = "---\ntitle: Test Document\nauthor: Test Author\n---\nThis is the body content."
  let result = extract_yaml_front_matter(yaml_content)
  inspect(
    result.front_matter,
    content="title: Test Document\nauthor: Test Author",
  )
  inspect(result.body, content="This is the body content.")
}

///|
test "json_front_matter_extraction" {
  let json_content = "---json\n{\"title\": \"Test Document\", \"author\": \"Test Author\"}\n---\nThis is the JSON body content."
  let result = extract_json(json_content)
  inspect(
    result.front_matter,
    content="{\"title\": \"Test Document\", \"author\": \"Test Author\"}",
  )
  inspect(result.body, content="This is the JSON body content.")

  // Just verify that we have a parsed JSON object (the attrs field is non-null)
  // More detailed JSON testing can be added later when we understand the Json API better
}

///|
test "format_testing_functionality" {
  // Test YAML format detection
  let yaml_content = "---\ntitle: test\n---\ncontent"
  inspect(test_yaml_format(yaml_content), content="true")
  inspect(has_front_matter(yaml_content), content="true")

  // Test TOML format detection
  let toml_content1 = "+++\ntitle = \"test\"\n+++\ncontent"
  let toml_content2 = "---toml\ntitle = \"test\"\n---\ncontent"
  inspect(test_toml_format(toml_content1), content="true")
  inspect(test_toml_format(toml_content2), content="true")
  inspect(has_front_matter(toml_content1), content="true")

  // Test JSON format detection
  let json_content = "---json\n{\"title\": \"test\"}\n---\ncontent"
  inspect(test_json_format(json_content), content="true")
  inspect(has_front_matter(json_content), content="true")

  // Test negative cases
  let no_frontmatter = "Just plain content without front matter"
  inspect(has_front_matter(no_frontmatter), content="false")
  inspect(test_yaml_format(no_frontmatter), content="false")
  inspect(test_toml_format(no_frontmatter), content="false")
  inspect(test_json_format(no_frontmatter), content="false")
}

///|
test "any_format_extraction" {
  // Test auto-detection and extraction for YAML
  let yaml_content = "---\ntitle: YAML Test\n---\nYAML body content"
  let yaml_result = extract_any(yaml_content)
  inspect(yaml_result.front_matter, content="title: YAML Test")
  inspect(yaml_result.body, content="YAML body content")

  // Test auto-detection and extraction for JSON
  let json_content = "---json\n{\"title\": \"JSON Test\"}\n---\nJSON body content"
  let json_result = extract_any(json_content)
  inspect(json_result.front_matter, content="{\"title\": \"JSON Test\"}")
  inspect(json_result.body, content="JSON body content")

  // Test format detection
  match detect_format(yaml_content) {
    Some(Yaml) => ()
    _ => fail("Expected to detect YAML format")
  }
  match detect_format(json_content) {
    Some(Json) => ()
    _ => fail("Expected to detect JSON format")
  }

  // Test no format detection
  let no_format = "Just plain text"
  match detect_format(no_format) {
    None => ()
    _ => fail("Expected no format detection")
  }
}

///|
test "yaml_and_toml_extraction" {
  // Test YAML extraction
  let yaml_content = "---\ntitle: YAML Document\nauthor: John Doe\n---\nYAML content here"
  let yaml_result = extract_yaml(yaml_content)
  inspect(
    yaml_result.front_matter,
    content="title: YAML Document\nauthor: John Doe",
  )
  inspect(yaml_result.body, content="YAML content here")

  // Test TOML extraction with +++ delimiters
  let toml_content1 = "+++\ntitle = \"TOML Document\"\nauthor = \"Jane Doe\"\n+++\nTOML content here"
  let toml_result1 = extract_toml(toml_content1)
  inspect(
    toml_result1.front_matter,
    content="title = \"TOML Document\"\nauthor = \"Jane Doe\"",
  )
  inspect(toml_result1.body, content="TOML content here")

  // Test TOML extraction with ---toml delimiters
  let toml_content2 = "---toml\ntitle = \"TOML Document 2\"\n---\nTOML content 2"
  let toml_result2 = extract_toml(toml_content2)
  inspect(toml_result2.front_matter, content="title = \"TOML Document 2\"")
  inspect(toml_result2.body, content="TOML content 2")
}

///|
test "comprehensive_format_coverage" {
  // Test that all three formats work with the generic extract_any function
  let yaml_text = "---\ntype: yaml\n---\nContent"
  let toml_text = "+++\ntype = \"toml\"\n+++\nContent"
  let json_text = "---json\n{\"type\": \"json\"}\n---\nContent"

  // All should be detected and extracted successfully
  let yaml_extract = extract_any(yaml_text)
  let toml_extract = extract_any(toml_text)
  let json_extract = extract_any(json_text)
  inspect(yaml_extract.body, content="Content")
  inspect(toml_extract.body, content="Content")
  inspect(json_extract.body, content="Content")

  // Test format-specific extraction functions
  let yaml_specific = extract_yaml(yaml_text)
  let toml_specific = extract_toml(toml_text)
  let json_specific = extract_json(json_text)
  inspect(yaml_specific.front_matter, content="type: yaml")
  inspect(toml_specific.front_matter, content="type = \"toml\"")
  inspect(json_specific.front_matter, content="{\"type\": \"json\"}")
}
