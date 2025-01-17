use solana_sdk::{pubkey::Pubkey, signature::Signer};

pub struct DistributeTokensArgs {
    pub input_csv: String,
    pub transaction_db: String,
    pub output_path: Option<String>,
    pub dry_run: bool,
    pub sender_keypair: Box<dyn Signer>,
    pub fee_payer: Box<dyn Signer>,
    pub stake_args: Option<StakeArgs>,
    pub spl_token_args: Option<SafeTokenArgs>,
    pub transfer_amount: Option<u64>,
}

pub struct StakeArgs {
    pub unlocked_sol: u64,
    pub stake_account_address: Pubkey,
    pub stake_authority: Box<dyn Signer>,
    pub withdraw_authority: Box<dyn Signer>,
    pub lockup_authority: Option<Box<dyn Signer>>,
}

#[derive(Default)]
pub struct SafeTokenArgs {
    pub token_account_address: Pubkey,
    pub mint: Pubkey,
    pub decimals: u8,
}

pub struct BalancesArgs {
    pub input_csv: String,
    pub spl_token_args: Option<SafeTokenArgs>,
}

pub struct TransactionLogArgs {
    pub transaction_db: String,
    pub output_path: String,
}

pub enum Command {
    DistributeTokens(DistributeTokensArgs),
    Balances(BalancesArgs),
    TransactionLog(TransactionLogArgs),
}

pub struct Args {
    pub config_file: String,
    pub url: Option<String>,
    pub command: Command,
}
