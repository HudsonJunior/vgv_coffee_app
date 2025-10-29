# VGV Coffee App ☕

Hi VGV team!

I've completed my code assessment. I did my best to implement all the user requirements from your document, within the time I had and with the ideas I came up with.

Even though this is a simple application, I applied an architecture that wouldn’t normally be necessary for something this small, mainly to demonstrate a robust, scalable, and maintainable structure that could be used in a real-world project.

I used Slivers for better performance with lists and applied a coffee-themed visual style.

The client classes act as wrappers around external dependencies, while the source and repository layers follow well-known best practices.

I included unit tests for core functionality and additional integration tests for the main flows.

I decided not to create abstractions since I didn’t see the necessary complexity for them, but I believe the structure is still robust enough.

I really enjoyed working on this challenge and I'm looking forward to your feedback! :)

## Demo

📹 **[Watch Demo Video](./assets/demo_video.MP4)**

> Click the link above to view the application demo

## Features

- **Random Coffee Images**: Load coffee images from [Coffee API](https://coffee.alexflipnote.dev)
- **Save Favorites**: Save your favorite coffee images locally
- **Offline Access**: View saved favorites even without internet

## Architecture
I've choosen to follow Android's architecture [guidelines](https://developer.android.com/topic/architecture) (previously called Repository Pattern) with a few tweaks for the Flutter implementation.

### Layer Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                        UI LAYER                              │
│  ┌─────────────┐              ┌──────────────┐             │
│  │   Coffee    │              │  Favorites   │             │
│  │   Screen    │              │   Screen     │             │
│  └──────┬──────┘              └──────┬───────┘             │
│         │ listens                    │ listens              │
│  ┌──────▼──────┐              ┌──────▼───────┐             │
│  │Coffee Cubit │              │Favorites     │             │
│  │             │              │Cubit         │             │
│  └──────┬──────┘              └──────┬───────┘             │
└─────────┼─────────────────────────────┼───────────────────┘
          │ calls                       │ calls
┌─────────▼─────────────────────────────▼───────────────────┐
│                      DATA LAYER                            │
│  ┌──────────────┐              ┌──────────────┐           │
│  │   Coffee     │              │  Favorites   │           │
│  │  Repository  │              │  Repository  │           │
│  └──────┬───────┘              └──────┬───────┘           │
│         │ uses                        │ uses               │
│  ┌──────▼──────┐              ┌───────▼──────┐            │
│  │Coffee Remote│              │  Favorites   │            │
│  │ DataSource  │              │ Local DS     │            │
│  └──────┬──────┘              └──────┬───────┘            │
└─────────┼─────────────────────────────┼───────────────────┘
          │ uses                        │ uses
┌─────────▼─────────────────────────────▼───────────────────┐
│                   EXTERNAL SOURCES                         │
│  ┌──────────────┐              ┌──────────────┐           │
│  │  ApiClient   │              │ SharedPref   │           │
│  │    (Dio)     │              │   Client     │           │
│  └──────────────┘              └──────────────┘           │
└────────────────────────────────────────────────────────────┘
```

### Project Structure

```
lib/
├── core/
│   ├── clients/
│   │   ├── api_client.dart              # Dio wrapper
│   │   └── shared_preferences_client.dart
│   ├── di/
│   │   └── injection.dart               # Dependency injection
│   ├── errors/
│   │   └── failures.dart                # Error types
│   ├── theme/
│   │   └── app_theme.dart               # Material 3 theme
│   └── widgets/
│       ├── error_view.dart              # Reusable error UI
│       └── loading_view.dart            # Loading indicator
├── features/
│   ├── coffee/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── coffee.dart
│   │   │   ├── repository/
│   │   │   │   └── coffee_repository.dart
│   │   │   └── sources/
│   │   │       └── coffee_remote_data_source.dart
│   │   └── screen/
│   │       ├── coffee_screen.dart
│   │       ├── cubit/
│   │       │   ├── coffee_cubit.dart
│   │       │   └── coffee_state.dart
│   │       └── widgets/
│   │           ├── coffee_image_card.dart
│   │           └── coffee_action_buttons.dart
│   └── favorites/
│       ├── core/
│       │   ├── models/
│       │   │   └── favorite_coffee.dart
│       │   └── repository/
│       │       └── favorites_repository.dart
│       ├── data/
│       │   └── favorites_local_data_source.dart
│       └── screen/
│           ├── favorites_screen.dart
│           ├── cubit/
│           │   ├── favorites_cubit.dart
│           │   └── favorites_state.dart
│           └── widgets/
│               ├── favorite_coffee_card.dart
│               └── empty_favorites_view.dart
└── main.dart
```

## Tech Stack

- **Flutter version used**: ^3.35.3
- **State Management**: flutter_bloc (cubit)
- **Functional Programming**: dartz
- **HTTP Client**: dio
- **Local Storage**: shared_preferences
- **Reactive Streams**: rxdart
- **Image Caching**: cached_network_image
- **Dependency Injection**: get_it
- **Testing**: mocktail, bloc_test, flutter_test

## Getting Started

### Installation

1. **Clone the repository:**
```bash
git clone https://github.com/HudsonJunior/vgv_coffee_app
cd vgv_coffee_app
```

2. **Install dependencies:**
```bash
flutter pub get
```

3. **Run the app:**
```bash
# For development
flutter run

# For release
flutter run --release
```

## Running Tests

### Unit Tests

Run all unit tests:
```bash
flutter test
```

### Integration Tests

Run integration tests on a device or simulator:
```bash
flutter test integration_test/app_test.dart
```

### Testing with Mocktail

This project uses **Mocktail** for mocking, which doesn't require code generation. Each test file creates its own mocks by extending `Mock` and implementing the interface to mock:

```dart
class MockApiClient extends Mock implements ApiClient {}
```

## API Information

This app uses the [Coffee API by AlexFlipnote](https://coffee.alexflipnote.dev):
- **Endpoint**: `https://coffee.alexflipnote.dev/random.json`
- **Response Format**: `{"file": "https://coffee.alexflipnote.dev/..."}`