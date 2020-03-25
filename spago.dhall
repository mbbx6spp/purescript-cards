{ name = "purescript-starter"
, dependencies =
  [ "console"
  , "effect"
  , "generics-rep"
  , "prelude"
  , "psci-support"
  ]
, sources =
  [ "src/**/*.purs"
  ]
, packages = ./packages.dhall
}