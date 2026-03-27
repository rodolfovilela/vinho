import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:vinho/generated/l10n/app_localizations.dart';
import 'package:vinho/model/lead_model.dart';
import 'package:vinho/services/firestore_service.dart';
import 'package:vinho/theme/ov_theme.dart';
import 'package:vinho/widgets/dialog.dart';

class LeadsView extends StatelessWidget {
  LeadsView({super.key});

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    bool isWide = MediaQuery.of(context).size.width > 600;
    return Scaffold(
      backgroundColor: OVTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: OVTheme.lightBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        /* title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppLogo(),
          ],
        ), */
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  AppLocalizations.of(context)!.slogan1,
                  style: OVTheme.titlesBase.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: OVTheme.primaryRed),
                  textAlign: TextAlign.start,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 24),
                width: double.infinity,
                decoration: BoxDecoration(
                  //color: Colors.white,
                //  border:                      Border.all(color: OVTheme.semiTransparent, width: 0.8),
                border: BorderDirectional(
                  bottom: BorderSide(
                      color:  OVTheme.semiTransparent,
                      width: 0.8), )
                  //     borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.adjust_outlined,
                        size: 36,
                        color: OVTheme.primaryRed,
                      ),
                      const SizedBox(height: 8),
                      Flexible(
                        child: Text(
                          AppLocalizations.of(context)!.ourMissionTitle,
                          style: OVTheme.titlesBase.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.start,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 8),
                      HtmlWidget(
                        AppLocalizations.of(context)!.ourMissionDesc,
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
              FutureBuilder<List<LeadModel>>(
                future: FirestoreService()
                    .getLeads(Localizations.localeOf(context).languageCode),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    log('Error fetching leads: ${snapshot.error}');
                    return Text('Error: ${snapshot.error}');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Padding(
                      padding: const EdgeInsets.all(64.0),
                      child: CircularProgressIndicator(),
                    );
                  }
                  final leads = snapshot.data ?? [];
                  /*  if (leads.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(64.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.contact_mail,
                            size: 64,
                            color: OVTheme.muted,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Nenhuma oportunidade disponível',
                            style: OVTheme.titlesBase.copyWith(
                              fontSize: 20,
                              color: OVTheme.muted,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Verifique mais tarde ou entre em contato conosco',
                            style: OVTheme.bodyBase.copyWith(
                              color: OVTheme.muted,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  } */
                  if (leads.isNotEmpty) {
                    return Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      alignment: WrapAlignment.spaceBetween,
                      children: leads
                          .map((lead) => SizedBox(
                                width: isWide
                                    ? (MediaQuery.of(context).size.width / 2) -
                                        30
                                    : double.infinity,
                                child: Container(
                                  decoration: BoxDecoration(
                                      /* border: BorderDirectional(
                                      bottom: BorderSide(
                                          color: isWide ? Colors.transparent: OVTheme.semiTransparent,
                                          width: 0.8),
                                    ), */
                                      /* color: Colors.white,
                                    border: Border.all(
                                        color: OVTheme.semiTransparent,
                                        width: 0.8),
                                    borderRadius: BorderRadius.circular(12), */
                                      ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (lead.icon != null)
                                          Icon(
                                            lead.icon,
                                            size: 36,
                                            color: OVTheme.primaryRed,
                                          ),
                                        const SizedBox(height: 8),
                                        Flexible(
                                          child: Text(
                                            lead.title,
                                            style: OVTheme.titlesBase.copyWith(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            textAlign: TextAlign.start,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        ClipRect(
                                          child: HtmlWidget(
                                            lead.shortDescription,
                                            textStyle:
                                                OVTheme.bodyBase.copyWith(
                                              color: OVTheme.muted,
                                              fontSize: 13,
                                            ),
                                            buildAsync: false,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        OutlinedButton(
                                          onPressed: () => showDialog(
                                            barrierColor:
                                                OVTheme.semiTransparent,
                                            context: context,
                                            builder: (context) => OVDialog(content: Column(children: [Text(
                                                lead.title,
                                                style:
                                                    OVTheme.titlesBase.copyWith(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w700,
                                                  color: OVTheme.primaryRed,
                                                ),
                                              ),
                                               Container(
                                                width: double.infinity,
                                                //     padding: const EdgeInsets.all(16),
                                                decoration: BoxDecoration(
                                                    //    color: OVTheme.lightBackground,
                                                    //  borderRadius: BorderRadius.circular(12),
                                                    /*       border: Border.all(
                                                    color: OVTheme.semiTransparent,
                                                    width: 0.8,
                                                  ), */
                                                    ),
                                                child: RawScrollbar(
                                                  controller: _scrollController,
                                                  thumbVisibility: true,
                                                  trackVisibility: true,
                                                  //  radius: Radius.circular(8),
                                                  thumbColor:
                                                      OVTheme.primaryRed,
                                                  thickness: 2,
                                                  //   minThumbLength: 50,
                                                  child: SingleChildScrollView(
                                                    controller:
                                                        _scrollController,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 16),
                                                      child: HtmlWidget(
                                                        lead.description,
                                                        textStyle: OVTheme
                                                            .bodyBase
                                                            .copyWith(
                                                          color: OVTheme.muted,
                                                          fontSize: 13,
                                                        ),
                                                        buildAsync: false,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                             
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  style: TextButton.styleFrom(
                                                    foregroundColor:
                                                        OVTheme.primaryRed,
                                                  ),
                                                  child: Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .close),
                                                ),
                                              ],)) /* AlertDialog(
                                              backgroundColor:
                                                  OVTheme.backgroundColor,
                                              title: Text(
                                                lead.title,
                                                style:
                                                    OVTheme.titlesBase.copyWith(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w700,
                                                  color: OVTheme.primaryRed,
                                                ),
                                              ),
                                              content: Container(
                                                width: double.infinity,
                                                //     padding: const EdgeInsets.all(16),
                                                decoration: BoxDecoration(
                                                    //    color: OVTheme.lightBackground,
                                                    //  borderRadius: BorderRadius.circular(12),
                                                    /*       border: Border.all(
                                                    color: OVTheme.semiTransparent,
                                                    width: 0.8,
                                                  ), */
                                                    ),
                                                child: RawScrollbar(
                                                  controller: _scrollController,
                                                  thumbVisibility: true,
                                                  trackVisibility: true,
                                                  //  radius: Radius.circular(8),
                                                  thumbColor:
                                                      OVTheme.primaryRed,
                                                  thickness: 2,
                                                  //   minThumbLength: 50,
                                                  child: SingleChildScrollView(
                                                    controller:
                                                        _scrollController,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 16),
                                                      child: HtmlWidget(
                                                        lead.description,
                                                        textStyle: OVTheme
                                                            .bodyBase
                                                            .copyWith(
                                                          color: OVTheme.muted,
                                                          fontSize: 13,
                                                        ),
                                                        buildAsync: false,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  style: TextButton.styleFrom(
                                                    foregroundColor:
                                                        OVTheme.primaryRed,
                                                  ),
                                                  child: Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .close),
                                                ),
                                              ],
                                            ), */
                                          ),
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: Color(0xFF6D0E2E),
                                            side: BorderSide(
                                                color: Color(0xFF6D0E2E),
                                                width: 1.5),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 24, vertical: 14),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                          ),
                                          child: Text(
                                            AppLocalizations.of(context)!
                                                .learnMore,
                                            style: TextStyle(
                                              //fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ) /* Text(
                                           AppLocalizations.of(context)!.learnMore,
                                            style: OVTheme.bodyBase.copyWith(
                                              color: OVTheme.primaryRed,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ), */
                                      ],
                                    ),
                                  ),
                                ),
                              ))
                          .toList(),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
