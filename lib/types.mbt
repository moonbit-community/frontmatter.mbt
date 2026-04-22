// Copyright 2018-2025 the Deno authors. MIT license.
// Copyright 2025 International Digital Economy Academy

///|
/// Return type for extract function.
pub struct Extract[T] {
  /// The raw front matter string
  front_matter : String
  /// The body content after the front matter
  body : String
  /// The parsed attributes from the front matter
  attrs : T
} derive(Eq, Debug)

///|
pub impl[T : Show] Show for Extract[T] with output(self, logger) -> Unit {
  logger.write_string(
    "{front_matter: " +
    self.front_matter.to_string() +
    ", body: " +
    self.body.to_string() +
    ", attrs: " +
    self.attrs.to_string() +
    "}",
  )
}

///|
/// Create an Extract result
pub fn[T] Extract::new(
  front_matter : String,
  body : String,
  attrs : T,
) -> Extract[T] {
  { front_matter, body, attrs }
}
