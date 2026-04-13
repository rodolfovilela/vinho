import 'package:flutter/material.dart';
import 'package:vinho/generated/l10n/app_localizations.dart';
import 'package:vinho/model/location_result_model.dart';
import 'package:vinho/services/location.dart';
import 'package:vinho/theme/ov_theme.dart';

class LocationAutocomplete extends StatefulWidget {
  final Function(LocationResult) onSelected;
  final Function() onClear;
  final Function(String) onTextChanged;

  const LocationAutocomplete(
      {super.key,
      required this.onSelected,
      required this.onClear,
      required this.onTextChanged});

  @override
  LocationAutocompleteState createState() => LocationAutocompleteState();
}

class LocationAutocompleteState extends State<LocationAutocomplete> {
  final LocationSearchService _service = LocationSearchService();

  TextEditingController? _controller;

  bool _isFilled = false;

  void clear({bool notify = false}) {
    _controller?.clear();
    setState(() {
      _isFilled = false;
    });
    if (notify) {
      widget.onClear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Autocomplete<LocationResult>(
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
        widget.onSelected(value);
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
            hintText: AppLocalizations.of(context)!.locationPlaceholder,
            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            prefixIcon: Icon(
              Icons.location_on_outlined,
              size: 18,
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
    );
  }

  void _onTextChanged() {
    widget.onTextChanged(_controller?.text ?? '');
  }
}
