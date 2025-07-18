import 'package:flutter/material.dart';

class ExamScreen extends StatefulWidget {
  final int lessonId;

  const ExamScreen({super.key, required this.lessonId});

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  late Future<List<Map<String, dynamic>>> questionsFuture;
  int score = 0;
  final Map<int, String> selectedAnswers = {};
  List<Map<String, dynamic>> questions = []; // تم نقل التعريف هنا وتهيئته بقائمة فارغة

  @override
  void initState() {
    super.initState();
    questionsFuture = _fetchQuestionsForLesson();
  }

  Future<List<Map<String, dynamic>>> _fetchQuestionsForLesson() async {
    // سيتم استبدال هذا بالاتصال بـ Supabase لاحقًا
    return [
      {
        "question_text": "ما هو معنى كلمة 'Apple'؟",
        "options": ["تفاحة", "موزة", "سيارة", "شجرة"],
        "correct_answer": "A",
        "explanation": "Apple تعني تفاحة.",
      },
      {
        "question_text": "ما هو الجملة الصحيحة؟",
        "options": ["He go school", "He goes to school", "He going school", "He went school"],
        "correct_answer": "B",
        "explanation": "He goes to school هو الجملة الصحيحة.",
      },
    ];
  }

  void _submitAnswers() {
    score = 0;

    for (var i = 0; i < selectedAnswers.length; i++) {
      final userAnswer = selectedAnswers[i];
      final correctAnswer = questions[i]['correct_answer'];

      if (userAnswer == correctAnswer) {
        score++;
      }
    }

    _showResultDialog();
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('النتيجة'),
        content: Text('أجبت بشكل صحيح على $score من ${selectedAnswers.length} سؤال'),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: const Text('حسنًا'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: questionsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Scaffold(
            body: Center(child: Text("لا توجد أسئلة لهذا الدرس")),
          );
        }

        // تعيين القيمة للمتغير questions
        questions = snapshot.data!;

        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
            title: const Text("امتحان الدرس",style: TextStyle(
              color: Colors.white,
            ),),
            backgroundColor: Colors.deepPurple,
          ),
          body: ListView.builder(
            itemCount: questions.length,
            itemBuilder: (context, index) {
              final question = questions[index];
              final options = question['options'] as List;

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          question['question_text'],
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          textDirection: TextDirection.rtl,
                        ),
                        const SizedBox(height: 10),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: options.length,
                          itemBuilder: (context, optionIndex) {
                            final optionLetter = String.fromCharCode(65 + optionIndex); // A, B, C, D
                            final selected = selectedAnswers[index] == optionLetter;

                            return Directionality(
                              textDirection: TextDirection.rtl,
                              child: ListTile(
                                title: Text('$optionLetter - ${options[optionIndex]}'),
                                leading: Radio<String>(
                                  value: optionLetter,
                                  groupValue: selectedAnswers[index],
                                  onChanged: (value) {
                                    setState(() {
                                      selectedAnswers[index] = value!;
                                    });
                                  },
                                ),
                                tileColor: selected ? Colors.deepPurple.withOpacity(0.1) : null,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        if (question.containsKey('explanation') && selectedAnswers[index] != null)
                          Text(
                            "الشرح: ${question['explanation']}",
                            style: const TextStyle(color: Colors.grey),
                            textDirection: TextDirection.rtl,
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: Colors.deepPurple,
            onPressed: selectedAnswers.length == questions.length ? _submitAnswers : null,
            icon: const Icon(Icons.check,
            color: Colors.white,),
            label: const Text("تقييم الإجابات",style: TextStyle(
              color: Colors.white,
            ),),
          ),
        );
      },
    );
  }
}