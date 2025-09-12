///|
/// Comprehensive demonstration of the front matter module capabilities
fn main {
  println("MoonBit Front Matter Module Demo")
  println("===============================")

  // Test YAML front matter
  println("\n1. YAML Front Matter:")
  let yaml_content = "---\ntitle: YAML Example\nauthor: MoonBit Team\ntags:\n  - yaml\n  - frontmatter\n---\nThis is YAML body content."
  try {
    let yaml_result = @lib.extract_yaml(yaml_content)
    println("   Front matter: " + yaml_result.front_matter)
    println("   Body: " + yaml_result.body)
    println(
      "   Has front matter: " + @lib.has_front_matter(yaml_content).to_string(),
    )
  } catch {
    @lib.FrontMatterError(msg) => println("   YAML Error: " + msg)
  }

  // Test TOML front matter
  println("\n2. TOML Front Matter:")
  let toml_content = "+++\ntitle = 'TOML Example'\nauthor = 'MoonBit Team'\ntags = ['toml', 'frontmatter']\n+++\nThis is TOML body content."
  try {
    let toml_result = @lib.extract_toml(toml_content)
    println("   Front matter: " + toml_result.front_matter)
    println("   Body: " + toml_result.body)
    println(
      "   Test TOML format: " + @lib.test_toml_format(toml_content).to_string(),
    )
  } catch {
    @lib.FrontMatterError(msg) => println("   TOML Error: " + msg)
  }

  // Test JSON front matter
  println("\n3. JSON Front Matter:")
  let json_content = "---json\n{\n  \"title\": \"JSON Example\",\n  \"author\": \"MoonBit Team\",\n  \"tags\": [\"json\", \"frontmatter\"]\n}\n---\nThis is JSON body content."
  try {
    let json_result = @lib.extract_json(json_content)
    println("   Front matter: " + json_result.front_matter)
    println("   Body: " + json_result.body)
    println(
      "   Test JSON format: " + @lib.test_json_format(json_content).to_string(),
    )
  } catch {
    @lib.FrontMatterError(msg) => println("   JSON Error: " + msg)
  }

  // Test auto-detection
  println("\n4. Auto-Detection:")
  try {
    let auto_result = @lib.extract_any(yaml_content)
    println("   Auto-detected YAML - Body: " + auto_result.body)
    let detected_format = @lib.detect_format_any(toml_content)
    match detected_format {
      Some(format) => println("   Detected format: " + format.to_string())
      None => println("   No format detected")
    }
  } catch {
    @lib.FrontMatterError(msg) => println("   Auto-detection Error: " + msg)
  }

  // Test Unicode and special characters
  println("\n5. Unicode Support:")
  let unicode_content = "---\ntitle: Unicode Test 🎯\nname: José María\ngreeting: こんにちは\n---\nUnicode body: 测试 🌟"
  try {
    let unicode_result = @lib.extract_yaml(unicode_content)
    println("   Unicode front matter extracted successfully")
    println("   Body length: " + unicode_result.body.length().to_string())
  } catch {
    @lib.FrontMatterError(msg) => println("   Unicode Error: " + msg)
  }
  println("\n✓ Front Matter Module Demo Complete!")
}
