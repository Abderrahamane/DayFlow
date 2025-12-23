# DayFlow

**Smart Daily Planner & Habit Tracker**

![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?style=flat&logo=flutter&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-Cloud-FFCA28?style=flat&logo=firebase&logoColor=black)
![License](https://img.shields.io/badge/License-MIT-green.svg)

DayFlow is a modern productivity application designed to help you manage tasks, build positive habits, and track your progress. Built with Flutter and Firebase, it offers a seamless experience across devices with real-time synchronization.

---

## Key Features

- **Task Management**: Create, prioritize, and organize tasks with tags and subtasks.
- **Habit Tracking**: Build streaks, track completion rates, and visualize progress.
- **Smart Notes**: Quick note-taking with pinning and search capabilities.
- **Reminders**: Customizable notifications and recurring alerts.
- **Cloud Sync**: Real-time data synchronization via Google Firebase.
- **Personalization**: Dark/Light mode, custom themes, and multi-language support (English, French, Arabic).
- **Analytics**: Insightful statistics on your productivity and habits.

---

## Tech Stack

- **Framework**: Flutter (Dart)
- **Backend**: Firebase (Auth, Firestore, Storage)
- **State Management**: Bloc/Cubit
- **Analytics**: Mixpanel

---

## Getting Started

### Prerequisites
- Flutter SDK (3.0.0+)
- Git

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

3. **Firebase Setup**
   - Create a project in the [Firebase Console](https://console.firebase.google.com/).
   - Add Android/iOS apps and download the configuration files (`google-services.json` / `GoogleService-Info.plist`).
   - Place them in the respective `android/app` and `ios/Runner` directories.

4. **Run the App**
   ```bash
   flutter run
   ```

---

## Project Structure

```
DayFlow/
├── lib/
│   ├── main.dart            # Entry point
│   ├── models/              # Data models
│   ├── pages/               # UI Screens
│   ├── blocs/               # State Management
│   ├── services/            # API & Backend services
│   ├── theme/               # App Theme configuration
│   ├── utils/               # Constants & Helpers
│   └── widgets/             # Reusable components
└── ...
```

---

## Team

| Name | Role |
|------|------|
| **Abderrahmane Houri** | Team Leader & Flutter Developer |
| **Mohamed Al Amin Saàd** | Flutter Developer |
| **Lina Selma Ouadah** | Flutter Developer |

---

## Contributing

Contributions are welcome! Please follow these steps:
1. Fork the repository.
2. Create a feature branch (`git checkout -b feature/amazing-feature`).
3. Commit your changes (`git commit -m 'Add amazing feature'`).
4. Push to the branch (`git push origin feature/amazing-feature`).
5. Open a Pull Request.

---

## License

This project is licensed under the MIT License.
