# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# Run the app
flutter run

# Analyze / lint
flutter analyze

# Tests
flutter test

# Code generation (Freezed, Retrofit, json_serializable) — run after modifying annotated files
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode for code generation
flutter pub run build_runner watch --delete-conflicting-outputs

# Build releases
flutter build apk --release
flutter build ios --release
```

**Code generation is required** whenever you modify files annotated with `@freezed`, `@JsonSerializable`, or `@RestApi`. Generated files end in `.g.dart` and `.freezed.dart` — never edit them manually.

Shorebird is configured (`shorebird.yaml`) for OTA patch releases.

## Architecture

This is a Flutter ISP customer portal for MikroTik router management, using a layered architecture: **UI → Cubit → API wrapper → Retrofit service → Dio**.

### State Management: BLoC/Cubit + Freezed

Every feature uses Cubit (not full BLoC) with Freezed union states:

```
feature/
├── cubit/
│   ├── feature_cubit.dart      # extends Cubit<FeatureState>, injected via GetIt
│   └── feature_state.dart      # @freezed union: initial | loading | success(data) | error(msg)
```

States are always immutable Freezed unions. Call `emit(FeatureState.loading())`, `emit(FeatureState.success(data))`, etc.

### Routing: GoRouter

All routes are declared in `lib/routes.dart`. Routes that need a Cubit wrap it with `BlocProvider` in the route builder. Use `context.go('/path')` and `context.push('/path')` for navigation. The 12 routes include: startup, onboarding, signin, home, speed-test, connected-devices, payment, invoice, router-security (password change & reset), notifications, chat.

### Dependency Injection: GetIt

Initialized in `lib/core/di/dependency_injection.dart` via `initDI()` called from `main()`.

- **Dio**: singleton, shared by all API services
- **API services** (`*_api.dart` wrappers): `lazySingleton`
- **Cubits**: `factory` (new instance per registration)
- **Repositories**: `lazySingleton`

Access via `getIt<Type>()` or inject through constructors.

### Networking Layer

```
core/networking/
├── dio_factory.dart          # Dio singleton, PrettyDioLogger, token injection
├── api_result.dart           # ApiResult<T> = Success<T> | Failure<ErrorModel>  (Freezed)
├── api_error_handler.dart    # Maps exceptions to ErrorModel
└── api_constans.dart         # Base URL, endpoint constants
```

**Base URL:** `http://network-isp-user-api.runasp.net/network-user-api/`

Every feature's API layer has two files:

- `*_api_service.dart` — Retrofit abstract class with `@RestApi`, `@POST`/`@GET` decorators (code-gen target)
- `*_api.dart` — Concrete wrapper that calls the service and returns `ApiResult<T>`

Cubits call the `*_api.dart` wrapper, never the Retrofit service directly.

**Authentication:** Bearer token is injected into Dio headers after login via `DioFactory.setTokenIntoHeaderAfterLogin()`.

### UI Conventions

**Localization:** Arabic (`ar`) is the default locale (RTL). English (`en`) is secondary. ARB files are in `l10n/`. Use generated `AppLocalizations` — never hardcode Arabic strings.

**Typography:** Always use `AppText` widget (never raw `Text`). Named constructors: `.medium()`, `.semiBold()`, `.bold()`. Font is Cairo-Bold loaded from assets.

**Responsive sizing:** Use `flutter_screenutil` — sizes are expressed as `16.sp`, `24.w`, `12.h`.

**Core components** in `lib/core/components/`: `AppButton`, `AppCard`, `AppText`, `AppTextFormField`, `CustomAppBar`, `AppSnackBar`, `AppAlertDialog`, `AppDrawer`, etc. Prefer these over raw Flutter widgets.

**Colors:** Defined in `AppColors` (`lib/core/constants/colors.dart`). Primary `#1565C0`, text `#0A192F`.

### Feature Module Structure

```
pages/
├── auth/signin/           # Login flow
├── home/                  # Main shell with bottom nav (home, subscriptions, support, settings tabs)
├── features/
│   ├── chat/              # Customer support chat
│   ├── connected_devices/ # WiFi device management
│   ├── speed_test/        # Internet speed testing
│   ├── router_security/   # Password change & router reset
│   ├── payment/           # Payment screen
│   ├── invoice/           # Invoice screen
│   └── notifications/     # Notifications screen
├── onboarding/            # First-run onboarding
└── startup/               # App initialization (auth check, routing decision)
```

Each feature under `pages/` follows: `api/ + cubit/ + model/ + screen/` (only what the feature needs).
