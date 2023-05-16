{ name = "purescript"
, dependencies =
  [ "arrays"
  , "effect"
  , "integers"
  , "js-iterators"
  , "lazy"
  , "lists"
  , "maybe"
  , "pha"
  , "prelude"
  , "tuples"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs" ]
}
