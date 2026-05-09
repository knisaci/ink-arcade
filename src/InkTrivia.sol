// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract InkTrivia {

    struct Question {
        string text;
        string[4] options;
        uint8 correctIndex;
        string explanation;
    }

    struct PlayerStats {
        uint256 totalAnswered;
        uint256 totalCorrect;
        uint256 lastQuestionId;
        bool    lastAnswerCorrect;
    }

    address public owner;
    Question[] private questions;

    mapping(address => PlayerStats) public playerStats;
    mapping(address => mapping(uint256 => bool)) public hasAnswered;

    event AnswerSubmitted(
        address indexed player,
        uint256 indexed questionId,
        uint8   chosenIndex,
        bool    correct,
        uint256 totalCorrect,
        uint256 totalAnswered
    );

    event QuestionAdded(uint256 indexed questionId, string text);

    modifier onlyOwner() {
        require(msg.sender == owner, "InkTrivia: not owner");
        _;
    }

    constructor() {
        owner = msg.sender;
        _seedQuestions();
    }

    function submitAnswer(uint256 questionId, uint8 chosenIndex) external {
        require(questionId < questions.length, "InkTrivia: invalid question");
        require(chosenIndex < 4, "InkTrivia: invalid option");
        require(!hasAnswered[msg.sender][questionId], "InkTrivia: already answered");

        hasAnswered[msg.sender][questionId] = true;

        bool correct = (chosenIndex == questions[questionId].correctIndex);

        PlayerStats storage stats = playerStats[msg.sender];
        stats.totalAnswered++;
        stats.lastQuestionId = questionId;
        stats.lastAnswerCorrect = correct;
        if (correct) stats.totalCorrect++;

        emit AnswerSubmitted(
            msg.sender,
            questionId,
            chosenIndex,
            correct,
            stats.totalCorrect,
            stats.totalAnswered
        );
    }

    function questionCount() external view returns (uint256) {
        return questions.length;
    }

    function getQuestion(uint256 questionId)
        external
        view
        returns (
            string memory text,
            string memory optA,
            string memory optB,
            string memory optC,
            string memory optD
        )
    {
        require(questionId < questions.length, "InkTrivia: invalid question");
        Question storage q = questions[questionId];
        return (q.text, q.options[0], q.options[1], q.options[2], q.options[3]);
    }

    function getAnswer(uint256 questionId)
        external
        view
        returns (uint8 correctIndex, string memory explanation)
    {
        require(questionId < questions.length, "InkTrivia: invalid question");
        Question storage q = questions[questionId];
        return (q.correctIndex, q.explanation);
    }

    function getPlayerStats(address player)
        external
        view
        returns (
            uint256 totalAnswered,
            uint256 totalCorrect,
            uint256 lastQuestionId,
            bool    lastAnswerCorrect
        )
    {
        PlayerStats storage s = playerStats[player];
        return (s.totalAnswered, s.totalCorrect, s.lastQuestionId, s.lastAnswerCorrect);
    }

    function playerHasAnswered(address player, uint256 questionId)
        external
        view
        returns (bool)
    {
        return hasAnswered[player][questionId];
    }

    function addQuestion(
        string calldata text,
        string[4] calldata options,
        uint8 correctIndex,
        string calldata explanation
    ) external onlyOwner {
        require(correctIndex < 4, "InkTrivia: invalid correctIndex");
        questions.push(Question({
            text: text,
            options: options,
            correctIndex: correctIndex,
            explanation: explanation
        }));
        emit QuestionAdded(questions.length - 1, text);
    }

    function _seedQuestions() internal {
        questions.push(Question({
            text: "What is Ink?",
            options: ["A Coinbase L2", "A Kraken L2 built on Optimism OP Stack", "An Ethereum sidechain", "A ZK rollup by Binance"],
            correctIndex: 1,
            explanation: "Ink is Kraken's Layer 2 blockchain built on Optimism's OP Stack, launched on mainnet in December 2024."
        }));
        questions.push(Question({
            text: "What is the block time on Ink?",
            options: ["12 seconds", "2 seconds", "1 second", "500 milliseconds"],
            correctIndex: 2,
            explanation: "Ink launched with 1-second block times, making it ideal for fast DeFi interactions."
        }));
        questions.push(Question({
            text: "What is an AMM?",
            options: ["Automated Money Manager", "Automated Market Maker", "Advanced Mining Module", "Async Message Manager"],
            correctIndex: 1,
            explanation: "An AMM (Automated Market Maker) uses liquidity pools and a pricing formula instead of an order book."
        }));
        questions.push(Question({
            text: "What does TVL stand for in DeFi?",
            options: ["Total Value Listed", "Token Vault Limit", "Total Value Locked", "Transaction Volume Ledger"],
            correctIndex: 2,
            explanation: "TVL (Total Value Locked) measures the total value of crypto assets deposited into a DeFi protocol."
        }));
        questions.push(Question({
            text: "Which network is Ink part of?",
            options: ["Arbitrum Orbit", "zkSync Hyperchain", "Optimism Superchain", "Polygon CDK"],
            correctIndex: 2,
            explanation: "Ink is part of the Optimism Superchain - chains sharing security, governance, and interoperability."
        }));
        questions.push(Question({
            text: "What is a liquidity pool?",
            options: ["A hardware wallet for cold storage", "A smart contract holding token reserves used for trading", "A validator node set", "A type of NFT collection"],
            correctIndex: 1,
            explanation: "A liquidity pool is a smart contract holding reserves of tokens, enabling decentralised trading without an order book."
        }));
        questions.push(Question({
            text: "What gas token does Ink use?",
            options: ["INK", "OP", "USDC", "ETH"],
            correctIndex: 3,
            explanation: "ETH is the gas token on Ink. You bridge ETH from Ethereum or the Superchain to pay for transactions."
        }));
        questions.push(Question({
            text: "What is a flash loan?",
            options: ["A loan repaid over 30 days", "An uncollateralised loan borrowed and repaid within one transaction", "A stablecoin lending product", "A cross-chain bridge mechanism"],
            correctIndex: 1,
            explanation: "A flash loan is borrowed and repaid within the same transaction - no collateral needed, enforced by the smart contract."
        }));
        questions.push(Question({
            text: "What is the Optimism Superchain?",
            options: ["A single blockchain network", "A network of L2 chains sharing security and interoperability", "Ethereum's consensus layer", "A cross-chain bridge protocol"],
            correctIndex: 1,
            explanation: "The Superchain is a network of OP Stack L2s - including Ink, Base, and OP Mainnet - that share security and can interoperate seamlessly."
        }));
    }
}
