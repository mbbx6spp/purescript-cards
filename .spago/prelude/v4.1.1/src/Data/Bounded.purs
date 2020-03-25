module Data.Bounded
  ( class Bounded
  , bottom
  , top
  , module Data.Ord
  ) where

import Data.Ord (class Ord, Ordering(..), compare, (<), (<=), (>), (>=))
import Data.Unit (Unit, unit)

-- | The `Bounded` type class represents totally ordered types that have an
-- | upper and lower boundary.
-- |
-- | Instances should satisfy the following law in addition to the `Ord` laws:
-- |
-- | - Bounded: `bottom <= a <= top`
class Ord a <= Bounded a where
  top :: a
  bottom :: a

instance boundedBoolean :: Bounded Boolean where
  top = true
  bottom = false

-- | The `Bounded` `Int` instance has `top :: Int` equal to 2^31 - 1,
-- | and `bottom :: Int` equal to -2^31, since these are the largest and smallest
-- | integers representable by twos-complement 32-bit integers, respectively.
instance boundedInt :: Bounded Int where
  top = topInt
  bottom = bottomInt

foreign import topInt :: Int
foreign import bottomInt :: Int

-- | Characters fall within the Unicode range.
instance boundedChar :: Bounded Char where
  top = topChar
  bottom = bottomChar

foreign import topChar :: Char
foreign import bottomChar :: Char

instance boundedOrdering :: Bounded Ordering where
  top = GT
  bottom = LT

instance boundedUnit :: Bounded Unit where
  top = unit
  bottom = unit

foreign import topNumber :: Number
foreign import bottomNumber :: Number

instance boundedNumber :: Bounded Number where
  top = topNumber
  bottom = bottomNumber
