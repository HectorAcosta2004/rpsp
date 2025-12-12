import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
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
      // Aquí iría la lógica para enviar el correo o guardar en base de datos
      // final nombre = _nameController.text;
      // final apellido = _lastNameController.text;
      // ...

      ScaffoldMessenger.of(context).showSnackBar(
        // CAMBIO 1: Mensaje de éxito traducido
        SnackBar(content: Text('request_sent_success'.tr())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // CAMBIO 2: Título traducido
        title: Text('prayer_requests_title'.tr()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                // CAMBIO 3: Subtítulo traducido
                'send_us_request'.tr(),
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Campo Nombre
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  // CAMBIO 4: Label traducido
                  labelText: 'first_name'.tr(),
                  border: const OutlineInputBorder(),
                ),
                // Nota: Si AppValidators.required devuelve un string fijo en inglés,
                // deberías considerar usar AppValidators.requiredWithName('first_name'.tr())
                // si tu validador lo soporta, o dejarlo así si el validador ya maneja errores genéricos.
                validator: AppValidators.required,
              ),
              const SizedBox(height: 16),

              // Campo Apellido
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  // CAMBIO 5: Label traducido
                  labelText: 'last_name'.tr(),
                  border: const OutlineInputBorder(),
                ),
                validator: AppValidators.required,
              ),
              const SizedBox(height: 16),

              // Campo Email
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  // CAMBIO 6: Reutilizamos la clave 'email' que ya tenías
                  labelText: 'email'.tr(),
                  border: const OutlineInputBorder(),
                ),
                validator: AppValidators.email,
              ),
              const SizedBox(height: 16),

              // Campo Mensaje
              TextFormField(
                controller: _messageController,
                maxLines: 5,
                decoration: InputDecoration(
                  // CAMBIO 7: Reutilizamos la clave 'message' que ya tenías
                  labelText: 'message'.tr(),
                  border: const OutlineInputBorder(),
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
                // CAMBIO 8: Botón traducido
                child: Text('send_request'.tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
