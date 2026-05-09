# 🎮 Ink Arcade — DeFi Trivia

A browser-based DeFi trivia game where every answer is a real on-chain transaction on **Ink mainnet**.

Players connect their wallet, answer questions about DeFi concepts and Ink-specific knowledge, and submit answers directly to a smart contract. Results, scores, and explanations are all stored and retrieved on-chain.

**Live:** https://knisaci.github.io/ink-arcade

---

## How It Works

1. Connect any EVM wallet (Rabby, MetaMask, etc.)
2. Read a DeFi or Ink trivia question loaded live from the contract
3. Pick your answer — this triggers a real transaction on Ink
4. The contract checks your answer and emits an event
5. The frontend reveals if you were right + an explanation
6. Your score is tracked on-chain per wallet

Every game session generates real transactions on Ink mainnet. No backend, no database — everything is on-chain.

---

## Contracts

| Network | Address | Explorer |
|---|---|---|
| Ink Mainnet | `0xC996c0143c4C88F0B0bC32d328D14c071A603CcB` | [View](https://explorer.inkonchain.com/address/0xC996c0143c4C88F0B0bC32d328D14c071A603CcB) |
| Ink Sepolia (testnet) | `0xC996c0143c4C88F0B0bC32d328D14c071A603CcB` | [View](https://explorer-sepolia.inkonchain.com/address/0xC996c0143c4C88F0B0bC32d328D14c071A603CcB) |

---

## Architecture

```
ink-arcade/
├── src/
│   └── InkTrivia.sol     — Solidity contract (questions, answers, scores)
├── index.html            — Single-file frontend (no build step)
└── foundry.toml          — Foundry config for Ink mainnet + Sepolia
```

**Stack:**
- Smart contract: Solidity 0.8.20, deployed with Foundry
- Frontend: Vanilla HTML/JS, ethers.js v6 via CDN
- Hosting: GitHub Pages
- Chain: Ink mainnet (Chain ID: 57073, OP Stack L2 by Kraken)

---

## Contract Interface

```solidity
// Get a question (never reveals the answer)
function getQuestion(uint256 questionId)
    external view returns (string, string, string, string, string);

// Submit your answer on-chain
function submitAnswer(uint256 questionId, uint8 chosenIndex) external;

// Get the correct answer + explanation (call after submitting)
function getAnswer(uint256 questionId)
    external view returns (uint8 correctIndex, string explanation);

// Get a player's score
function getPlayerStats(address player)
    external view returns (uint256 answered, uint256 correct, uint256 lastId, bool lastCorrect);
```

---

## Run Locally

```bash
# Serve the frontend (required — file:// won't work with wallet extensions)
python3 -m http.server 8080

# Open in browser
open http://localhost:8080
```

---

## Deploy Your Own

```bash
# Install Foundry
curl -L https://foundry.paradigm.xyz | bash && foundryup

# Clone and deploy to Ink mainnet
git clone https://github.com/knisaci/ink-arcade
cd ink-arcade
forge create src/InkTrivia.sol:InkTrivia \
  --rpc-url https://rpc-gel.inkonchain.com \
  --private-key YOUR_PRIVATE_KEY \
  --broadcast
```

---

## Network Info

| Field | Value |
|---|---|
| Network | Ink Mainnet |
| Chain ID | 57073 |
| RPC | https://rpc-gel.inkonchain.com |
| Explorer | https://explorer.inkonchain.com |
| Bridge | https://inkonchain.com/bridge |

---

## Roadmap

- [x] Game 1 — DeFi Trivia (live)
- [ ] Game 2 — Swap Simulator
- [ ] Game 3 — Vault Builder
- [ ] Game 4 — Gas Estimator

---

Built on [Ink](https://inkonchain.com) — Kraken's L2 on the Optimism Superchain.
