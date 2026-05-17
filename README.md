<<<<<<< HEAD
# InstaClinic

A modern Flutter web application for managing medical clinics and services.

## Features

- Admin Dashboard with statistics and request tracking
- Service Management System
  - Add, edit, and delete medical services
  - Categorize services (Main, Clinic, Extra)
  - Upload service images
  - Set pricing and duration
- User Authentication with Supabase
- Responsive Web Design

## Tech Stack

- Flutter Web
- GetX for State Management
- Supabase for Backend
- Image Picker Web for file uploads

## Getting Started

### Prerequisites

- Flutter SDK (latest version)
- Dart SDK
- Git

### Installation

1. Clone the repository
```bash
git clone https://github.com/yourusername/instaclinics.git
```

2. Navigate to project directory
```bash
cd instaclinics
```

3. Install dependencies
```bash
flutter pub get
```

4. Create a `.env` file in the root directory and add your Supabase credentials:
```
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
```

5. Run the application
```bash
flutter run -d chrome
```

## Project Structure

```
lib/
  ├── constants/
  │   └── app_colors.dart
  ├── controllers/
  │   ├── auth_controller.dart
  │   └── services_controller.dart
  ├── views/
  │   └── web/
  │       ├── dashboard_view.dart
  │       └── services_content.dart
  └── main.dart
```

## Contributing

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details
=======
# fristproject

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
>>>>>>> 93bf6bca16fdd4cb529e27395b8d54966be290c1
