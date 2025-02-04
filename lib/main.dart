import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GitHub Copilot Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final TextEditingController _controller = TextEditingController();
  String _expression = '';

  void _onPressed(String value) {
    setState(() {
      if (value == 'C') {
        _expression = '';
      } else if (value == '=') {
        try {
          final expression = Expression.parse(_expression);
          final evaluator = const ExpressionEvaluator();
          final result = evaluator.eval(expression, {});
          _expression += ' = $result';
        } catch (e) {
          _expression = 'Error';
        }
      } else if (value == 'x²') {
        try {
          final expression = Expression.parse('($_expression) * ($_expression)');
          final evaluator = const ExpressionEvaluator();
          final result = evaluator.eval(expression, {});
          _expression = '$result';
        } catch (e) {
          _expression = 'Error';
        }
      } else if (value == 'No more math!') {
        _expression = 'No more math!';
      } else {
        if (_expression.contains('=')) {
          _expression = value;
        } else {
          _expression += value;
        }
      }
      _controller.text = _expression;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GitHub Copilot Calculator'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.centerRight,
              child: TextField(
                controller: _controller,
                style: const TextStyle(fontSize: 32),
                textAlign: TextAlign.right,
                readOnly: true,
                decoration: const InputDecoration(border: InputBorder.none),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: GridView.count(
              crossAxisCount: 4,
              children: [
                _buildButton('7'), _buildButton('8'), _buildButton('9'), _buildButton('/'),
                _buildButton('4'), _buildButton('5'), _buildButton('6'), _buildButton('*'),
                _buildButton('1'), _buildButton('2'), _buildButton('3'), _buildButton('-'),
                _buildButton('0'), _buildButton('C'), _buildButton('='), _buildButton('+'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _onPressed('x²'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('x²', style: TextStyle(fontSize: 24)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _onPressed('No more math!'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('No more math!', style: TextStyle(fontSize: 24)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String value) {
    return ElevatedButton(
      onPressed: () => _onPressed(value),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(value, style: const TextStyle(fontSize: 24)),
    );
  }
}