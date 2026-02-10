import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/utils/app_form_validattors.dart';

class PrayerRequestPage extends StatefulWidget {
  const PrayerRequestPage({super.key});

  @override
  State<PrayerRequestPage> createState() => _PrayerRequestPageState();
}

class _PrayerRequestPageState extends State<PrayerRequestPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  // Variable to store the selected union key (e.g., 'union_central')
  String? _selectedUnion;

  // 1. MAP OF UNIONS AND THEIR EMAILS

  final Map<String, String> _unionEmails = {
    'union_central': 'central@example.com',
    'union_chiapas': 'chiapas@example.com',
    'union_interoceanica': 'interoceanica@example.com',
    'union_norte': '1220072@unav.edu.mx',
    'union_sureste': 'sureste@example.com',
  };

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

      // 1. Open Email App
      await _launchEmailApp();

      // 2. Send to WordPress API
      await _sendToWordPressAPI();

      setState(() {
        _isSending = false;
      });

      if (mounted) {
        // Clear the form
        _nameController.clear();
        _lastNameController.clear();
        _emailController.clear();
        _messageController.clear();
        setState(() {
          _selectedUnion = null; // Reset the dropdown
        });

        // Show success message
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

    // 2. LOGIC TO CHOOSE THE EMAIL RECIPIENT
    String destinatario;

    if (_selectedUnion != null && _unionEmails.containsKey(_selectedUnion)) {
      // If a union was selected, use its specific email
      destinatario = _unionEmails[_selectedUnion]!;
    } else {
      // If none selected ("None" or null), use the default email
      destinatario = 'afragoso@adventistasumn.org';
    }

    final String asunto = 'Nuevo Pedido de Oración: $nombre $apellido';

    // Translate the union name for the email body so the recipient understands it
    final String unionName =
        _selectedUnion != null ? _selectedUnion!.tr() : 'union_none'.tr();

    final String cuerpo = 'Nombre: $nombre $apellido\n'
        'Email de contacto: $emailUsuario\n'
        'Unión: $unionName\n\n' // Include the union info
        'Pedido de Oración:\n$mensaje';

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
      debugPrint('Could not launch email app: $e');
    }
  }

  Future<void> _sendToWordPressAPI() async {
    try {
      final dio = Dio();

      const String apiUrl =
          'https://rpsp.adventistasumn.org/wp-json/contact-form-7/v1/contact-forms/160/feedback';

      final String unionName =
          _selectedUnion != null ? _selectedUnion!.tr() : 'union_none'.tr();

      final String mensajeCompleto =
          'Unión seleccionada: $unionName\n\n${_messageController.text}';

      final formData = FormData.fromMap({
        'your-name': '${_nameController.text} ${_lastNameController.text}',
        'your-email': _emailController.text,
        'your-message': mensajeCompleto, // Message with union info
        'your-subject': 'Petición desde App Móvil ($unionName)',
        '_wpcf7_unit_tag': 'wpcf7-f160-p1-o1',
      });

      final response = await dio.post(
        apiUrl,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode == 200) {
        print('✅ Data sent to WordPress successfully: ${response.data}');
      } else {
        print(
            '⚠️ WordPress received the request but responded: ${response.statusCode}');
        print('Response: ${response.data}');
      }
    } catch (e) {
      print('❌ Error connecting to API: $e');
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

              // 3. UNION SELECTION DROPDOWN
              DropdownButtonFormField<String>(
                value: _selectedUnion,
                decoration: InputDecoration(
                  labelText: 'select_union'.tr(),
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.church),
                ),
                items: [
                  // Default "None" option
                  DropdownMenuItem(
                    value: null,
                    child: Text('union_none'.tr()),
                  ),
                  ..._unionEmails.keys.map((String key) {
                    return DropdownMenuItem(
                      value: key,
                      child: Text(
                        key.tr(),
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 14),
                      ),
                    );
                  }),
                ],
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedUnion = newValue;
                  });
                },
                isExpanded: true,
              ),

              const SizedBox(height: 16),

              // First Name Field
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'first_name'.tr(),
                  border: const OutlineInputBorder(),
                ),
                validator: AppValidators.required.call,
              ),
              const SizedBox(height: 16),

              // Last Name Field
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  labelText: 'last_name'.tr(),
                  border: const OutlineInputBorder(),
                ),
                validator: AppValidators.required.call,
              ),
              const SizedBox(height: 16),

              // Email Field
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'email'.tr(),
                  border: const OutlineInputBorder(),
                ),
                validator: AppValidators.email.call,
              ),
              const SizedBox(height: 16),

              // Message Field
              TextFormField(
                controller: _messageController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'message'.tr(),
                  border: const OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                validator: AppValidators.required.call,
              ),
              const SizedBox(height: 24),

              // Submit Button
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
