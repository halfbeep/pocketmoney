import BigNumber, { BigNumberish, ethers } from 'ethers'

// Define the ABI for the contract, including both releaseAllowance and contractBalance functions
const contractABI = [
  {
    constant: false,
    inputs: [],
    name: 'releaseAllowance',
    outputs: [],
    payable: false,
    stateMutability: 'nonpayable',
    type: 'function',
  },
  {
    constant: false,
    inputs: [],
    name: 'contractBalance',
    outputs: [
      {
        name: '',
        type: 'uint256',
      },
    ],
    payable: false,
    stateMutability: 'view',
    type: 'function',
  },
  {
    constant: false,
    inputs: [],
    name: 'fundContract',
    outputs: [],
    payable: true, // This function is expected to be payable
    stateMutability: 'payable',
    type: 'function',
  },
]

// The deployed contract address
const contractAddress = '0x5fbdb2315678afecb367f032d93f642f64180aa3'

// Connect to Ethereum provider (e.g., MetaMask or Infura)
// Use ethers.providers.Web3Provider if you're using a browser-based provider like MetaMask
const provider = new ethers.JsonRpcProvider('http://127.0.0.1:8545')

//'https://mainnet.infura.io/v3/YOUR API KEY'

// Get the wallet (or connect a signer for the transaction)
// Replace with the private key of the account you want to use to send the transaction
const signer = new ethers.Wallet('0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d', provider)

// A helper function to release allowance
async function releaseAllowance() {
  try {
    // Connect to the contract
    const contract = new ethers.Contract(contractAddress, contractABI, signer)

    // Call the releaseAllowance function
    const tx = await contract.releaseAllowance()

    console.log('Transaction submitted:', tx.hash)

    // Wait for the transaction to be confirmed
    const receipt = await tx.wait()

    console.log('Transaction confirmed:', receipt)
  } catch (error) {
    console.error('Error calling releaseAllowance:', error)
  }
}

// A helper function to get the contract balance
async function getContractBalance() {
  try {
    // Since this is a view function, you don't need a signer, just a provider
    const myContract = new ethers.Contract(
      contractAddress,
      contractABI,
      provider
    )

    // Call the contractBalance function
    const balance: BigNumberish = await myContract.contractBalance()

    // Convert the balance from wei to ether for readability
    const balanceInEther = ethers.formatEther(balance)

    console.log('Contract balance:', balanceInEther, 'ETH')
  } catch (error) {
    console.error('Error fetching contract balance:', error)
  }
}

// A helper function to call fundContract and send Ether
async function fundContract() {
  try {
    // Connect to the contract
    const contract = new ethers.Contract(contractAddress, contractABI, signer)

    // Define the amount of Ether you want to send (in this example, 0.1 Ether)
    const amountToSend = ethers.parseEther('0.00005') // Replace with the amount of Ether you want to send

    // Call fundContract() and attach the Ether to the transaction
    const tx = await contract.fundContract({ value: amountToSend })

    console.log('Transaction submitted:', tx.hash)

    // Wait for the transaction to be confirmed
    const receipt = await tx.wait()

    if (receipt && receipt.status === 1) {
      console.log('Transaction confirmed:', receipt)
    } else if (receipt && receipt.status === 0) {
      console.error('Transaction failed:', receipt)
    }
  } catch (error) {
    console.error('Error calling fundContract:', error)
  }
}

// Call the functions
// releaseAllowance()
// getContractBalance()
fundContract()