import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // Para CupertinoPageRoute si prefieres consistencia
import '../../core/utils/app_form_validattors.dart';

class PrayerRequestPage extends StatefulWidget {
  const PrayerRequestPage({Key? key}) : super(key: key);

  @override
  State<PrayerRequestPage> createState() => _PrayerRequestPageState();
}

class _PrayerRequestPageState extends State<PrayerRequestPage> {
  final _formKey = GlobalKey<FormState>();
  
  // Controladores para capturar el texto
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Aquí va la lógica para enviar los datos (API, Firebase, etc.)
      final nombre = _nameController.text;
      final apellido = _lastNameController.text;
      final email = _emailController.text;
      final mensaje = _messageController.text;

      print("Enviando petición: $nombre $apellido, $email, $mensaje");
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Petición enviada correctamente')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Peticiones de Oración'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Envíanos tu petición',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              
              // Campo Nombre
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                ),
                validator: AppValidators.required, // Usando tu validador existente
              ),
              const SizedBox(height: 16),

              // Campo Apellido
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                  labelText: 'Apellido',
                  border: OutlineInputBorder(),
                ),
                validator: AppValidators.required,
              ),
              const SizedBox(height: 16),

              // Campo Email
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: AppValidators.email, // Validador de email existente
              ),
              const SizedBox(height: 16),

              // Campo Mensaje
              TextFormField(
                controller: _messageController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Mensaje',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                validator: AppValidators.required,
              ),
              const SizedBox(height: 24),

              // Botón de Enviar
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Enviar Petición'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}