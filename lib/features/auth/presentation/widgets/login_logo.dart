import 'package:flutter/material.dart';

import '../../../../shared/widgets/vision_price_logo.dart';

class LoginLogo extends StatelessWidget {
  const LoginLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return const VisionPriceLogo(size: 40, showWordmark: true);
  }
}
