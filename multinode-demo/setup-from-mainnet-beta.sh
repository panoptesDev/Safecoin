#!/usr/bin/env bash

here=$(dirname "$0")
# shellcheck source=multinode-demo/common.sh
source "$here"/common.sh

set -e

rm -rf "$PANOPTIS_CONFIG_DIR"/latest-mainnet-beta-snapshot
mkdir -p "$PANOPTIS_CONFIG_DIR"/latest-mainnet-beta-snapshot
(
  cd "$PANOPTIS_CONFIG_DIR"/latest-mainnet-beta-snapshot || exit 1
  set -x
  wget http://api.mainnet-beta.safecoin.org/genesis.tar.bz2
  wget --trust-server-names http://api.mainnet-beta.safecoin.org/snapshot.tar.bz2
)

snapshot=$(ls "$PANOPTIS_CONFIG_DIR"/latest-mainnet-beta-snapshot/snapshot-[0-9]*-*.tar.zst)
if [[ -z $snapshot ]]; then
  echo Error: Unable to find latest snapshot
  exit 1
fi

if [[ ! $snapshot =~ snapshot-([0-9]*)-.*.tar.zst ]]; then
  echo Error: Unable to determine snapshot slot for "$snapshot"
  exit 1
fi

snapshot_slot="${BASH_REMATCH[1]}"

rm -rf "$PANOPTIS_CONFIG_DIR"/bootstrap-validator
mkdir -p "$PANOPTIS_CONFIG_DIR"/bootstrap-validator


# Create genesis ledger
if [[ -r $FAUCET_KEYPAIR ]]; then
  cp -f "$FAUCET_KEYPAIR" "$PANOPTIS_CONFIG_DIR"/faucet.json
else
  $safecoin_keygen new --no-passphrase -fso "$PANOPTIS_CONFIG_DIR"/faucet.json
fi

if [[ -f $BOOTSTRAP_VALIDATOR_IDENTITY_KEYPAIR ]]; then
  cp -f "$BOOTSTRAP_VALIDATOR_IDENTITY_KEYPAIR" "$PANOPTIS_CONFIG_DIR"/bootstrap-validator/identity.json
else
  $safecoin_keygen new --no-passphrase -so "$PANOPTIS_CONFIG_DIR"/bootstrap-validator/identity.json
fi

$safecoin_keygen new --no-passphrase -so "$PANOPTIS_CONFIG_DIR"/bootstrap-validator/vote-account.json
$safecoin_keygen new --no-passphrase -so "$PANOPTIS_CONFIG_DIR"/bootstrap-validator/stake-account.json

$safecoin_ledger_tool create-snapshot \
  --ledger "$PANOPTIS_CONFIG_DIR"/latest-mainnet-beta-snapshot \
  --faucet-pubkey "$PANOPTIS_CONFIG_DIR"/faucet.json \
  --faucet-lamports 1000 \
  --bootstrap-validator "$PANOPTIS_CONFIG_DIR"/bootstrap-validator/identity.json \
                        "$PANOPTIS_CONFIG_DIR"/bootstrap-validator/vote-account.json \
                        "$PANOPTIS_CONFIG_DIR"/bootstrap-validator/stake-account.json \
  --hashes-per-tick sleep \
  "$snapshot_slot" "$PANOPTIS_CONFIG_DIR"/bootstrap-validator

$safecoin_ledger_tool modify-genesis \
  --ledger "$PANOPTIS_CONFIG_DIR"/latest-mainnet-beta-snapshot \
  --hashes-per-tick sleep \
  "$PANOPTIS_CONFIG_DIR"/bootstrap-validator
