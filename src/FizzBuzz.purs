module FizzBuzz (main) where

import Control.Applicative (pure)
import Control.Bind (bind, discard)
import Control.Monad (void)
import Control.Monad.State (StateT, get, runStateT)
import Data.Array (range)
import Data.Eq ((==))
import Data.Function (($))
import Data.Functor (map)
import Data.Int (rem)
import Data.Show (show)
import Data.String (joinWith)
import Data.Unit (Unit, unit)
import Effect (Effect)
import Effect.Class (liftEffect)
import Effect.Console (log)

fizzBuzz :: StateT (Array Int) Effect Unit
fizzBuzz = do
  xs <- get
  liftEffect $ log $ joinWith "\n" (map toString xs)
  pure unit
  where toString :: Int -> String
        toString n | n `rem` 15 == 0 = "FizzBuzz"
        toString n | n `rem` 5  == 0 = "Buzz"
        toString n | n `rem` 3  == 0 = "Fizz"
        toString n = show n

main :: Effect Unit
main  = void $ runStateT fizzBuzz (range 1 100)
