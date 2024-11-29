import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  static const int MAX_DIGITS = 15;
  static const int MAX_DECIMALS = 10;
  String expression = "";
  String result = "0";
  String previousResult = "";
  List<String> history = [];
  bool isErrorShowing = false;

  double _calculateFontSize(String text, double baseSize) {
    if (text == "Cannot divide by zero") return baseSize * 0.5;
    if (text.length <= 12) return baseSize;
    if (text.length <= 15) return baseSize * (12 / text.length);
    return baseSize * (12 / 15);
  }

  void showErrorMessage(String message) {
    if (!isErrorShowing) {
      isErrorShowing = true;
      ScaffoldMessenger.of(context)
          .showSnackBar(
            SnackBar(
              content: Text(
                message,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.black,
                ),
              ),
              duration: const Duration(seconds: 2),
              backgroundColor: const Color.fromARGB(255, 235, 231, 230),
            ),
          )
          .closed
          .then((_) => isErrorShowing = false);
    }
  }

  // Rest of the code stays exactly the same as in your existing implementation
  Widget calcButton(String btnText, Color btnColor, Color textColor) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          double size = constraints.maxWidth < 360 ? 60 : 80;
          return SizedBox(
            width: size,
            height: size,
            child: ElevatedButton(
              onPressed: () => onBtnTap(btnText),
              style: ElevatedButton.styleFrom(
                backgroundColor: btnColor,
                shape: const CircleBorder(),
                padding: EdgeInsets.zero,
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  btnText,
                  style: TextStyle(
                    fontSize: size * 0.3,
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Calculator'),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: showHistory,
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double expressionBaseSize = constraints.maxWidth * 0.08;
            double resultBaseSize = constraints.maxWidth * 0.12;
            
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: constraints.maxHeight * 0.3,
                        alignment: Alignment.bottomRight,
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              expression.isEmpty ? "" : expression,
                              style: TextStyle(
                                fontSize: _calculateFontSize(expression, expressionBaseSize),
                                color: Colors.white70,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.visible,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              result,
                              style: TextStyle(
                                fontSize: _calculateFontSize(result, resultBaseSize),
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.visible,
                            ),
                          ],
                        ),
                      ),
                      ...List.generate(6, (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: _getRowButtons(index, constraints),
                          ),
                        );
                      }),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _getRowButtons(int rowIndex, BoxConstraints constraints) {
    switch (rowIndex) {
      case 0:
        return [
          calcButton('⌫', Colors.grey, Colors.black),
          calcButton('(', Colors.grey, Colors.black),
          calcButton(')', Colors.grey, Colors.black),
          calcButton('√', Colors.amber, Colors.white),
        ];
      case 1:
        return [
          calcButton('C', Colors.grey, Colors.black),
          calcButton('±', Colors.grey, Colors.black),
          calcButton('%', Colors.grey, Colors.black),
          calcButton('÷', Colors.amber, Colors.white),
        ];
      case 2:
        return [
          calcButton('7', Colors.grey, Colors.white),
          calcButton('8', Colors.grey, Colors.white),
          calcButton('9', Colors.grey, Colors.white),
          calcButton('x', Colors.amber, Colors.white),
        ];
      case 3:
        return [
          calcButton('4', Colors.grey, Colors.white),
          calcButton('5', Colors.grey, Colors.white),
          calcButton('6', Colors.grey, Colors.white),
          calcButton('-', Colors.amber, Colors.white),
        ];
      case 4:
        return [
          calcButton('1', Colors.grey, Colors.white),
          calcButton('2', Colors.grey, Colors.white),
          calcButton('3', Colors.grey, Colors.white),
          calcButton('+', Colors.amber, Colors.white),
        ];
      case 5:
        double buttonWidth = constraints.maxWidth < 360 ? 140 : 180;
        return [
          SizedBox(
            width: buttonWidth,
            height: constraints.maxWidth < 360 ? 60 : 80,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade900,
                shape: const StadiumBorder(),
                padding: EdgeInsets.zero,
              ),
              onPressed: () => onBtnTap('0'),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  '0',
                  style: TextStyle(
                    fontSize: constraints.maxWidth * 0.08,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          calcButton('.', Colors.grey.shade900, Colors.white),
          calcButton('=', Colors.amber, Colors.white),
        ];
      default:
        return [];
    }
  }

  void onBtnTap(String value) {
    setState(() {
      switch (value) {
        case '⌫':
          delete();
          break;
        case 'C':
          clearAll();
          break;
        case '=':
          calculate();
          break;
        case '√':
          appendValue("√(");
          break;
        case '±':
          toggleSign();
          break;
        case '×':
          appendValue('*');
          break;
        case '÷':
          appendValue('/');
          break;
        default:
          appendValue(value);
      }
    });
  }

  void clearAll() {
    expression = "";
    result = "0";
    previousResult = "";
  }

  void delete() {
    if (expression.isNotEmpty) {
      expression = expression.substring(0, expression.length - 1);
      if (expression.isEmpty) {
        result = "0";
      }
    }
  }

  void appendValue(String value) {
    if (expression == "Error") {
      expression = "";
      return;
    }
    
    int digitCount = expression.replaceAll(RegExp(r'[^0-9]'), '').length;
    
    if (digitCount >= MAX_DIGITS && '0123456789'.contains(value)) {
      showErrorMessage('Cannot enter more than 15 digits');
      return;
    }
    
    if (previousResult.isNotEmpty && '0123456789.'.contains(value)) {
      expression = value;
      previousResult = "";
    } else if (previousResult.isNotEmpty) {
      expression = previousResult + value;
      previousResult = "";
    } else {
      expression += value;
    }
  }

  void toggleSign() {
    if (expression.isNotEmpty) {
      if (expression.startsWith('-')) {
        expression = expression.substring(1);
      } else {
        expression = "-$expression";
      }
    } else if (result != "0") {
      expression = "-$result";
      previousResult = "";
    }
  }

  String formatNumber(double number) {
    String numStr = number.toStringAsFixed(MAX_DECIMALS);
    
    if (numStr.contains('.')) {
      numStr = numStr.replaceAll(RegExp(r'0*$'), '');
      if (numStr.endsWith('.')) {
        numStr = numStr.substring(0, numStr.length - 1);
      }
    }
    
    if (numStr.replaceAll(RegExp(r'[^0-9]'), '').length > MAX_DIGITS) {
      String integerPart = number.truncate().toString();
      int remainingDigits = MAX_DIGITS - integerPart.length;
      if (remainingDigits > 0) {
        numStr = number.toStringAsFixed(remainingDigits);
        numStr = numStr.replaceAll(RegExp(r'0*$'), '');
        if (numStr.endsWith('.')) {
          numStr = numStr.substring(0, numStr.length - 1);
        }
      } else {
        numStr = integerPart;
      }
    }
    
    return numStr;
  }

  void calculate() {
    if (expression.isEmpty) return;

    try {
      String parsedExpression = handleAdjacentParentheses(expression)
          .replaceAll('x', '*')
          .replaceAll('÷', '/')
          .replaceAll('%', '/100')
          .replaceAll("√", "sqrt");

      if (parsedExpression.contains('/0')) {
        setState(() {
          result = "Cannot divide by zero";
          expression = "";
          previousResult = "";
        });
        showErrorMessage('Cannot divide by zero');
        return;
      }

      Parser parser = Parser();
      Expression exp = parser.parse(parsedExpression);
      ContextModel contextModel = ContextModel();

      double eval = exp.evaluate(EvaluationType.REAL, contextModel);
      
      if (eval.isInfinite || eval.isNaN) {
        setState(() {
          result = "Error";
        });
        showErrorMessage('Invalid operation');
      } else {
        result = formatNumber(eval);
      }
      
      previousResult = result;
      history.add("$expression = $result");
      expression = "";
      
    } catch (e) {
      setState(() {
        result = "Error";
        expression = "";
        previousResult = "";
      });
      showErrorMessage('Invalid expression');
    }
  }

  String handleAdjacentParentheses(String expression) {
    String result = expression;
    result = result.replaceAllMapped(RegExp(r'(\d)(\()'), (match) => '${match.group(1)}*${match.group(2)}');
    result = result.replaceAllMapped(RegExp(r'(\))(\d)'), (match) => '${match.group(1)}*${match.group(2)}');
    result = result.replaceAllMapped(RegExp(r'\)(\()'), (match) => ')*(');
    return result;
  }

  void showHistory() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            constraints: const BoxConstraints(maxHeight: 300),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppBar(
                  title: const Text('History'),
                  automaticallyImplyLeading: false,
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.clear_all),
                      onPressed: () {
                        setState(() {
                          history.clear();
                        });
                        Navigator.pop(context);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: history.length,
                    itemBuilder: (context, index) {
                      final entry = history[history.length - 1 - index];
                      return ListTile(
                        title: Text(entry),
                        onTap: () {
                          setState(() {
                            expression = entry.split("=")[0].trim();
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
