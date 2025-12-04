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

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Add a reusable, responsive App Drawer + Header (LLM prompt)
Goal
Add a reusable, responsive navigation Drawer and matching header to the Sandwich Shop Flutter app so users can open the app menu from every page and navigate to any named route. Keep changes small and UI-only.

Scope & constraints
UI-only: No backend, auth, persistence, networking, or route architecture refactor.
Keep edits minimal: add a new header/drawer widget and wire it into main.dart and top-level Scaffolds only.
Null-safety compatible and prefer existing styles in app_styles.dart where available.
Use named-route navigation (Navigator.pushNamed / Navigator.pushReplacementNamed) only.
Deliverables (exact files)
New widget file: lib/views/header.dart (or lib/views/app_header.dart) implementing:
Header (AppBar helper) and/or AppDrawer (Drawer widget / side nav).
Integration updates (small edits):
main.dart — pass a route -> label map or use existing routes map when building the drawer.
Top-level pages (e.g., order_screen.dart) — add appBar/drawer entries to use the new Header/AppDrawer.
Do NOT modify unrelated files.
Behavior & UX requirements
Accessible from all pages:
Every page with a Scaffold should show the drawer via the AppBar hamburger icon on narrow screens.
Responsive:
Narrow screens (< 600 px): standard slide-in Drawer opened by AppBar.
Wide screens (>= 600 px): show a persistent side navigation (NavigationRail or fixed column) and still provide an AppBar.
Route-driven menu:
Drawer shows items for the app’s named routes. Labels can be derived or provided via a small Map<String, String> routeLabels.
Each menu item: Icon + Text and onTap navigates to the route.
Navigation semantics:
For primary flows (home), prefer Navigator.pushReplacementNamed(context, routeName).
For other pages, Navigator.pushNamed(context, routeName) is acceptable.
Visual consistency:
Use app_styles.dart if present; otherwise, follow Material defaults.
Accessibility:
Tappable areas >= 48x48, semantic labels for screen readers.
Current route highlight:
Indicate which route is active (use selected: true or highlight style).
API & usage suggestions
Public API example:
class Header extends StatelessWidget with:
static PreferredSizeWidget appBar(BuildContext context) or Header.appBar(context).
Widget buildDrawer(BuildContext context, {Map<String,String>? routeLabels}).
Or:
class AppHeader extends StatelessWidget { final Map<String,String>? routeLabels; const AppHeader({this.routeLabels}); }
Use: Scaffold(appBar: AppHeader.appBar(context), drawer: AppHeader.drawer(context, routeLabels: {...}), body: ...)
Route labels:
If automatic discovery of routes map is impractical, accept a routeLabels map passed from main.dart.
Implementation hints
Build items from a Map<String, String> where key = route name and value = label:
Example item widget: ListTile(leading: Icon(...), title: Text(label), selected: ModalRoute.of(context)?.settings.name == routeName, onTap: () { Navigator.pushReplacementNamed(context, routeName); })
Responsiveness:
Use LayoutBuilder or MediaQuery.of(context).size.width to switch between Drawer and a persistent side nav (NavigationRail or a Container column).
Keep the drawer self-contained and testable:
AppDrawer(routeLabels: routeLabels) or Header(routeLabels: routeLabels).
Highlight current route with ModalRoute.of(context)?.settings.name.
Prefer pushReplacementNamed for home navigation so the drawer selection doesn't stack duplicates.
Acceptance criteria (testable)
From any page, opening the drawer and selecting a menu item navigates to the named route.
On small screens the drawer is a slide-in menu; on wide screens the side nav is persistently visible.
The active route is visually highlighted.
Only the new lib/views/header.dart and small, explicit edits in main.dart and top-level Scaffolds are present.
No backend/auth/persistence code was added.
Do / Don't
Do: Keep header/drawer modular, responsive, and style-consistent.
Don’t: Rewrite routing architecture, add auth/persistence, or change unrelated UI components.