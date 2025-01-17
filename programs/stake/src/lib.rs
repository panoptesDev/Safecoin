#![cfg_attr(RUSTC_WITH_SPECIALIZATION, feature(specialization))]
#![allow(clippy::integer_arithmetic)]
use solana_sdk::genesis_config::GenesisConfig;

pub mod config;
pub mod stake_instruction;
pub mod stake_state;

pub use solana_sdk::stake::program::{check_id, id};

pub fn add_genesis_accounts(genesis_config: &mut GenesisConfig) -> u64 {
    config::add_genesis_account(genesis_config)
}

#[macro_use]
extern crate safecoin_frozen_abi_macro;
