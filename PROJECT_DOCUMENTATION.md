# ExamCraft AI - Flutter App Documentation

## 📱 What is ExamCraft AI?

ExamCraft AI is a mobile app built with Flutter that helps students prepare for exams using artificial intelligence. Think of it as your personal study assistant that can create practice questions, tests, and help you learn better.

## 🛠️ Tech Stack (Technologies Used)

### Frontend Framework
- **Flutter**: A framework by Google to build mobile apps for both Android and iOS using one codebase
- **Dart**: The programming language used with Flutter

### State Management
- **Provider**: A simple way to manage app data and notify screens when data changes

### Backend & API
- **HTTP Client**: For communicating with the server
- **REST API**: Server hosted at `https://examcraft-ai-backend.onrender.com`

### Local Storage (Offline Data)
- **SQLite**: Local database to store data on the phone
- **Shared Preferences**: Simple key-value storage for user settings
- **Flutter Secure Storage**: Encrypted storage for sensitive data like login tokens

### UI & Design
- **Google Fonts**: Custom fonts (Inter font family)
- **Material Design**: Google's design system for consistent UI

## 📦 Packages Used

```yaml
# Core Flutter packages
flutter: sdk
provider: ^6.1.1          # State management
http: ^1.1.0              # API calls

# File & Media handling
file_picker: ^8.0.0+1     # Pick files from device
image_picker: ^1.0.4      # Pick images from camera/gallery
url_launcher: ^6.2.2      # Open URLs and external apps

# UI & Fonts
google_fonts: ^6.1.0      # Custom fonts
cupertino_icons: ^1.0.2   # iOS-style icons

# Storage
flutter_secure_storage: ^9.0.0  # Encrypted storage
sqflite: ^2.3.0                 # Local SQLite database
shared_preferences: ^2.2.2      # Simple key-value storage
path_provider: ^2.1.1           # Get device storage paths

# PDF & Document handling
pdf: ^3.10.4              # Generate PDF files
printing: ^5.11.0         # Print documents

# Utilities
path: ^1.8.3              # File path utilities
http_parser: ^4.0.2       # Parse HTTP responses
image: ^4.1.3             # Image processing
intl: ^0.18.1             # Internationalization
```

## 📁 Project Structure

```
lib/
├── main.dart                    # App entry point
├── app.dart                     # Main app configuration
├── api/                         # API communication
├── models/                      # Data structures
├── providers/                   # State management
├── repositories/                # Data access layer
├── screens/                     # App screens/pages
├── services/                    # Business logic
├── utils/                       # Helper functions
└── widgets/                     # Reusable UI components
```

## 🔧 How the App Works

### 1. App Startup (`main.dart` & `app.dart`)

**File: `lib/main.dart`**
- This is where the app starts
- Calls `runApp()` to launch the ExamCraft app

**File: `lib/app.dart`**
- Sets up the main app configuration
- Configures the dark theme with neon colors
- Sets up all the providers (state managers)
- Decides whether to show login screen or home screen

### 2. Authentication System

**How Login Status is Saved:**
- Uses **Shared Preferences** to store login status (`is_logged_in: true/false`)
- Stores user name and email in Shared Preferences
- Uses **Flutter Secure Storage** for sensitive data like JWT tokens

**How Login Status is Removed:**
- When user logs out, calls `SharedPrefsHelper.clearAll()`
- This removes all stored user data
- App automatically shows login screen

**Files Involved:**
- `lib/providers/auth_provider.dart` - Manages login state
- `lib/utils/shared_prefs_helper.dart` - Handles simple data storage
- `lib/utils/secure_storage_helper.dart` - Handles encrypted data storage
- `lib/screens/auth/login_screen.dart` - Login interface
- `lib/screens/auth/signup_screen.dart` - Registration interface

### 3. Offline Database Storage

**Database: SQLite (`examcraft.db`)**

The app stores data locally using SQLite database with these tables:

**Tables:**
1. **mcqs** - Multiple choice questions
   - Stores: question, options, correct answer, user answer, difficulty
2. **questions** - Short/long questions  
   - Stores: question, answer, type (short/long)
3. **test_results** - Test scores and history
   - Stores: test title, score, total questions, percentage

**File: `lib/services/database_helper.dart`**
- Creates and manages the local database
- Provides methods to insert, read, update, delete data
- Database is stored on the device's internal storage

### 4. API Configuration & Communication

**Base URL:** `https://examcraft-ai-backend.onrender.com`

**File: `lib/api/api_client.dart`**
- Handles all HTTP requests (GET, POST)
- Adds proper headers to requests
- Handles response parsing and error handling

**API Files:**
- `lib/api/auth_api.dart` - Login, signup, password reset
- `lib/api/generation_api.dart` - Generate questions using AI
- `lib/api/test_api.dart` - Test-related operations

### 5. State Management (Providers)

Providers are like "managers" that hold data and notify screens when data changes.

**File: `lib/providers/auth_provider.dart`**
- Manages: User login status, user data
- Functions: login(), signup(), logout(), checkLoginStatus()

**File: `lib/providers/generate_provider.dart`**
- Manages: AI question generation
- Functions: Generate MCQs, short questions, long questions

**File: `lib/providers/test_provider.dart`**
- Manages: Test taking, scoring, results
- Functions: Start test, submit answers, calculate scores

**File: `lib/providers/practice_test_provider.dart`**
- Manages: Practice test functionality
- Functions: Load practice questions, track progress

**File: `lib/providers/info_provider.dart`**
- Manages: App information and settings

**File: `lib/providers/rating_provider.dart`**
- Manages: App rating functionality

### 6. Screens (User Interfaces)

**Authentication Screens:**
- `lib/screens/auth/login_screen.dart` - User login
- `lib/screens/auth/signup_screen.dart` - User registration  
- `lib/screens/auth/forgot_password_screen.dart` - Password reset

**Main Screens:**
- `lib/screens/home/home_screen.dart` - Main dashboard
- `lib/screens/generation/mcq_generation_screen.dart` - Generate questions
- `lib/screens/history_screen.dart` - View past tests

**Question Screens:**
- `lib/screens/questions/mcq_test_screen.dart` - Take MCQ tests
- `lib/screens/questions/mcq_display_screen.dart` - View MCQ questions
- `lib/screens/questions/mcq_test_setup_screen.dart` - Configure test settings
- `lib/screens/questions/mcq_test_result_screen.dart` - View test results

**Practice Screens:**
- `lib/screens/practice/mcq_practice_test_screen.dart` - Practice MCQs
- `lib/screens/practice/practice_upload_screen.dart` - Upload study material
- `lib/screens/practice/test_intro_screen.dart` - Test introduction
- `lib/screens/practice/test_result_screen.dart` - Practice results

### 7. Widgets Folder (Reusable Components)

**Common Widgets (`lib/widgets/common/`):**

**Design System:**
- `app_colors.dart` - All app colors (dark theme with neon accents)
- `app_text_styles.dart` - Text styles using Google Fonts
- `app_spacing.dart` - Consistent spacing values

**UI Components:**
- `custom_app_bar.dart` - Custom app bar with back button
- `app_button.dart` - Styled buttons
- `app_textfield.dart` - Input fields
- `feature_card.dart` - Cards for features
- `modern_card.dart` - Modern-styled cards
- `loader.dart` - Loading spinner
- `snackbar.dart` - Notification messages

**MCQ Widgets (`lib/widgets/mcq/`):**
- `mcq_card.dart` - Display MCQ questions
- `option_widget.dart` - MCQ answer options

### 8. How Everything Connects

```
User Opens App
       ↓
main.dart starts app
       ↓
app.dart checks AuthProvider
       ↓
AuthProvider checks SharedPrefsHelper for login status
       ↓
If logged in: Show HomeScreen
If not logged in: Show LoginScreen
       ↓
User interacts with screens
       ↓
Screens use Providers to manage data
       ↓
Providers use Repositories to get data
       ↓
Repositories use API clients or DatabaseHelper
       ↓
Data flows back to UI through Providers
       ↓
UI updates automatically when data changes
```

### 9. Data Flow Example: Taking a Test

1. User taps "Take Test" on HomeScreen
2. Navigation goes to `mcq_test_setup_screen.dart`
3. User configures test settings
4. Screen calls `TestProvider.startTest()`
5. TestProvider calls `TestRepository.getQuestions()`
6. Repository calls `ApiClient.get('/questions')`
7. Questions are fetched from server
8. TestProvider stores questions and notifies UI
9. UI shows `mcq_test_screen.dart` with questions
10. User answers questions
11. TestProvider tracks answers
12. When finished, TestProvider calculates score
13. Score is saved to local database via DatabaseHelper
14. UI shows `mcq_test_result_screen.dart` with results

### 10. Offline Functionality

**What works offline:**
- View previously downloaded questions
- Take practice tests with cached questions
- View test history and results
- Browse saved content

**What needs internet:**
- Generate new questions (requires AI API)
- Login/signup
- Sync data with server
- Download new content

### 11. Security Features

**Data Protection:**
- JWT tokens stored in Flutter Secure Storage (encrypted)
- User passwords never stored locally
- API calls use HTTPS encryption
- Local database is private to the app

**Authentication:**
- JWT token-based authentication
- Automatic token refresh
- Secure logout that clears all data

## 🎨 Design System

**Color Scheme:** Dark theme with neon accents
- Background: Deep charcoal blue (#0B0F1A)
- Primary: Neon Indigo (#4F46E5)
- Secondary: Neon Cyan (#22D3EE)
- Text: Light gray (#E5E7EB)

**Typography:** Inter font family with various weights
**Spacing:** Consistent 8px base unit system

## 🔄 App Lifecycle

1. **App Launch**: Check authentication status
2. **Authentication**: Login/signup flow
3. **Main App**: Access features based on user permissions
4. **Background**: Save state and data
5. **Resume**: Restore previous state
6. **Logout**: Clear all user data and return to login

This documentation provides a complete overview of how ExamCraft AI works, making it easy for anyone to understand the app's architecture and functionality, even without Flutter knowledge.