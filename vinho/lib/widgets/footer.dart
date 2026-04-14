import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vinho/generated/l10n/app_localizations.dart';
import 'package:vinho/l10n_helper/l10n_helper.dart';
import 'package:vinho/theme/ov_theme.dart';
import 'package:vinho/widgets/language.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // color: OVTheme.lightBackground,
        border:
            Border(top: BorderSide(color: OVTheme.semiTransparent, width: 0.8)),
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(top: 16),
      width: double.infinity,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Wrap(
                  children: [
                    IconButton(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      onPressed: () async {
                        if (!await launchUrl(Uri.parse(
                            "https://www.instagram.com/ovinhoacontece/"))) {
                          print('Could not launch Instagram URL');
                        }
                      },
                      icon: Image.asset('assets/icons/instagram.png',
                          width: 20, height: 20),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              AppLanguage()
            ],
          ),
          Row(
            children: [
              Text(
                '© 2026 O Vinho Acontece',
                style: OVTheme.bodyBase
                    .copyWith(fontSize: 12, color: OVTheme.muted),
              ),
            ],
          )
        ],
      ),
    );
  }
}
