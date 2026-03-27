import 'package:flutter/material.dart';
import 'package:vinho/theme/ov_theme.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kToolbarHeight * 1.4,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: FittedBox(
        fit: BoxFit.contain,
        child: Row(
          children: [
            
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'O Vinho',
                    style: OVTheme.titlesBase.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Acontece',
                    style: OVTheme.titlesBase.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: OVTheme.primaryRed,
                    ),
                  ),
                ],
              ),
            ),
            Image.asset(
              'assets/images/glass.png',
              height: kToolbarHeight * 0.8,
            ),
          ],
        ),
      ),
    );
  }
}
