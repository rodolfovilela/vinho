import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:vinho/generated/l10n/app_localizations.dart';
import 'package:vinho/model/function_response_model.dart';
import 'package:vinho/services/functions_service.dart';
import 'package:vinho/theme/ov_theme.dart';
import 'package:vinho/widgets/location_autocomplete.dart';

class QuickSearchView extends StatefulWidget {
  const QuickSearchView({super.key});

  @override
  State<QuickSearchView> createState() => _QuickSearchViewState();
}

class _QuickSearchViewState extends State<QuickSearchView> {
  final ScrollController _scrollController = ScrollController();
  final _formKey = GlobalKey<FormBuilderState>();
  TextEditingController locationController = TextEditingController();
  bool _isSearching = false;

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
    return Container(
        //color: Colors.white,
        width: double.infinity,
        child: FormBuilder(
          key: _formKey,
          onChanged: () {
            _formKey.currentState!.saveAndValidate();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Column(
              children: [
                LocationAutocomplete(
                    onClear: () {},
                  controller: locationController,
                  onSelected: (result) {
                    print(result.label);
                    print(result.type); // district | municipality
                  },
                ),
                /* FormBuilderTextField(
                  style: OVTheme.bodyBase,
                  name: 'quickSearchLocation',
                  decoration: InputDecoration(
                    icon: Icon(Icons.location_on_outlined,
                        color: OVTheme.muted),
                    hintText: AppLocalizations.of(context)!.searchHint,
                    border: UnderlineInputBorder(
                        borderSide: BorderSide(color: OVTheme.semiTransparent)),
                  ),
                ), */
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
                SizedBox(
                  height: 46,
                  child: Container(
                    margin: const EdgeInsets.only(left: 8.0),
                    child: ElevatedButton(
                        onPressed: _isSearching /* || controller.text.isEmpty */
                            ? null
                            : _submitSearch,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: OVTheme.primaryRed,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(1),
                          ),
                          elevation: 4,
                        ),
                        child: /* _isSearching
                            ? SizedBox(
                                height: 46,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            :  */
                            Text(AppLocalizations.of(context)!.viewEvents,
                                style: OVTheme.bodyBase.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500))),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Future<List<String>> _submitSearch() async {
    setState(() {
      _isSearching = true;
    });

    try {
      FunctionResponseModel ret =
          await FunctionsService.searchEvents(locationController.text);
      if (ret.success) {
        return ret.entitieIds;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('AppLocalizations.of(context)!.searchError'),
          backgroundColor: OVTheme.primaryRed,
        ));
      }
      return [];
    } finally {
      if (mounted) setState(() => _isSearching = false);
    }
  }
}
