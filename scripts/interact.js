const ethers = require("ethers")

const interactingLocally = true

const WALLET_CONTRACT_ARTIFACT_PATH = process.env.WALLET_CONTRACT_ARTIFACT_PATH
const WALLET_CONTRACT_ADDRESS = process.env.WALLET_CONTRACT_ADDRESS

const ALCHEMY_API_KEY = process.env.ALCHEMY_API_KEY
const METAMASK_PKEY = process.env.METAMASK_PKEY

const LOCAL_PKEY = process.env.LOCAL_PKEY

let provider
let signer

if (interactingLocally) {
  provider = new ethers.providers.JsonRpcProvider()
  signer = new ethers.Wallet(LOCAL_PKEY, provider)
} else {
  provider = new ethers.providers.AlchemyProvider(network="goerli", ALCHEMY_API_KEY)
  signer = new ethers.Wallet(METAMASK_PKEY, provider)
}

const WalletContract = require(WALLET_CONTRACT_ARTIFACT_PATH)
const walletContract = new ethers.Contract(WALLET_CONTRACT_ADDRESS, WalletContract.abi, signer)

async function main() {
  console.log(">>> walletContract.test()")
  await walletContract.test(WALLET_CONTRACT_ADDRESS)
}

main().catch(error => {
  console.log(error)
  process.exitCode = 1
})

walletContract.on("TestLogExecuteTransferLayers", transferNum => {
  console.log("EVENT Wallet: TestLogExecuteTransferLayers")
  console.log("transferNum:", transferNum)
})
