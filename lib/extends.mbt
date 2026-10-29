///|
pub extend Extract with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend Extract with Eq::{not_equal, equal}

///|
pub extend Extract with Show::{to_string, output}

///|
pub extend Format with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend Format with Eq::{not_equal, equal}

///|
pub extend Format with Show::{output}
