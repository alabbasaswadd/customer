# Mikrotic Customer — Project Reference

> **Living document.** Updated after every development session. Always read this before starting work.

---

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [Tech Stack & Dependencies](#2-tech-stack--dependencies)
3. [Folder Structure](#3-folder-structure)
4. [Design System](#4-design-system)
   - 4.1 Color Palette
   - 4.2 Typography
   - 4.3 Spacing & Dimensions
   - 4.4 Border Radius
   - 4.5 Shadows
   - 4.6 Animations
5. [Component Library](#5-component-library)
6. [Architecture](#6-architecture)
   - 6.1 State Management (BLoC / Cubit)
   - 6.2 Dependency Injection (GetIt)
   - 6.3 API Layer
   - 6.4 Navigation (GoRouter)
   - 6.5 Localization
7. [Screen Inventory](#7-screen-inventory)
8. [Routes Reference](#8-routes-reference)
9. [Development Rules](#9-development-rules)
10. [Change Log](#10-change-log)

---

## 1. Project Overview

| Field | Value |
|---|---|
| **App Name** | Mikrotic Customer |
| **Package** | `mikrotic_customer` |
| **Version** | 1.0.0+1 |
| **Platform** | Flutter (Android · iOS · Windows) |
| **SDK** | Dart `^3.10.8` |
| **Default Locale** | Arabic (`ar`) — RTL |
| **Secondary Locale** | English (`en`) |
| **Purpose** | ISP customer portal — MikroTik router management, subscription tracking, wallet, support |

---

## 2. Tech Stack & Dependencies

### Core

| Package | Version | Role |
|---|---|---|
| `flutter_bloc` | ^9.0.0 | State management (Cubit pattern) |
| `get_it` | ^9.2.1 | Dependency injection (service locator) |
| `go_router` | ^17.1.0 | Declarative navigation |
| `dio` | ^5.7.0 | HTTP client |
| `retrofit` | ^4.9.2 | Type-safe API calls (code-gen) |
| `pretty_dio_logger` | ^1.4.0 | Network logging (dev) |
| `freezed_annotation` | ^3.0.0 | Immutable union types for states/results |
| `json_annotation` | ^4.9.0 | JSON serialization |
| `intl` | ^0.20.2 | Localization / date formatting |
| `shared_preferences` | ^2.3.3 | Local key-value persistence |
| `get` | ^4.6.5 | Used only in `AppAlertDialog` for `.tr` string translation |
| `adaptive_theme` | ^3.6.0 | Light/dark theme switching |
| `flutter_spinkit` | ^5.2.1 | Loading indicators |
| `permission_handler` | ^12.0.1 | Location permission (WiFi name) |
| `network_info_plus` | ^8.1.0 | WiFi network info |
| `flutter_internet_speed_test_pro` | ^1.5.1 | Speed test |
| `flutter_native_splash` | ^2.4.7 | Splash screen |
| `cached_network_image` | ^3.4.1 | Image caching |
| `local_auth` | ^3.0.0 | Biometric auth |
| `image_picker` | ^1.1.2 | Media selection |
| `flutter_screenutil` | ^5.9.3 | Screen-size utilities |

### Dev

| Package | Role |
|---|---|
| `build_runner` | Code generation runner |
| `freezed` | Union-type code-gen |
| `json_serializable` | JSON code-gen |
| `retrofit_generator` | API code-gen |
| `flutter_launcher_icons` | App icon generation |
| `flutter_lints` | Lint rules |

### Assets

```
assets/fonts/cairo/Cairo-Regular.ttf
assets/fonts/cairo/Cairo-Bold.ttf
assets/images/          ← all image assets
```

---

## 3. Folder Structure

```
lib/
├── main.dart                          ← App entry point
├── routes.dart                        ← GoRouter configuration (all routes)
├── theme.dart                         ← lightTheme + darkTheme
│
├── core/
│   ├── components/                    ← Reusable UI widgets
│   │   ├── app_button.dart            ← AppButton
│   │   ├── app_card.dart              ← AppCard (animated)
│   │   ├── app_text.dart              ← AppText + .medium/.semiBold/.bold
│   │   ├── app_text_form_field.dart   ← AppTextFormField
│   │   ├── custom_appbar.dart         ← CustomAppBar
│   │   ├── app_snackbar.dart          ← AppSnackbar
│   │   ├── app_alert_dialog.dart      ← AppAlertDialog
│   │   ├── app_animation.dart         ← AppAnimation
│   │   ├── app_bottom_sheet.dart
│   │   ├── app_drawer.dart
│   │   ├── app_indicator.dart
│   │   ├── custom_drop_down_button.dart
│   │   ├── custom_floating_action_button.dart
│   │   ├── my_icon.dart
│   │   ├── my_list_tile.dart
│   │   └── my_loading_widget.dart
│   │
│   ├── constants/
│   │   ├── colors.dart                ← AppColors (all color constants)
│   │   ├── api_routes.dart
│   │   ├── images.dart
│   │   ├── functions.dart
│   │   ├── handle_api.dart            ← (currently commented out)
│   │   ├── cached/
│   │   │   └── cached_helper.dart
│   │   └── model/
│   │       └── error_model.dart
│   │
│   ├── di/
│   │   └── dependency_injection.dart  ← GetIt registrations
│   │
│   └── networking/
│       ├── api_constans.dart          ← ApiConstants + ApiErrors
│       ├── api_error.dart
│       ├── api_error_handler.dart
│       ├── api_error_model.dart
│       ├── api_result.dart            ← ApiResult<T> (Success | Failure)
│       ├── api_service.dart
│       └── dio_factory.dart
│
├── l10n/
│   ├── app_localizations.dart         ← Abstract base + delegate
│   ├── app_localizations_ar.dart      ← Arabic strings
│   └── app_localizations_en.dart      ← English strings
│
└── pages/
    ├── auth/
    │   └── signin/
    │       ├── api/signin_api.dart
    │       ├── cubit/signin_cubit.dart + signin_state.dart
    │       ├── model/signin_model.dart + request + response
    │       └── screen/signin_screen.dart
    │
    ├── home/
    │   ├── api/home_api.dart           ← Mock API (getUserProfile, getPlans, submitComplaint)
    │   ├── cubit/
    │   │   ├── home_cubit.dart         ← HomeCubit → HomeState<UserModel>
    │   │   ├── home_state.dart
    │   │   ├── subscriptions_cubit.dart
    │   │   ├── subscriptions_state.dart
    │   │   ├── support_cubit.dart
    │   │   └── support_state.dart
    │   ├── model/
    │   │   ├── user_model.dart         ← UserModel + SubscriptionModel
    │   │   ├── subscription_plan_model.dart
    │   │   └── complaint_model.dart
    │   └── screen/
    │       ├── home_navigation.dart    ← Root scaffold + PageView + ModernBottomNav
    │       ├── tabs/
    │       │   ├── home_tab.dart       ← Dashboard tab
    │       │   ├── subscriptions_tab.dart
    │       │   ├── support_tab.dart
    │       │   └── settings_tab.dart
    │       └── widgets/
    │           ├── greeting_header.dart      ← Blue gradient header
    │           ├── subscription_card.dart    ← Countdown timer card
    │           ├── quick_actions_widget.dart ← 2×2 action grid + router security sheet
    │           ├── wallet_section_widget.dart ← Balance card + activity + quick actions ✨NEW
    │           ├── balance_card.dart
    │           ├── home_loading_widget.dart
    │           ├── home_error_widget.dart
    │           └── modern_bottom_nav.dart    ← Animated bottom navigation
    │
    └── features/
        ├── payment/
        │   └── screen/payment_screen.dart
        ├── speed_test/
        │   └── screen/speed_test_screen.dart
        ├── connected_devices/
        │   ├── api/connected_devices_api.dart  ← Real API + ARP fallback + mock
        │   ├── cubit/connected_devices_cubit.dart + state
        │   ├── model/device_model.dart + network_info + scan_result
        │   └── screen/connected_devices_screen.dart
        ├── invoice/                             ✨NEW
        │   └── screen/invoice_screen.dart       ← Activity logbook
        └── router_security/                     ✨NEW
            └── screen/
                ├── change_router_password_screen.dart
                └── router_reset_screen.dart
```

---

## 4. Design System

### 4.1 Color Palette

All colors live in `lib/core/constants/colors.dart` as `AppColors`.

#### Light Mode

| Token | Hex | Usage |
|---|---|---|
| `kPrimaryColor` | `#1565C0` | Primary actions, headers, active states |
| `kSecondColor` | `#1976D2` | Gradient second stop, secondary UI |
| `kThirtColor` | `#42A5F5` | Tertiary accents, highlights |
| `kFontColor` | `#0A192F` | Body text (deep navy, not pure black) |
| `kGreyColor` | `#4F4F4F` | Secondary text, subtitles, placeholders |
| `kWhiteColor` | `#FFFFFF` | Surfaces, on-primary text |
| `kBlackColor` | `#000000` | Absolute black |
| `kRedColor` | `Colors.red` | Errors, destructive actions, expired states |

#### Dark Mode

| Token | Hex | Usage |
|---|---|---|
| `kPrimaryColorDarkMode` | `#0D47A1` | Primary (dark) |
| `kSecondColorDarkMode` | `#1565C0` | Secondary (dark) |
| `kThirtColorDarkMode` | `#1E88E5` | Tertiary (dark) |
| Background | `#0A192F` | `scaffoldBackgroundColor` |
| Card | `kSecondColorDarkMode` | `cardColor` |

#### Semantic Colors (used in-code, not AppColors constants)

| Usage | Color |
|---|---|
| Online / success indicators | `Colors.green` |
| Wallet income | `Colors.green` |
| Wallet expenses / errors | `AppColors.kRedColor` |
| Invoice — transactions | `Colors.blue` |
| Invoice — password changes | `Colors.orange` |
| Invoice — resets | `Colors.purple` |
| Invoice — admin actions | `Colors.teal` |
| Router security / warning | `Colors.orange` |
| Destructive reset | `AppColors.kRedColor` |

#### Theme-Aware References (prefer these in widget code)

```dart
theme.colorScheme.primary        // adapts light/dark
theme.colorScheme.onSurface      // text color
theme.cardColor                  // card background
theme.scaffoldBackgroundColor    // page background
theme.shadowColor                // for BoxShadow
theme.colorScheme.outline        // borders
```

---

### 4.2 Typography

**Font Family:** `Cairo-Bold` (custom, loaded from assets)

All text goes through `AppText` widget — never use raw `Text()`.

```dart
// Default
AppText('text')                   // 16px, w700, Cairo-Bold
AppText('text', fontSize: 14)     // custom size
AppText('text', color: ...)       // color override

// Named constructors
AppText.medium('text')            // 14px, w500
AppText.semiBold('text')          // 16px, w600
AppText.bold('text')              // 18px, w700
```

#### Size Scale

| Role | Size | Weight |
|---|---|---|
| Page title / AppBar | 20–28 px | w700 |
| Section header | 18 px | w700 |
| Card title / label | 15–16 px | w600 |
| Body / description | 13–14 px | w400–w500 |
| Badge / meta | 10–12 px | w500–w600 |
| Large number (balance) | 36–38 px | w700 |
| Countdown digits | 24 px | w700 |

**Text defaults:** `maxLines: 1`, `overflow: TextOverflow.ellipsis`, `height: 1.5`  
Override with `maxLines: N` and `overflow: TextOverflow.visible` for multi-line.

---

### 4.3 Spacing & Dimensions

| Context | Value |
|---|---|
| Horizontal page padding | 20 px |
| Vertical gap between major sections | 24 px |
| Vertical gap between minor sections | 12–16 px |
| Card internal padding | 16–24 px |
| Icon container padding | 8–14 px |
| Bottom page margin | 32 px |
| Standard button height | 50–56 px |
| Bottom nav height | 70 px |
| Modal/bottom-sheet top handle | 40×4 px, 2 px radius |

---

### 4.4 Border Radius

| Component | Radius |
|---|---|
| Main cards | 16–20 px |
| Gradient header / hero cards | 20–24 px |
| Greeting header (bottom only) | 30 px |
| Buttons | 12–16 px |
| Icon containers (square) | 10–14 px |
| Badges / pills | 8–20 px |
| Filter tabs | 12 px |
| Bottom sheets (top only) | 24 px |
| Progress bar | 4–6 px |
| Input fields | 8 px |

---

### 4.5 Shadows

**Light mode card shadow:**
```dart
BoxShadow(
  color: theme.shadowColor.withOpacity(0.05–0.08),
  blurRadius: 10–15,
  offset: Offset(0, 4–5),
)
```

**Gradient card / hero shadow:**
```dart
BoxShadow(
  color: theme.colorScheme.primary.withOpacity(0.3),
  blurRadius: 15–20,
  offset: Offset(0, 8–10),
)
```

**Colored card shadow:**
```dart
BoxShadow(
  color: accentColor.withOpacity(0.15–0.3),
  blurRadius: 15,
  offset: Offset(0, 8),
)
```

---

### 4.6 Animations

| Pattern | Duration | Curve |
|---|---|---|
| Page entry (fade + slide) | 800 ms | `easeOut` / `easeOutCubic` |
| Staggered list items | 250 + index×80 ms | `easeOutCubic` |
| Success dialog scale | 700 ms | `easeOutBack` (0–0.5), `easeOut` (0.4–1.0) |
| Home tab staggered sections | 1200 ms total, Interval(start, end) | `easeOutCubic` |
| Quick action card press | 150 ms | `easeInOut` (scale 1→0.95) |
| Tab selection | 300 ms | `easeInOut` |
| Animated container transitions | 200 ms | `easeOut` |
| Bottom nav icon | 300 ms | various |
| Password strength bar | `AnimatedContainer` 200 ms | default |
| Reset progress bar | 5000 ms | `easeInOut` |
| Router icon rotation (loading) | 1200 ms repeat | — |

**Home tab animation intervals** (1200 ms total controller):

| Section | Interval |
|---|---|
| Header (GreetingHeader) | 0.0 → 0.3 |
| Balance (unused) | 0.2 → 0.5 |
| Subscription card | 0.35 → 0.6 |
| Wallet section ✨ | 0.5 → 0.78 |
| Quick actions | 0.68 → 1.0 |

---

## 5. Component Library

All components in `lib/core/components/`.

### AppText
```dart
AppText('Label', fontSize: 16, fontWeight: FontWeight.w700, color: ...,
    maxLines: 2, overflow: TextOverflow.visible, textAlign: TextAlign.center)
```

### AppButton
```dart
AppButton(
  text: 'Submit',
  onPressed: _submit,
  isLoading: _isLoading,       // shows CircularProgressIndicator
  icon: Icons.lock_rounded,    // optional leading icon
  color: AppColors.kPrimaryColor,
  height: 50,
  borderRadius: 12,
  padding: EdgeInsets.zero,    // outer padding; zero when width-controlled by parent
)
```
- Has built-in gradient (`color → Color.lerp(color, Black, 0.1)`)
- Ripple on tap: `white.withOpacity(0.2)`

### AppTextFormField
```dart
AppTextFormField(
  label: 'كلمة المرور',
  controller: _controller,
  obscureText: !_show,
  icon: Icons.lock_outline_rounded,
  suffixIcon: IconButton(...),
  validator: (val) => val!.isEmpty ? 'required' : null,
  onChanged: _onChanged,
  maxLines: 1,
  borderRadius: 8,
)
```
- Focus color: `AppColors.kPrimaryColor`
- Error color: `Colors.red`
- Label style: Cairo-Bold 12px w800

### AppCard
```dart
AppCard(
  onTap: () {},
  elevation: 4,
  borderRadius: BorderRadius.circular(16),
  padding: EdgeInsets.all(16),
  color: theme.cardColor,           // or gradient
  enableRippleEffect: true,
  enableAutoPulse: false,
  child: ...,
)
```

### Gradient Hero Card (pattern)
```dart
Container(
  padding: const EdgeInsets.all(20),
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(20),
    boxShadow: [BoxShadow(color: theme.colorScheme.primary.withOpacity(0.3),
        blurRadius: 15, offset: Offset(0, 8))],
  ),
)
```

### AppBar Pattern (transparent)
```dart
AppBar(
  backgroundColor: Colors.transparent,
  elevation: 0,
  leading: IconButton(
    icon: Icon(Icons.arrow_back_ios_rounded, color: theme.colorScheme.onSurface),
    onPressed: () => Navigator.pop(context),
  ),
  title: AppText('Title', fontSize: 20, fontWeight: FontWeight.w700,
      color: theme.colorScheme.onSurface),
  centerTitle: true,
)
```

### Bottom Sheet Pattern
```dart
showModalBottomSheet(
  context: context,
  backgroundColor: Colors.transparent,
  isScrollControlled: true,
  builder: (_) => Container(
    decoration: BoxDecoration(
      color: theme.scaffoldBackgroundColor,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
    ),
    padding: const EdgeInsets.all(24),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 40, height: 4,
            decoration: BoxDecoration(color: AppColors.kGreyColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2))),
        // content...
      ],
    ),
  ),
);
```

### Staggered List Animation (pattern)
```dart
TweenAnimationBuilder<double>(
  tween: Tween(begin: 0.0, end: 1.0),
  duration: Duration(milliseconds: 250 + (index * 80)),
  curve: Curves.easeOutCubic,
  builder: (context, value, child) {
    return Transform.translate(
      offset: Offset(0, 20 * (1 - value)),
      child: Opacity(opacity: value, child: child),
    );
  },
  child: YourWidget(),
)
```

---

## 6. Architecture

### 6.1 State Management (BLoC / Cubit)

Pattern: **Cubit** with **Freezed** union states.

```dart
// State definition
@freezed
class HomeState<T> with _$HomeState<T> {
  const factory HomeState.initial() = _Initial;
  const factory HomeState.loading() = Loading;
  const factory HomeState.success(T data) = Success<T>;
  const factory HomeState.error(String errorMessage) = Error;
}

// Cubit
class HomeCubit extends Cubit<HomeState<UserModel>> {
  HomeCubit(this.api) : super(const HomeState.initial());
  // ...
}

// UI consumption
BlocConsumer<HomeCubit, HomeState<UserModel>>(
  listener: (ctx, state) { state.maybeWhen(success: (_) {...}, orElse: () {}); },
  builder: (ctx, state) => state.when(
    initial: () => LoadingWidget(),
    loading: () => LoadingWidget(),
    success: (data) => ContentWidget(data),
    error: (msg) => ErrorWidget(msg),
  ),
)
```

**Registered Cubits:**

| Cubit | State | Purpose |
|---|---|---|
| `HomeCubit` | `HomeState<UserModel>` | User profile + balance |
| `SubscriptionsCubit` | `SubscriptionsState` | Subscription plans list |
| `SupportCubit` | `SupportState` | Complaint submission |
| `SigninCubit` | `SigninState` | Authentication |
| `ConnectedDevicesCubit` | `ConnectedDevicesState` | Network scan + device list |

---

### 6.2 Dependency Injection (GetIt)

File: `lib/core/di/dependency_injection.dart`

```dart
final getIt = GetIt.instance;

Future<void> initDI() async {
  // Singletons
  getIt.registerLazySingleton(() { /* Dio config */ });
  getIt.registerLazySingleton(() => SigninApi(getIt()));
  getIt.registerLazySingleton(() => HomeApi());
  getIt.registerLazySingleton(() => ConnectedDevicesApi());

  // Cubits (factories — new instance each time)
  getIt.registerFactory(() => SigninCubit(getIt()));
  getIt.registerFactory(() => HomeCubit(getIt()));
  getIt.registerFactory(() => SubscriptionsCubit(getIt()));
  getIt.registerFactory(() => SupportCubit(getIt()));
  getIt.registerFactory(() => ConnectedDevicesCubit(getIt()));
}
```

**Providing cubits in screens:**
```dart
BlocProvider(create: (context) => getIt<HomeCubit>())
// or in routes.dart for standalone screens:
BlocProvider(create: (context) => getIt<ConnectedDevicesCubit>()..loadNetworkInfo())
```

---

### 6.3 API Layer

**Base URL:** `http://network-isp-user-api.runasp.net/network-user-api`

**Result wrapper (Freezed):**
```dart
@freezed
class ApiResult<T> with _$ApiResult<T> {
  const factory ApiResult.success(T data) = Success<T>;
  const factory ApiResult.failure(ErrorModel error) = Failure<T>;
}
```

**Endpoints defined in `ApiConstants`:**

| Constant | Path |
|---|---|
| `login` | `/user-api/Account/SignIn` |
| `signup` | `/user-api/Account/SignUp` |
| `connectedDevices` | `/user-api/Network/ConnectedDevices` |
| `dhcpLeases` | `/user-api/Network/DhcpLeases` |

**API status:** Most APIs use mock data (`HomeApi`, `SupportCubit`). `ConnectedDevicesApi` calls real endpoint with ARP fallback + mock devices.

---

### 6.4 Navigation (GoRouter)

File: `lib/routes.dart`

| Path | Screen | BlocProvider |
|---|---|---|
| `/` | `HomeNavigation` | — (MultiBlocProvider inside) |
| `/signin` | `SigninScreen` | `SigninCubit` |
| `/speed-test` | `SpeedTestScreen` | — |
| `/connected-devices` | `ConnectedDevicesScreen` | `ConnectedDevicesCubit` |
| `/payment` | `PaymentScreen` | — |
| `/invoice` | `InvoiceScreen` | — ✨NEW |
| `/change-router-password` | `ChangeRouterPasswordScreen` | — ✨NEW |
| `/router-reset` | `RouterResetScreen` | — ✨NEW |

**Navigation calls:**
```dart
context.push('/route-name')    // push (back button returns)
context.go('/route-name')      // replace stack
Navigator.pop(context)         // back from modal/dialog
```

---

### 6.5 Localization

**System:** Flutter gen-l10n (ARB-based)  
**Files:** `lib/l10n/app_localizations_ar.dart` + `app_localizations_en.dart`  
**Access:** `AppLocalizations.of(context)!` — always non-null after setup

**Usage:**
```dart
final t = AppLocalizations.of(context)!;
AppText(t.subscription_active)
```

**Adding new strings:** Add abstract getter to `app_localizations.dart`, then implement in both `_ar.dart` and `_en.dart`.

---

## 7. Screen Inventory

### Bottom-Tab Screens (HomeNavigation)

| Index | Tab | File |
|---|---|---|
| 0 | Home | `home_tab.dart` |
| 1 | Subscriptions | `subscriptions_tab.dart` |
| 2 | Support | `support_tab.dart` |
| 3 | Settings | `settings_tab.dart` |

### Home Tab Widget Stack (top → bottom)

```
GreetingHeader          ← gradient header, balance display, notification bell
SizedBox(24)
SubscriptionCard        ← countdown timer, speed badge, renew button
SizedBox(24)
WalletSectionWidget  ✨ ← balance card, income/expenses, recent activity, quick actions
SizedBox(24)
QuickActionsWidget      ← 2×2 grid: Devices, Speed Test, Invoices, Router Security
SizedBox(32)
```

### Feature Screens

| Screen | Route | Description |
|---|---|---|
| `PaymentScreen` | `/payment` | Wallet top-up, payment method selection |
| `SpeedTestScreen` | `/speed-test` | Download/upload gauge with custom painter |
| `ConnectedDevicesScreen` | `/connected-devices` | Network scan, device cards, filter tabs |
| `InvoiceScreen` ✨ | `/invoice` | Activity logbook with search, filters, expandable entries |
| `ChangeRouterPasswordScreen` ✨ | `/change-router-password` | Password change with strength meter |
| `RouterResetScreen` ✨ | `/router-reset` | Soft/factory reset with progress state machine |
| `SigninScreen` | `/signin` | Login with animation |

---

### InvoiceScreen — Detail

- **Summary banner:** Gradient card with Total Records / This Month / Successful counts
- **Search bar:** Live filtering across title, subtitle, detail fields
- **Filter tabs:** All · المالية · كلمة المرور · إعادة الضبط · إدارية
- **Log entry card:** Icon, title, relative date, category badge, success/fail badge, expandable detail panel
- **Entry types:** `transaction` (blue) · `passwordChange` (orange) · `reset` (purple) · `admin` (teal)
- **Data:** Mock entries (10 items) — no API endpoint yet
- **Animations:** Staggered slide-up (250 + index×80 ms), `AnimatedCrossFade` expand

### ChangeRouterPasswordScreen — Detail

- Fade + slide-up entry (800 ms)
- Orange gradient header card
- Current / New / Confirm password fields (show/hide toggle on each)
- Live password strength: 4-segment bar (Weak/Fair/Strong/Very Strong)
  - Score algorithm: length≥8 (+1), length≥12 (+1), uppercase (+1), digit (+1), special char (+1)
- Requirements info card (primary-tinted)
- `AppButton` with loading spinner
- Animated result dialog (scale easeOutBack + icon pop): green ✓ / red ✗

### RouterResetScreen — Detail

- **Idle state:** Warning red gradient banner + two selectable option cards
  - Soft Reset (blue) — reversible
  - Factory Reset (red) — with "cannot undo" warning chip
- **Confirm dialog:** Different copy for factory vs soft; factory adds red warning box
- **Loading state:** Rotating router icon + `LinearProgressIndicator` (5 s animated)
- **Result state:** Animated scale-in icon + success/fail text + back/retry buttons
- State machine: `idle → confirming → loading → success | failed`

### WalletSectionWidget — Detail

- Balance card: primary gradient, wallet icon, "active" green dot pill, large balance figure + EGP
- Summary row: income (green ↓) + expenses (red ↑) side-by-side cards
- Recent activity: 3 preview items with "View All" → `/invoice`
- Quick actions: Add Funds → `/payment` · Transfer (placeholder) · History → `/invoice`

---

## 8. Routes Reference

```dart
// routes.dart — complete list
GoRoute(path: '/',                     HomeNavigation)
GoRoute(path: '/signin',               SigninScreen + SigninCubit)
GoRoute(path: '/speed-test',           SpeedTestScreen)
GoRoute(path: '/connected-devices',    ConnectedDevicesScreen + ConnectedDevicesCubit)
GoRoute(path: '/payment',              PaymentScreen)
GoRoute(path: '/invoice',              InvoiceScreen)                       ✨
GoRoute(path: '/change-router-password', ChangeRouterPasswordScreen)       ✨
GoRoute(path: '/router-reset',         RouterResetScreen)                  ✨
```

---

## 9. Development Rules

### Mandatory

1. **Always use `AppText`** — never raw `Text()` widget.
2. **Always use `AppTextFormField`** — never raw `TextFormField` directly.
3. **AppBar pattern** — always transparent, back arrow `arrow_back_ios_rounded`, centered `AppText` title.
4. **Colors** — always reference `AppColors.*` or `theme.colorScheme.*`; no hardcoded hex in widgets.
5. **New routes** — must be added to `lib/routes.dart`.
6. **New Cubits** — must be registered in `lib/core/di/dependency_injection.dart`.
7. **New localization strings** — add abstract getter in `app_localizations.dart` AND implement in both `_ar.dart` and `_en.dart`.
8. **Staggered animations** — new list screens use `TweenAnimationBuilder` with `duration: Duration(milliseconds: 250 + index * 80)`.
9. **Entry animations** — new feature screens (non-tab) use `FadeTransition` + `SlideTransition` (800 ms, easeOutCubic).

### Forbidden

- Do not use `withOpacity()` on new code — use `.withValues(alpha: ...)` (but existing code uses `withOpacity`; don't refactor unless explicitly asked).
- Do not use `textScaleFactor` — deprecated; omit or use `textScaler`.
- Do not hardcode strings in Arabic/English directly in UI — use localization keys.
- Do not define global `GetX` dependencies (`.Get.put`) — use GetIt only.
- Do not use `Navigator.push()` for routes defined in GoRouter — use `context.push()`.
- Do not create `StatefulWidget` where `StatelessWidget` suffices.
- Do not add comments that explain what the code does (names should do that); only add comments for non-obvious WHY.

### Naming Conventions

| Thing | Convention | Example |
|---|---|---|
| Files | `snake_case.dart` | `invoice_screen.dart` |
| Classes | `PascalCase` | `InvoiceScreen` |
| Private widgets | `_PascalCase` | `_LogEntryCard` |
| Private methods/vars | `_camelCase` | `_buildHeaderCard` |
| Private top-level fns | `_camelCase` | `_showRouterSecuritySheet` |
| Route paths | `/kebab-case` | `/change-router-password` |
| Cubit states | `ClassName.stateType()` | `HomeState.success(data)` |

### File Organization per Screen

```
pages/features/<feature>/
  screen/
    <feature>_screen.dart     ← main screen widget
  cubit/
    <feature>_cubit.dart
    <feature>_state.dart
  api/
    <feature>_api.dart
  model/
    <feature>_model.dart
```

---

## 10. Change Log

### Session 2 — 2026-05-11

**Prompt:** Add Invoice/Logbook screen, Wallet information section on homepage, Router Security management interfaces (Change Password + Reset).

#### New Files Created

| File | Description |
|---|---|
| `lib/pages/features/invoice/screen/invoice_screen.dart` | Activity logbook with search, filter tabs, expandable entries, summary stats |
| `lib/pages/features/router_security/screen/change_router_password_screen.dart` | Password change form with strength meter and animated result dialog |
| `lib/pages/features/router_security/screen/router_reset_screen.dart` | Soft/factory reset with confirmation dialog, progress animation, result screen |
| `lib/pages/home/screen/widgets/wallet_section_widget.dart` | Balance card, income/expenses summary, recent activity preview, quick action buttons |

#### Modified Files

| File | Change |
|---|---|
| `lib/routes.dart` | Added `/invoice`, `/change-router-password`, `/router-reset` |
| `lib/pages/home/screen/tabs/home_tab.dart` | Added `_walletAnimation` + `WalletSectionWidget` between subscription card and quick actions; removed unused `balance_card` import |
| `lib/pages/home/screen/widgets/quick_actions_widget.dart` | Invoices card → `/invoice`; 4th card changed to Router Security (opens bottom sheet with sub-options); added `_showRouterSecuritySheet()` top-level function + `_SecurityOptionTile` widget |

#### Verified

- `flutter analyze` — 0 errors, 0 new warnings (existing project warnings unchanged)
- `flutter pub get` — success

---

### Session 1 — Initial Build

Pre-existing screens and infrastructure (not built in documented sessions):

- Sign in screen with animations
- Home navigation (4-tab PageView + ModernBottomNav)
- Home tab (greeting header, subscription countdown, quick actions)
- Subscriptions tab (plan list + bottom sheet)
- Support tab (complaint form)
- Settings tab (grouped list)
- Connected devices screen (network scan, ARP fallback, device cards)
- Speed test screen (custom gauge painter)
- Payment screen (method selection, amount input, success dialog)
- Core component library (AppText, AppButton, AppCard, AppTextFormField, etc.)
- BLoC/Cubit architecture with Freezed
- GoRouter navigation
- Arabic/English localization
- Light/dark theme
