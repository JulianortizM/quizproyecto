import 'dart:async';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../constants.dart';
import '../models/question_model.dart';
import '../widgets/question_widget.dart';
import '../widgets/next_button.dart';
import '../widgets/option_card.dart';
import '../widgets/result_box.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;
  int score = 0;
  bool isPressed = false;
  bool isAlreadySelected = false;
  int timerSeconds = 30;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timerSeconds > 0) {
        setState(() {
          timerSeconds--;
        });
      } else {
        timer.cancel();
        nextQuestion();
      }
    });
  }

  void nextQuestion() {
    _timer.cancel(); // Cancelamos el temporizador existente antes de avanzar a la siguiente pregunta.
    if (index == _questions.length - 1) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => ResultBox(
          result: score,
          questionLength: _questions.length,
          onPressed: startOver,
        ),
      );
    } else {
      if (isPressed) {
        setState(() {
          index++;
          isPressed = false;
          isAlreadySelected = false;
          timerSeconds = 30; // Reiniciamos el temporizador al avanzar a la siguiente pregunta
          startTimer(); // Iniciamos el nuevo temporizador
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No piense saltarse la pregunta, conteste mejor.'),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.symmetric(vertical: 20.0),
          ),
        );
      }
    }
  }

  void checkAnswerAndUpdate(bool value) {
    if (isAlreadySelected) {
      return;
    } else {
      if (value == true) {
        score++;
      }
      setState(() {
        isPressed = true;
        isAlreadySelected = true;
      });
    }
  }

  void startOver() {
    setState(() {
      index = 0;
      score = 0;
      isPressed = false;
      isAlreadySelected = false;
      timerSeconds = 30; // Reiniciamos el temporizador al iniciar de nuevo
    });
    startTimer(); // Iniciamos el nuevo temporizador
    Navigator.pop(context);
  }

  List<Question> _questions = [
    Question(
      id: '1',
      title: '¿Cuál de las siguientes etiquetas se utiliza para definir un párrafo en HTML?',
      options: {'<p>': true, '<h1>': false, '<div>': false, '<span>': false},
    ),
    Question(
      id: '2',
      title: '¿Qué significa CSS en desarrollo web?',
      options: {'Cascading Style Sheets': true, 'Central Style System': false, 'Computer Style Sheets': false, 'Creative Style Sheets': false},
    ),
    Question(
      id: '3',
      title: '¿Qué lenguaje de programación se utiliza principalmente para la interactividad en el lado del cliente en el desarrollo web?',
      options: {'JavaScript': true, 'Python': false, 'Java': false, 'PHP': false},
    ),
    Question(
      id: '4',
      title: '¿Qué atributo de HTML se utiliza para especificar la dirección de un enlace?',
      options: {'href': true, 'src': false, 'link': false, 'url': false},
    ),
    Question(
      id: '5',
      title: '¿Cuál de los siguientes no es un método HTTP?',
      options: {'PUT': false, 'MOVE': true, 'DELETE': true, 'POST': false},
    ),
    Question(
      id: '6',
      title: '¿Qué significa AJAX en el contexto del desarrollo web?',
      options: {'Asynchronous JavaScript and XML': true, 'Advanced JavaScript and XML': false, 'All JavaScript and XML': false, 'Automatic JavaScript and XML': false},
    ),
    Question(
      id: '7',
      title: '¿Cuál de las siguientes no es una técnica para mejorar la optimización de un sitio web?',
      options: {'SCSS': false, 'Minificación': false, 'Compresión de imágenes': false, 'Responsive Design': true},
    ),
    Question(
      id: '8',
      title: '¿Cuál de las siguientes no es una librería de JavaScript ampliamente utilizada?',
      options: {'React': false, 'Vue': false, 'Python': true, 'Angular': false},
    ),
    Question(
      id: '9',
      title: '¿Qué etiqueta de HTML se utiliza para hacer una lista ordenada?',
      options: {'<ol>': true, '<ul>': false, '<li>': false, '<dl>': false},
    ),
    Question(
      id: '10',
      title: '¿Cuál de los siguientes NO es un lenguaje de marcado?',
      options: {'Python': true, 'HTML': false, 'XML': false, 'Markdown': true},
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text('Quiz App'),
        backgroundColor: background,
        shadowColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(
              'Puntuación: $score',
              style: const TextStyle(
                fontSize: 18.0,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          children: [
            QuestionWidget(
              indexAction: index,
              question: _questions[index].title,
              totalQuestions: _questions.length,
            ),
            const Divider(color: Colors.indigo),
            const SizedBox(height: 25.0),
            Text(
              'Tiempo restante: $timerSeconds segundos',
              style:const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            for (int i = 0; i < _questions[index].options.length; i++)
              GestureDetector(
                onTap: () =>
                    checkAnswerAndUpdate(_questions[index].options.values.toList()[i]),
                child: OptionCard(
                  option: _questions[index].options.keys.toList()[i],
                  color: isPressed
                      ? _questions[index].options.values.toList()[i] == true
                      ? correct
                      : incorrect
                      : const Color(0xFFFFFFFF),
                ),
              ),
            const SizedBox(height: 20),
            if (index == _questions.length - 1) ...[
              ResultChart(correct: score, incorrect: _questions.length - score),
            ],
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: NextButton(
          nextQuestion: nextQuestion,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class ResultChart extends StatelessWidget {
  final int correct;
  final int incorrect;

  const ResultChart({super.key, required this.correct, required this.incorrect});

  @override
  Widget build(BuildContext context) {
    List<charts.Series<ResultData, String>> series = [
      charts.Series(
        id: "Resultados",
        data: [
          ResultData(label: "Correctas", value: correct),
          ResultData(label: "Incorrectas", value: incorrect),
        ],
        domainFn: (ResultData series, _) => series.label,
        measureFn: (ResultData series, _) => series.value,
      )
    ];

    return Container(
      height: 200,
      padding:const EdgeInsets.all(10),
      child: charts.BarChart(
        series,
        animate: true,
        barGroupingType: charts.BarGroupingType.grouped,
      ),
    );
  }
}

class ResultData {
  final String label;
  final int value;

  ResultData({required this.label, required this.value});
}
