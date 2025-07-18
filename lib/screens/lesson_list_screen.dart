import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:daily_english/screens/lesson_detail_screen.dart';

class LessonListScreen extends StatelessWidget {
  const LessonListScreen({super.key});

  Future<List<Map<String, dynamic>>> fetchLessons() async {
    try {
      final client = Supabase.instance.client;
      final response = await client
          .from('lessons')
          .select()
          .order('lesson_order', ascending: true);
      
      print('Fetched lessons: ${response.length}');
      return response;
    } catch (e) {
      print('Error fetching lessons: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.deepPurple,
        title: const Text('الدروس', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchLessons(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('حدث خطأ: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('لا توجد دروس متاحة حالياً'));
          }

          final lessons = snapshot.data!;

          return RefreshIndicator(
            onRefresh: () async {
              // يمكنك إضافة تحديث البيانات هنا إذا أردت
            },
            child: ListView.builder(
              itemCount: lessons.length,
              itemBuilder: (context, index) {
                final lesson = lessons[index];

                return Directionality(
                  textDirection: TextDirection.rtl,
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 16),
                    elevation: 3,
                    child: ListTile(
                      title: Text(
                        lesson['title_ar'] ?? 'عنوان غير موجود',
                        textAlign: TextAlign.right,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        lesson['title_en'] ?? 'Lesson Title',
                        textAlign: TextAlign.right,
                        style: const TextStyle(color: Colors.blueGrey),
                      ),
                      trailing: CircleAvatar(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        child: Text('${lesson['lesson_order']}'),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                LessonDetailScreen(lesson: lesson),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}