{ name = "purescript-starter"
, dependencies =
  [ "console"
  , "effect"
  , "express"
  , "generics-rep"
  , "prelude"
  , "psci-support"
  ]
, sources =
  [ "src/**/*.purs"
  ]
, packages = ./packages.dhall
}