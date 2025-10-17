# 🚀 Venmo Crypto Connector

A comprehensive Rails engine providing educational content, wallet integration, and guided onboarding for cryptocurrency users leveraging Venmo's crypto features.

[![Ruby Version](https://img.shields.io/badge/ruby-2.6%2B-blue.svg)](https://www.ruby-lang.org/)
[![Rails Version](https://img.shields.io/badge/rails-6.1%2B-red.svg)](https://rubyonrails.org/)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

## 🎯 Overview

The Venmo Crypto Connector bridges the gap between traditional payment platforms like Venmo and the cryptocurrency ecosystem. It provides users with comprehensive education, wallet integration, and guided onboarding to safely navigate the crypto world.

## ✨ Features

### 🏗️ **Mountable Rails Engine**
- Complete namespace isolation with `VenmoCryptoConnector`
- Self-contained with models, controllers, views, and assets
- Easily distributable as a gem
- Configurable mounting at any path

### 🔐 **Sign-In with Ethereum (SIWE)**
- Passwordless authentication using wallet signatures
- Cryptographic proof of wallet ownership
- Secure session management with JWT tokens
- Nonce rotation to prevent replay attacks

### 📚 **Progressive Educational System**
- 8 comprehensive learning modules
- Multiple content types (video, interactive, quiz, reading)
- Gamification with experience points and achievements
- Module completion tracking and prerequisites

### 📱 **Interactive Venmo Guides**
- Step-by-step visual guides for Venmo app features
- Screenshot annotations and video tutorials
- Progress tracking through multi-step processes
- Interactive checklists and warnings

### 💰 **Transaction Simulation**
- Risk-free practice with simulated wallets
- Multiple cryptocurrencies (USDC, ETH, BTC, PYUSD)
- Realistic blockchain delays and success rates
- Background job processing for authentic experience

### 🔗 **Multi-Wallet Support**
- MetaMask integration
- WalletConnect compatibility
- Wallet connection verification
- Blockchain interaction services

## 🚀 Quick Start

### Live Demo

Try the interactive demo without installation:

```bash
# Clone the repository
git clone https://github.com/yourusername/venmo-crypto-connector.git
cd venmo-crypto-connector

# Start the demo server
ruby simple_server.rb

# Open in browser
open http://localhost:3000/interactive_demo.html
```

### Rails Engine Installation

```ruby
# Add to Gemfile
gem 'venmo_crypto_connector', path: '/path/to/venmo_crypto_connector'

# Mount in routes
mount VenmoCryptoConnector::Engine, at: "/crypto"

# Run migrations and seed data
rails db:migrate
rails runner "load 'path/to/venmo_crypto_connector/db/seeds.rb'"

# Start server
rails server
```

## 📁 Project Structure

```
venmo-crypto-connector/
├── venmo_crypto_connector/          # Main Rails engine
│   ├── app/
│   │   ├── controllers/             # API and web controllers
│   │   ├── models/                  # Data models
│   │   ├── services/                # Business logic
│   │   ├── jobs/                    # Background processing
│   │   └── views/                   # User interface
│   ├── db/migrate/                  # Database schema
│   ├── lib/                         # Engine configuration
│   └── app/assets/javascripts/      # Frontend integration
├── sample_app/                      # Example host application
├── demo.html                        # Static demo page
├── interactive_demo.html            # Interactive demo
├── simple_server.rb                 # Demo server
└── README.md                        # This file
```

## 🎓 Educational Modules

1. **Crypto Basics for Venmo Users** (5 min) - Introduction to cryptocurrency
2. **Setting Up Your Venmo for Crypto** (8 min) - Identity verification guide
3. **Your First Crypto Purchase** (6 min) - Buying crypto through Venmo
4. **Sending to Other Venmo Users** (4 min) - Peer-to-peer transfers
5. **Understanding External Wallets** (7 min) - Wallet types and security
6. **Sending Crypto to External Wallets** (10 min) - External transfers
7. **Receiving Crypto from External Sources** (5 min) - Incoming transfers
8. **Security Best Practices** (8 min) - Security quiz and certification

## 📱 Venmo Integration Guides

1. **Complete Identity Verification** - Step-by-step KYC process
2. **Make Your First Crypto Purchase** - Buying crypto in Venmo
3. **Send Crypto to Another Venmo User** - P2P transfers
4. **Find Your Venmo Wallet Address** - Locating receive addresses
5. **Send Crypto to External Wallet** - External transfers
6. **Check Transfer Status** - Monitoring transactions

## 🔧 API Endpoints

### Authentication
```bash
GET  /api/v1/nonces/:address
POST /api/v1/verify_signature
```

### User Management
```bash
GET  /api/v1/users/me
GET  /api/v1/users/stats
PUT  /api/v1/users/:id
```

### Wallet Connections
```bash
GET  /api/v1/wallet_connections
POST /api/v1/wallet_connections
GET  /api/v1/wallet_connections/:id
DELETE /api/v1/wallet_connections/:id
```

### Educational Content
```bash
GET  /modules
GET  /modules/:id
POST /modules/:id/complete
GET  /venmo_guides/:id
POST /venmo_guides/:id/complete
```

## 🛠️ Development

### Prerequisites
- Ruby 2.6+
- Rails 6.1+
- PostgreSQL or SQLite
- Node.js (for frontend assets)

### Setup
```bash
# Clone repository
git clone https://github.com/yourusername/venmo-crypto-connector.git
cd venmo-crypto-connector

# Install dependencies
cd venmo_crypto_connector
bundle install

# Setup database
rails db:create
rails db:migrate
rails db:seed

# Start development server
rails server
```

### Testing
```bash
# Run test suite
bundle exec rspec

# Run with coverage
COVERAGE=true bundle exec rspec
```

## 🔐 Security Features

- **SIWE Authentication** - Cryptographic proof of wallet ownership
- **Session Management** - JWT-based secure sessions
- **Input Validation** - Comprehensive parameter validation
- **Rate Limiting** - Protection against abuse
- **HTTPS Enforcement** - Required for production
- **Nonce Rotation** - Prevents replay attacks

## 📊 Demo Features

### Interactive Demo (`http://localhost:3000/interactive_demo.html`)
- ✅ Wallet connection simulation
- ✅ SIWE authentication flow
- ✅ Educational modules display
- ✅ Simulated wallet balances
- ✅ API endpoint testing
- ✅ Real-time status updates

### Static Demo (`demo.html`)
- ✅ Comprehensive project overview
- ✅ Feature documentation
- ✅ Installation instructions
- ✅ Technical architecture

## 🚀 Deployment

### Production Considerations
1. **HTTPS Required** - Crypto wallets require secure connections
2. **Environment Variables** - Set all required environment variables
3. **Database** - Use PostgreSQL in production
4. **Background Jobs** - Configure Sidekiq for transaction simulation
5. **CORS** - Configure for your domain

### Environment Variables
```bash
APP_DOMAIN=yourdomain.com
SECRET_KEY_BASE=your_secret_key
WALLETCONNECT_PROJECT_ID=your_project_id
INFURA_API_KEY=your_infura_key
COINBASE_APP_ID=your_coinbase_app_id
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ⚠️ Disclaimer

This is an independent educational tool not affiliated with, endorsed by, or supported by Venmo or PayPal. Users must complete Venmo's own identity verification and comply with all applicable laws and regulations.

## 🆘 Support

- **Documentation**: Check this README and inline code comments
- **Issues**: Report bugs via [GitHub issues](https://github.com/yourusername/venmo-crypto-connector/issues)
- **Discussions**: Use [GitHub discussions](https://github.com/yourusername/venmo-crypto-connector/discussions) for questions

## 🔄 Version History

- **v1.0.0**: Initial release with core functionality
  - SIWE authentication
  - Educational modules
  - Transaction simulation
  - Venmo integration guides

## 🌟 Acknowledgments

- Built with ❤️ for the crypto community
- Inspired by the need to bridge traditional and decentralized finance
- Special thanks to the Rails and Web3 communities

---

**Ready to onboard users into the crypto ecosystem?** 🚀

[Try the Demo](http://localhost:3000/interactive_demo.html) | [View Documentation](demo.html) | [Report Issues](https://github.com/yourusername/venmo-crypto-connector/issues)
