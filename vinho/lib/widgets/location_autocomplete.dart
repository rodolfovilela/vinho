import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:vinho/generated/l10n/app_localizations.dart';
import 'package:vinho/model/location_result_model.dart';
import 'package:vinho/services/location.dart';
import 'package:vinho/theme/ov_theme.dart';

class LocationAutocomplete extends StatefulWidget {
  final Function(LocationResult) onSelected;
  final Function() onClear;
  final TextEditingController controller;
  final LocationSearchService service = LocationSearchService();

  LocationAutocomplete({
    super.key,
    required this.onSelected,
    required this.controller,
    required this.onClear,
  });

  @override
  State<LocationAutocomplete> createState() => _LocationAutocompleteState();
}

class _LocationAutocompleteState extends State<LocationAutocomplete> {
  bool isLocationFilled = false;
  @override
  Widget build(BuildContext context) {
    return Autocomplete<LocationResult>(
      displayStringForOption: (option) => option.label,
      optionsBuilder: (TextEditingValue textEditingValue) {
        setState(() {
          isLocationFilled = textEditingValue.text.isNotEmpty;
        });
        widget.controller.text = textEditingValue.text;
        return widget.service.search(textEditingValue.text);
      },
      onSelected: widget.onSelected,
      fieldViewBuilder: (context, controller, focusNode, onSubmit) {
        return FormBuilderTextField(
          name: 'location',
          style: OVTheme.bodyBase.copyWith(fontSize: 16),
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: OVTheme.blackRetro, width: 1.2)),
            hintText: AppLocalizations.of(context)!.locationPlaceholder,
            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            prefixIcon: Icon(Icons.location_on_outlined,
                size: 18, color: OVTheme.muted),
            suffixIcon: isLocationFilled
                ? IconButton(
                    icon: Icon(Icons.clear, size: 20),
                    onPressed: () {
                      controller.clear();
                      widget.onClear();
                      setState(() {
                        isLocationFilled = false;
                      });
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
            color: Colors.white,
            elevation: 4,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.6,
                  minHeight: 100),
              child: ListView.builder(
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
                      style: TextStyle(fontSize: 12),
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
/* 
  String _formatDistrict(String code) {
    return code[0] + code.substring(1).toLowerCase();
  } */
}
