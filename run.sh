#!/usr/bin/env bash
#
# Run a minimal Panoptis cluster.  Ctrl-C to exit.
#
# Before running this script ensure standard Panoptis programs are available
# in the PATH, or that `cargo build` ran successfully
#
set -e

# Prefer possible `cargo build` binaries over PATH binaries
cd "$(dirname "$0")/"

profile=debug
if [[ -n $NDEBUG ]]; then
  profile=release
fi
PATH=$PWD/target/$profile:$PATH

ok=true
for program in solana-{faucet,genesis,keygen,validator}; do
  $program -V || ok=false
done
$ok || {
  echo
  echo "Unable to locate required programs.  Try building them first with:"
  echo
  echo "  $ cargo build --all"
  echo
  exit 1
}

export RUST_LOG=${RUST_LOG:-solana=info,solana_runtime::message_processor=debug} # if RUST_LOG is unset, default to info
export RUST_BACKTRACE=1
dataDir=$PWD/config/"$(basename "$0" .sh)"
ledgerDir=$PWD/config/ledger

PANOPTIS_RUN_SH_CLUSTER_TYPE=${PANOPTIS_RUN_SH_CLUSTER_TYPE:-development}

set -x
if ! safecoin address; then
  echo Generating default keypair
  panoptis-keygen new --no-passphrase
fi
validator_identity="$dataDir/validator-identity.json"
if [[ -e $validator_identity ]]; then
  echo "Use existing validator keypair"
else
  panoptis-keygen new --no-passphrase -so "$validator_identity"
fi
validator_vote_account="$dataDir/validator-vote-account.json"
if [[ -e $validator_vote_account ]]; then
  echo "Use existing validator vote account keypair"
else
  panoptis-keygen new --no-passphrase -so "$validator_vote_account"
fi
validator_stake_account="$dataDir/validator-stake-account.json"
if [[ -e $validator_stake_account ]]; then
  echo "Use existing validator stake account keypair"
else
  panoptis-keygen new --no-passphrase -so "$validator_stake_account"
fi

if [[ -e "$ledgerDir"/genesis.bin || -e "$ledgerDir"/genesis.tar.bz2 ]]; then
  echo "Use existing genesis"
else
  ./fetch-spl.sh
  if [[ -r spl-genesis-args.sh ]]; then
    SPL_GENESIS_ARGS=$(cat spl-genesis-args.sh)
  fi

  # shellcheck disable=SC2086
  panoptis-genesis \
    --hashes-per-tick sleep \
    --faucet-lamports 500000000000000000 \
    --bootstrap-validator \
      "$validator_identity" \
      "$validator_vote_account" \
      "$validator_stake_account" \
    --ledger "$ledgerDir" \
    --cluster-type "$PANOPTIS_RUN_SH_CLUSTER_TYPE" \
    $SPL_GENESIS_ARGS \
    $PANOPTIS_RUN_SH_GENESIS_ARGS
fi

abort() {
  set +e
  kill "$faucet" "$validator"
  wait "$validator"
}
trap abort INT TERM EXIT

panoptis-faucet &
faucet=$!

args=(
  --identity "$validator_identity"
  --vote-account "$validator_vote_account"
  --ledger "$ledgerDir"
  --gossip-port 10015
  --rpc-port 8328
  --rpc-faucet-address 127.0.0.1:9900
  --log -
  --enable-rpc-transaction-history
  --enable-cpi-and-log-storage
  --init-complete-file "$dataDir"/init-completed
  --snapshot-compression none
  --require-tower
  --no-wait-for-vote-to-start-leader
)
# shellcheck disable=SC2086
panoptis-validator "${args[@]}" $PANOPTIS_RUN_SH_VALIDATOR_ARGS &
validator=$!

wait "$validator"
