<<<<<<< HEAD
# Today - Flutter To-Do App

A clean and minimal Flutter To-Do application designed as a productivity-focused mobile experience.

## Overview

Today is a simple, professional To-Do application built with Flutter and Material 3. The application focuses on essential task management functionality with a calm, modern design philosophy. It works completely offline without any backend, storing tasks in memory for this assignment.

## Features

- Professional splash screen with app branding
- Add tasks via a polished bottom sheet
- Edit tasks with title, date, and time modification
- Delete tasks with swipe-to-delete gesture
- Undo deletion with SnackBar action
- Complete/uncomplete tasks with checkbox interaction
- Optional task date selection
- Optional task time selection
- Professional empty state when no tasks exist
- Dynamic date display (e.g., "Tuesday, 11 August")
- Dynamic greeting based on time of day
- Real-time remaining-task count
- Completion progress indicator
- Overdue task indication
- Smart task ordering by due date
- Responsive UI for various screen sizes
- Fully offline functionality

## Setup Instructions

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd to_do_list
   ```

2. Open the project in Android Studio or VS Code

3. Verify Flutter installation:
   ```bash
   flutter --version
   ```

4. Install dependencies:
   ```bash
   flutter pub get
   ```

5. Connect an Android device or start an emulator

6. Run the application:
   ```bash
   flutter run
   ```

## Flutter Version

Flutter: 3.35.4
Dart: 3.9.2

## Packages Used

No external packages were used.

The application uses Flutter's built-in Material 3 widgets and Dart libraries.

## Project Structure

```
lib/
├── main.dart              # App entry point
├── models/
│   └── task.dart         # Task data model with date/time support
├── screens/
│   ├── splash_screen.dart # Splash screen with app branding
│   └── home_screen.dart  # Main home screen with task management
├── widgets/
│   ├── task_tile.dart    # Individual task display with edit/delete
│   ├── add_task_sheet.dart # Bottom sheet for adding tasks with date/time
│   ├── edit_task_sheet.dart # Bottom sheet for editing tasks
│   ├── empty_state.dart  # Empty state widget
│   └── progress_header.dart # Progress indicator widget
├── theme/
│   └── app_theme.dart    # Material 3 theme configuration
└── utils/
    └── date_utils.dart   # Date formatting and overdue detection
```

- **models/**: Data structures for the application
- **screens/**: Full-screen UI components
- **widgets/**: Reusable UI components
- **theme/**: App-wide styling and theming
- **utils/**: Helper functions and utilities

## How the Application Works

The application follows a simple unidirectional data flow:

1. **Splash Screen**: Shows app branding with fade animation, then transitions to Home Screen
2. **UI Layer**: Widgets display tasks and handle user interactions
3. **Task Model**: Each task has id, title, completion status, optional due date, optional due time, and creation date
4. **Local State**: Tasks are stored in an in-memory List<Task>
5. **State Management**: setState() triggers UI rebuilds when data changes
6. **UI Rebuild**: Flutter rebuilds affected widgets to reflect the new state

**Adding Tasks**: User taps FAB → Bottom sheet opens → User enters task title → Optionally selects date/time → Task added to list → UI updates

**Editing Tasks**: User taps edit icon → Edit bottom sheet opens → User modifies title/date/time → Changes saved → UI updates immediately

**Completing Tasks**: User taps checkbox → Task's isCompleted toggles → setState called → UI rebuilds with new state

**Deleting Tasks**: User swipes task → Task removed from list → SnackBar shows with UNDO option → UI updates immediately

**Task Ordering**: Incomplete tasks are sorted by due date (tasks with dates first, then by creation time)

## Build APK

To build a release APK:

```bash
flutter build apk --release
```

The generated APK will be located at:
```
build/app/outputs/flutter-apk/app-release.apk
```

## Short Questions

**Question 1: What is the difference between StatelessWidget and StatefulWidget?**

StatelessWidget is immutable and cannot change its internal state once built. It's used for widgets that don't need to update over time. StatefulWidget has a mutable State object that can change, allowing the widget to rebuild when its state changes via setState().

**Question 2: What is setState() used for in Flutter?**

setState() is used in StatefulWidget to mark the widget as needing to be rebuilt. When called, it schedules a rebuild of the widget with the updated state, allowing the UI to reflect changes in data.

**Question 3: What is the difference between ListView and Column?**

Column is a layout widget that arranges children vertically without built-in scrolling. It renders all children at once, which can cause overflow errors with many items. ListView is a scrollable list widget that efficiently renders only visible items, making it suitable for large or unknown numbers of children.

**Question 4: How would you handle an API call in Flutter?**

Use the async/await pattern with the http package or similar. Create an async function that makes the HTTP request, awaits the response, parses the JSON data, and returns the result. Handle errors with try-catch blocks and update the UI using setState() or a state management solution.

**Question 5: What is the purpose of pubspec.yaml?**

pubspec.yaml is the configuration file for a Flutter project. It specifies project metadata, dependencies (packages the project needs), assets (images, fonts, etc.), and other project settings like SDK version constraints and build configurations.

**Question 6: Which Flutter project or feature have you worked on that you are most proud of, and what was your contribution?**

[Add your actual Flutter project and contribution here.]

## Limitations

- Task data is currently stored in memory only
- Tasks may reset when the app is completely restarted
- No backend/database is used for persistence
- No cloud synchronization or backup functionality
=======
# Today--todo-app
It is the Flutter based todo application
>>>>>>> bd82845000bdb316d47b999235c669b875906277
