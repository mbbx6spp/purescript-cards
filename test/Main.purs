module Test.Main where

import Data.Function (($))
import Data.Unit (Unit)
import Effect (Effect)
import Effect.Aff (launchAff_)
import Test.Spec (describe, it, pending)
import Test.Spec.Reporter.Console (consoleReporter)
import Test.Spec.Runner (runSpec)

main :: Effect Unit
main = launchAff_ $ runSpec [consoleReporter] do
  describe "Backend API" do
    describe "GET /" do
      pending "returns expected JSON"
    describe "GET /cards/shuffle" do
      pending "returns expected shuffled card hand via JSON"
