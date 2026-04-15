import 'package:flutter/material.dart';
import 'package:vinho/generated/l10n/app_localizations.dart';
import 'package:vinho/l10n_helper/l10n_helper.dart';
import 'package:vinho/theme/ov_theme.dart';

class AppLanguage extends StatelessWidget {
  const AppLanguage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Locale>(
      tooltip: AppLocalizations.of(context)!.changeLanguage,
      icon: Image.asset(
          'assets/icons/${L10nHelper.of(context).currentLocale().languageCode}.png',
          width: 20,
          height: 20),
      padding: EdgeInsets.zero,
      color: Colors.white,
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<Locale>(
          textStyle: OVTheme.bodyBase.copyWith(color: OVTheme.vaporwaveGray),
          value: Locale('pt'),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child:
                    Image.asset('assets/icons/pt.png', width: 20, height: 20),
              ),
              Text('Português'),
            ],
          ),
        ),
        PopupMenuItem<Locale>(
          textStyle: OVTheme.bodyBase.copyWith(color: OVTheme.vaporwaveGray),
          value: Locale('en'),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child:
                    Image.asset('assets/icons/en.png', width: 20, height: 20),
              ),
              Text('English'),
            ],
          ),
        ),
      ],
      onSelected: (Locale locale) {
        L10nHelper.of(context).changeLocale(locale);
      },
    );
  }
}
