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

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Reusable, Responsive App Drawer + Header — Requirements
Goal
Add a reusable, responsive navigation Drawer and matching Header to the Sandwich Shop Flutter app so users can open the app menu from every page and navigate to named routes. This is a UI-only change.

Scope & Constraints
UI-only: do NOT add backend, authentication, persistence, networking, or rework routing architecture.
Keep edits minimal: add a new header/drawer widget and wire it into main.dart and top-level Scaffolds only.
Use named-route navigation (Navigator.pushNamed / Navigator.pushReplacementNamed) only.
Code must be null-safety compatible and prefer styles from app_styles.dart if available.
Deliverables (files)
New file: lib/views/header.dart (or lib/views/app_header.dart) containing:
Header and/or AppDrawer (drawer widget and AppBar helper).
Small updates (integration):
main.dart — provide (or make available) route labels (Map<String, String>) for drawer items or reuse the existing routes map.
Top-level pages (example: order_screen.dart) — add appBar and drawer or persistent side-nav wiring.
Do NOT modify unrelated files.
User Stories
As a user, I can open the app navigation from any page via the AppBar on mobile (hamburger) or via a persistent side navigation on wide screens.
As a user, I can tap a menu item to navigate to the named route.
As a developer, I can pass a small route -> label map into the header/drawer if automatic route discovery is impractical.
Behavior & UX Requirements
Accessible from all pages:
Every page using Scaffold should expose the drawer via the AppBar hamburger icon on narrow screens.
Responsive:
Narrow screens (< 600 px): standard slide-in Drawer accessible from AppBar.
Wide screens (>= 600 px): persistent side navigation (e.g., NavigationRail or fixed column) visible alongside content; AppBar still present.
Route-driven items:
Drawer items correspond to named routes provided by main.dart (or a routeLabels map).
Each item shows an Icon + Text.
Current-route highlight:
Visually indicate the active route (use selected state or highlight style).
Navigation semantics:
Primary flows (e.g., home): Navigator.pushReplacementNamed(context, routeName).
Secondary flows: Navigator.pushNamed(context, routeName).
Accessibility:
Tappable areas at least 48×48, and provide semantic labels for screen readers.
API & Usage Suggestions
Example public API:
class Header extends StatelessWidget with:
static PreferredSizeWidget buildAppBar(BuildContext context) — returns an AppBar wired to open the drawer.
Widget buildDrawer(BuildContext context, {Map<String, String>? routeLabels}) — returns the drawer / side-nav.
Usage example:
Scaffold(appBar: Header.buildAppBar(context), drawer: Header.buildDrawer(context, routeLabels: {...}), body: ...)
If route discovery is impractical, accept a Map<String, String> that maps route names to user-facing labels.
Acceptance Criteria (testable)
From any page with a Scaffold, the drawer can be opened and menu items are visible.
Selecting a menu item navigates to the corresponding named route.
On narrow screens the drawer slides in; on wide screens a persistent side nav is visible.
The active route is highlighted in the drawer/side nav.
Only lib/views/header.dart plus small explicit edits in main.dart and top-level Scaffolds are present.
No authentication, persistence, or networking code is introduced.
Non-functional Constraints
Keep imports minimal and code idiomatic.
Prefer app_styles.dart for colors/spacing if present; otherwise use Material defaults.
Limit changes to the files listed above; do not refactor routing architecture.
Subtasks (developer checklist)
Create lib/views/header.dart with Header/AppDrawer and a configurable routeLabels parameter.
Update main.dart to provide a Map<String,String> of route -> label or expose routes for the drawer.
Add appBar and drawer (or persistent side navigation) to top-level pages, e.g., order_screen.dart.
Test navigation and responsive behavior at narrow and wide widths.
Ensure accessibility (touch target size, semantic labels) and selected-state highlighting.
Implementation Hints
Detect current route with: ModalRoute.of(context)?.settings.name.
Drawer item template:
ListTile(leading: Icon(...), title: Text(label), selected: ModalRoute.of(context)?.settings.name == routeName, onTap: () => Navigator.pushReplacementNamed(context, routeName))
Responsiveness:
Use LayoutBuilder or MediaQuery.of(context).size.width to switch between Drawer and NavigationRail/fixed column.
Keep the drawer self-contained and testable: AppDrawer(routeLabels: routeLabels) or Header(routeLabels: routeLabels).
Do / Don’t
Do: Keep the header/drawer modular, responsive, accessible, and style-consistent.
Don’t: Change the app routing architecture, add auth/persistence, or modify unrelated UI components.