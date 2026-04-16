import 'package:flutter/material.dart';
import 'package:vinho/generated/l10n/app_localizations.dart';
import 'package:vinho/model/location_result_model.dart';
import 'package:vinho/services/location.dart';
import 'package:vinho/theme/ov_theme.dart';

class LocationAutocomplete extends StatefulWidget {
  /*  final Function(LocationResult) onSelected; */
  final Function(bool isSearchingSuggestion) onSearch;
  final Function() onClear;
  final Function(String) onTextChanged;

  const LocationAutocomplete(
      {super.key,
      /*  required this.onSelected, */
      required this.onSearch,
      required this.onClear,
      required this.onTextChanged});

  @override
  LocationAutocompleteState createState() => LocationAutocompleteState();
}

class LocationAutocompleteState extends State<LocationAutocomplete> {
  final LocationSearchService _service = LocationSearchService();
  List<LocationResult> locationSuggestions = [];

  TextEditingController? _controller;

  bool _isFilled = false;

  late bool _isSearching;
  // late bool isSearchingSuggestion;

  void clear({bool notify = false}) {
    _controller?.clear();
    setState(() {
      _isFilled = false;
    });
    if (notify) {
      widget.onClear();
    }
  }

  void setLocation(String location) {
    _controller?.clear();
    setState(() {
      _controller!.text = location;
      //  _isFilled = false;
    });
  }

  void getSuggestions() {
    //if (!isSearchingSuggestion) {
    setState(() {
      doGetSuggestions();
    });
    //   }
  }

  @override
  void initState() {
    super.initState();
    _isSearching = false;
    // isSearchingSuggestion = false;
  }

  @override
  Widget build(BuildContext context) {
    bool isWide = MediaQuery.of(context).size.width > 600;
    // locationSuggestions = [];
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              flex: isWide ? 9 : 4,
              child: Autocomplete<LocationResult>(
                displayStringForOption: (option) => option.label,
                optionsBuilder: (TextEditingValue value) {
                  setState(() {
                    _isFilled = value.text.isNotEmpty;
                  });

                  if (value.text.isEmpty) {
                    return const Iterable<LocationResult>.empty();
                  }

                  return _service.search(value.text);
                },
                onSelected: (LocationResult value) {
                  _controller?.text = value.label;
                  /* widget.onSelected(value); */
                  widget.onSearch(true);
                },
                fieldViewBuilder: (context, controller, focusNode, onSubmit) {
                  _controller = controller;

                  controller.removeListener(_onTextChanged);
                  controller.addListener(_onTextChanged);

                  return TextField(
                    controller: controller,
                    focusNode: focusNode,
                    style: OVTheme.bodyBase.copyWith(fontSize: 16),
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: OVTheme.blackRetro,
                          width: 1.2,
                        ),
                      ),
                      hintText:
                          AppLocalizations.of(context)!.locationPlaceholder,
                      hintStyle: TextStyle(fontSize: 13),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                      prefixIcon: Icon(
                        Icons.location_on_outlined,
                        size: 13,
                        color: OVTheme.muted,
                      ),
                      suffixIcon: _isFilled
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 20),
                              onPressed: () {
                                clear(notify: true);
                              },
                            )
                          : null,
                    ),
                  );
                },
                optionsViewBuilder: (context, onSelected, options) {
                  return Align(
                    alignment: Alignment.topLeft,
                    child: Material(
                      elevation: 4,
                      color: Colors.white,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.6,
                          minHeight: 100,
                        ),
                        child: /*  options.isEmpty
                            ? Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  AppLocalizations.of(context)!.noResults,
                                  style: OVTheme.bodyBase.copyWith(
                                    color: OVTheme.muted,
                                  ),
                                ),
                              )
                            :  */
                            ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: options.length,
                          itemBuilder: (context, index) {
                            final option = options.elementAt(index);

                            return ListTile(
                              leading: Icon(
                                option.type == LocationType.district
                                    ? Icons.map
                                    : Icons.location_on,
                                size: 18,
                              ),
                              title: Text(option.label),
                              subtitle: Text(
                                option.type == LocationType.district
                                    ? AppLocalizations.of(context)!.district
                                    : option.districtCode,
                                style: const TextStyle(fontSize: 12),
                              ),
                              onTap: () => onSelected(option),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 46,
              child: Container(
                margin: const EdgeInsets.only(left: 4.0),
                child: ElevatedButton(
                    onPressed: _isSearching
                        ? null
                        : () {
                            widget.onSearch(false);
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: OVTheme.primaryRed,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(1),
                      ),
                      elevation: 4,
                    ),
                    child: Text(AppLocalizations.of(context)!.viewEvents,
                        style: OVTheme.bodyBase
                            .copyWith(color: Colors.white, fontSize: 14))),
              ),
            )
          ],
        ),
        if (locationSuggestions.isNotEmpty &&
            locationSuggestions
                    .indexWhere((l) => l.label == _controller?.text) <
                0)
          Padding(
            padding: const EdgeInsets.only(left: 12.0, top: 8),
            child: Row(
              children: [
                Text(
                  AppLocalizations.of(context)!.didYouMean,
                  style: OVTheme.bodyBase.copyWith(),
                  textAlign: TextAlign.center,
                ),
                ...locationSuggestions.map((s) => TextButton(
                      onPressed: () {
                        setLocation(s.label);
                        widget.onSearch(true);
                        resetSuggestions();
                      },
                      child: Text(
                        s.label,
                        style: OVTheme.bodyBase.copyWith(
                            color: OVTheme.primaryRed,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold
                            /*    */
                            ),
                      ),
                    )),
              ],
            ),
          ),
      ],
    );
  }

  void resetSuggestions() {
      setState(() {
      locationSuggestions = [];
    });
  }

  void _onTextChanged() {
    widget.onTextChanged(_controller?.text ?? '');
  }

  void doGetSuggestions() {
    locationSuggestions =
        LocationSearchService.getSuggestions(_controller!.text);
  }
}
