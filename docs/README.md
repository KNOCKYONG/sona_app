# Sona App Documentation

Welcome to the Sona App documentation. This directory contains all guides and references for setting up, developing, and maintaining the Sona App.

## Documentation Structure

### 📚 Setup Guides
Essential guides for initial project setup and configuration.

- **[API Setup Guide](setup/API_SETUP_GUIDE.md)** - Configure OpenAI API and environment variables
- **[Firebase Anonymous Auth Setup](setup/FIREBASE_ANONYMOUS_AUTH_SETUP.md)** - Enable and configure anonymous authentication
- **[Firebase Authentication Setup](setup/FIREBASE_AUTHENTICATION_SETUP.md)** - Complete Firebase authentication configuration
- **[Google Sign-In Setup](setup/GOOGLE_SIGNIN_SETUP.md)** - Implement Google OAuth authentication
- **[Security Setup Guide](setup/SECURITY_SETUP_GUIDE.md)** - Security configuration and best practices

### 🛠️ Development Guides
Comprehensive guides for implementing and enhancing features.

- **[Advanced Chat System Guide](development/ADVANCED_CHAT_SYSTEM_GUIDE.md)** - Implement sophisticated chat features and memory management
- **[AI Chat Style Upgrade Guide](development/AI_CHAT_STYLE_UPGRADE_GUIDE.md)** - Enhance AI conversation styles and personality traits
- **[Conversation Context Guide](development/CONVERSATION_CONTEXT_GUIDE.md)** - Manage conversation memory, context, and continuity
- **[Swipe Optimization Guide](development/SWIPE_OPTIMIZATION_GUIDE.md)** - Optimize swipe matching functionality and performance
- **[Token Optimization Guide](development/TOKEN_OPTIMIZATION_GUIDE.md)** - Reduce API token usage and costs

### 🔧 Troubleshooting
Solutions for common issues and debugging guides.

- **[Device ID Solution Guide](troubleshooting/DEVICE_ID_SOLUTION_GUIDE.md)** - Resolve device identification and persistence issues
- **[Swipe Matching Debug Guide](troubleshooting/SWIPE_MATCHING_DEBUG_GUIDE.md)** - Debug and fix swipe matching problems
- **[Tutorial Matching Solution](troubleshooting/TUTORIAL_MATCHING_SOLUTION.md)** - Fix tutorial flow and onboarding issues

### 🏗️ Architecture & Planning
System architecture, design documents, and project planning.

- **[Relationship Structure](architecture/RELATIONSHIP_STRUCTURE.md)** - Application data relationships and architecture
- **[Base Prompt](architecture/base_prompt.md)** - AI persona base prompts and personality definitions
- **[Firebase Operations Plan](architecture/firebase-operations-plan.md)** - Firebase implementation strategy and roadmap
- **[Sona PRD](architecture/sona_prd.md)** - Product requirements document and feature specifications

## Quick Navigation

### By Task
- **First-time setup?** Start with [Firebase Authentication Setup](setup/FIREBASE_AUTHENTICATION_SETUP.md) and [API Setup Guide](setup/API_SETUP_GUIDE.md)
- **Adding new features?** Check [Advanced Chat System Guide](development/ADVANCED_CHAT_SYSTEM_GUIDE.md)
- **Optimizing performance?** See [Token Optimization Guide](development/TOKEN_OPTIMIZATION_GUIDE.md) and [Swipe Optimization Guide](development/SWIPE_OPTIMIZATION_GUIDE.md)
- **Debugging issues?** Browse the [Troubleshooting](troubleshooting/) section

### By Component
- **Authentication**: [Firebase Auth](setup/FIREBASE_AUTHENTICATION_SETUP.md), [Google Sign-In](setup/GOOGLE_SIGNIN_SETUP.md), [Anonymous Auth](setup/FIREBASE_ANONYMOUS_AUTH_SETUP.md)
- **Chat System**: [Advanced Chat](development/ADVANCED_CHAT_SYSTEM_GUIDE.md), [AI Styles](development/AI_CHAT_STYLE_UPGRADE_GUIDE.md), [Context Management](development/CONVERSATION_CONTEXT_GUIDE.md)
- **Matching System**: [Swipe Optimization](development/SWIPE_OPTIMIZATION_GUIDE.md), [Debug Guide](troubleshooting/SWIPE_MATCHING_DEBUG_GUIDE.md)
- **Security**: [Security Setup](setup/SECURITY_SETUP_GUIDE.md)

## Documentation Standards

- All guides include step-by-step instructions
- Code examples are provided where applicable
- Common issues and solutions are documented
- Each guide is self-contained but references related documentation

## Contributing to Documentation

When adding new documentation:
1. Place it in the appropriate subdirectory
2. Use clear, descriptive filenames
3. Include a table of contents for longer documents
4. Update this index file with the new documentation
5. Follow the existing formatting conventions