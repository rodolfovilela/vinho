import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:vinho/model/lead_model.dart';
import 'package:vinho/theme/ov_theme.dart';

class LeadsView extends StatelessWidget {
  const LeadsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OVTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: OVTheme.lightBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        /* title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: FittedBox(
            fit: BoxFit.contain,
            child: Image.asset(
              'assets/images/glass.png',
              height: 40,
            ),
          ),
        ), */
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom:16.0),
                child: Text(
                  "O vinho é mais do que uma bebida: é para partilhar.",
                  style: OVTheme.titlesBase
                      .copyWith(fontSize: 24, fontWeight: FontWeight.w600, color: OVTheme.primaryRed  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.spaceBetween,
                children: leads
                    .map((lead) => SizedBox(
                          width: MediaQuery.of(context).size.width > 600
                              ? (MediaQuery.of(context).size.width / 3) - 22
                              : double.infinity,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: OVTheme.semiTransparent, width: 0.8),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (lead.icon != null)
                                    Icon(
                                      lead.icon,
                                      size: 36,
                                      color: OVTheme.primaryRed,
                                    ),
                                  if (lead.image != null) lead.image!,
                                  const SizedBox(height: 8),
                                  Text(
                                    lead.title,
                                    style: OVTheme.titlesBase.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  HtmlWidget(
                                    lead.description,
                                    textStyle: OVTheme.bodyBase.copyWith(
                                      color: OVTheme.muted,
                                      fontSize: 13,
                                    ),
                                    buildAsync: false,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
