{ name = "purescript-cards"
, dependencies =
  [ "aff"
  , "console"
  , "effect"
  , "express"
  , "generics-rep"
  , "js-date"
  , "lists"
  , "node-process"
  , "prelude"
  , "profunctor-lenses"
  , "psci-support"
  , "refs"
  , "transformers"
  , "tuples"
  ]
, sources = [ "src/**/*.purs" ]
, packages = ./packages.dhall
}
