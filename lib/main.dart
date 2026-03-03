import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(home: StudentApp(), debugShowCheckedModeBanner: false),
  );
}

class StudentApp extends StatefulWidget {
  const StudentApp({super.key});

  @override
  State<StudentApp> createState() => _StudentAppState();
}

class _StudentAppState extends State<StudentApp> {
  int energy = 50;
  String emoji = '👨‍🎓';
  String message = 'Вітаю в універі! Введи щось, щоб почати.';

  final controller = TextEditingController();

  void processAction() {
    final input = controller.text.trim().toLowerCase();
    final int? hours = int.tryParse(input);

    setState(() {
      if (hours != null) {
        if (hours > 0) {
          energy += hours * 10;
          emoji = '😴';
          message = 'Ти поспав $hours год. Сон — це розкіш!';
        } else if (hours == 0) {
          emoji = '😐';
          message = '0 годин сну... ну ти і живеш';
        } else {
          emoji = '🤡';
          message = 'Від\'ємний сон? Ти що, винайшов машину часу?';
        }
      } else if (input == 'lab') {
        energy -= 15;
        emoji = '👨‍💻';
        message = 'Лабу здав! Але мінус енергія...';
      } else if (input == 'exam') {
        energy -= 40;
        emoji = '📚';
        message = 'Сесія висмоктує душу. Тримайся!';
      } else if (input == 'project') {
        energy -= 30;
        emoji = '😫';
        message = 'Курсач сам себе не напише. Енергія падає.';
      } else if (input == 'red bull') {
        energy += 25;
        emoji = '⚡';
        message = 'Ред Булл надає крила!';
      } else if (input == 'avada kedavra') {
        energy = 0;
        emoji = '💀';
        message = 'Тебе відраховано. Game Over.';
      } else {
        emoji = '❓';
        message = 'Студент не знає команди "$input"';
      }

      if (energy > 100) energy = 100;
      if (energy < 0) energy = 0;

      if (energy == 0 && input != 'avada kedavra') {
        emoji = '🪫';
        message = 'Енергія на нулі. Тобі терміново треба Red Bull або сон!';
      }
    });

    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Survival Guide: Student Edition'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 100)),
            const SizedBox(height: 10),

            LinearProgressIndicator(
              value: energy / 100,
              minHeight: 15,
              color: energy > 30 ? Colors.green : Colors.red,
            ),

            const SizedBox(height: 10),

            Text(
              'Енергія: $energy%',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 30),

            TextField(
              controller: controller,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
                labelText: 'Введи: lab, exam, project, red bull або години сну',
              ),
              onSubmitted: (_) => processAction(),
            ),
            const SizedBox(height: 15),

            ElevatedButton(
              onPressed: processAction,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
              ),
              child: const Text(
                'Виконати',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
