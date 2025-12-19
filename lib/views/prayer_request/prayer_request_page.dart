import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/utils/app_form_validattors.dart';

class PrayerRequestPage extends StatefulWidget {
  const PrayerRequestPage({Key? key}) : super(key: key);

  @override
  State<PrayerRequestPage> createState() => _PrayerRequestPageState();
}

class _PrayerRequestPageState extends State<PrayerRequestPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  bool _isSending = false;

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSending = true;
      });

      await _launchEmailApp();

      await _sendToWordPressAPI();

      setState(() {
        _isSending = false;
      });

      if (mounted) {
        _nameController.clear();
        _lastNameController.clear();
        _emailController.clear();
        _messageController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('request_sent_success'.tr())),
        );
      }
    }
  }

  Future<void> _launchEmailApp() async {
    final nombre = _nameController.text;
    final apellido = _lastNameController.text;
    final emailUsuario = _emailController.text;
    final mensaje = _messageController.text;

    const String destinatario = "1220072@unav.edu.mx";
    final String asunto = "Nuevo Pedido de Oración: $nombre $apellido";

    final String cuerpo = "Nombre: $nombre $apellido\n"
        "Email de contacto: $emailUsuario\n\n"
        "Pedido de Oración:\n$mensaje";

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: destinatario,
      query:
          'subject=${Uri.encodeComponent(asunto)}&body=${Uri.encodeComponent(cuerpo)}',
    );

    try {
      if (await canLaunchUrl(emailLaunchUri)) {
        await launchUrl(emailLaunchUri);
      }
    } catch (e) {
      debugPrint("No se pudo abrir la app de correo: $e");
    }
  }

  Future<void> _sendToWordPressAPI() async {
    try {
      final dio = Dio();

      const String apiUrl =
          "https://rpsp.adventistasumn.org/wp-json/contact-form-7/v1/contact-forms/160/feedback";

      final formData = FormData.fromMap({
        "your-name": "${_nameController.text} ${_lastNameController.text}",
        "your-email": _emailController.text,
        "your-message": _messageController.text,
        "your-subject": "Petición desde App Móvil",
        "_wpcf7_unit_tag":
            "wpcf7-f160-p1-o1", // Ayuda a la validación interna de WP
      });

      final response = await dio.post(
        apiUrl,
        data: formData,
        options: Options(
          headers: {
            "Content-Type": "multipart/form-data",
          },
        ),
      );

      if (response.statusCode == 200) {
        print("✅ Datos guardados en WordPress correctamente: ${response.data}");
      } else {
        print(
            "⚠️ WordPress recibió la petición pero respondió: ${response.statusCode}");
        print("Respuesta: ${response.data}");
      }
    } catch (e) {
      print("❌ Error de conexión con la API: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                'send_us_request'.tr(),
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'first_name'.tr(),
                  border: const OutlineInputBorder(),
                ),
                validator: AppValidators.required,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  labelText: 'last_name'.tr(),
                  border: const OutlineInputBorder(),
                ),
                validator: AppValidators.required,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'email'.tr(),
                  border: const OutlineInputBorder(),
                ),
                validator: AppValidators.email,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _messageController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'message'.tr(),
                  border: const OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                validator: AppValidators.required,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isSending ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isSending
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text('send_request'.tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
