#![cfg_attr(RUSTC_WITH_SPECIALIZATION, feature(specialization))]
#![allow(clippy::integer_arithmetic)]

pub mod authorized_voters;
pub mod vote_instruction;
pub mod vote_state;
pub mod vote_transaction;

#[macro_use]
extern crate solana_metrics;

#[macro_use]
extern crate safecoin_frozen_abi_macro;

pub use solana_sdk::vote::program::{check_id, id};
