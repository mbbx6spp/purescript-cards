{ name = "purescript-starter"
, dependencies =
  [ "console"
  , "effect"
  , "express"
  , "generics-rep"
  , "node-fs-aff"
  , "node-process"
  , "node-url"
  , "prelude"
  , "psci-support"
  ]
, source =
  [ "src/**/*.purs"
  ]
, packages = ./packages.dhall
}