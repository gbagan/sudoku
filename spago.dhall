{ name = "purescript"
, dependencies =
  [ "arrays"
  , "effect"
  , "functions"
  , "integers"
  , "js-iterators"
  , "lists"
  , "maybe"
  , "pha"
  , "prelude"
  , "tuples"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs" ]
}
