# Implementation Plan - Internship and Certificate Management App

A professional Flutter application for managing internships and certificates locally using SQLite, featuring a premium dark navy-blue theme and comprehensive CRUD operations.

## User Review Required

> [!IMPORTANT]
> **Database Persistence:** All data will be stored locally using `sqflite`. No cloud sync is included as per requirements.
> **Assets:** I will use standard Material icons and placeholder images where appropriate. You may need to provide specific illustration assets later.
> **State Management:** `Provider` will be used for efficient state handling across the app.

## Proposed Changes

### Core Infrastructure

#### [MODIFY] [pubspec.yaml](file:///C:/Users/Aleesha/Documents/GitHub/Aleesha-flutter/internship_and_certificate_manager_app/pubspec.yaml)
Add dependencies: `sqflite`, `path`, `intl`, `provider`, `google_fonts`, `font_awesome_flutter`, `image_picker`, `percent_indicator`.

#### [NEW] [database_helper.dart](file:///C:/Users/Aleesha/Documents/GitHub/Aleesha-flutter/internship_and_certificate_manager_app/lib/database/database_helper.dart)
Initialize SQLite with tables: `students`, `internships`, `companies`, `supervisors`, `certificates`, `internship_notes`, `favorites`.

### Data Models
[NEW] Define models in `lib/models/`:
- `Student`, `Internship`, `Company`, `Supervisor`, `Certificate`, `Note`.

### Services & State Management
[NEW] Implement repositories and providers in `lib/services/` and `lib/providers/`:
- `DatabaseService`: Generic CRUD logic.
- `AppProvider`: Main state for the application (loading data from SQLite).

### UI Components (Theme & Reusable Widgets)
#### [NEW] [app_theme.dart](file:///C:/Users/Aleesha/Documents/GitHub/Aleesha-flutter/internship_and_certificate_manager_app/lib/utils/app_theme.dart)
Define the requested color palette (#1A2332, #25344A, #30445C, etc.) and typography.

#### [NEW] Reusable Widgets in `lib/widgets/`:
- `CustomCard`, `StatusBadge`, `ProgressIndicator`, `CertificateCard`, `ActionDialog`.

### Screens Implementation

#### [NEW] Navigation & Onboarding:
- `SplashScreen`, `OnboardingScreen`, `MainNavigation` (Bottom Nav).

#### [NEW] Internship Module:
- `DashboardScreen`: Dynamic stats and overview.
- `InternshipListScreen`: Searchable/Filterable list.
- `InternshipDetailsScreen`: Details, progress, and notes.
- `AddEditInternshipScreen`: Form with validation.

#### [NEW] Certificate Module:
- `CertificateGalleryScreen`: Grid of certificates with search/filter.
- `CertificateDetailsScreen`: Full-screen view and favorites.
- `AddEditCertificateScreen`: Image picker and form.

#### [NEW] Profile & Settings:
- `ProfileScreen`: Student info, university info, skills.
- `SettingsScreen`: Basic app settings.

## Verification Plan

### Automated Tests
- Unit tests for Model serialization/deserialization.
- Database service tests for basic CRUD integrity.

### Manual Verification
- Verify database persistence after app restart.
- Test all filters and search bars for dynamic updates.
- Check validation on all forms (empty fields, date ranges).
- Confirm "Favorite" status updates UI immediately.
