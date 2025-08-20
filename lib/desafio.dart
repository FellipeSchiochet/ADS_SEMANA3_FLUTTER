import 'dart:convert';
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
      debugShowCheckedModeBanner: false,
      home: ClimaPage(),
    );
  }
}

class ClimaPage extends StatefulWidget {
  const ClimaPage({super.key});

  @override
  State<ClimaPage> createState() => _ClimaPageState();
}

class _ClimaPageState extends State<ClimaPage> {
  final TextEditingController cidadeController = TextEditingController();
  String resultado = "";

  Future<void> buscarClima(String cidade) async {
    const apiKey = 'd62e687bba2640f08e7222548251908';
    final url = Uri.parse(
        'https://api.weatherapi.com/v1/current.json?key=$apiKey&q=$cidade&lang=pt');

    final resposta = await http.get(url);

    if (resposta.statusCode == 200) {
      final dados = jsonDecode(resposta.body);
      final temp = dados['current']['temp_c'];
      final condicao = dados['current']['condition']['text'];

      setState(() {
        resultado = "Cidade: $cidade\nTemperatura: $temp°C\nCondição: $condicao";
      });
    } else {
      setState(() {
        resultado = "Erro na requisição: ${resposta.statusCode}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Consulta de Clima")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: cidadeController,
              decoration: const InputDecoration(
                labelText: "Digite o nome da cidade",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final cidade = cidadeController.text.trim();
                if (cidade.isNotEmpty) {
                  buscarClima(cidade);
                }
              },
              child: const Text("Buscar Clima"),
            ),
            const SizedBox(height: 24),
            Text(
              resultado,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
