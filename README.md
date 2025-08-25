# DAO Scholarship Smart Contract

A decentralized autonomous organization (DAO) for transparent and fair scholarship fund distribution on the Stacks blockchain.

## Overview

The DAO Scholarship smart contract enables decentralized governance of scholarship funds through community voting. Members can propose scholarship applications, vote on proposals, and automatically distribute approved funds to recipients.

## Features

- **Decentralized Governance**: DAO members vote on scholarship applications
- **Transparent Process**: All applications and votes are recorded on-chain
- **Automated Payouts**: Approved scholarships are automatically funded
- **Quorum Requirements**: Ensures adequate participation in voting decisions
- **Multi-stage Workflow**: Application → Voting → Approval → Payment

## Getting Started

### Prerequisites

- [Clarinet](https://docs.hiro.so/clarinet) installed
- Node.js (v18 or higher)
- Stacks wallet for testing

### Installation

1. Clone the repository:
```bash
git clone https://github.com/Travisigho/dao-scholarship.git
cd dao-scholarship
```

2. Install dependencies:
```bash
cd scholarshipdoa
npm install
```

3. Run tests:
```bash
npm test
```

### Project Structure

```
scholarshipdoa/
├── contracts/
│   └── doa_scholar.clar      # Main smart contract
├── tests/
│   └── doa_scholar.test.ts   # Contract tests
└── settings/                 # Network configurations
```

## Contract Functions

### Core Operations

- `submit-application()` - Submit a new scholarship application
- `vote-on-application()` - Cast vote on pending applications  
- `finalize-application()` - Close voting and determine outcome
- `release-payout()` - Transfer funds to approved recipients
- `deposit-funds()` - Add funds to the scholarship pool

### DAO Management

- `add-dao-member()` - Add new voting members (owner only)
- `remove-dao-member()` - Remove voting members (owner only)

### Read-only Functions

- `get-application()` - Retrieve application details
- `get-voting-results()` - View voting statistics
- `get-total-funds()` - Check available funding

## Usage

### For DAO Members

1. **Vote on Applications**: Review scholarship proposals and cast your vote
2. **Monitor Funding**: Track available funds and approved payouts
3. **Participate in Governance**: Help shape the scholarship criteria

### For Applicants

1. **Submit Application**: Provide institution, program, and funding details
2. **Wait for Voting**: DAO members review during the voting period
3. **Receive Funds**: Approved applications receive automatic payouts

## Development

### Running Tests

```bash
# Run all tests
npm test

# Run tests with coverage
npm run test:report

# Watch mode
npm run test:watch
```

### Contract Parameters

- **Voting Duration**: 144 blocks (~24 hours)
- **Minimum Votes**: 3 votes required for approval
- **Quorum**: 51% of total voting power

## License

ISC

## Contributing

1. Fork the repository
2. Create a feature branch
3. Add tests for new functionality
4. Submit a pull request

---

*Built with [Clarinet](https://docs.hiro.so/clarinet) and deployed on the Stacks blockchain.*