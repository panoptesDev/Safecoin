#!/usr/bin/env bash

here=$(dirname "$0")
# shellcheck source=multinode-demo/common.sh
source "$here"/common.sh

set -e

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

args=(
  "$@"
  --max-genesis-archive-unpacked-size 1073741824
  --enable-warmup-epochs
  --bootstrap-validator "$PANOPTIS_CONFIG_DIR"/bootstrap-validator/identity.json
                        "$PANOPTIS_CONFIG_DIR"/bootstrap-validator/vote-account.json
                        "$PANOPTIS_CONFIG_DIR"/bootstrap-validator/stake-account.json
)

"$PANOPTIS_ROOT"/fetch-spl.sh
if [[ -r spl-genesis-args.sh ]]; then
  SPL_GENESIS_ARGS=$(cat "$PANOPTIS_ROOT"/spl-genesis-args.sh)
  #shellcheck disable=SC2207
  #shellcheck disable=SC2206
  args+=($SPL_GENESIS_ARGS)
fi

default_arg --ledger "$PANOPTIS_CONFIG_DIR"/bootstrap-validator
default_arg --faucet-pubkey "$PANOPTIS_CONFIG_DIR"/faucet.json
default_arg --faucet-lamports 1000
default_arg --hashes-per-tick auto
default_arg --cluster-type mainnet-beta

$safecoin_genesis "${args[@]}"
