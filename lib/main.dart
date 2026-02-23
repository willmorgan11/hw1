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
  String firstOperand = '';
  String currentOperator = '';
  bool awaitingSecondOperand = false;
  bool hasError = false;

  // button labels
  final List<String> buttonLabels = [
    '7', '8', '9', '/',
    '4', '5', '6', '*',
    '1', '2', '3', '-',
    'AC', '0', '=', '+',
  ];

  // performs the arithmetic and returns result as a string
  String? calculate(String a, String op, String b) {
    int numA = int.parse(a);
    int numB = int.parse(b);
    if (op == '/' && numB == 0) return null;
    switch (op) {
      case '+': return (numA + numB).toString();
      case '-': return (numA - numB).toString();
      case '*': return (numA * numB).toString();
      case '/': return (numA ~/ numB).toString();
      default:  return b;
    }
  }

  // operators
  final Set<String> operators = {'+', '-', '*', '/', '='};

  void onButtonPressed(String label) {
    setState(() {
      if (hasError && label != 'AC') return; // only AC works if there is an error
      if (label == 'AC') {
        // reset
        displayText = '0';
        firstOperand = '';
        currentOperator = '';
        awaitingSecondOperand = false;
        hasError = false;
      } 
      else if (operators.contains(label) && label != '=') {
        // store first operand and operator
        firstOperand = displayText;
        currentOperator = label;
        awaitingSecondOperand = true;
      } 
      else if (label == '=') {
        if (firstOperand.isEmpty || currentOperator.isEmpty || awaitingSecondOperand) {
          displayText = 'Error: incomplete input, press AC';
          hasError = true;
          return;
        }
        final result = calculate(firstOperand, currentOperator, displayText);
        if (result == null) {
          displayText = 'Error: cannot divide by 0, press AC';
          hasError = true;
        } 
        else {
          displayText = result;
          firstOperand = '';
          currentOperator = '';
          awaitingSecondOperand = false;
        }
      }
      else {
        if (awaitingSecondOperand) {
          displayText = label;
          awaitingSecondOperand = false;
        } 
        else {
          displayText = (displayText == '0') ? label : displayText + label;
        }
      }
    });
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
                style: TextStyle(fontSize: hasError ? 24 : 48, color: Colors.white),
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