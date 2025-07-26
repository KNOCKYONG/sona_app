# Sona App

A Flutter-based AI chat application with multiple personas, offering personalized conversation experiences.

## Project Structure

```
sonaapp/
├── sona_app/          # Flutter application source code
├── docs/              # Project documentation
├── firebase_*.js      # Firebase configuration scripts
└── CLAUDE.md          # Claude Code configuration
```

## Documentation

All project documentation has been organized in the `docs/` directory:

### Setup Guides
- [API Setup Guide](docs/setup/API_SETUP_GUIDE.md) - Configure OpenAI and other APIs
- [Firebase Anonymous Auth Setup](docs/setup/FIREBASE_ANONYMOUS_AUTH_SETUP.md) - Enable anonymous authentication
- [Firebase Authentication Setup](docs/setup/FIREBASE_AUTHENTICATION_SETUP.md) - Configure Firebase authentication
- [Google Sign-In Setup](docs/setup/GOOGLE_SIGNIN_SETUP.md) - Implement Google authentication
- [Security Setup Guide](docs/setup/SECURITY_SETUP_GUIDE.md) - Security configuration and best practices

### Development Guides
- [Advanced Chat System Guide](docs/development/ADVANCED_CHAT_SYSTEM_GUIDE.md) - Implement advanced chat features
- [AI Chat Style Upgrade Guide](docs/development/AI_CHAT_STYLE_UPGRADE_GUIDE.md) - Enhance AI conversation styles
- [Conversation Context Guide](docs/development/CONVERSATION_CONTEXT_GUIDE.md) - Manage conversation memory and context
- [Swipe Optimization Guide](docs/development/SWIPE_OPTIMIZATION_GUIDE.md) - Optimize swipe matching functionality
- [Token Optimization Guide](docs/development/TOKEN_OPTIMIZATION_GUIDE.md) - Reduce API token usage

### Troubleshooting
- [Device ID Solution Guide](docs/troubleshooting/DEVICE_ID_SOLUTION_GUIDE.md) - Resolve device identification issues
- [Swipe Matching Debug Guide](docs/troubleshooting/SWIPE_MATCHING_DEBUG_GUIDE.md) - Debug swipe matching problems
- [Tutorial Matching Solution](docs/troubleshooting/TUTORIAL_MATCHING_SOLUTION.md) - Fix tutorial flow issues

### Architecture & Planning
- [Relationship Structure](docs/architecture/RELATIONSHIP_STRUCTURE.md) - App relationship and data architecture
- [Base Prompt](docs/architecture/base_prompt.md) - AI persona base prompts
- [Firebase Operations Plan](docs/architecture/firebase-operations-plan.md) - Firebase implementation strategy
- [Sona PRD](docs/architecture/sona_prd.md) - Product requirements document

## Quick Start

1. **Prerequisites**
   - Flutter SDK (3.0 or higher)
   - Firebase project setup
   - OpenAI API key

2. **Installation**
   ```bash
   cd sona_app
   flutter pub get
   ```

3. **Configuration**
   - Follow the [API Setup Guide](docs/setup/API_SETUP_GUIDE.md)
   - Configure Firebase using the [Firebase Authentication Setup](docs/setup/FIREBASE_AUTHENTICATION_SETUP.md)

4. **Run the app**
   ```bash
   flutter run
   ```

## Key Features

- Multiple AI personas with unique personalities
- Real-time chat with memory and context
- Swipe-based persona matching
- Google Sign-In authentication
- Anonymous user support
- Subscription management
- Secure data storage

## Development

For detailed development information, please refer to the documentation in the `docs/development/` directory.

## Security

Security is a top priority. Please review the [Security Setup Guide](docs/setup/SECURITY_SETUP_GUIDE.md) before deploying.

## License

This project is proprietary software. All rights reserved.