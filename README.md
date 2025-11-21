# DayFlow - Smart Daily Planner 🧠

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)
![Firebase](https://img.shields.io/badge/Firebase-Cloud-orange.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

**A modern productivity app built with Flutter and Firebase**

Manage your tasks, build habits, take notes, and track your progress — with cloud sync, dark mode, and multilingual support.

[Features](#-features) • [Getting Started](#-quick-start) • [Documentation](#-documentation) • [Team](#-team)

</div>

---

## 🌟 Features

### 📝 Task Management
- Create, edit, and delete tasks
- Set priorities (none, low, medium, high)
- Add due dates and reminders
- Create subtasks for complex projects
- Filter and sort tasks (all, completed, pending, overdue, today)
- Tag tasks for organization

### 🎯 Habit Tracking
- Build positive habits through daily tracking
- Visual streak indicators
- Completion rate statistics
- Habit linking with task tags
- Customizable icons and colors
- Progress visualization

### 📒 Notes
- Quick note-taking
- Tag-based organization
- Pin important notes
- Search functionality
- Auto-save

### ⏰ Reminders
- Schedule notifications
- Recurring reminders
- Due date alerts
- Customizable notification settings

### 🎨 Personalization
- **Dark & Light Mode**: Easy on your eyes, day or night
- **Multi-Language Support**: English, French, Arabic (with RTL support)
- **Custom Themes**: Personalize your experience

### ☁️ Cloud Features
- **Real-time Sync**: Access your data on any device
- **Firebase Authentication**: Secure email/password and Google Sign-In
- **Cloud Firestore**: Automatic backup and sync
- **Offline Support**: Works without internet, syncs when connected

### 📊 Analytics & Insights
- Task completion statistics
- Habit streak tracking
- Progress visualization
- Productivity metrics

---

## 🚀 Quick Start

### Prerequisites

- **Flutter SDK** 3.0.0 or higher
- **Android Studio** or **VS Code** with Flutter extensions
- **Firebase Account** (free tier works)
- **Git** for version control

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Abderrahamane/DayFlow.git
   cd DayFlow
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up Firebase** (required for authentication and database)
   - Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Add Android/iOS apps to your Firebase project
   - Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Place them in the appropriate directories
   - Enable Email/Password and Google authentication
   - Create a Firestore database

4. **Run the app**
   ```bash
   flutter run
   ```

For detailed setup instructions, see [📘 Setup Guide](docs/SETUP_GUIDE.md)

---

## 📚 Documentation

Comprehensive documentation is available in the `docs/` folder:

### For Beginners
- **[🎯 Getting Started Guide](docs/GETTING_STARTED.md)** - Perfect for beginners, step-by-step learning path
- **[🚀 Setup Guide](docs/SETUP_GUIDE.md)** - Complete installation and configuration instructions

### For Developers
- **[🏗️ Architecture Guide](docs/ARCHITECTURE.md)** - High-level architecture, state management, database design
- **[📁 File Structure](docs/FILE_STRUCTURE.md)** - Detailed file-by-file documentation with code examples
- **[✨ Features Documentation](docs/FEATURES.md)** - Complete feature breakdown with implementation details
- **[✅ Requirements Verification](docs/REQUIREMENTS_VERIFICATION.md)** - Project requirements analysis and verification

### Quick Links
- [Understanding the Project Structure](#project-structure)
- [How State Management Works](docs/ARCHITECTURE.md#state-management)
- [Adding Your First Feature](docs/GETTING_STARTED.md#making-your-first-change)
- [Navigation Flow](docs/ARCHITECTURE.md#navigation-flow)
- [Localization System](docs/ARCHITECTURE.md#localization-system)

---

## 📂 Project Structure

```
DayFlow/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── models/                   # Data models (Task, Habit, Note)
│   ├── providers/                # State management (Provider pattern)
│   ├── services/                 # External APIs (Firebase, Mixpanel)
│   ├── pages/                    # App screens
│   │   ├── auth/                # Authentication screens
│   │   └── onboarding/          # Onboarding experience
│   ├── widgets/                  # Reusable UI components
│   ├── utils/                    # Helpers and utilities
│   └── theme/                    # App theming
├── docs/                         # Documentation
├── test/                         # Unit and widget tests
└── pubspec.yaml                  # Dependencies
```

For detailed explanation, see [📁 File Structure Documentation](docs/FILE_STRUCTURE.md)

---

## ⚙️ Tech Stack

### Frontend
- **Flutter** 3.0+ - UI framework
- **Dart** - Programming language
- **Provider** - State management
- **Material Design 3** - UI components

### Backend & Services
- **Firebase Authentication** - User management
- **Cloud Firestore** - NoSQL cloud database
- **Firebase Cloud Messaging** - Push notifications
- **Google Sign-In** - OAuth authentication
- **Mixpanel** - Analytics and user tracking

### Development Tools
- **Git** - Version control
- **VS Code / Android Studio** - IDEs
- **Flutter DevTools** - Debugging
- **Firebase Console** - Backend management

---

## 🎨 Key Features Showcase

### State Management (Provider Pattern)
```dart
// Clean, reactive state management
Consumer<TasksProvider>(
  builder: (context, provider, child) {
    return ListView.builder(
      itemCount: provider.tasks.length,
      itemBuilder: (context, index) {
        return TaskCard(task: provider.tasks[index]);
      },
    );
  },
)
```

### Multi-Language Support
```dart
// Easy localization
final l10n = AppLocalizations.of(context);
Text(l10n.welcome);  // "Welcome" / "Bienvenue" / "مرحبا"
```

### Firebase Integration
```dart
// Automatic cloud sync
await tasksProvider.addTask(newTask);  // Saves to Firestore automatically
```

---

## 👥 Team

| Name | Role | Responsibilities |
|------|------|------------------|
| **Abderrahmane Houri** | Team Leader & Flutter Developer | Architecture, Code Review, Documentation |
| **Mohamed Al Amin Saàd** | Flutter Developer | Backend Integration, Analytics |
| **Lina Selma Ouadah** | Flutter Developer | UI/UX, State Management |

---

## 🤝 Contributing

We welcome contributions from the team! Here's how to contribute:

1. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes**
   - Follow the existing code style
   - Add comments for complex logic
   - Test your changes thoroughly

3. **Commit and push**
   ```bash
   git add .
   git commit -m "Brief description of changes"
   git push origin feature/your-feature-name
   ```

4. **Create a Pull Request**
   - Go to GitHub and create a PR
   - Add a clear description of your changes
   - Request review from team leader

### Development Workflow
- Branch naming: `feature/<feature-name>`, `bugfix/<bug-name>`
- Main branches:
  - `main` → Production-ready code
  - `develop` → Development and testing
- All changes require code review
- Follow the team's coding standards

---

## 📱 Screenshots

_Coming soon - Screenshots will be added here_

---

## 🐛 Known Issues & Future Enhancements

### Known Issues
- None currently reported

### Planned Features
- [ ] Widget for home screen
- [ ] Calendar integration
- [ ] Voice input for tasks
- [ ] Social sharing
- [ ] Team collaboration
- [ ] Pomodoro timer
- [ ] Eisenhower matrix view

See [Features Documentation](docs/FEATURES.md) for complete roadmap.

---

## 📄 License

This project is developed as part of a university course.

---

## 📞 Support

**Need help?**
- 📖 Check the [Documentation](docs/)
- 🐛 [Report a bug](https://github.com/Abderrahamane/DayFlow/issues)
- 💬 Contact team leader: Abderrahmane Houri

---

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase for backend services
- All open-source contributors
- Course instructors for guidance

---

<div align="center">

**Made with ❤️ by the DayFlow Team**

[⬆ Back to top](#dayflow---smart-daily-planner-)

</div>
