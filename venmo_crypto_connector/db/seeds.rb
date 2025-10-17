# Venmo Crypto Connector Seed Data

# Create educational modules
modules_data = [
  {
    title: "Crypto Basics for Venmo Users",
    description: "Learn the fundamentals of cryptocurrency and how it relates to your Venmo experience.",
    sequence_number: 1,
    estimated_duration_minutes: 5,
    module_type: "video",
    content_data: {
      video_url: "https://example.com/videos/crypto-basics.mp4",
      reading_content: "Cryptocurrency is digital money that exists on the blockchain..."
    },
    icon_class: "fas fa-coins",
    color_theme: "blue"
  },
  {
    title: "Setting Up Your Venmo for Crypto",
    description: "Step-by-step guide to enabling crypto features in your Venmo account.",
    sequence_number: 2,
    estimated_duration_minutes: 8,
    module_type: "interactive",
    content_data: {
      interactive_content: "Follow these steps to set up crypto in Venmo...",
      checklist: [
        "Open Venmo app",
        "Go to Crypto tab",
        "Complete identity verification",
        "Accept terms and conditions"
      ]
    },
    icon_class: "fas fa-mobile-alt",
    color_theme: "green"
  },
  {
    title: "Your First Crypto Purchase",
    description: "Learn how to buy cryptocurrency through Venmo safely and efficiently.",
    sequence_number: 3,
    estimated_duration_minutes: 6,
    module_type: "video",
    content_data: {
      video_url: "https://example.com/videos/first-purchase.mp4",
      tips: [
        "Start with small amounts",
        "Choose stablecoins for beginners",
        "Understand the fees involved"
      ]
    },
    icon_class: "fas fa-shopping-cart",
    color_theme: "purple"
  },
  {
    title: "Sending to Other Venmo Users",
    description: "Master peer-to-peer crypto transfers within the Venmo ecosystem.",
    sequence_number: 4,
    estimated_duration_minutes: 4,
    module_type: "interactive",
    content_data: {
      interactive_content: "Practice sending crypto to other Venmo users...",
      simulation: true
    },
    icon_class: "fas fa-paper-plane",
    color_theme: "orange"
  },
  {
    title: "Understanding External Wallets",
    description: "Learn about different types of crypto wallets and when to use them.",
    sequence_number: 5,
    estimated_duration_minutes: 7,
    module_type: "reading",
    content_data: {
      reading_content: "External wallets give you full control over your crypto...",
      wallet_types: [
        "Software wallets (MetaMask, Trust Wallet)",
        "Hardware wallets (Ledger, Trezor)",
        "Mobile wallets (Coinbase Wallet, Rainbow)"
      ]
    },
    icon_class: "fas fa-wallet",
    color_theme: "teal"
  },
  {
    title: "Sending Crypto to External Wallets",
    description: "Learn how to transfer crypto from Venmo to external wallets safely.",
    sequence_number: 6,
    estimated_duration_minutes: 10,
    module_type: "interactive",
    content_data: {
      interactive_content: "Practice sending crypto to external wallets...",
      warnings: [
        "Double-check wallet addresses",
        "Start with small test amounts",
        "Understand network fees"
      ],
      simulation: true
    },
    icon_class: "fas fa-exchange-alt",
    color_theme: "red"
  },
  {
    title: "Receiving Crypto from External Sources",
    description: "Learn how to receive crypto in your Venmo wallet from external sources.",
    sequence_number: 7,
    estimated_duration_minutes: 5,
    module_type: "video",
    content_data: {
      video_url: "https://example.com/videos/receiving-crypto.mp4",
      steps: [
        "Find your Venmo wallet address",
        "Share address with sender",
        "Wait for confirmations",
        "Check transaction status"
      ]
    },
    icon_class: "fas fa-download",
    color_theme: "indigo"
  },
  {
    title: "Security Best Practices",
    description: "Essential security knowledge for protecting your crypto assets.",
    sequence_number: 8,
    estimated_duration_minutes: 8,
    module_type: "quiz",
    quiz_questions: [
      {
        question: "What should you never share with anyone?",
        options: ["Your wallet address", "Your private key", "Your transaction history", "Your public key"],
        correct_answer: 1,
        explanation: "Your private key gives full access to your wallet. Never share it with anyone."
      },
      {
        question: "What's the best way to verify a wallet address before sending crypto?",
        options: ["Send a small test amount first", "Copy and paste from a trusted source", "Ask someone else to verify", "All of the above"],
        correct_answer: 3,
        explanation: "All of these methods help ensure you're sending to the correct address."
      },
      {
        question: "What should you do if you suspect your wallet has been compromised?",
        options: ["Wait and see what happens", "Transfer funds to a new wallet immediately", "Change your password", "Contact customer support"],
        correct_answer: 1,
        explanation: "If you suspect compromise, immediately transfer all funds to a new, secure wallet."
      }
    ],
    icon_class: "fas fa-shield-alt",
    color_theme: "yellow"
  }
]

modules_data.each do |module_attrs|
  VenmoCryptoConnector::EducationModule.find_or_create_by(
    sequence_number: module_attrs[:sequence_number]
  ) do |module_item|
    module_item.assign_attributes(module_attrs)
  end
end

puts "✅ Created #{modules_data.length} educational modules"

# Create Venmo guides
venmo_guides_data = [
  {
    title: "Complete Identity Verification in Venmo",
    description: "Step-by-step guide to verify your identity for crypto features in Venmo.",
    action: "identity_verification",
    estimated_duration_minutes: 10,
    xp_reward: 150,
    icon_class: "fas fa-id-card",
    color_theme: "blue"
  },
  {
    title: "Make Your First Crypto Purchase",
    description: "Learn how to buy cryptocurrency through Venmo with confidence.",
    action: "first_crypto_purchase",
    estimated_duration_minutes: 8,
    xp_reward: 200,
    icon_class: "fas fa-shopping-cart",
    color_theme: "green"
  },
  {
    title: "Send Crypto to Another Venmo User",
    description: "Master peer-to-peer crypto transfers within Venmo.",
    action: "send_to_venmo_user",
    estimated_duration_minutes: 5,
    xp_reward: 100,
    icon_class: "fas fa-paper-plane",
    color_theme: "purple"
  },
  {
    title: "Find Your Venmo Wallet Address",
    description: "Learn how to locate your wallet address for receiving crypto.",
    action: "find_wallet_address",
    estimated_duration_minutes: 3,
    xp_reward: 75,
    icon_class: "fas fa-search",
    color_theme: "orange"
  },
  {
    title: "Send Crypto to External Wallet",
    description: "Transfer crypto from Venmo to external wallets safely.",
    action: "send_to_external_wallet",
    estimated_duration_minutes: 12,
    xp_reward: 250,
    icon_class: "fas fa-exchange-alt",
    color_theme: "red"
  },
  {
    title: "Check Transfer Status",
    description: "Monitor your crypto transfers and understand confirmation times.",
    action: "check_transfer_status",
    estimated_duration_minutes: 4,
    xp_reward: 50,
    icon_class: "fas fa-clock",
    color_theme: "teal"
  }
]

venmo_guides_data.each do |guide_attrs|
  VenmoCryptoConnector::VenmoGuide.find_or_create_by(
    action: guide_attrs[:action]
  ) do |guide|
    guide.assign_attributes(guide_attrs)
  end
end

puts "✅ Created #{venmo_guides_data.length} Venmo guides"

# Create sample guide steps for identity verification
identity_guide = VenmoCryptoConnector::VenmoGuide.find_by(action: 'identity_verification')
if identity_guide
  identity_steps = [
    {
      title: "Open Venmo App",
      instructions: "Launch the Venmo app on your mobile device and make sure you're logged in.",
      step_type: "screenshot",
      sequence: 1,
      image_url: "/assets/venmo-home-screen.png"
    },
    {
      title: "Navigate to Crypto Tab",
      instructions: "Tap on the 'Crypto' tab at the bottom of the screen. If you don't see it, you may need to update your app.",
      step_type: "screenshot",
      sequence: 2,
      image_url: "/assets/venmo-crypto-tab.png"
    },
    {
      title: "Start Identity Verification",
      instructions: "Tap 'Get Started' or 'Verify Identity' to begin the verification process.",
      step_type: "screenshot",
      sequence: 3,
      image_url: "/assets/venmo-verify-start.png"
    },
    {
      title: "Provide Required Information",
      instructions: "You'll need to provide your Social Security Number (SSN) or Individual Taxpayer Identification Number (ITIN). This is required by law for crypto transactions.",
      step_type: "warning",
      sequence: 4,
      content: "⚠️ This information is required by federal regulations for cryptocurrency transactions. Venmo uses this to comply with Know Your Customer (KYC) requirements."
    },
    {
      title: "Take Photo ID",
      instructions: "Take a clear photo of your government-issued ID (driver's license, passport, or state ID). Make sure all text is readable and the photo is well-lit.",
      step_type: "screenshot",
      sequence: 5,
      image_url: "/assets/venmo-photo-id.png"
    },
    {
      title: "Complete Facial Recognition",
      instructions: "Follow the prompts to take a selfie for facial recognition verification. Make sure you're in good lighting and looking directly at the camera.",
      step_type: "screenshot",
      sequence: 6,
      image_url: "/assets/venmo-facial-recognition.png"
    },
    {
      title: "Wait for Verification",
      instructions: "Venmo will review your information. This usually takes a few minutes to a few hours. You'll receive a notification when verification is complete.",
      step_type: "text_instruction",
      sequence: 7,
      content: "Verification typically takes 5-30 minutes, but can take up to 24 hours in some cases. You can continue using other Venmo features while waiting."
    }
  ]

  identity_steps.each do |step_attrs|
    identity_guide.venmo_guide_steps.find_or_create_by(
      sequence: step_attrs[:sequence]
    ) do |step|
      step.assign_attributes(step_attrs)
    end
  end
end

puts "✅ Created sample guide steps for identity verification"

# Create a sample user for testing (optional)
if Rails.env.development?
  sample_user = VenmoCryptoConnector::User.find_or_create_by(
    email: "test@example.com"
  ) do |user|
    user.username = "test_user"
    user.eth_address = "0x742d35Cc6634C0532925a3b8D4C9db96C4b4d8b6"
    user.eth_nonce = SecureRandom.uuid
    user.onboarding_step = "wallet_connected"
    user.identity_verified = true
    user.wallet_connected = true
    user.experience_points = 250
  end

  puts "✅ Created sample user: #{sample_user.email}"
end

puts "🎉 Seed data loaded successfully!"
