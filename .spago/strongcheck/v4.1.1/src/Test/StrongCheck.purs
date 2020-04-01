module Test.StrongCheck
  ( Result(..)
  , class Testable, test
  , quickCheck
  , quickCheck'
  , quickCheckWithSeed
  , quickCheckPure
  , smallCheck
  , smallCheckPure
  , statCheck
  , statCheckPure
  , assert
  , assertEq, (===)
  , assertNotEq, (/==)
  , annotate, (<?>)
  , module Exports
  )
  where

import Prelude

import Control.Monad.Free (Free)
import Control.Monad.Trampoline (runTrampoline)
import Data.Array as A
import Data.Foldable (class Foldable)
import Data.Int as Int
import Data.List (List(..), length)
import Data.List as List
import Data.Maybe (maybe)
import Data.Tuple (Tuple(..))
import Effect (Effect)
import Effect.Console (log)
import Effect.Exception (throwException, error)
import Math as Math
import Test.StrongCheck.Arbitrary (class Arbitrary, arbitrary)
import Test.StrongCheck.Arbitrary (class Arbitrary, arbitrary, class Coarbitrary, coarbitrary) as Exports
import Test.StrongCheck.Gen (GenT, Gen, GenState(..), collectAll, sample', decorateSeed)
import Test.StrongCheck.LCG (Seed, mkSeed) as Exports
import Test.StrongCheck.LCG (Seed, randomSeed, runSeed)

-- | The result of a property test.
data Result = Success | Failed String

derive instance eqResult :: Eq Result
derive instance ordResult :: Ord Result

instance showResult :: Show Result where
  show Success = "Success"
  show (Failed msg) = "Failed: " <> msg

instance semigroupResult :: Semigroup Result where
  append Success Success = Success
  append (Failed msg) Success = Failed msg
  append Success (Failed msg) = Failed msg
  append (Failed m1) (Failed m2) = Failed (m1 <> "\n" <> m2)

instance monoidResult :: Monoid Result where
  mempty = Success

-- | A class for types that can be treated as a property test result.
class Testable prop where
  test :: prop -> Gen Result

instance testableBoolean :: Testable Boolean where
  test true = pure Success
  test false = pure $ Failed "Test returned false"

instance testableResult :: Testable Result where
  test = pure

instance testableFunction :: (Arbitrary t, Testable prop) => Testable (t -> prop) where
  test f = test <<< f =<< arbitrary

instance testableGen :: Testable prop => Testable (GenT (Free (Function Unit)) prop) where
  test genProp = 
    genProp >>= test

-- | Checks the proposition for 100 random values.
quickCheck :: forall prop. Testable prop => prop -> Effect Unit
quickCheck prop = quickCheck' 100 prop

-- | Checks the proposition for the specified number of random values.
quickCheck' :: forall prop. Testable prop => Int -> prop -> Effect Unit
quickCheck' n prop = do
  seed <- randomSeed
  quickCheckWithSeed seed n prop

-- | Checks the proposition for the specified number of random values, starting with a specific seed.
quickCheckWithSeed :: forall prop. Testable prop => Seed -> Int -> prop -> Effect Unit
quickCheckWithSeed seed n prop = check (quickCheckPure n seed) prop

-- | Checks the proposition for the specified number of random values in a pure
-- | setting, returning an array of results.
quickCheckPure :: forall prop. Testable prop => Int -> Seed -> prop -> Array (Tuple Seed Result)
quickCheckPure n s prop = runTrampoline $ sample' n (defState s) (decorateSeed (test prop))

-- | Exhaustively checks the proposition for all possible values. Assumes the
-- | generator is a finite generator.
smallCheck :: forall prop. Testable prop => prop -> Effect Unit
smallCheck prop = do
  seed <- randomSeed
  check (smallCheckPure seed) prop

-- | Exhaustively checks the proposition for all possible values in a pure
-- | setting, returning an array of results. Assumes the generator is a finite
-- | generator.
smallCheckPure :: forall prop. Testable prop => Seed -> prop -> Array (Tuple Seed Result)
smallCheckPure s prop = runTrampoline $ collectAll (defState s) (decorateSeed (test prop))

-- | Checks that the proposition has a certain probability of being true for
-- | arbitrary values.
statCheck :: forall prop. Testable prop => Number -> prop -> Effect Unit
statCheck freq prop = do
  seed <- randomSeed
  log <<< show $ statCheckPure seed freq prop

-- | Checks that the proposition has a certain probability of being true for
-- | arbitrary values in a pure setting, returning a result.
statCheckPure :: forall prop. Testable prop => Seed -> Number -> prop -> Result
statCheckPure s freq prop = try 100
  where
  try :: Int -> Result
  try x =
    let
      measure :: Int -> Number
      measure n =
        let results = quickCheckPure n s prop
        in Int.toNumber $ (countSuccesses results) / (A.length results)

      measure' :: Int -> Array Number
      measure' 0 = []
      measure' n = measure' (n - 1) <> [measure (n * x)]

      freqs :: Array Number
      freqs = measure' 4

      dists :: Array Number
      dists = (Math.abs <<< (-) freq) <$> freqs

      dirs :: Array Number
      dirs  = A.zipWith (\a b -> a - b) ([1.0] <> dists) dists

      fails :: Int
      fails = A.length $ A.filter ((>) 0.0) dirs

      succs :: Array Number
      succs = A.filter ((<=) 0.0) dirs
    in
      if fails > 1
      then
        if x < 1000000 then try (x * 10)
        else Failed $ "Divergence of statistical test: freqs = " <> show freqs <> ", dists = " <> show dists <> ", dirs = " <> show dirs <> ", fails: " <> show fails
      else maybe (Failed "Error!") (\l -> if l > 0.5 then Failed $ "Final convergence distance too low: " <> show l else Success) (A.last succs)

defState :: Seed -> GenState
defState s = (GenState {seed: s, size: 10})

check :: forall prop f. Testable prop => Foldable f => (prop -> f (Tuple Seed Result)) -> prop -> Effect Unit
check f prop = do
  let results = f prop
  let successes = countSuccesses results
  log $ show successes <> "/" <> show (length $ List.fromFoldable results) <> " test(s) passed."
  throwOnFirstFailure 1 results

throwOnFirstFailure :: forall f. Foldable f => Int -> f (Tuple Seed Result) -> Effect Unit
throwOnFirstFailure n fr = throwOnFirstFailure' n (List.fromFoldable fr)
  where
  throwOnFirstFailure' :: Int -> List (Tuple Seed Result) -> Effect Unit
  throwOnFirstFailure' _ Nil = pure unit
  throwOnFirstFailure' n' (Cons (Tuple seed (Failed msg)) _) = throwException $ error $ "Test " <> show n' <> " (seed " <> show (runSeed seed) <> ") failed: \n" <> msg
  throwOnFirstFailure' n' (Cons _ rest) = throwOnFirstFailure (n' + 1) rest

countSuccesses :: forall f. Foldable f => f (Tuple Seed Result) -> Int
countSuccesses fa = countSuccesses' 0 (List.fromFoldable fa)
  where
  countSuccesses' acc Nil = acc
  countSuccesses' acc (Cons (Tuple _ Success) rest) = countSuccesses' (acc + 1) rest
  countSuccesses' acc (Cons _ rest) = countSuccesses' acc rest

-- | Checks that the specified proposition holds. Useful for unit tests.
assert :: forall prop. Testable prop => prop -> Effect Unit
assert = quickCheck' 1

-- | Converts a `Boolean` into a `Result` by lifting a message into `Failed`
-- | when the boolean is `false`.
annotate :: Boolean -> String -> Result
annotate true = const Success
annotate false = Failed

infix 1 annotate as <?>

-- | Asserts that two values are equal, resulting in a `Failure` if they are
-- | not, with a message showing the values involved.
assertEq :: forall a. Eq a => Show a => a -> a -> Result
assertEq a b = a == b <?> msg
  where
  msg = show a <> " /= " <> show b

infix 2 assertEq as ===

-- | Asserts that two values are not equal, resulting in a `Failure` if they
-- | are, with a message showing the values involved.
assertNotEq :: forall a. Eq a => Show a => a -> a -> Result
assertNotEq a b = a /= b <?> msg
  where
  msg = show a <> " == " <> show b

infix 2 assertNotEq as /==
