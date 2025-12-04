## Task: Add a simple Sign-up / Login UI (UI + routing only)

This prompt instructs an LLM to add a simple Sign-up / Login screen to the Sandwich Shop Flutter app. The deliverable is UI and navigation wiring only — do NOT implement any real authentication, persistence, or external services.

Requirements
- Purpose: Create a lightweight sign-up/login page that collects email and password and navigates to the app homepage when the user taps the primary button.
- No authentication: Do not store credentials, call auth APIs, or write to local storage.
- Keep changes limited and focused: add a new view file and update routes and the order screen to navigate to it.

Files and routes (exact file paths to use)
- New screen file: `lib/views/login_screen.dart` (implement the UI here).
- Register route `'/login'` in `lib/main.dart` (add to the app's routes or onGenerateRoute map).
- Trigger navigation from `lib/views/order_screen.dart` by adding a bottom button that calls `Navigator.pushNamed(context, '/login')`.

UI & Behavior Details
- Screen scaffold
	- Use a `Scaffold` with `SafeArea` and a `SingleChildScrollView` body to avoid keyboard overflow.
	- Provide a simple, centred header area with the app logo (use `assets/images/logo.png` if available, otherwise `FlutterLogo` / `Icon(Icons.fastfood)` placeholder).
- Form
	- Use `Form` + `GlobalKey<FormState>`.
	- Fields: `TextFormField` for Email (`keyboardType: TextInputType.emailAddress`) and `TextFormField` for Password (`obscureText: true`).
	- Add minimal validation (non-empty; email contains `@` is enough).
	- Use `TextEditingController`s and dispose them in `StatefulWidget`'s `dispose()`.
- Actions
	- Primary button: `ElevatedButton` labelled `Sign Up` (or `Create Account`). When tapped, if the form validates, navigate to the homepage using `Navigator.pushReplacementNamed(context, '/')` (or whatever main route the app uses).
	- Secondary action: optional `TextButton` for "Already have an account? Sign in" — should be non-functional

Styling & Consistency
- Prefer existing project styles if present (e.g., `lib/views/app_styles.dart`); otherwise use Material defaults.
- Keep layout responsive and simple — padding, spacing, and full-width primary button.

Acceptance criteria (how to verify)
- From the running app's order screen, tapping the new bottom "Account / Sign Up" button opens `LoginScreen` at `'/login'`.
- `LoginScreen` displays logo, email and password fields, and a `Sign Up` button.
- Tapping `Sign Up` (with valid input) navigates to the app homepage (route `/`), and no credentials are saved or sent.

Implementation hints for the LLM
- Use `Navigator.pushNamed(context, '/login')` to open the login screen.
- Use `Navigator.pushReplacementNamed(context, '/')` to go to the homepage after sign-up.
- Keep imports minimal and null-safety compliant.
- Do not refactor unrelated files; only add `login_screen.dart`, update `main.dart` routes, and modify `order_screen.dart` to add the navigation button.

If you need clarification about the project's main route name, look for how the app sets `home` or which route the app uses as its entry page. Adapt the homepage route used in navigation accordingly.