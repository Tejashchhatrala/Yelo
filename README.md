# YELO - Community Opportunity Feed

YELO is a Flutter-based mobile application that connects people with local opportunities. It's a community-driven platform where users can discover and engage with events, projects, and other opportunities happening around them.

## 🌟 Features

- **Local Opportunity Feed**: A dynamic, image-rich feed of opportunities, styled like a modern social media app.
- **Firebase Authentication**: Secure sign-up and login with email and phone number.
- **Interactive Cards**: Like and bookmark opportunities that interest you.
- **User Profiles**: View your profile, and see lists of opportunities you've liked and bookmarked.
- **Commenting**: Engage in discussions on each opportunity with threaded comments.
- **Real-time Updates**: The feed and comments update in real-time, powered by Firestore.

## 📱 Screenshots

*Screenshots will be added here once the new UI is complete.*

## 🛠️ Tech Stack

- **Frontend**: Flutter
- **Backend**: Firebase
- **Database**: Cloud Firestore
- **Authentication**: Firebase Auth
- **Storage**: Firebase Cloud Storage

## 🚀 Getting Started

### Prerequisites

- Flutter (3.x or later)
- Dart SDK
- Android Studio / VS Code
- Firebase CLI
- Git

### Installation Steps

1. Clone the repository
```bash
git clone https://github.com/yourusername/yelo.git
cd yelo
```

2. Install dependencies
```bash
flutter pub get
```

3. Configure Firebase
   - Create a new Firebase project at [Firebase Console](https://console.firebase.google.com)
   - Enable required services:
     - Authentication (with Email/Password and Phone providers)
     - Cloud Firestore
     - Cloud Storage
   - Download configuration files:
     - Add `google-services.json` to `android/app/`
     - Add `GoogleService-Info.plist` to `ios/Runner/`

4. Run the application
```bash
flutter run
```

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Contributing Guidelines

- Follow the established code style and organization
- Write meaningful commit messages
- Include comments and documentation for new features
- Add tests for new functionality
- Update README.md with details of significant changes

## 📄 License

This project is licensed under the MIT License.
