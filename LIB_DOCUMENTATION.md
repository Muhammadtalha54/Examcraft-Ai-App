# ExamCraft AI - Library Documentation

## Overview
ExamCraft AI is a premium Flutter app for academic exam preparation with AI-powered features. The app allows users to generate MCQs, short questions, and long questions from PDF files, take practice tests, and track their performance.

## Package Dependencies

### Core Flutter Packages
- **flutter**: Flutter SDK
- **cupertino_icons**: iOS-style icons

### State Management
- **provider**: State management solution for managing app-wide state

### Networking & API
- **http**: HTTP client for API requests
- **http_parser**: HTTP parsing utilities

### File Operations
- **file_picker**: Pick files from device storage
- **image_picker**: Pick images from gallery/camera
- **path_provider**: Access device directories
- **path**: Path manipulation utilities

### PDF Generation
- **pdf**: PDF creation and manipulation
- **printing**: PDF printing and sharing functionality
- **image**: Image processing for PDF generation

### Storage & Persistence
- **sqflite**: SQLite database for local storage
- **shared_preferences**: Simple key-value storage
- **flutter_secure_storage**: Secure storage for sensitive data

### UI & Styling
- **google_fonts**: Google Fonts integration
- **url_launcher**: Launch URLs and external apps

### Utilities
- **intl**: Internationalization and date formatting

### Development
- **flutter_test**: Testing framework
- **flutter_lints**: Linting rules
- **flutter_launcher_icons**: App icon generation

## Folder Structure

### 📁 api/
Contains API client and service classes for backend communication.

#### Files:
- **api_client.dart**: Base HTTP client configuration and common API methods
- **auth_api.dart**: Authentication API endpoints (login, signup, forgot password)
- **generation_api.dart**: Question generation API endpoints (MCQ, short, long questions)
- **test_api.dart**: Test evaluation and result submission API endpoints

### 📁 models/
Data models representing the app's core entities.

#### Files:
- **mcq_model.dart**: Multiple Choice Question model with options and correct answers
- **mcq.dart**: Alternative MCQ model implementation
- **question_model.dart**: Short/Long answer question model
- **test_result_model.dart**: Test result data model with scores and statistics
- **user_model.dart**: User profile and authentication data model

### 📁 providers/
State management providers using the Provider pattern.

#### Files:
- **auth_provider.dart**: Manages user authentication state (login, signup, logout)
- **generate_provider.dart**: Manages question generation state and API calls
- **rating_provider.dart**: Manages app rating and feedback functionality
- **test_provider.dart**: Manages test evaluation and history state

### 📁 repositories/
Repository pattern implementation for data access abstraction.

#### Files:
- **auth_repository.dart**: Authentication data operations and API calls
- **generate_repository.dart**: Question generation data operations
- **rating_repository.dart**: Rating and feedback data operations
- **test_repository.dart**: Test evaluation and history data operations

### 📁 screens/
UI screens organized by feature modules.

#### 📁 auth/
Authentication related screens.
- **login_screen.dart**: User login interface with email/password validation
- **signup_screen.dart**: User registration interface with form validation
- **forgot_password_screen.dart**: Password reset interface

#### 📁 generation/
Question generation screens organized by question types.

##### 📁 mcqscreens/
- **mcq_generation_screen.dart**: Upload PDF and configure MCQ generation
- **mcq_display_screen.dart**: Display generated MCQs with download options
- **mcq_practice_test_screen.dart**: Interactive MCQ test interface with timer
- **test_intro_screen.dart**: Test configuration screen before starting
- **test_result_screen.dart**: Display test results with detailed feedback

##### 📁 long_question/
- **long_questions_screen.dart**: Upload PDF and generate long answer questions
- **long_questions_display_screen.dart**: Display generated long questions with PDF export

##### 📁 shortquestion/
- **short_questions_screen.dart**: Upload PDF and generate short answer questions

#### 📁 historyscreen/
- **history_screen.dart**: Display user's test history with scores and statistics

#### 📁 home/
- **home_screen.dart**: Main dashboard with feature navigation cards

#### 📁 infoscreen/
- **info_screens.dart**: App information and help screens

#### 📁 questions/
Additional question-related screens.
- **mcq_test_screen.dart**: MCQ test interface
- **mcq_test_setup_screen.dart**: Test configuration and setup
- **mcq_test_result_screen.dart**: Test result display

#### 📁 rateappscreen/
- **rate_app_screen.dart**: App rating and feedback interface

### 📁 services/
Core services for data persistence and API communication.

#### Files:
- **api_service.dart**: Centralized API service with HTTP client configuration
- **database_helper.dart**: SQLite database operations for local data storage

### 📁 utils/
Utility classes and helper functions.

#### Files:
- **pdf_generator.dart**: PDF creation utilities for questions and results
- **pdf_helper.dart**: PDF manipulation and export helpers
- **response_handler.dart**: API response parsing and error handling
- **secure_storage_helper.dart**: Secure storage operations wrapper
- **shared_prefs_helper.dart**: Shared preferences operations wrapper
- **validators.dart**: Form validation utilities (email, password, etc.)

### 📁 widgets/
Reusable UI components organized by category.

#### 📁 common/
Common UI widgets used throughout the app.
- **app_button.dart**: Styled button component with loading states
- **app_colors.dart**: App color scheme and theme colors
- **app_drawer.dart**: Navigation drawer component
- **app_spacing.dart**: Consistent spacing utilities
- **app_text_styles.dart**: Typography styles and text themes
- **app_textfield.dart**: Styled text input component with validation
- **custom_app_bar.dart**: Custom app bar component
- **feature_card.dart**: Feature navigation card component
- **ios_transition.dart**: iOS-style page transitions
- **loader.dart**: Loading indicator components
- **media_query_helper.dart**: Screen size and responsive design helpers
- **modern_app_bar.dart**: Modern styled app bar
- **modern_card.dart**: Modern card component
- **modern_feature_card.dart**: Modern feature card component
- **snackbar.dart**: Toast notification component

#### 📁 mcq/
MCQ-specific UI components.
- **mcq_card.dart**: MCQ question display card
- **option_widget.dart**: MCQ answer option component

### 📄 Root Files
- **main.dart**: App entry point and initialization
- **app.dart**: App configuration and routing setup

## Key Features

### 🤖 AI-Powered Question Generation
- Generate MCQs from PDF documents
- Create short answer questions
- Generate long answer questions
- Configurable difficulty levels

### 📝 Interactive Testing
- Timed MCQ tests
- Instant feedback
- Score tracking
- Performance analytics

### 📊 Progress Tracking
- Test history
- Score statistics
- Performance trends
- Pass/fail tracking

### 💾 Data Persistence
- Local SQLite database
- Secure user data storage
- Offline functionality
- Test result history

### 🎨 Modern UI/UX
- iOS-style design
- Responsive layout
- Dark/light theme support
- Smooth animations

## Architecture Pattern

The app follows a **Repository Pattern** with **Provider State Management**:

1. **Presentation Layer**: Screens and Widgets
2. **Business Logic Layer**: Providers
3. **Data Access Layer**: Repositories
4. **Data Layer**: APIs and Local Database

This architecture ensures:
- Separation of concerns
- Testability
- Maintainability
- Scalability
- Clean code organization