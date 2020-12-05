def assert($expected): 
  if . == $expected then . 
  else { 
    error: "Assertion Failed", 
    expected: $expected, 
    actual: .
  } 
  end
;
