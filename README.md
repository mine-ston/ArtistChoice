# ArtistChoice

A decentralized voting system smart contract for artist and performer selection built on the Stacks blockchain using Clarity.

## Description

ArtistChoice allows users to vote for their favorite artists and performers in various categories through a transparent, blockchain-based voting system. The contract includes features for artist registration, controlled voting periods, and immutable result tracking.

## Features

- **Artist Registration**: Anyone can register artists with name, description, and category
- **Controlled Voting Periods**: Owner-managed voting sessions with defined duration
- **One Vote Per User**: Prevents double voting with user vote tracking
- **Real-time Vote Counting**: Transparent vote tallying for each artist
- **Artist Management**: Registered artists or contract owner can update artist information
- **Ownership Transfer**: Contract ownership can be transferred to new principals
- **Comprehensive Query Functions**: Multiple read-only functions for data retrieval

## Technical Specifications

- **Blockchain**: Stacks
- **Language**: Clarity 2.5
- **Contract Version**: 1.0.0
- **Testing Framework**: Vitest with Clarinet SDK
- **String Limits**: 
  - Artist names: 50 characters
  - Descriptions: 200 characters
  - Categories: 30 characters

## Installation

### Prerequisites

- [Clarinet](https://github.com/hirosystems/clarinet) CLI tool
- Node.js (v18 or higher)
- npm or yarn package manager

### Setup

1. Clone the repository:
```bash
git clone <repository-url>
cd ArtistChoice
```

2. Navigate to the contract directory:
```bash
cd ArtistChoice_contract
```

3. Install dependencies:
```bash
npm install
```

4. Check contract syntax:
```bash
clarinet check
```

## Usage Examples

### Starting a Voting Period

```clarity
;; Start voting for 1000 blocks (approximately 1 week)
(contract-call? .ArtistChoice start-voting u1000)
```

### Registering an Artist

```clarity
;; Register a new artist
(contract-call? .ArtistChoice register-artist 
  "Taylor Swift" 
  "Grammy-winning pop artist known for storytelling through music" 
  "Pop")
```

### Casting a Vote

```clarity
;; Vote for artist with ID 1
(contract-call? .ArtistChoice vote-for-artist u1)
```

### Querying Artist Information

```clarity
;; Get artist details
(contract-call? .ArtistChoice get-artist u1)

;; Check vote count
(contract-call? .ArtistChoice get-artist-votes u1)

;; Check if voting is active
(contract-call? .ArtistChoice is-voting-active)
```

## Contract Functions

### Public Functions

| Function | Parameters | Description |
|----------|------------|-------------|
| `start-voting` | `duration: uint` | Starts a new voting period (owner only) |
| `end-voting` | None | Ends the current voting period (owner only) |
| `register-artist` | `name, description, category` | Registers a new artist for voting |
| `vote-for-artist` | `artist-id: uint` | Casts a vote for an artist |
| `update-artist` | `artist-id, name, description, category` | Updates artist information |
| `transfer-ownership` | `new-owner: principal` | Transfers contract ownership |

### Read-Only Functions

| Function | Parameters | Description |
|----------|------------|-------------|
| `get-artist` | `artist-id: uint` | Returns artist information |
| `get-artist-votes` | `artist-id: uint` | Returns vote count for an artist |
| `has-user-voted` | `user: principal` | Checks if a user has voted |
| `get-user-vote` | `user: principal` | Returns user's vote details |
| `is-voting-active` | None | Returns current voting status |
| `get-voting-end-block` | None | Returns voting end block height |
| `get-contract-owner` | None | Returns current contract owner |
| `get-artist-count` | None | Returns total registered artists |
| `get-current-block` | None | Returns current block height |

## Error Codes

| Code | Constant | Description |
|------|----------|-------------|
| u100 | `ERR-OWNER-ONLY` | Action requires contract owner privileges |
| u101 | `ERR-NOT-FOUND` | Artist not found |
| u102 | `ERR-ALREADY-EXISTS` | Entity already exists |
| u103 | `ERR-VOTING-NOT-ACTIVE` | Voting period is not active |
| u104 | `ERR-ALREADY-VOTED` | User has already cast their vote |
| u105 | `ERR-INVALID-ARTIST` | Artist ID is invalid |
| u106 | `ERR-UNAUTHORIZED` | User lacks required permissions |

## Testing

Run the test suite:

```bash
npm test
```

Run tests with coverage and cost analysis:

```bash
npm run test:report
```

Watch mode for development:

```bash
npm run test:watch
```

## Deployment Guide

### Local Development (Devnet)

1. Start Clarinet console:
```bash
clarinet console
```

2. Deploy the contract:
```clarity
::deploy_contract ArtistChoice
```

### Testnet Deployment

1. Configure your testnet settings in `settings/Testnet.toml`
2. Deploy using Clarinet:
```bash
clarinet deployments apply -p testnet
```

### Mainnet Deployment

1. Configure your mainnet settings in `settings/Mainnet.toml`
2. Ensure thorough testing on testnet
3. Deploy using Clarinet:
```bash
clarinet deployments apply -p mainnet
```

## Security Notes

- **Owner Privileges**: Contract owner has significant control including starting/ending voting periods and transferring ownership
- **Vote Immutability**: Once cast, votes cannot be changed or deleted
- **Single Vote Enforcement**: The contract prevents users from voting multiple times
- **Artist Updates**: Only the artist registrant or contract owner can update artist information
- **Voting Window**: Votes can only be cast during active voting periods
- **Data Validation**: All string inputs are limited to prevent excessive data storage

## Development

### Project Structure

```
ArtistChoice/
├── README.md
└── ArtistChoice_contract/
    ├── contracts/
    │   └── ArtistChoice.clar
    ├── tests/
    │   └── ArtistChoice.test.ts
    ├── settings/
    │   ├── Devnet.toml
    │   ├── Testnet.toml
    │   └── Mainnet.toml
    ├── Clarinet.toml
    ├── package.json
    ├── tsconfig.json
    └── vitest.config.js
```

### Contributing

1. Fork the repository
2. Create a feature branch
3. Write tests for new functionality
4. Ensure all tests pass
5. Submit a pull request

## License

ISC License

## Support

For questions, issues, or contributions, please refer to the project's issue tracker or contact the development team.