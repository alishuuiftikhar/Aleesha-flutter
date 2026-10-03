# COMSATS FYP Portal — Mobile App (lib/)

This is a Flutter implementation of the COMSATS FYP Portal (Vehari Campus)
website (cuivehari.online), rebuilt as a mobile app with the same workflow:
Account Setup → Team & Workspace → Idea Selection → Supervisor Approval →
Milestone Submissions → Evaluation & Results.

## Structure

- `lib/core` — theme, constants, route table
- `lib/models` — User, ProjectIdea, Team, SupervisionRequest, Submission,
  Evaluation, Notification
- `lib/services` — data layer (currently backed by `MockDataService`, an
  in-memory dataset seeded with the real ideas/supervisors from the site).
  Swap the method bodies for HTTP calls to your real backend when ready.
- `lib/providers` — ChangeNotifier state management (Provider package)
- `lib/screens` — one folder per feature: auth, home (role-based
  dashboards), ideas, team, supervision, submissions, evaluation,
  notifications, profile, resources, help
- `lib/widgets` — shared/reusable UI components

## Role-based dashboards

The app adapts to the logged-in user's role (Student / Supervisor /
Evaluator / Sub Admin / Super Admin), matching the portal's stated user
groups.

## Getting it running

1. Create a new Flutter project: `flutter create fyp_portal_app`
2. Replace its generated `lib/` folder with this one, and merge the
   `pubspec.yaml` dependencies shown above into yours.
3. `flutter pub get`
4. `flutter run`

## Demo login

Any of the seeded emails logs in as that role (password is not checked
in the mock layer):
- `fa21-student@cuivehari.edu.pk` — Student
- `manzoor@cuivehari.edu.pk` — Supervisor
- `rabnawaz@cuivehari.edu.pk` — Evaluator
- `subadmin@cuivehari.edu.pk` / `superadmin@cuivehari.edu.pk` — Admin roles

## Next steps for production

- Replace `MockDataService` calls in `lib/services/*` with real API/HTTP
  calls (or Firebase/Supabase) and real institutional SSO.
- Add `file_picker` for real document uploads in
  `submission_upload_screen.dart`.
- Add push notifications (Firebase Cloud Messaging) wired to
  `NotificationProvider`.
