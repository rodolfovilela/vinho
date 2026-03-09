import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vinho/generated/l10n/app_localizations.dart';
import 'package:vinho/mock/mock_data.dart';
import 'package:vinho/model/event_model.dart';
import 'package:vinho/theme/gradient_border_container.dart';
import 'package:vinho/theme/ov_theme.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class QuickSearchView extends StatefulWidget {
  const QuickSearchView();

  @override
  State<QuickSearchView> createState() => _QuickSearchViewState();
}

class _QuickSearchViewState extends State<QuickSearchView> {
  final ScrollController _scrollController = ScrollController();
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: GradientBorderContainer(
            borderRadius: BorderRadius.circular(12),
            gradientColors: [OVTheme.semiTransparent, OVTheme.semiTransparent],
            backgroundColor: Colors.white,
            borderWidth: 1.5,
            child: FormBuilder(
              key: _formKey,
              onChanged: () {
                _formKey.currentState!.saveAndValidate();
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: Column(
                  children: [
                    FormBuilderTextField(
                      style: OVTheme.bodyBase,
                      name: 'quickSearchLocation',
                      decoration: InputDecoration(
                        icon: Icon(Icons.location_on_outlined,
                            color: OVTheme.muted),
                        hintText: AppLocalizations.of(context)!.searchHint,
                        border: UnderlineInputBorder(
                            borderSide: BorderSide(color: OVTheme.semiTransparent)),
                      ),
                    ),
                    FormBuilderDateRangePicker(
                      style: OVTheme.bodyBase,
                      name: 'quickSearchDateRange',
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                      //   enableInteractiveSelection: false,
                      initialEntryMode: DatePickerEntryMode.calendarOnly,
                      decoration: InputDecoration(
                        icon: Icon(Icons.calendar_today_outlined,
                            color: OVTheme.muted),
                        border: InputBorder.none,
                      ),
                    ),
                    Column(
                      children: [],
                    ),
                    TextButton(
                        style: TextButton.styleFrom(
                          elevation: 0,
                          backgroundColor: OVTheme.primaryColor,
                          minimumSize: const Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                                color: OVTheme.semiTransparent, width: 0.6),
                          ),
                        ),
                        onPressed: () {},
                        child: Text(
                          AppLocalizations.of(context)!.searchButton,
                          style: OVTheme.bodyBase
                              .copyWith(color: OVTheme.backgroundColor),
                        ))
                  ],
                ),
              ),
            )));
  }
}
