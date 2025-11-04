# DayFlow

<div align="center">

<img src="https://api.iconify.design/carbon:task-complete.svg?color=%236366f1" width="150"/>

### Your Intelligent Productivity Companion

**Transform your daily routine with smart task management, habit tracking, and personalized AI guidance**

---

[![Flutter](https://img.shields.io/badge/Flutter-3.24+-02569B?style=flat-square&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.5+-0175C2?style=flat-square&logo=dart&logoColor=white)](https://dart.dev)
[![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=flat-square&logo=firebase&logoColor=black)](https://firebase.google.com)
[![Material Design](https://img.shields.io/badge/Material%20Design%203-757575?style=flat-square&logo=material-design&logoColor=white)](https://m3.material.io)
[![License: MIT](https://img.shields.io/badge/License-MIT-success.svg?style=flat-square)](LICENSE)

**[Features](#core-features)** • **[Technology](#technology-stack)** • **[Installation](#getting-started)** • **[Documentation](#documentation)** • **[Roadmap](#future-vision)**

</div>

---

## Overview

DayFlow is a comprehensive productivity platform that combines intelligent task management, behavioral habit tracking, and AI-powered insights to help you achieve your goals. Built with Flutter for cross-platform compatibility, DayFlow adapts to your workflow and provides personalized guidance through every step of your productivity journey.

### Design Philosophy

- **User-Centric**: Intuitive interfaces that minimize friction and maximize efficiency
- **Adaptive Intelligence**: Learn from your patterns to provide meaningful insights
- **Cross-Platform**: Seamless experience across Android, Windows, and Web
- **Privacy-First**: Your data remains secure with enterprise-grade encryption
- **Accessibility**: Full support for multiple languages and accessibility features

---

## Core Features

<table>
<tr>
<td width="50%">

### Task Management System

**Advanced Organization**
- Hierarchical task structures with subtask support
- Multi-dimensional filtering by priority, date, and status
- Tag-based categorization for flexible organization
- Due date tracking with intelligent overdue detection
- Rich task descriptions with markdown support

**Smart Workflows**
- Drag-and-drop task prioritization
- Bulk operations for efficient management
- Quick task creation with natural language
- Customizable task templates
- Progress tracking with completion analytics

</td>
<td width="50%">

### Habit Tracking & Analytics

**Behavioral Intelligence**
- Daily, weekly, and custom frequency tracking
- Visual progress charts powered by FL Chart
- Streak tracking with milestone celebrations
- Completion rate analytics across time periods
- Pattern recognition for habit optimization

**Integration Features**
- Automatic habit completion via linked tasks
- Goal-based habit recommendations
- Historical data visualization
- Export capabilities for external analysis
- Habit correlation insights

</td>
</tr>
</table>

---

<table>
<tr>
<td width="50%">

### AI-Powered Assistant

**Personalized Experience**
- Interactive onboarding with preference learning
- Context-aware productivity suggestions
- Achievement recognition and celebration
- Behavioral pattern analysis
- Adaptive notification timing

**Intelligent Insights**
- Productivity trend identification
- Goal progress forecasting
- Work-life balance recommendations
- Focus time optimization
- Habit sustainability predictions

</td>
<td width="50%">

### Enterprise-Grade Security

**Authentication System**
- Firebase Authentication integration
- Multi-factor authentication support
- OAuth 2.0 with Google Sign-In
- Secure password recovery flow
- Email verification protocols
- Session management with auto-logout

**Data Protection**
- End-to-end encryption for sensitive data
- Secure local storage with encryption keys
- Cloud backup with encrypted transmission
- GDPR-compliant data handling
- Granular privacy controls

</td>
</tr>
</table>

---

### Additional Capabilities

<details>
<summary><b>Note-Taking System</b></summary>

- Rich text editor with formatting options
- Multiple page templates (blank, lined, grid)
- Pin important notes for quick access
- Tag-based organization
- Color-coded categorization
- Search functionality across all notes
- Customizable fonts and themes

</details>

<details>
<summary><b>Internationalization</b></summary>

- Full localization support
- English, French, and Arabic languages
- Right-to-left (RTL) text support for Arabic
- Cultural date and time formatting
- Extensible translation framework
- Easy addition of new languages

</details>

<details>
<summary><b>User Interface</b></summary>

- Material Design 3 implementation
- Adaptive layouts for all screen sizes
- Smooth micro-interactions and animations
- Dark and light theme support
- High contrast mode for accessibility
- Customizable color schemes
- Gesture-based navigation

</details>

<details>
<summary><b>Data Management</b></summary>

- Local-first architecture for offline functionality
- Automatic data persistence
- Cloud synchronization (planned)
- Import/export capabilities (planned)
- Data backup and restore
- Version control for data recovery

</details>

---

## Technology Stack

### Frontend Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Presentation Layer                    │
├─────────────────────────────────────────────────────────┤
│  Material Design 3  │  Custom Widgets  │  Animations   │
├─────────────────────────────────────────────────────────┤
│                    Business Logic Layer                  │
├─────────────────────────────────────────────────────────┤
│   Provider State    │  Services Layer  │  Repositories  │
├─────────────────────────────────────────────────────────┤
│                      Data Layer                          │
├─────────────────────────────────────────────────────────┤
│  SharedPreferences  │   Firestore     │  Local Storage │
└─────────────────────────────────────────────────────────┘
```

### Technologies & Libraries

<div align="center">

| Category | Technology | Purpose |
|----------|-----------|---------|
| **Framework** | Flutter 3.24+ | Cross-platform UI framework |
| **Language** | Dart 3.5+ | Application logic and business rules |
| **Authentication** | Firebase Auth | User management and security |
| **Database** | Cloud Firestore | Real-time NoSQL database |
| **Charts** | FL Chart | Data visualization and analytics |
| **State Management** | Provider | Reactive state management |
| **Local Storage** | SharedPreferences | Persistent local data storage |
| **Internationalization** | flutter_localizations | Multi-language support |
| **UI Components** | Material Design 3 | Modern UI/UX patterns |
| **Backend (Planned)** | Node.js + MongoDB | RESTful API and data persistence |

</div>

### Supported Platforms

<div align="center">

| Platform | Status | Version |
|----------|--------|---------|
| Android | Production Ready | 5.0+ (API 21+) |
| Windows | Production Ready | Windows 10+ |
| Web | Production Ready | Modern Browsers |
| iOS | Planned | iOS 12+ |
| macOS | Planned | macOS 10.14+ |
| Linux | Planned | Ubuntu 20.04+ |

</div>

---

## Project Architecture

```
lib/
├── main.dart                          # Application entry point and initialization
├── firebase_options.dart              # Firebase project configuration
│
├── models/                            # Data models and entity definitions
│   ├── task_model.dart               # Task entity with business logic
│   ├── habit_model.dart              # Habit tracking model
│   └── note_model.dart               # Note-taking model
│
├── pages/                            # Application screens and views
│   ├── auth/                         # Authentication flow
│   │   ├── login_page.dart          # User login interface
│   │   ├── signup_page.dart         # User registration
│   │   ├── forgot_password_page.dart # Password recovery
│   │   └── email_verification_page.dart # Email verification UI
│   │
│   ├── onboarding/                   # First-time user experience
│   │   ├── onboarding_page.dart     # Feature introduction
│   │   ├── question_flow_page.dart  # Personalization wizard
│   │   └── question_flow_widgets/   # Onboarding components
│   │       ├── robot_character.dart # AI assistant character
│   │       ├── speech_bubble.dart   # Chat interface
│   │       ├── answer_button.dart   # Interactive options
│   │       └── completion_screen.dart # Success screen
│   │
│   ├── welcome_page.dart             # Landing page with animations
│   ├── todo_page.dart                # Task management interface
│   ├── habits_page.dart              # Habit tracking overview
│   ├── habit_detail_page.dart        # Individual habit analytics
│   ├── notes_page.dart               # Note listing and organization
│   ├── note_page_write.dart          # Note editor with templates
│   ├── reminders_page.dart           # Reminder management
│   ├── settings_page.dart            # User preferences
│   ├── task_detail_page.dart         # Task details and subtasks
│   ├── task_edit_page.dart           # Task creation/editing
│   ├── privacy_backup_page.dart      # Data backup settings
│   ├── help_support_page.dart        # Help documentation
│   └── terms_privacy_page.dart       # Legal information
│
├── services/                         # Business logic and data operations
│   ├── firebase_auth_service.dart   # Authentication service layer
│   ├── task_service.dart            # Task CRUD operations
│   └── habit_service.dart           # Habit tracking operations
│
├── widgets/                          # Reusable UI components
│   ├── ui_kit.dart                  # Component library export
│   ├── custom_button.dart           # Button components
│   ├── custom_input.dart            # Input field components
│   ├── custom_card.dart             # Card layout components
│   ├── task_card.dart               # Task display widget
│   ├── habit_card.dart              # Habit display widget
│   ├── note_item.dart               # Note display widget
│   ├── bottom_nav_bar.dart          # Navigation bar
│   ├── app_drawer.dart              # Side navigation drawer
│   ├── modal_sheet.dart             # Bottom sheet components
│   └── date_time_picker.dart        # Date/time selection
│
├── providers/                        # State management
│   └── language_provider.dart       # Language preference state
│
├── theme/                            # Visual styling
│   └── app_theme.dart               # Theme definitions and provider
│
└── utils/                            # Utility functions and helpers
    ├── routes.dart                  # Navigation routes
    ├── app_localizations.dart       # Internationalization helper
    └── date_utils.dart              # Date formatting utilities
```

---

## Getting Started

### Prerequisites

Ensure you have the following installed on your development machine:

- **Flutter SDK** version 3.24 or higher
- **Dart SDK** version 3.5 or higher
- **Android Studio** or **Visual Studio Code** with Flutter extensions
- **Git** for version control
- **Firebase CLI** for Firebase configuration

### Installation Steps

#### 1. Clone the Repository

```bash
git clone https://github.com/Abderrahamane/dayflow.git
cd dayflow
```

#### 2. Install Dependencies

```bash
flutter pub get
```

#### 3. Firebase Configuration

Create a Firebase project at [Firebase Console](https://console.firebase.google.com) and enable the following services:

- **Authentication** (Email/Password, Google)
- **Cloud Firestore**

Then configure Firebase for your Flutter project:

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase
flutterfire configure
```

This will generate the `firebase_options.dart` file with your project configuration.

#### 4. Platform-Specific Setup

**Android**

No additional setup required. Ensure you have an Android device or emulator running.

**Windows**

Enable Windows desktop support:

```bash
flutter config --enable-windows-desktop
```

**Web**

Enable web support:

```bash
flutter config --enable-web
```

#### 5. Run the Application

```bash
# For Android
flutter run -d android

# For Windows
flutter run -d windows

# For Web
flutter run -d chrome

# For all available devices
flutter run
```

### Building for Production

#### Android

```bash
# Build APK (for testing)
flutter build apk --release

# Build App Bundle (for Play Store)
flutter build appbundle --release
```

#### Windows

```bash
flutter build windows --release
```

The executable will be located in `build/windows/runner/Release/`

#### Web

```bash
flutter build web --release
```

The build output will be in `build/web/`

---

## Development Workflow

### Code Style and Conventions

This project follows the official [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style) and [Flutter Best Practices](https://flutter.dev/docs/development/tools/formatting).

**Key Conventions:**
- Use meaningful variable and function names
- Document complex logic with comments
- Follow the existing architecture patterns
- Write widget tests for critical functionality
- Use const constructors where possible for performance

### Running Tests

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/models/task_model_test.dart
```

### Code Formatting

```bash
# Format all Dart files
dart format .

# Check formatting without making changes
dart format --output=none --set-exit-if-changed .
```

### Static Analysis

```bash
# Run Dart analyzer
flutter analyze
```

---

## Screenshots
> **Note:** Replace placeholder images with actual application screenshots

<div align="center">

### Welcome Experience
<img width="300" alt="Screenshot 2025-11-03 224044" src="https://github.com/user-attachments/assets/13cc5abd-7dd0-4f18-aaa0-d412ff35e6ab" />
<br/>
<sub>Animated welcome screen with smooth transitions and engaging visuals</sub>

---

### Onboarding Flow
<table>
<tr>
<td width="33%">
<img width="100%" alt="Screenshot 2025-11-03 224106" src="https://github.com/user-attachments/assets/b8b0105a-9538-4c9e-bd6f-9024425f8c70" />
<br/>
<sub>Feature introduction</sub>
</td>
<td width="33%">
<img width="100%" alt="Screenshot 2025-11-03 224144" src="https://github.com/user-attachments/assets/7dc88c0e-4637-42b7-93b8-c59278248cfc" />
<br/>
<sub>AI assistant interaction</sub>
</td>
<td width="33%">
<img width="100%" alt="Screenshot 2025-11-03 224210" src="https://github.com/user-attachments/assets/33a81e66-7ffb-4de3-8a2f-e58074802c71" />
<br/>
<sub>Personalization questions</sub>
</td>
</tr>
</table>

---

### Core Application
<table>
<tr>
<td width="25%">
<img width="100%" alt="Screenshot 2025-11-03 224316" src="https://github.com/user-attachments/assets/f43e3c86-7ce9-42ec-887b-1c9a1b2b6091" />
<br/>
<sub><b>Task Management</b><br/>Organize and prioritize</sub>
</td>
<td width="25%">
<img width="100%" alt="Screenshot 2025-11-03 224534" src="https://github.com/user-attachments/assets/68e70584-c54a-4d8b-adc2-215bf82d54aa" />
<br/>
<sub><b>Habit Tracking</b><br/>Build consistency</sub>
</td>
<td width="25%">
<img width="100%" alt="Screenshot 2025-11-03 224554" src="https://github.com/user-attachments/assets/e7c0851e-84a4-41d7-bcd9-7fb9a57a4742" />
<br/>
<sub><b>Note Taking</b><br/>Capture ideas</sub>
</td>
<td width="25%">
<img width="100%" alt="Screenshot 2025-11-03 224811" src="https://github.com/user-attachments/assets/1fd96299-11de-471a-a8d5-5aeacfe3d9ce" />
<br/>
<sub><b>Analytics</b><br/>Track progress</sub>
</td>
</tr>
</table>

---

### Detail Views
<table>
<tr>
<td width="50%">
<img width="100%" alt="Screenshot 2025-11-03 224330" src="https://github.com/user-attachments/assets/31f7e9c2-628c-464b-af9c-9ab3493dc30d" />
<br/>
<sub>Task detail view with subtasks and metadata</sub>
</td>
<td width="50%">
<img width="100%" alt="Screenshot 2025-11-03 225148" src="https://github.com/user-attachments/assets/de513be8-b1ef-4d51-bba2-02d87e56d081" />
<br/>
<sub>Help & Support page</sub>
</td>
</tr>
</table>

---

### Theme Variations
<table>
<tr>
<td width="50%">
<img width="100%" alt="Screenshot 2025-11-03 230042" src="https://github.com/user-attachments/assets/be74f81a-6bd8-4f9b-b277-51ea5ba8d0d7" />
<br/>
<sub>Light theme with vibrant colors</sub>
</td>
<td width="50%">
<img width="100%" alt="Screenshot 2025-11-03 231312" src="https://github.com/user-attachments/assets/29522b3a-e65e-4160-84c1-ad3e633a2b9d" />
<br/>
<sub>Reminders & Alarms Page</sub>
</td>
</tr>
</table>

---

### Settings and Configuration
<img width="300" alt="Screenshot 2025-11-03 225428" src="https://github.com/user-attachments/assets/46face2f-9776-4961-94cc-faf8946ff40c" />
<br/>
<sub>Comprehensive settings with profile management, theme selection, and language preferences</sub>

</div>

---

## Documentation

### User Guide

Comprehensive user documentation is available in the [Wiki](https://github.com/Abderrahamane/DayFlow/wiki) section, covering:

- Getting started guide
- Feature walkthroughs
- Tips and best practices
- Troubleshooting common issues
- Keyboard shortcuts and gestures

### API Documentation

API documentation for developers is generated using DartDoc and can be accessed after building:

```bash
# Generate documentation
dart doc .

# View documentation
open doc/api/index.html
```

### Contributing Guide

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

---

## Future Vision

### Phase 1: Foundation Enhancement

**Q1 2024**

- [ ] Advanced statistics dashboard with interactive charts
- [ ] Push notification system for reminders
- [ ] Widget support for Android home screens
- [ ] Enhanced AI suggestions based on usage patterns
- [ ] Export/import functionality for data portability

### Phase 2: Backend Integration

**Q2 2024**

- [ ] Node.js REST API development
- [ ] MongoDB database implementation
- [ ] Real-time cloud synchronization
- [ ] Multi-device data consistency
- [ ] Automatic conflict resolution

### Phase 3: Platform Expansion

**Q3 2024**

- [ ] iOS application release
- [ ] macOS native application
- [ ] Linux desktop support
- [ ] Browser extensions for quick task capture
- [ ] Wear OS companion app

### Phase 4: Intelligence & Integration

**Q4 2024**

- [ ] Advanced machine learning for habit prediction
- [ ] Natural language processing for task creation
- [ ] Calendar integration (Google, Outlook, Apple)
- [ ] Voice commands and dictation
- [ ] Smart scheduling with time blocking

### Phase 5: Collaboration & Community

**2025**

- [ ] Team workspaces and shared tasks
- [ ] Collaborative habit challenges
- [ ] Public habit tracking profiles
- [ ] Achievement system with badges
- [ ] Community templates and best practices

### Long-term Innovations

- **Augmented Intelligence**: Predictive task prioritization using advanced ML models
- **Biometric Integration**: Stress level monitoring and adaptive scheduling
- **Cross-platform Ecosystem**: Seamless experience across all devices
- **Open API**: Third-party integrations and custom workflows
- **Blockchain**: Decentralized data storage option for maximum privacy

---

## Contributing

We welcome contributions from the community. Whether you're fixing bugs, improving documentation, or proposing new features, your input is valuable.

### How to Contribute

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/innovative-feature`)
3. **Commit** your changes (`git commit -m 'Add innovative feature'`)
4. **Push** to the branch (`git push origin feature/innovative-feature`)
5. **Open** a Pull Request with a comprehensive description

### Contribution Guidelines

- Follow the existing code style and architecture
- Write clear, concise commit messages
- Include unit tests for new functionality
- Update documentation as needed
- Ensure all tests pass before submitting
- Add screenshots for UI changes

### Code Review Process

All submissions require review before merging. We review for:

- Code quality and maintainability
- Test coverage and edge cases
- Performance implications
- Security considerations
- Documentation completeness

---

## Issue Reporting

### Bug Reports

When reporting bugs, please include:

- **Description**: Clear and concise description of the issue
- **Steps to Reproduce**: Detailed steps to recreate the problem
- **Expected Behavior**: What should happen
- **Actual Behavior**: What actually happens
- **Screenshots**: Visual evidence if applicable
- **Environment**: OS, Flutter version, device information
- **Logs**: Relevant error messages or stack traces

### Feature Requests

For feature suggestions, provide:

- **Use Case**: Why this feature would be valuable
- **Proposed Solution**: How you envision it working
- **Alternatives**: Other approaches you've considered
- **Mockups**: Visual representations if applicable

---

## Security

Security is paramount at DayFlow. We implement industry-standard security practices to protect user data.

### Reporting Security Vulnerabilities

If you discover a security vulnerability, please email security@dayflow.app instead of using the issue tracker. We will respond promptly and work with you to resolve the issue.

### Security Measures

- End-to-end encryption for sensitive data
- Secure authentication with Firebase
- Regular security audits
- Dependency vulnerability scanning
- Secure coding practices
- GDPR and CCPA compliance

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for complete details.

```
MIT License

Copyright (c) 2024 DayFlow Team

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
```

---

## Acknowledgments

### Development Team

**HOURI Abderrahmane** - Project Lead & Lead Developer & Core Developer  
Student at ENSIA ALGER

**Mohamed Al Amin Saàd** - Core Developer 
Student at ENSIA ALGER

**Lina Selma Ouadah** 
Student at ENSIA ALGER

### Technologies & Libraries

We are grateful to the following open-source projects and their maintainers:

- **Flutter Team** at Google for the amazing framework
- **Firebase** for authentication and backend services
- **FL Chart** contributors for excellent data visualization
- **Material Design** team for comprehensive design guidelines
- **Dart Community** for continuous language improvements

### Special Thanks

- ENSIA ALGER for academic support and resources
- Beta testers for valuable feedback and suggestions
- Open-source community for inspiration and knowledge sharing

---

## Contact & Support

<div align="center">

### Get in Touch

**Project Repository**: [github.com/Abderrahamane/DayFlow](https://github.com/Abderrahamane/DayFlow)

**Email**: contact@dayflow.app

**Documentation**: [docs.dayflow.app](https://docs.dayflow.app)

**Twitter**: [@DayFlowApp](https://twitter.com/dayflowapp)

---

### Support the Project

If you find DayFlow valuable, please consider:

- Starring the repository on GitHub
- Sharing the project with your network
- Contributing code or documentation
- Reporting bugs and suggesting features
- Providing feedback on your experience

---

**Built with precision and passion by the DayFlow Team**

*Empowering productivity, one day at a time*

[Back to Top](#dayflow)

</div>
