import 'package:appproy/screens/home_screen.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

class ResultBox extends StatefulWidget {
  const ResultBox({super.key, required this.result, required this.questionLength, required this.onPressed});

  final int result;
  final int questionLength;
  final VoidCallback onPressed;

  @override
  _ResultBoxState createState() => _ResultBoxState();
}

class _ResultBoxState extends State<ResultBox> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Color _circleColor;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _circleColor = _calculateCircleColor(widget.result);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _calculateCircleColor(int result) {
    return result == widget.questionLength ~/ 2
        ? Colors.yellow
        : result < widget.questionLength ~/ 2
        ? incorrect
        : correct;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: background,
      content: Padding(
        padding: const EdgeInsets.all(60.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Total',
              style: TextStyle(color: neutral, fontSize: 30.0),
            ),
            const SizedBox(height: 20.0),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.scale(
                  scale: _animation.value,
                  child: CircleAvatar(
                    radius: 70.0,
                    backgroundColor: _circleColor,
                    child: Text(
                      '${widget.result}/${widget.questionLength}',
                      style: const TextStyle(
                        fontSize: 30.0,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(
              height: 20.0,
            ),
            Text(
              widget.result == widget.questionLength ~/ 2
                  ? 'Casi'
                  : widget.result < widget.questionLength ~/ 2
                  ? 'Inténtalo de nuevo'
                  : 'Buena esa mi papacho',
              style: const TextStyle(color: neutral, fontSize: 20.0),
            ),
            const SizedBox(
              height: 25.0,
            ),
            GestureDetector(
              onTap: widget.onPressed,
              child: const Text(
                'Empezar de nuevo',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20.0,
                  letterSpacing: 10.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
