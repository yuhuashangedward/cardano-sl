-- | Computation of LRC genesis data.

module Pos.Lrc.Genesis
    ( genesisLeaders
    ) where

import           Universum

import qualified Data.HashMap.Strict as HM

import           Pos.Core (GenesisData (..), SharedSeed (..), SlotLeaders, genesisData, HasGenesisData, HasProtocolConstants)
import           Pos.Lrc.Fts (followTheSatoshi)
import           Pos.Txp.GenesisUtxo (genesisUtxo)
import           Pos.Txp.Toil (GenesisUtxo (..), Utxo, utxoToStakes)


-- | Compute leaders of the 0-th epoch from initial shared seed and stake distribution.
genesisLeaders :: (HasGenesisData, HasProtocolConstants) => SlotLeaders
genesisLeaders = followTheSatoshiUtxo (gdFtsSeed genesisData) utxo
  where
    GenesisUtxo utxo = genesisUtxo

-- This should not be exported unless it is *needed* elsewhere
followTheSatoshiUtxo ::
       (HasGenesisData, HasProtocolConstants)
    => SharedSeed
    -> Utxo
    -> SlotLeaders
followTheSatoshiUtxo seed utxo =
    followTheSatoshi seed $ HM.toList $ utxoToStakes utxo
