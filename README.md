# TutCare - Patient Appointments

A Flutter application built as part of the **TutWonders Flutter Technical Task**. The application integrates with the provided backend APIs to allow patients to authenticate, view their appointments, manage them, and book new appointments.

The project was developed using the latest stable version of Flutter and the latest compatible package versions, with **Visual Studio Code** as the primary development environment.

---

# Features

### Authentication
- Secure patient login.
- Authentication token stored securely using **Flutter Secure Storage**.
- Automatic token attachment for authenticated API requests using Dio Interceptors.

### Appointments
- Display all appointments for the logged-in patient.
- Appointment details screen.
- Pull-to-refresh support.
- Local caching of appointments for a better user experience.
- Bottom sheet form for booking new appointments.

### Networking
- REST API integration using Dio.
- Secure authentication.
- Error handling.
- Internet connection checking.

---

# Architecture

The project follows **Clean Architecture** principles to separate responsibilities between layers.

```
lib/
│
├── core/
│   ├── api/
│   ├── cache/
│   ├── errors/
│   ├── network/
│   └── services/
│
├── features/
│   ├── authentication/
│   └── appointments/
│
└── main.dart
```

The application uses **BLoC (flutter_bloc)** for state management to provide a predictable and maintainable architecture.

---

# Technologies Used

- Flutter (Latest Stable Version)
- Dart
- Visual Studio Code
- Dio
- Flutter Bloc
- Dartz
- Flutter Secure Storage
- Internet Connection Checker Plus
- Intl

---

# Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter

  dartz: ^0.10.1
  flutter_bloc: ^9.1.1
  intl: ^0.20.3
  dio: ^5.10.0
  flutter_secure_storage: ^9.2.4
  internet_connection_checker_plus: ^2.9.0
```

---

# Getting Started

## 1. Install Flutter

Download Flutter from the official website:

https://flutter.dev/docs/get-started/install

Verify the installation:

```bash
flutter doctor
```

Make sure all required dependencies are installed.

---

## 2. Clone the Repository

```bash
git clone https://github.com/danielemad/TutTask.git
```

Navigate to the project directory:

```bash
cd your-repository
```

---

## 3. Install Packages

```bash
flutter pub get
```

---

## 4. Run the Application

```bash
flutter run
```

If multiple devices are connected:

```bash
flutter devices
```

Then run:

```bash
flutter run -d <device-id>
```

---

# Project Requirements

- Flutter (Latest Stable Version)
- Dart SDK
- Android Studio or Visual Studio Code
- Android SDK or iOS SDK (depending on the target platform)

---

# State Management

The application uses **flutter_bloc** for state management.

Business logic is separated from the presentation layer to keep the UI clean and maintainable.

---

# Networking

Networking is implemented using **Dio**.

Features include:

- API Client
- Dio Interceptors
- Secure Authorization Header
- Error Handling
- Timeout Handling

---

# Local Storage

Sensitive data such as authentication tokens are stored securely using **Flutter Secure Storage**.

Appointments are cached locally to improve the user experience.

---

# Error Handling

The application handles:

- Network failures
- API errors
- Unauthorized requests
- Invalid responses
- Connection availability

---

# Current Implementation

The current implementation includes:

- Patient Login
- Appointment List
- Appointment Details Screen
- Pull-to-Refresh
- Book Appointment Bottom Sheet
- Local Appointment Caching
- Secure Authentication Token Storage

---

# Development Environment

The project was developed using:

- Flutter (Latest Stable Release)
- Dart (Latest Stable Version)
- Visual Studio Code
- Latest compatible package versions

---

# Future Improvements

The following features can be added in future versions:

- Appointment cancellation
- Optimistic UI updates
- Offline mode improvements
- Unit testing
- Widget testing
- Dark mode
- Responsive tablet layouts

---

# Author

Developed as part of the TutWonders Flutter Technical Assessment.