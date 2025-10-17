class WalletConnect {
  constructor() {
    this.provider = null;
    this.userAddress = null;
    this.isConnecting = false;
  }

  async connect() {
    if (this.isConnecting) return false;
    
    this.isConnecting = true;
    this.updateUI('connecting');

    try {
      if (typeof window.ethereum === 'undefined') {
        throw new Error('Please install MetaMask or another Web3 wallet to continue.');
      }

      // Request account access
      const accounts = await window.ethereum.request({
        method: 'eth_requestAccounts'
      });

      this.userAddress = accounts[0];
      this.provider = window.ethereum;

      // Fetch nonce from backend
      const nonceResponse = await fetch(`/api/v1/nonces/${this.userAddress}`);
      if (!nonceResponse.ok) {
        throw new Error('Failed to get authentication nonce');
      }
      
      const { nonce, message } = await nonceResponse.json();

      // Request signature
      const signature = await window.ethereum.request({
        method: 'personal_sign',
        params: [message, this.userAddress]
      });

      // Verify signature with backend
      const verifyResponse = await fetch('/api/v1/verify_signature', {
        method: 'POST',
        headers: { 
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
        },
        body: JSON.stringify({
          message: message,
          signature: signature,
          address: this.userAddress
        })
      });

      const result = await verifyResponse.json();

      if (result.success) {
        localStorage.setItem('auth_token', result.session_token);
        this.updateUI('connected', result.user);
        this.onSuccessfulConnection(result.user);
      } else {
        throw new Error(result.errors?.join(', ') || 'Authentication failed');
      }

    } catch (error) {
      console.error('Wallet connection error:', error);
      this.updateUI('error', null, error.message);
      this.showError(error.message);
    } finally {
      this.isConnecting = false;
    }
  }

  async connectWithWalletConnect() {
    if (this.isConnecting) return false;
    
    this.isConnecting = true;
    this.updateUI('connecting');

    try {
      // Dynamic import for WalletConnect
      const { EthereumProvider } = await import('@walletconnect/ethereum-provider');
      
      const provider = await EthereumProvider.init({
        projectId: process.env.WALLETCONNECT_PROJECT_ID || 'your_project_id',
        chains: [1], // Ethereum mainnet
        showQrModal: true,
        methods: ['personal_sign', 'eth_sendTransaction'],
        events: ['chainChanged', 'accountsChanged']
      });

      await provider.connect();
      
      this.provider = provider;
      this.userAddress = provider.accounts[0];

      // Continue with same authentication flow
      await this.performAuthentication();

    } catch (error) {
      console.error('WalletConnect error:', error);
      this.updateUI('error', null, error.message);
      this.showError(error.message);
    } finally {
      this.isConnecting = false;
    }
  }

  async performAuthentication() {
    try {
      // Fetch nonce from backend
      const nonceResponse = await fetch(`/api/v1/nonces/${this.userAddress}`);
      const { nonce, message } = await nonceResponse.json();

      // Request signature
      const signature = await this.provider.request({
        method: 'personal_sign',
        params: [message, this.userAddress]
      });

      // Verify signature with backend
      const verifyResponse = await fetch('/api/v1/verify_signature', {
        method: 'POST',
        headers: { 
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
        },
        body: JSON.stringify({
          message: message,
          signature: signature,
          address: this.userAddress
        })
      });

      const result = await verifyResponse.json();

      if (result.success) {
        localStorage.setItem('auth_token', result.session_token);
        this.updateUI('connected', result.user);
        this.onSuccessfulConnection(result.user);
      } else {
        throw new Error(result.errors?.join(', ') || 'Authentication failed');
      }

    } catch (error) {
      throw new Error(`Authentication failed: ${error.message}`);
    }
  }

  disconnect() {
    this.provider = null;
    this.userAddress = null;
    localStorage.removeItem('auth_token');
    this.updateUI('disconnected');
    this.onDisconnection();
  }

  updateUI(state, user = null, error = null) {
    const connectButton = document.getElementById('connect-wallet');
    const walletInfo = document.getElementById('wallet-info');
    const errorDiv = document.getElementById('wallet-error');

    if (errorDiv) {
      errorDiv.style.display = error ? 'block' : 'none';
      if (error) {
        errorDiv.textContent = error;
      }
    }

    switch (state) {
      case 'connecting':
        if (connectButton) {
          connectButton.disabled = true;
          connectButton.textContent = 'Connecting...';
        }
        break;
      
      case 'connected':
        if (connectButton) {
          connectButton.style.display = 'none';
        }
        if (walletInfo && user) {
          walletInfo.style.display = 'block';
          walletInfo.innerHTML = `
            <div class="wallet-connected">
              <div class="wallet-address">
                <strong>Connected:</strong> ${this.formatAddress(user.eth_address)}
              </div>
              <div class="user-stats">
                <span class="xp">XP: ${user.experience_points}</span>
                <span class="step">Step: ${this.formatOnboardingStep(user.onboarding_step)}</span>
              </div>
              <button onclick="walletConnect.disconnect()" class="btn btn-secondary btn-sm">
                Disconnect
              </button>
            </div>
          `;
        }
        break;
      
      case 'disconnected':
        if (connectButton) {
          connectButton.style.display = 'block';
          connectButton.disabled = false;
          connectButton.textContent = 'Connect Wallet';
        }
        if (walletInfo) {
          walletInfo.style.display = 'none';
        }
        break;
      
      case 'error':
        if (connectButton) {
          connectButton.disabled = false;
          connectButton.textContent = 'Connect Wallet';
        }
        break;
    }
  }

  formatAddress(address) {
    if (!address) return '';
    return `${address.slice(0, 6)}...${address.slice(-4)}`;
  }

  formatOnboardingStep(step) {
    const steps = {
      'not_started': 'Not Started',
      'wallet_connected': 'Wallet Connected',
      'identity_verified': 'Identity Verified',
      'first_purchase_completed': 'First Purchase',
      'first_transfer_completed': 'First Transfer',
      'external_wallet_connected': 'External Wallet',
      'onboarding_complete': 'Complete'
    };
    return steps[step] || step;
  }

  showError(message) {
    // Create or update error notification
    let errorDiv = document.getElementById('wallet-error');
    if (!errorDiv) {
      errorDiv = document.createElement('div');
      errorDiv.id = 'wallet-error';
      errorDiv.className = 'alert alert-danger';
      document.body.appendChild(errorDiv);
    }
    
    errorDiv.textContent = message;
    errorDiv.style.display = 'block';
    
    // Auto-hide after 5 seconds
    setTimeout(() => {
      errorDiv.style.display = 'none';
    }, 5000);
  }

  onSuccessfulConnection(user) {
    // Custom event for successful connection
    const event = new CustomEvent('walletConnected', { 
      detail: { user: user, address: this.userAddress } 
    });
    document.dispatchEvent(event);
  }

  onDisconnection() {
    // Custom event for disconnection
    const event = new CustomEvent('walletDisconnected');
    document.dispatchEvent(event);
  }

  // Check if already connected on page load
  checkExistingConnection() {
    const token = localStorage.getItem('auth_token');
    if (token) {
      // Verify token is still valid
      fetch('/api/v1/users/me', {
        headers: {
          'Authorization': `Bearer ${token}`,
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
        }
      })
      .then(response => {
        if (response.ok) {
          return response.json();
        } else {
          localStorage.removeItem('auth_token');
          return null;
        }
      })
      .then(user => {
        if (user) {
          this.userAddress = user.eth_address;
          this.updateUI('connected', user);
        }
      })
      .catch(() => {
        localStorage.removeItem('auth_token');
      });
    }
  }
}

// Initialize global instance
const walletConnect = new WalletConnect();

// Initialize on page load
document.addEventListener('DOMContentLoaded', () => {
  walletConnect.checkExistingConnection();
  
  const connectButton = document.getElementById('connect-wallet');
  if (connectButton) {
    connectButton.addEventListener('click', () => walletConnect.connect());
  }
  
  const walletConnectButton = document.getElementById('connect-walletconnect');
  if (walletConnectButton) {
    walletConnectButton.addEventListener('click', () => walletConnect.connectWithWalletConnect());
  }
});

// Export for use in other scripts
window.walletConnect = walletConnect;
