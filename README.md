# FeeToken (Arbitrum-ready ERC20 with 5% Dev Fee)

A simple, non-mintable ERC20 token with a **5% transfer fee** (sent to dev wallet), for Arbitrum and EVM chains.  
Deployed supply is fixed and cannot be minted further.  
Owner can renounce (set to dead wallet).  
Dev wallet and fee are set at deployment, and fee is fixed.

---

## Features

- No minting after deployment (supply fixed at creation)
- 5% fee on every transfer, sent to the dev wallet
- Name, symbol, supply, dev wallet are set at deployment
- Fee cannot be changed after deployment
- Owner can update dev wallet (before renouncing ownership)
- Owner can renounce by setting owner to the `0x000...dEaD` wallet

---

## How To Deploy (Arbitrum Testnet)

1. Go to [Remix IDE](https://remix.ethereum.org/)
2. Paste `FeeToken.sol` in a new file
3. In "Solidity Compiler", select 0.8.20
4. Compile
5. Go to "Deploy & Run"
   - Environment: Injected Provider (Metamask)
   - Network: Arbitrum Sepolia or Arbitrum Goerli (testnet)
6. Set constructor params:
   - `_name` (string, e.g. "ArbiFeeToken")
   - `_symbol` (string, e.g. "AFT")
   - `_initialSupply` (uint, e.g. `1000000` for 1 million tokens)
   - `_devWallet` (address, must be a valid dev wallet)
7. Deploy!

---

## Testing on Testnet

1. **Fund your wallet** with Arbitrum Sepolia or Arbitrum Goerli ETH ([faucet here](https://faucet.quicknode.com/arbitrum/sepolia))
2. Deploy contract using Remix/Metamask on Arbitrum testnet
3. After deploy:
   - The full supply will be in your wallet
   - Try transferring tokens to another wallet: the dev wallet should receive 5%
   - Try `setDevWallet()` as owner
   - Renounce ownership using `renounceOwnership()` (cannot undo!)
4. Only testnet!  
   After you are confident, deploy to Arbitrum mainnet.

---

## License

MIT

---

## Security/Notes

- The fee and dev wallet cannot be changed after renouncing ownership.
- This contract is simple and unaudited—use at your own risk!
- Always test on testnet first.

---

## Example

Deploy with:
- Name: ArbiFeeToken
- Symbol: AFT
- Supply: 1,000,000
- Dev Wallet: your Arbitrum address

**After deployment:**
- Call `transfer()` from your wallet to a friend for 1,000 tokens
- Friend receives 950, dev wallet receives 50
- Try with different wallets!

---

## Dead wallet for renouncing:
`0x000000000000000000000000000000000000dEaD`

---

Any questions, [open an issue](https://github.com/YOUR-USERNAME/YOUR-REPO/issues)!
