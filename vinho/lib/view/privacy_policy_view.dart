import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:vinho/l10n_helper/l10n_helper.dart';
import 'package:vinho/services/firestore_service.dart';
import 'package:vinho/theme/ov_theme.dart';

class PrivacyPolicyView extends StatefulWidget {
  const PrivacyPolicyView({super.key});

  @override
  State<PrivacyPolicyView> createState() => _PrivacyPolicyViewState();
}

class _PrivacyPolicyViewState extends State<PrivacyPolicyView> {
  String? _privacyContent;
  bool _isLoading = true;
  String? _error;
  final ScrollController _scrollController = ScrollController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _loadPrivacyPolicy();
  }

  Future<void> _loadPrivacyPolicy() async {
    try {
      final lang = L10nHelper.of(context).currentLocale().languageCode;
      final service = FirestoreService();
      final privacy = await service.getPrivacyPolicy(lang);
      if (mounted) {
        setState(() {
          _privacyContent = privacy!.content ?? 'Privacy policy not available.';
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading privacy policy: $e');
      if (mounted) {
        setState(() {
          _error = 'Failed to load privacy policy.';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OVTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: OVTheme.lightBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(_error!,
                            style: OVTheme.bodyBase
                                .copyWith(color: OVTheme.muted)),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadPrivacyPolicy,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : RawScrollbar(
                    controller: _scrollController,
                    thumbVisibility: true,
                    trackVisibility: true,
                    //  radius: Radius.circular(8),
                    thumbColor: OVTheme.primaryRed,
                    thickness: 4,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, bottom: 24),
                      child: HtmlWidget(
                        _privacyContent!,
                        textStyle: OVTheme.bodyBase.copyWith(
                          color: OVTheme.muted,
                          fontSize: 13,
                        ),
                        buildAsync: false,
                      ),
                    ),
                  ),
      ),
    );
  }
}
