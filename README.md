# Tody - Modern Todo App 📝

<p align="center">
  <img src="assets/icon/app_icon.png" alt="Tody Logo" width="120"/>
</p>

<p align="center">
  A beautiful and feature-rich Todo application built with Flutter, featuring clean architecture, Provider for state management, GetX for navigation, and Hive for local storage.
</p>

---

## ✨ Features

| Feature | Description |
|---------|-------------|
| 📝 **CRUD Operations** | Create, Read, Update, and Delete tasks with ease |
| 🎨 **Modern UI/UX** | Beautiful gradient splash screen and material design |
| 💾 **Local Storage** | Persistent data storage using Hive (offline-first) |
| 🏗️ **Clean Architecture** | Well-organized folder structure with reusable widgets |
| 🔄 **State Management** | Provider for reactive state management |
| 🧭 **Navigation** | GetX for seamless navigation and snackbar notifications |
| 📱 **Responsive** | Works on all screen sizes |
| 🌙 **Dark Mode** | Automatic theme switching based on system preferences |
| 🏷️ **Categories** | Organize tasks by 8 default categories |
| 🎯 **Priorities** | Set High, Medium, or Low priority for tasks |
| 📅 **Due Dates** | Set and track task due dates |
| ✅ **Task Filters** | Filter by All, Today, Upcoming, or Completed |
| 🗑️ **Swipe to Delete** | Swipe left on any task to delete it |
| ✨ **Animations** | Smooth staggered list animations |

---

## 📸 Screenshots

| Splash Screen | Home Screen | Add Task | Task Filters |
|---------------|-------------|----------|--------------|
| Gradient splash with animated logo | Task list with stats cards | Form with priority & category | Filter chips for quick access |

---

## 🏗️ Architecture

This app follows **Clean Architecture** principles with a clear separation of concerns:

```
lib/
├── core/                          # Core utilities and configurations
│   ├── constants/
│   │   ├── app_colors.dart        # Color palette (primary, status, category colors)
│   │   ├── app_strings.dart       # All app strings and labels
│   │   └── app_sizes.dart         # Spacing, padding, font sizes
│   ├── routes/
│   │   └── app_routes.dart        # GetX navigation routes
│   └── theme/
│       └── app_theme.dart         # Light & dark theme configuration
│
├── data/                          # Data layer
│   ├── models/
│   │   ├── todo_model.dart        # Todo model with Hive TypeAdapters
│   │   └── todo_model.g.dart      # Generated Hive adapter
│   ├── repositories/
│   │   └── todo_repository.dart   # CRUD operations & business logic
│   └── services/
│       └── hive_service.dart      # Hive database initialization & operations
│
├── presentation/                  # UI layer
│   ├── screens/
│   │   ├── splash/
│   │   │   └── splash_screen.dart # Animated splash screen
│   │   ├── home/
│   │   │   └── home_screen.dart   # Main todo list with filters
│   │   └── add_edit/
│   │       └── add_edit_todo_screen.dart  # Add/Edit task form
│   └── widgets/                   # Reusable UI components
│       ├── buttons/
│       │   └── primary_button.dart
│       ├── cards/
│       │   ├── todo_card.dart     # Task card with swipe-to-delete
│       │   └── stats_card.dart    # Statistics card
│       ├── common/
│       │   ├── empty_state.dart   # Empty state placeholder
│       │   ├── filter_chip_widget.dart
│       │   └── loading_indicator.dart
│       └── inputs/
│           ├── custom_text_field.dart
│           ├── date_picker_field.dart
│           ├── priority_selector.dart
│           └── category_selector.dart
│
├── providers/                     # State management
│   └── todo_provider.dart         # Provider with filters & CRUD
│
└── main.dart                      # App entry point
```

---

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK** 3.9.0 or higher
- **Dart SDK** (included with Flutter)
- **Android Studio** / **VS Code** with Flutter extensions
- **Git** for version control

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/tody.git
   cd tody
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   # For debug mode
   flutter run

   # For release mode
   flutter run --release
   ```

### Build for Production

```bash
# Android APK
flutter build apk --release

# Android App Bundle (for Play Store)
flutter build appbundle --release

# iOS (requires macOS)
flutter build ios --release

# Web
flutter build web --release

# Windows
flutter build windows --release
```

---

## 📦 Dependencies

### Main Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `provider` | ^6.1.2 | State management |
| `get` | ^4.6.6 | Navigation & utilities |
| `hive` | ^2.2.3 | NoSQL local database |
| `hive_flutter` | ^1.1.0 | Hive Flutter integration |
| `uuid` | ^4.5.1 | Unique ID generation |
| `intl` | ^0.19.0 | Date formatting |
| `flutter_staggered_animations` | ^1.1.1 | List animations |
| `iconsax` | ^0.0.8 | Modern icons |
| `flutter_native_splash` | ^2.4.4 | Native splash screen |

### Dev Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `hive_generator` | ^2.0.1 | Hive TypeAdapter generator |
| `build_runner` | ^2.4.13 | Code generation |
| `flutter_launcher_icons` | ^0.14.3 | App icon generator |

---

## 🎨 Theming & Colors

### Primary Colors
- **Primary**: `#6C63FF` (Purple)
- **Primary Dark**: `#4A42D9`
- **Secondary**: `#FF6B6B` (Coral)

### Priority Colors
- **High**: `#E53935` (Red)
- **Medium**: `#FF9800` (Orange)
- **Low**: `#4CAF50` (Green)

### Category Colors
8 predefined colors for categories: Purple, Coral, Green, Orange, Blue, Purple, Cyan, Pink

---

## 📱 App Screens

### 1. Splash Screen
- Animated gradient background
- Logo with scale and fade animations
- Auto-navigates to home after 2.5 seconds

### 2. Home Screen
- **Header**: Greeting message with current time
- **Stats Cards**: Pending and Completed task counts
- **Filter Chips**: All, Today, Upcoming, Completed
- **Task List**: Animated list with swipe-to-delete
- **FAB**: Floating action button to add new task

### 3. Add/Edit Task Screen
- **Title Field**: Required, minimum 3 characters
- **Description Field**: Optional, multiline
- **Due Date Picker**: Select date with clear option
- **Priority Selector**: High, Medium, Low chips
- **Category Selector**: 8 default categories
- **Save/Update Button**: Creates or updates task
- **Delete Button**: Only shown when editing

---

## 🔧 Configuration

### App Icon Generation
Icons are pre-configured in `pubspec.yaml`. To regenerate:

```bash
dart run flutter_launcher_icons
```

### Splash Screen Generation
Native splash is pre-configured. To regenerate:

```bash
dart run flutter_native_splash:create
```

### Hive Adapters
If you modify the `TodoModel`, regenerate adapters:

```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## 📝 Usage Guide

### Adding a Task
1. Tap the **"+ Add Task"** FAB button
2. Enter task title (required)
3. Optionally add description
4. Select due date (optional)
5. Choose priority (default: Medium)
6. Select category (default: Personal)
7. Tap **"Create"**

### Editing a Task
1. Tap on any task card
2. Modify the fields as needed
3. Tap **"Update"** to save changes

### Completing a Task
1. Tap the checkbox on the left of any task
2. Task will be marked as completed with strikethrough

### Deleting a Task
1. **Swipe left** on any task card
2. Task will be deleted with confirmation snackbar

### Filtering Tasks
Use the filter chips below the stats cards:
- **All**: Shows all tasks
- **Today**: Tasks due today
- **Upcoming**: Future tasks
- **Completed**: Finished tasks

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

This project is open source and available under the **MIT License**.

```
MIT License

Copyright (c) 2025 Tody

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

## 🙏 Acknowledgments

- [Flutter](https://flutter.dev/) - UI toolkit
- [Provider](https://pub.dev/packages/provider) - State management
- [GetX](https://pub.dev/packages/get) - Navigation
- [Hive](https://pub.dev/packages/hive) - Local database
- [Iconsax](https://pub.dev/packages/iconsax) - Icons

---

<p align="center">
  Made with ❤️ using Flutter
</p>

