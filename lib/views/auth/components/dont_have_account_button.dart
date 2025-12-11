import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/routes/app_routes.dart';

class DontHaveAccountButton extends StatelessWidget {
  const DontHaveAccountButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('No account exists'.tr()),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.signup);
            },
            child: Text('Create Account'.tr()),
          ),
        ],
      ),
    );
  }
}
