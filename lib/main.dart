import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey)),
      home: const CalculatorHome(),
    );
  }
}

class CalculatorHome extends StatefulWidget {
  const CalculatorHome({super.key});

  @override
  State<CalculatorHome> createState() => _CalculatorHomeState();
}

class _CalculatorHomeState extends State<CalculatorHome> {
  String displayText = '0';

  // button labels
  final List<String> buttonLabels = [
    '7', '8', '9', '/',
    '4', '5', '6', '*',
    '1', '2', '3', '-',
    'AC', '0', '=', '+',
  ];

  // operators
  final Set<String> operators = {'+', '-', '*', '/', '='};

  void onButtonPressed(String label) {
    // logic will be added here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calculator')),
      body: Column(
        children: [
          // display area
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(24),
              color: Colors.blueGrey,
              child: Text(
                displayText,
                style: const TextStyle(fontSize: 48, color: Colors.white),
              ),
            ),
          ),
          // button grid
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            padding: const EdgeInsets.all(8),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children: buttonLabels.map((label) {
              final bool isOperator = operators.contains(label);
              final bool isAC = label == 'AC';
              return ElevatedButton(
                onPressed: () => onButtonPressed(label),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isAC
                      ? Colors.redAccent
                      : isOperator
                          ? Colors.blueGrey
                          : Colors.grey,
                  foregroundColor: isOperator || isAC ? Colors.white : Colors.white,
                  textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(label),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}