import bs58 from "bs58";
import {
  SystemProgram,
  StakeProgram,
  VOTE_PROGRAM_ID,
  BPF_LOADER_PROGRAM_ID,
  BPF_LOADER_DEPRECATED_PROGRAM_ID,
  SYSVAR_CLOCK_PUBKEY,
  SYSVAR_RENT_PUBKEY,
  SYSVAR_REWARDS_PUBKEY,
  SYSVAR_STAKE_HISTORY_PUBKEY,
  ParsedTransaction,
  TransactionInstruction,
  Transaction,
  PartiallyDecodedInstruction,
  ParsedInstruction,
} from "@safecoin/web3.js";
import { Cluster } from "providers/cluster";
import { SerumMarketRegistry } from "serumMarketRegistry";
import { TokenInfoMap } from "@solana/pano-token-registry";

export type ProgramName = typeof PROGRAM_NAME_BY_ID[keyof typeof PROGRAM_NAME_BY_ID];

export enum PROGRAM_NAMES {
  // native built-ins
  CONFIG = "Config Program",
  STAKE = "Stake Program",
  SYSTEM = "System Program",
  VOTE = "Vote Program",

  // spl
  ASSOCIATED_TOKEN = "Associated Token Program",
  FEATURE_PROPOSAL = "Feature Proposal Program",
  LENDING = "Lending Program",
  MEMO = "Memo Program",
  MEMO_2 = "Memo Program v2",
  SWAP = "Swap Program",
  TOKEN = "Token Program",

  // other
  BONFIDA_POOL = "Bonfida Pool Program",
  BREAK_PANOPTIS = "Break Panoptis Program",
  RAYDIUM_LIQUIDITY_1 = "Raydium Liquidity Pool Program v1",
  RAYDIUM_LIQUIDITY_2 = "Raydium Liquidity Pool Program v2",
  RAYDIUM_STAKING = "Raydium Staking Program",
  SERUM_2 = "Serum Program v2",
  SERUM_3 = "Serum Program v3",
}

const ALL_CLUSTERS = [
  Cluster.Custom,
  Cluster.Devnet,
  Cluster.Testnet,
  Cluster.MainnetBeta,
];

const LIVE_CLUSTERS = [Cluster.Devnet, Cluster.Testnet, Cluster.MainnetBeta];

const MAINNET_ONLY = [Cluster.MainnetBeta];

export const PROGRAM_DEPLOYMENTS = {
  // native built-ins
  [PROGRAM_NAMES.CONFIG]: ALL_CLUSTERS,
  [PROGRAM_NAMES.STAKE]: ALL_CLUSTERS,
  [PROGRAM_NAMES.SYSTEM]: ALL_CLUSTERS,
  [PROGRAM_NAMES.VOTE]: ALL_CLUSTERS,

  // spl
  [PROGRAM_NAMES.ASSOCIATED_TOKEN]: ALL_CLUSTERS,
  [PROGRAM_NAMES.FEATURE_PROPOSAL]: ALL_CLUSTERS,
  [PROGRAM_NAMES.LENDING]: LIVE_CLUSTERS,
  [PROGRAM_NAMES.MEMO]: ALL_CLUSTERS,
  [PROGRAM_NAMES.MEMO_2]: ALL_CLUSTERS,
  [PROGRAM_NAMES.SWAP]: LIVE_CLUSTERS,
  [PROGRAM_NAMES.TOKEN]: ALL_CLUSTERS,

  // other
  [PROGRAM_NAMES.BONFIDA_POOL]: MAINNET_ONLY,
  [PROGRAM_NAMES.BREAK_PANOPTIS]: LIVE_CLUSTERS,
  [PROGRAM_NAMES.RAYDIUM_LIQUIDITY_1]: MAINNET_ONLY,
  [PROGRAM_NAMES.RAYDIUM_LIQUIDITY_2]: MAINNET_ONLY,
  [PROGRAM_NAMES.RAYDIUM_STAKING]: MAINNET_ONLY,
  [PROGRAM_NAMES.SERUM_2]: MAINNET_ONLY,
  [PROGRAM_NAMES.SERUM_3]: MAINNET_ONLY,
} as const;

export const PROGRAM_NAME_BY_ID = {
  // native built-ins
  Config1111111111111111111111111111111111111: PROGRAM_NAMES.CONFIG,
  [StakeProgram.programId.toBase58()]: PROGRAM_NAMES.STAKE,
  [SystemProgram.programId.toBase58()]: PROGRAM_NAMES.SYSTEM,
  [VOTE_PROGRAM_ID.toBase58()]: PROGRAM_NAMES.VOTE,

  // spl
  CWyEp7dp1Cv3334j6gCci2UrrjA8Q98bYa7AwGBpZ6iJ: PROGRAM_NAMES.ASSOCIATED_TOKEN,
  D5WhRrnh8AefVULhudnuLA1LCVzvEgdn49eDWE67wYNn: PROGRAM_NAMES.FEATURE_PROPOSAL,
  4DDUJ1rA8Vd7e6SFWanf4V8JnsfapjCGNutQYw8Vtt45: PROGRAM_NAMES.MEMO,
  9h7wfE8nxQ6YsRedqNHwroEZbA5bMAmNsh8GdxwBTtaV: PROGRAM_NAMES.MEMO_2,
  6RWe1TGwvojnbAynyWrHzm3GgHf7AmX7kLQTJG7vHCfb: PROGRAM_NAMES.SWAP,
  7v5TwK92hUSqduoL3R8NtzTNfNzMA48nJL4mzPYMdDrD: PROGRAM_NAMES.TOKEN,
  LendZqTs7gn5CTSJU1jWKhKuVpjJGom45nnwPb2AMTi: PROGRAM_NAMES.LENDING,

  // other
  WvmTNLpGMVbwJVYztYL4Hnsy82cJhQorxjnnXcRm3b6: PROGRAM_NAMES.BONFIDA_POOL,
  CtY5L6mdBzRUakZFJ3NXkhy8ufGkDteBJvgawdAVgWVv: PROGRAM_NAMES.BREAK_PANOPTIS,
  RVKd61ztZW9GUwhRbbLoYVRE5Xf1B2tVscKqwZqXgEr:
    PROGRAM_NAMES.RAYDIUM_LIQUIDITY_1,
  "27haf8L6oxUeXrHrgEgsexjSY5hbVUWEmvv9Nyxg8vQv":
    PROGRAM_NAMES.RAYDIUM_LIQUIDITY_2,
  EhhTKczWMGQt46ynNeRX1WfeagwwJd7ufHvCDjRxjo5Q: PROGRAM_NAMES.RAYDIUM_STAKING,
  EUqojwWA2rd19FZrzeBncJsm38Jm1hEhE3zsmX3bRc2o: PROGRAM_NAMES.SERUM_2,
  "9xQeWvG816bUx9EPjHmaT23yvVM2ZWbrrpZb9PusVFin": PROGRAM_NAMES.SERUM_3,
} as const;

export type LoaderName = typeof LOADER_IDS[keyof typeof LOADER_IDS];
export const LOADER_IDS = {
  MoveLdr111111111111111111111111111111111111: "Move Loader",
  NativeLoader1111111111111111111111111111111: "Native Loader",
  [BPF_LOADER_DEPRECATED_PROGRAM_ID.toBase58()]: "BPF Loader",
  [BPF_LOADER_PROGRAM_ID.toBase58()]: "BPF Loader 2",
  BPFLoaderUpgradeab1e11111111111111111111111: "BPF Upgradeable Loader",
} as const;

const SYSVAR_ID: { [key: string]: string } = {
  Sysvar1111111111111111111111111111111111111: "SYSVAR",
};

export const SYSVAR_IDS = {
  [SYSVAR_CLOCK_PUBKEY.toBase58()]: "Sysvar: Clock",
  SysvarEpochSchedu1e111111111111111111111111: "Sysvar: Epoch Schedule",
  SysvarFees111111111111111111111111111111111: "Sysvar: Fees",
  SysvarRecentB1ockHashes11111111111111111111: "Sysvar: Recent Blockhashes",
  [SYSVAR_RENT_PUBKEY.toBase58()]: "Sysvar: Rent",
  [SYSVAR_REWARDS_PUBKEY.toBase58()]: "Sysvar: Rewards",
  SysvarS1otHashes111111111111111111111111111: "Sysvar: Slot Hashes",
  SysvarS1otHistory11111111111111111111111111: "Sysvar: Slot History",
  [SYSVAR_STAKE_HISTORY_PUBKEY.toBase58()]: "Sysvar: Stake History",
  Sysvar1nstructions1111111111111111111111111: "Sysvar: Instructions",
};

export function programLabel(
  address: string,
  cluster: Cluster
): string | undefined {
  const programName = PROGRAM_NAME_BY_ID[address];
  if (programName && PROGRAM_DEPLOYMENTS[programName].includes(cluster)) {
    return programName;
  }
}

export function addressLabel(
  address: string,
  cluster: Cluster,
  tokenRegistry?: TokenInfoMap
): string | undefined {
  return (
    programLabel(address, cluster) ||
    LOADER_IDS[address] ||
    SYSVAR_IDS[address] ||
    SYSVAR_ID[address] ||
    tokenRegistry?.get(address)?.name ||
    SerumMarketRegistry.get(address, cluster)
  );
}

export function displayAddress(
  address: string,
  cluster: Cluster,
  tokenRegistry: TokenInfoMap
): string {
  return addressLabel(address, cluster, tokenRegistry) || address;
}

export function intoTransactionInstruction(
  tx: ParsedTransaction,
  instruction: ParsedInstruction | PartiallyDecodedInstruction
): TransactionInstruction | undefined {
  const message = tx.message;
  if ("parsed" in instruction) return;

  const keys = [];
  for (const account of instruction.accounts) {
    const accountKey = message.accountKeys.find(({ pubkey }) =>
      pubkey.equals(account)
    );
    if (!accountKey) return;
    keys.push({
      pubkey: accountKey.pubkey,
      isSigner: accountKey.signer,
      isWritable: accountKey.writable,
    });
  }

  return new TransactionInstruction({
    data: bs58.decode(instruction.data),
    keys: keys,
    programId: instruction.programId,
  });
}

export function intoParsedTransaction(tx: Transaction): ParsedTransaction {
  const message = tx.compileMessage();
  return {
    signatures: tx.signatures.map((value) =>
      bs58.encode(value.signature as any)
    ),
    message: {
      accountKeys: message.accountKeys.map((key, index) => ({
        pubkey: key,
        signer: tx.signatures.some(({ publicKey }) => publicKey.equals(key)),
        writable: message.isAccountWritable(index),
      })),
      instructions: message.instructions.map((ix) => ({
        programId: message.accountKeys[ix.programIdIndex],
        accounts: ix.accounts.map((index) => message.accountKeys[index]),
        data: ix.data,
      })),
      recentBlockhash: message.recentBlockhash,
    },
  };
}
