# CTS Scorecard Application

A Flutter-based mobile application for managing and tracking scorecards, platform returns, chemical tools, and penalties for CTS (Crop Technology Services).

## 🚀 Project Setup

### Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK (included with Flutter)
- Android Studio / Xcode (for emulator/simulator)
- VS Code or Android Studio (recommended for development)

### Installation
1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd cts_scorecard
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## ✨ Key Features

- **Scorecard Management**
  - Create and submit scorecards with multiple sections
  - Score input with validation
  - Save drafts of in-progress scorecards

- **Platform Returns**
  - Submit platform return forms
  - Track return status
  - Historical data viewing

- **Chemical Tools**
  - Manage chemical tool inventory
  - Track tool usage and maintenance

- **Penalty System**
  - Record and manage penalties
  - Generate penalty reports
  - Track penalty status

- **Data Export**
  - Generate PDF reports
  - Export data for analysis

## 🏗️ Technical Implementation

- **State Management**: Provider pattern for efficient state management
- **Form Handling**: flutter_form_builder for complex form validations
- **Local Storage**: SharedPreferences for offline data persistence
- **PDF Generation**: pdf and printing packages for report generation
- **Responsive Design**: Works on both mobile and tablet devices

## ⚠️ Assumptions & Limitations

### Assumptions
1. Users have a stable internet connection for data synchronization
2. All required form fields are filled before submission
3. Data validation happens both client and server-side
4. Users have basic knowledge of using mobile applications

### Known Limitations
1. **Offline Support**: Limited offline functionality; requires internet for data sync
2. **File Size**: Large PDF reports may take time to generate on low-end devices
3. **Platform Support**: Primarily tested on Android/iOS; limited testing on web/desktop
4. **Data Retention**: Local data might be cleared if app is uninstalled

## 📝 License

This project is licensed under the [MIT License](LICENSE).

## 🤝 Contributing

Contributions are welcome! Please read our contributing guidelines before submitting pull requests.
