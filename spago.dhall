{ name = "purescript"
, dependencies =
  [ "arrays"
  , "effect"
  , "integers"
  , "lazy"
  , "lists"
  , "maybe"
  , "pha"
  , "prelude"
  , "tuples"
  , "debug"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs" ]
}
