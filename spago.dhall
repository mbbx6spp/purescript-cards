{ name = "purescript-starter"
, dependencies =
  [ "console"
  , "effect"
  , "express"
  , "generics-rep"
  , "node-process"
  , "prelude"
  , "psci-support"
  , "refs"
  ]
, sources =
  [ "src/**/*.purs"
  ]
, packages = ./packages.dhall
}