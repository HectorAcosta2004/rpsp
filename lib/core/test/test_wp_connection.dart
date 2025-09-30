import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

/// Cambia esto a tu dominio WordPress
const String wordpressUrl = 'rpsp.adventistasumn.org';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WP Connection Test',
      home: const ConnectionTestScreen(),
    );
  }
}

class ConnectionTestScreen extends StatelessWidget {
  const ConnectionTestScreen({super.key});

  /// Función que prueba la conexión
  Future<void> testConnection() async {
    final url = Uri.parse('https://$wordpressUrl/wp-json/wp/v2/posts');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        print('✅ Conexión exitosa a WordPress!');
        print('JSON recibido: ${response.body}');
      } else {
        print('❌ Error al conectar. Código: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Excepción al conectar: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prueba Conexión WP')),
      body: Center(
        child: ElevatedButton(
          onPressed: testConnection,
          child: const Text('Probar conexión WordPress'),
        ),
      ),
    );
  }
}
