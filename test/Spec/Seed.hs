{-# LANGUAGE AllowAmbiguousTypes #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE UndecidableInstances #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}

module Spec.Seed where

import Data.Bits
import qualified Data.ByteString as BS
import Data.List.NonEmpty as NE
import Data.Maybe (fromJust)
import Data.Proxy
import Data.Word
import qualified GHC.Exts as GHC (IsList (..))
import GHC.TypeLits
import Spec.Stateful ()
import System.Random
import Test.SmallCheck.Series hiding (NonEmpty (..))
import Test.Tasty
import Test.Tasty.SmallCheck as SC

newtype GenN (n :: Nat) = GenN BS.ByteString
  deriving (Eq, Show)

instance (KnownNat n, Monad m) => Serial m (GenN n) where
  series = GenN . fst . uniformByteString n . mkStdGen <$> series
    where
      n = fromInteger (natVal (Proxy :: Proxy n))

instance (KnownNat n, Monad m) => Serial m (Gen64 n) where
  series =
    Gen64 . dropExtra . fst . uniformList n . mkStdGen <$> series
    where
      (n, r8) =
        case fromInteger (natVal (Proxy :: Proxy n)) `quotRem` 8 of
          (q, 0) -> (q, 0)
          (q, r) -> (q + 1, (8 - r) * 8)
      -- We need to drop extra top most bits in the last generated Word64 in order for
      -- roundtrip to work, because that is exactly what SeedGen will do
      dropExtra xs =
        case NE.reverse (fromJust (NE.nonEmpty xs)) of
          w64 :| rest -> NE.reverse ((w64 `shiftL` r8) `shiftR` r8 :| rest)

instance (1 <= n, KnownNat n) => SeedGen (GenN n) where
  type SeedSize (GenN n) = n
  toSeed (GenN bs) = fromJust . mkSeed . GHC.fromList $ BS.unpack bs
  fromSeed = GenN . BS.pack . GHC.toList . unSeed

newtype Gen64 (n :: Nat) = Gen64 (NonEmpty Word64)
  deriving (Eq, Show)

instance (1 <= n, KnownNat n) => SeedGen (Gen64 n) where
  type SeedSize (Gen64 n) = n
  toSeed64 (Gen64 ws) = ws
  fromSeed64 = Gen64

seedGenSpec ::
  forall g.
  (SeedGen g, Eq g, Show g, Serial IO g) =>
  TestTree
seedGenSpec =
  testGroup
    (seedGenTypeName @g)
    [ testProperty "fromSeed/toSeed" $
        forAll $
          \(g :: g) -> g == fromSeed (toSeed g)
    , testProperty "fromSeed64/toSeed64" $
        forAll $
          \(g :: g) -> g == fromSeed64 (toSeed64 g)
    ]

spec :: TestTree
spec =
  testGroup
    "SeedGen"
    [ seedGenSpec @StdGen
    , seedGenSpec @(GenN 1)
    , seedGenSpec @(GenN 2)
    , seedGenSpec @(GenN 3)
    , seedGenSpec @(GenN 4)
    , seedGenSpec @(GenN 5)
    , seedGenSpec @(GenN 6)
    , seedGenSpec @(GenN 7)
    , seedGenSpec @(GenN 8)
    , seedGenSpec @(GenN 9)
    , seedGenSpec @(GenN 10)
    , seedGenSpec @(GenN 11)
    , seedGenSpec @(GenN 12)
    , seedGenSpec @(GenN 13)
    , seedGenSpec @(GenN 14)
    , seedGenSpec @(GenN 15)
    , seedGenSpec @(GenN 16)
    , seedGenSpec @(GenN 17)
    , seedGenSpec @(Gen64 1)
    , seedGenSpec @(Gen64 2)
    , seedGenSpec @(Gen64 3)
    , seedGenSpec @(Gen64 4)
    , seedGenSpec @(Gen64 5)
    , seedGenSpec @(Gen64 6)
    , seedGenSpec @(Gen64 7)
    , seedGenSpec @(Gen64 8)
    , seedGenSpec @(Gen64 9)
    , seedGenSpec @(Gen64 10)
    , seedGenSpec @(Gen64 11)
    , seedGenSpec @(Gen64 12)
    , seedGenSpec @(Gen64 13)
    , seedGenSpec @(Gen64 14)
    , seedGenSpec @(Gen64 15)
    , seedGenSpec @(Gen64 16)
    , seedGenSpec @(Gen64 17)
    ]
