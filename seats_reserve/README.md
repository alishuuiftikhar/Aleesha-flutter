# SeatSync – Software House Seat Management System

SeatSync is a professional, production-style Flutter mobile application for managing students, teachers/admins, available seats, daily seat reservations, attendance, fines, and reports in a software house environment.

## Features

- **Authentication**: Secure Login and Registration for Students and Admins.
- **Role-Based Access**: Distinct Student and Admin interfaces.
- **Seat Management**: Visual seat layout with real-time availability.
- **Reservation System**: Daily seat booking with deadline enforcement.
- **Attendance Tracking**: Admins can mark students as Present or Absent.
- **Fine Management**: Automatic fine generation for absences.
- **Admin Dashboard**: Comprehensive statistics and reports.
- **Student Approval**: Admin-controlled student registration approval.
- **Modern UI**: Material 3 design with Navy Blue theme.

## Tech Stack

- **Flutter**: Latest stable version.
- **Supabase**: Backend, Authentication, and PostgreSQL Database.
- **Provider**: State management.
- **Material 3**: Responsive UI components.

## Getting Started

### Prerequisites

- Flutter SDK installed.
- A Supabase project created.

### Supabase Setup

1.  **Database**: Execute the SQL provided in `supabase_schema.sql` in your Supabase SQL Editor.
2.  **Authentication**: Enable Email/Password authentication.
3.  **Storage**: (Optional) Create a `profiles` bucket for profile pictures.

### Application Configuration

1.  Open `lib/core/constants.dart`.
2.  Replace `YOUR_SUPABASE_URL` and `YOUR_SUPABASE_ANON_KEY` with your Supabase credentials.

### Installation

```bash
flutter pub get
flutter run
```

## Folder Structure

- `lib/core`: Constants and core utilities.
- `lib/models`: Data models for Profiles, Seats, Reservations, etc.
- `lib/services`: Supabase service for database interactions.
- `lib/providers`: State management using Provider.
- `lib/screens`: All UI screens (Auth, Student, Admin).
- `lib/widgets`: Reusable UI components.
- `lib/theme`: App theme and styling.


## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
