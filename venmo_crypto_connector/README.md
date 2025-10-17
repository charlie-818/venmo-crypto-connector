# Venmo Crypto Connector

A comprehensive Rails engine providing educational content, wallet integration, and guided onboarding for cryptocurrency users leveraging Venmo's crypto features.

## 🚀 Features

- **Sign-In with Ethereum (SIWE)** authentication
- **Progressive educational modules** for crypto onboarding
- **Interactive Venmo app guides** with step-by-step instructions
- **Transaction simulation** for risk-free practice
- **Multi-wallet support** (MetaMask, WalletConnect)
- **Experience points and gamification**
- **Comprehensive security education**

## 📋 Prerequisites

- Ruby 3.0+
- Rails 7.0+
- PostgreSQL
- Node.js (for frontend assets)

## 🛠 Installation

### As a Rails Engine

1. Add to your Gemfile:

```ruby
gem 'venmo_crypto_connector', path: '/path/to/venmo_crypto_connector'
```

2. Run bundle install:

```bash
bundle install
```

3. Mount the engine in your routes:

```ruby
# config/routes.rb
mount VenmoCryptoConnector::Engine, at: "/crypto"
```

4. Run migrations:

```bash
rake venmo_crypto_connector:install:migrations
rake db:migrate
```

5. Seed educational content:

```bash
rake venmo_crypto_connector:seed_modules
```

### Environment Variables

Create a `.env` file with the following variables:

```bash
# Required
APP_DOMAIN=yourdomain.com
SECRET_KEY_BASE=your_secret_key_base

# Optional (for enhanced features)
WALLETCONNECT_PROJECT_ID=your_walletconnect_project_id
INFURA_API_KEY=your_infura_api_key
COINBASE_APP_ID=your_coinbase_app_id
```

## 🎯 Usage

### Basic Setup

1. Start your Rails server:

```bash
rails server
```

2. Visit the crypto onboarding interface:

```
http://localhost:3000/crypto
```

### User Flow

1. **Connect Wallet**: Users connect their Ethereum wallet (MetaMask, WalletConnect)
2. **Authentication**: Sign-In with Ethereum (SIWE) verifies wallet ownership
3. **Educational Modules**: Progressive learning modules unlock as users advance
4. **Practice Transactions**: Simulated transactions for risk-free learning
5. **Venmo Integration**: Step-by-step guides for Venmo crypto features

### API Endpoints

#### Authentication

```bash
# Get nonce for wallet address
GET /api/v1/nonces/:address

# Verify signature and authenticate
POST /api/v1/verify_signature
{
  "message": "Sign in to Venmo Crypto Connector...",
  "signature": "0x...",
  "address": "0x..."
}
```

#### User Management

```bash
# Get current user info
GET /api/v1/users/me
Authorization: Bearer <session_token>
```

## 🏗 Architecture

### Models

- **User**: Core user model with crypto wallet support
- **EducationModule**: Progressive learning content
- **SimulatedWallet**: Practice wallet with fake balances
- **SimulatedTransaction**: Practice transactions

### Services

- **SiweAuthenticationService**: Handles wallet authentication
- **BaseService**: Common service patterns

### Controllers

- **API Controllers**: JSON endpoints for frontend
- **Web Controllers**: Traditional Rails views
- **Dashboard**: Main user interface

## 🎓 Educational Modules

The engine includes 8 progressive educational modules:

1. **Crypto Basics for Venmo Users** (5 min)
2. **Setting Up Your Venmo for Crypto** (8 min)
3. **Your First Crypto Purchase** (6 min)
4. **Sending to Other Venmo Users** (4 min)
5. **Understanding External Wallets** (7 min)
6. **Sending Crypto to External Wallets** (10 min)
7. **Receiving Crypto from External Sources** (5 min)
8. **Security Best Practices** (8 min)

## 🔐 Security Features

- **SIWE Authentication**: Cryptographic proof of wallet ownership
- **Session Management**: JWT-based secure sessions
- **Rate Limiting**: Protection against abuse
- **Input Validation**: Comprehensive parameter validation
- **HTTPS Enforcement**: Required for production

## 🧪 Testing

```bash
# Run the test suite
bundle exec rspec

# Run with coverage
COVERAGE=true bundle exec rspec
```

## 🚀 Deployment

### Production Considerations

1. **HTTPS Required**: Crypto wallets require secure connections
2. **Environment Variables**: Set all required environment variables
3. **Database**: Use PostgreSQL in production
4. **Background Jobs**: Configure Sidekiq for transaction simulation
5. **CORS**: Configure for your domain

### Docker Support

```dockerfile
FROM ruby:3.0-alpine
WORKDIR /app
COPY . .
RUN bundle install
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ⚠️ Disclaimer

This is an independent educational tool not affiliated with, endorsed by, or supported by Venmo or PayPal. Users must complete Venmo's own identity verification and comply with all applicable laws and regulations.

## 🆘 Support

- **Documentation**: Check this README and inline code comments
- **Issues**: Report bugs via GitHub issues
- **Discussions**: Use GitHub discussions for questions

## 🔄 Version History

- **v1.0.0**: Initial release with core functionality
  - SIWE authentication
  - Educational modules
  - Transaction simulation
  - Venmo integration guides

---

Built with ❤️ for the crypto community
