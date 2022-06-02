import 'dart:async';

import 'package:flutter/material.dart';


import '../../../screens/newHome.dart';
import '../../cis/logic/answer.dart';
import '../../cis/logic/question.dart';


class Quiz extends StatefulWidget {
  const Quiz(
    this.d4,
    this.questionIndex,
    this.answerQuestion, {
    Key? key,
  }) : super(key: key);

  final List<Map<String, Object>> d4;
  final int questionIndex;
  final Function(int s) answerQuestion;

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  Timer? countdownTimer;
  Duration myDuration = const Duration(minutes: 10);

  /// Timer related methods ///
  // Step 3
  void startTimer() {
    countdownTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
  }

  // Step 4
  void stopTimer() {
    setState(() => countdownTimer!.cancel());
  }

  void setCountDown() {
    const reduceSecondsBy = 1;
    setState(() {
      final seconds = myDuration.inSeconds - reduceSecondsBy;
      if (seconds < 0) {
        countdownTimer!.cancel();
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const MyHomePage(),
        ));
      } else {
        myDuration = Duration(seconds: seconds);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    countdownTimer!.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
     String strDigits(int n) => n.toString().padLeft(2, '0');
    final days = strDigits(myDuration.inDays);
    // Step 7
    final hours = strDigits(myDuration.inHours.remainder(24));
    final minutes = strDigits(myDuration.inMinutes.remainder(60));
    final seconds = strDigits(myDuration.inSeconds.remainder(60));
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
            Text(
          '$hours:$minutes:$seconds',
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 199, 219, 21),
              fontSize: 50),
        ),
        Question(widget.d4[widget.questionIndex]['questionText'].toString()),
        ...(widget.d4[widget.questionIndex]['answers'] as List<Map<String, Object>>)
            .map((answer) {
          return Answer(
              () => widget.answerQuestion(int.parse(answer['score'].toString())),
              answer['text'].toString());
        }).toList(),

      ],
    );
  }
}
