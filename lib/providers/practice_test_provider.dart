// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import '../models/mcq.dart';
// import '../services/api_service.dart';

// class PracticeTestProvider extends ChangeNotifier {
//   List<Mcq> _mcqs = [];
//   int _currentIndex = 0;
//   int _score = 0;
//   List<int?> _selectedAnswers = [];
//   bool _isAnswered = false;
//   Timer? _countdownTimer;
//   int _remainingSeconds = 0;
//   bool _isLoading = false;
//   String? _error;
//   bool _testCompleted = false;

//   // Getters
//   List<Mcq> get mcqs => _mcqs;
//   int get currentIndex => _currentIndex;
//   int get score => _score;
//   List<int?> get selectedAnswers => _selectedAnswers;
//   bool get isAnswered => _isAnswered;
//   int get remainingSeconds => _remainingSeconds;
//   bool get isLoading => _isLoading;
//   String? get error => _error;
//   bool get testCompleted => _testCompleted;

//   void initializeTest({
//     required Map<String, dynamic> mcqData,
//     required int mcqCount,
//     required bool timerEnabled,
//     required int timerMinutes,
//   }) {
//     _isLoading = true;
//     notifyListeners();

//     try {
//       if (mcqData['questions'] != null) {
//         _mcqs = (mcqData['questions'] as List).map((q) => 
//           Mcq(
//             question: q['question'],
//             options: List<String>.from(q['options']),
//             answer: String.fromCharCode(65 + q['correctIndex']),
//           )
//         ).toList();
//       } else {
//         _generateSampleMCQs();
//       }

//       _selectedAnswers = List.filled(_mcqs.length, null);
//       _currentIndex = 0;
//       _score = 0;
//       _isAnswered = false;
//       _testCompleted = false;

//       if (timerEnabled) {
//         _remainingSeconds = timerMinutes * 60;
//         _startTimer();
//       }

//       _isLoading = false;
//       notifyListeners();
//     } catch (e) {
//       _error = e.toString();
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   void _generateSampleMCQs() {
//     _mcqs = [
//       Mcq(question: "What is the capital of France?", options: ["London", "Paris", "Berlin", "Madrid"], answer: "B"),
//       Mcq(question: "Which planet is known as the Red Planet?", options: ["Venus", "Mars", "Jupiter", "Saturn"], answer: "B"),
//       Mcq(question: "What is 2 + 2?", options: ["3", "4", "5", "6"], answer: "B"),
//     ];
//   }

//   void _startTimer() {
//     _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       _remainingSeconds--;
//       if (_remainingSeconds <= 0) {
//         endTest();
//       }
//       notifyListeners();
//     });
//   }

//   void selectOption(int index) {
//     if (_isAnswered) return;

//     _selectedAnswers[_currentIndex] = index;
//     _isAnswered = true;

//     String selectedLetter = String.fromCharCode(65 + index);
//     if (selectedLetter == _mcqs[_currentIndex].answer) {
//       _score++;
//     }

//     notifyListeners();
//   }

//   void nextQuestion() {
//     if (_currentIndex < _mcqs.length - 1) {
//       _currentIndex++;
//       _isAnswered = false;
//       notifyListeners();
//     } else {
//       endTest();
//     }
//   }

//   void endTest() {
//     _countdownTimer?.cancel();
//     _testCompleted = true;
//     notifyListeners();
//   }

//   bool isCorrectOption(int optionIndex) {
//     if (!_isAnswered) return false;
//     String correctLetter = _mcqs[_currentIndex].answer;
//     int correctIndex = correctLetter.codeUnitAt(0) - 65;
//     return optionIndex == correctIndex;
//   }

//   bool isSelectedOption(int optionIndex) {
//     return _selectedAnswers[_currentIndex] == optionIndex;
//   }

//   String formatTime(int seconds) {
//     int minutes = seconds ~/ 60;
//     int remainingSeconds = seconds % 60;
//     return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
//   }

//   @override
//   void dispose() {
//     _countdownTimer?.cancel();
//     super.dispose();
//   }
// }