import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

extension Log on Object {
  void log() => devtools.log(toString());
}

const url =
    "https://55hogzih3c.execute-api.ap-south-1.amazonaws.com/dev/api/quizes";

Future<Iterable<Quiz>> parseJson() => HttpClient()
    .getUrl(Uri.parse(url))
    .then((req) => req.close())
    .then((res) => res.transform(const Utf8Decoder()).join())
    .then((str) => json.decode(str) as List<dynamic>)
    .then((json) => json.map((e) => Quiz.fromJson(e)));

void testit() async {
  final quiz = await parseJson();
  quiz.log();
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    testit();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dummy"),
      ),
      body: const Center(
        child: Text("Dummy App"),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Dummy App",
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

void main() async {
  runApp(const MyApp());
}

class Quiz {
  Quiz({
    required this.quizId,
    required this.quizTitle,
    required this.timer,
    required this.questions,
    required this.createdAt,
    required this.updatedAt,
  });

  int quizId;
  String quizTitle;
  String timer;
  List<Question> questions;
  DateTime createdAt;
  DateTime updatedAt;

  factory Quiz.fromJson(Map<String, dynamic> json) => Quiz(
        quizId: json["quiz_id"],
        quizTitle: json["quiz_title"],
        timer: json["timer"],
        questions: List<Question>.from(
            json["questions"].map((x) => Question.fromJson(x))),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  @override
  String toString() => "Quiz $quizTitle , and ID is $quizId  \n";
}

class Question {
  Question({
    required this.questionNumber,
    required this.title,
    required this.answer,
    required this.options,
  });

  int questionNumber;
  String title;
  String answer;
  Map<String, String> options;

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        questionNumber: json["question_number"],
        title: json["title"],
        answer: json["answer"],
        options: Map.from(json["options"])
            .map((k, v) => MapEntry<String, String>(k, v)),
      );
}
