import 'package:flutter/material.dart';

import 'social_button.dart';

class SocialButtons extends StatelessWidget {
  const SocialButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SocialButton(
            icon: Icons.face_outlined,
            label: 'Face ID',
            onTap: () {},
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SocialButton(
            icon: Icons.g_mobiledata,
            label: 'Google',
            onTap: () {},
          ),
        ),
      ],
    );
  }
}
