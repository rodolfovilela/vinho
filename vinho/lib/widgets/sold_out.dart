import 'package:flutter/material.dart';
import 'package:vinho/generated/l10n/app_localizations.dart';
import 'package:vinho/theme/ov_theme.dart';

class SoldOutWidget extends StatelessWidget {
  const SoldOutWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: OVTheme.muted,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        AppLocalizations.of(context)!.soldOut,
        style: OVTheme.bodyBase.copyWith(
          color: Colors.white,
          letterSpacing: 1,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}