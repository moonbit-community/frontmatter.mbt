# rami3l/frontmatter

A MoonBit library for extracting front matter from strings. Supports YAML, TOML, and JSON front matter formats.

## Features

- **YAML front matter**: Extract content delimited by `---` or `---yaml`
- **TOML front matter**: Extract content delimited by `+++` or `---toml`
- **JSON front matter**: Extract content delimited by `---json` with full JSON parsing
- **Auto-detection**: Automatically detect and extract any supported format
- **Format testing**: Test if a string contains valid front matter
- **Type-safe**: Full MoonBit type safety with proper error handling

## Usage Examples

### Auto-Detection

```moonbit
test "auto_extract_example" {
  let content = "---\ntitle: My Document\nauthor: John Doe\n---\nThis is the main content."

  // Automatically detect and extract front matter
  inspect(
    extract_any(content),
    content=(
      #|{front_matter: "title: My Document\nauthor: John Doe", body: "This is the main content.", attrs: "title: My Document\nauthor: John Doe"}
    ),
  )
}
```

### Format-Specific Extraction

#### YAML Front Matter

```moonbit
test "yaml_example" {
  let yaml_content = "---\ntitle: YAML Document\ndate: 2024-01-01\n---\nYAML content here."
  let result = extract_yaml(yaml_content)
  inspect(result.front_matter, content="title: YAML Document\ndate: 2024-01-01")
  inspect(result.body, content="YAML content here.")
}
```

#### JSON Front Matter

```moonbit
test "json_example" {
  let json_content = "---json\n{\"title\": \"JSON Document\", \"author\": \"Jane Doe\"}\n---\nJSON content here."
  let result = extract_json(json_content)
  inspect(
    result.front_matter,
    content="{\"title\": \"JSON Document\", \"author\": \"Jane Doe\"}",
  )
  inspect(result.body, content="JSON content here.")

  // JSON is automatically parsed into Json objects
  // The attrs field contains the parsed JSON
}
```

#### TOML Front Matter

```moonbit
test "toml_example" {
  let toml_content = "+++\ntitle = \"TOML Document\"\nauthor = \"Bob Smith\"\n+++\nTOML content here."
  let result = extract_toml(toml_content)
  inspect(
    result.front_matter,
    content="title = \"TOML Document\"\nauthor = \"Bob Smith\"",
  )
  inspect(result.body, content="TOML content here.")
}
```

### Format Testing

```moonbit
test "format_testing_example" {
  let yaml_text = "---\ntitle: test\n---\ncontent"
  let json_text = "---json\n{\"title\": \"test\"}\n---\ncontent"
  let plain_text = "Just plain content"

  // Test for specific formats
  inspect(test_yaml_format(yaml_text), content="true")
  inspect(test_json_format(json_text), content="true")

  // Test for any front matter
  inspect(has_front_matter(yaml_text), content="true")
  inspect(has_front_matter(json_text), content="true")
  inspect(has_front_matter(plain_text), content="false")
}
```

### Format Detection

```moonbit
test "format_detection_example" {
  let yaml_content = "---\ntitle: test\n---\ncontent"
  inspect(detect_format(yaml_content), content="Some(Yaml)")
  let json_content = "---json\n{\"title\": \"test\"}\n---\ncontent"
  inspect(detect_format(json_content), content="Some(Json)")
}
```

## API Reference

### Core Types

- `Extract[T]`: Contains extracted front matter, body content, and parsed attributes

  - `front_matter: String`: Raw front matter content
  - `body: String`: Body content after front matter
  - `attrs: T`: Parsed attributes (type depends on extraction function)

- `Format`: Enumeration of supported formats (`Yaml`, `Toml`, `Json`)

### Extraction Functions

- `extract_any(text: String) -> Extract[String]`: Auto-detect and extract any format
- `extract_yaml(text: String) -> Extract[String]`: Extract YAML front matter
- `extract_toml(text: String) -> Extract[String]`: Extract TOML front matter
- `extract_json(text: String) -> Extract[Json]`: Extract and parse JSON front matter

### Testing Functions

- `has_front_matter(text: String) -> Bool`: Test if text has any front matter
- `test_yaml_format(text: String) -> Bool`: Test for YAML front matter
- `test_toml_format(text: String) -> Bool`: Test for TOML front matter
- `test_json_format(text: String) -> Bool`: Test for JSON front matter

### Utility Functions

- `detect_format(text: String) -> Format?`: Detect front matter format
- `test_format(text: String, format: Format) -> Bool`: Test for specific format

## Supported Delimiters

### YAML

- `---` ... `---` (standard)
- `---yaml` ... `---`

### TOML

- `+++` ... `+++`
- `---toml` ... `---`

### JSON

- `---json` ... `---`

## Error Handling

All extraction functions may raise `FrontMatterError` when:

- No front matter is found
- Front matter is not properly closed
- Invalid format for the specific parser (e.g., invalid JSON)

## License

Apache-2.0
