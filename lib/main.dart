import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }

void buscarClima() async {
  final cidade = 'Jaragua do Sul';
  const apiKey = 'd62e687bba2640f08e7222548251908';
  final url = Uri.parse('https://api.weatherapi.com/v1/current.json?key=$apiKey&q=$cidade&lang=pt');

  final resposta = await http.get(url);

  if (resposta.statusCode == 200) {
    final dados = jsonDecode(resposta.body);
    final temp = dados['current']['temp_c'];
    final condicao = dados['current']['condition']['text'];
    debugPrint('Cidade: $cidade, $temp°C, Condição: $condicao');
  } else {
    if (kDebugMode) {
      print('Erro na requisição: ${resposta.statusCode}');
    }
  }
}

}
