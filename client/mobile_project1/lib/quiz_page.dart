import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage>
    with SingleTickerProviderStateMixin {
  // 1. Logic State
  List questions = [];
  int currentQuestionIndex = 0;
  int score = 0;
  bool isLoading = true;

  // 2. Animation State
  late AnimationController _controller;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    fetchQuestions(); // Load data from XAMPP
  }

  // 3. API Connection
  Future<void> fetchQuestions() async {
    try {
      // Use 10.0.2.2 for Android Emulator, or your Local IP for real devices
      final response = await http.get(
        Uri.parse('https://dbconnection-9gdi.onrender.com/get_questions.php'),
      );

      if (response.statusCode == 200) {
        setState(() {
          questions = json.decode(response.body);
          isLoading = false;
        });
        _controller.forward();
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  void answerQuestion(String selectedAnswer, String correctAnswer) {
    if (selectedAnswer == correctAnswer) {
      score++;
    }

    setState(() {
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
        _controller.reset();
        _controller.forward();
      } else {
        showFinishedDialog();
      }
    });
  }

  void showFinishedDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF0B3D2E),
        title: const Text(
          'Quiz Finished!',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Your score is $score/${questions.length}',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                currentQuestionIndex = 0;
                score = 0;
              });
              _controller.forward();
            },
            child: const Text('Restart', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 4. Loading State View
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF0B3D2E),
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    final question = questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF116530),
        centerTitle: true,
        title: const Text(
          '⚽ Football Quiz',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0B3D2E), Color(0xFF116530)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: FadeTransition(
          opacity: _fadeAnim,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // Question Card
                Container(
                  padding: const EdgeInsets.all(24),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white24, width: 2),
                  ),
                  child: Text(
                    question['question'], // From PHP: "question"
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // Answer Buttons
                ...(question['answers'] as List).map(
                  (answer) => Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: const Color(0xFF9BEC00),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () =>
                          answerQuestion(answer['text'], question['correct']),
                      child: Text(
                        answer['text'],
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
