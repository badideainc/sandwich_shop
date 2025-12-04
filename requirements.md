Sign-up / Login UI (UI + routing only) Requirements

1. Feature Description and Purpose

    Implement a simple Sign-up / Login screen for the Sandwich Shop app. This is a UI-only feature: collect email and password, validate basic input, and navigate to the app homepage. Do NOT implement authentication, persistence, or any external API calls.

2. User Stories

2.1. Access the Sign-up Screen

    - As a user, I can open the Sign-up screen from the Order screen by tapping an "Account / Sign Up" button.
    - As a developer, I must register the route `'/login'` so the app can navigate by name.

2.2. Fill and Submit Form

    - As a user, I can enter my email and password into clearly labelled fields.
    - As a user, I can submit the form by tapping a prominent "Sign Up" button.
    - As a developer, the form performs minimal validation (non-empty fields; email contains `@`) and uses `Form` + `GlobalKey<FormState>`.

2.3. Post-Submit Navigation

    - As a user, when I submit valid input, I am taken to the app homepage (replace the current route).
    - As a developer, navigate using `Navigator.pushReplacementNamed(context, '/')` or the app's main route.

3. Acceptance Criteria

    - `lib/views/login_screen.dart` exists and implements the UI for the Sign-up screen.
    - `lib/main.dart` registers the `'/login'` route (in `routes` or `onGenerateRoute`).
    - `lib/views/order_screen.dart` has a visible bottom button that calls `Navigator.pushNamed(context, '/login')`.
    - The Sign-up screen includes:
      - A `Scaffold` with `SafeArea` and `SingleChildScrollView`.
      - App logo (use `assets/images/logo.png` or `FlutterLogo` placeholder).
      - `TextFormField` for Email with `keyboardType: TextInputType.emailAddress`.
      - `TextFormField` for Password with `obscureText: true`.
      - `TextEditingController`s for each field and proper `dispose()` handling.
      - A primary `ElevatedButton` labeled "Sign Up" that validates the form and navigates to the homepage.
      - Optional secondary `TextButton` like "Already have an account? Sign in" (may be non-functional).
    - No credentials are persisted or sent; no auth libraries are added.

4. Non-functional Constraints

    - Keep code null-safety compliant and minimal in imports.
    - Prefer existing styles (e.g., `lib/views/app_styles.dart`) when present; otherwise use Material defaults.
    - Limit changes to the three files: `lib/views/login_screen.dart`, `lib/main.dart`, and `lib/views/order_screen.dart`.

5. Subtasks (developer checklist)

    - Create `lib/views/login_screen.dart` implementing the described UI and behavior.
    - Update `lib/main.dart` to register `'/login'` (or add to `onGenerateRoute`).
    - Add a bottom button in `lib/views/order_screen.dart` that calls `Navigator.pushNamed(context, '/login')`.
    - Verify that tapping "Sign Up" with valid input navigates to the homepage (`'/'`).
    - Ensure controllers are disposed and the form uses `GlobalKey<FormState>`.

6. Notes / Implementation Hints

    - Use `SingleChildScrollView` + `Padding` to avoid keyboard overflow.
    - Use `Navigator.pushNamed(context, '/login')` for opening the login screen.
    - Use `Navigator.pushReplacementNamed(context, '/')` to go to the homepage after sign-up.
    - The secondary action (Sign in) can be left non-functional for now.
