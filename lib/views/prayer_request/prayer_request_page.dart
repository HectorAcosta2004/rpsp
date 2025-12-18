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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('request_sent_success'.tr())),
      );
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

              // Campo Apellido
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
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text('send_request'.tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
