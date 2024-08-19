import 'package:calculadora_dart/calculadora_dart.dart' as calculadora_dart;
import 'dart:io';
void main(List<String> arguments) {
  apresentacao();
  executavel();
}

void apresentacao() {
  print(''' 
  Programação para dispositivos móveis
  Professor: Alisson Fereira
  Grupo composto por: Marcos Pereira, João Eduardo, Lucas Manoel
  
      __  _   __   __  ___       _____         __              __         __            
  __ / / | | / /  /  |/  /      / ___/ ___ _  / / ____ __ __  / / ___ _  / /_ ___   ____
 / // /  | |/ /  / /|_/ /      / /__  / _ `/ / / / __// // / / / / _ `/ / __/|   | / __/
/___ /   |___/  /_/  /_/      /___/  /_,_/| /_/ /___  |_,_/ /_/ |_,_/| /__/  |___|/_/|   

Seja bem-vindo(a) à Calculadora JVM!
Esta aplicação permite que você realize as operações básicas de cálculo.
Você pode iniciar digitando uma expressão contendo números e um dos seguintes operadores:
Soma(+), subtração(-), multiplicação(*), divisão(/).
A operação será executada e o resultado será exibido.
                                                                                      
''');
}

List<String> dividirEmKeys (String input) {
  RegExp exp = RegExp(r'(\d+\.?\d*|\+|\-|\*|\/)');
  Iterable<Match> matches = exp.allMatches(input);
  return matches.map((m) => m.group(0)!).toList();
}

bool isOperator (String key) {
  return key == '+' || key == '-' || key == '*' || key == '/';
}

String tratarOperadoresConsecutivos(String input) {
  input = input.replaceAll('++', '+');
  input = input.replaceAll('--', '+');
  input = input.replaceAll('+-', '-');
  input = input.replaceAll('-+', '-');
  return input;
}

double executarOperacao(double num1, double num2, String operador) {
  switch (operador) {
    case '+' :
      return num1 + num2;
    case '-' :
      return num1 - num2;
    case '*' :
      return num1 * num2;
    case '/' :
      return num1 / num2;
    case '+-' :
      return num1 - num2;
    default :
      throw Exception('Operador não suportado');
  }
}

double calcularExpressao(String input) {
  if (isOperator(input[0])) {
    input = '0$input';
  }
  input = tratarOperadoresConsecutivos(input);
  List<String> keys = dividirEmKeys(input);
  List<String> operadores = [];
  List<double> numbers = [];

  for (String key in keys) {
    if (isOperator(key)) {
      operadores.add(key);
    } else {
      numbers.add(double.parse(key));
    }
  }

  for (int i = 0; i < operadores.length; i++) {
    if (operadores[i] == '*' || operadores[i] == '/') {
      double resultado = executarOperacao(numbers[i], numbers[i + 1], operadores[i]);
      numbers[i] = resultado;
      numbers.removeAt(i + 1);
      operadores.removeAt(i);
      i--;
    }
  }
  double resultado = numbers[0];
  for (int i = 0; i < operadores.length; i++) {
    resultado = executarOperacao(resultado, numbers[i + 1], operadores[i]);
  }
  return resultado;
}

void executavel() {
  while (true) {
    print('Digite a operação ou digite "sair" para encerrar a aplicação:');
    String? input = stdin.readLineSync();
    if (input == null || input.toLowerCase() == 'sair') {
      print('A JVM Calculator está sendo encerrada...');
      break;
    }
    try {
      input = input.replaceAll(' ', '');
      double resultado = calcularExpressao(input);
      print('O resultado dessa operação é: $resultado');
    } catch (e) {
      throw Exception('Algo deu errado, tente novamente');
    }
  }
}
























