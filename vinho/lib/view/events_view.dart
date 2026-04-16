import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:vinho/generated/l10n/app_localizations.dart';
import 'package:vinho/model/event_model.dart';
import 'package:vinho/model/function_response_model.dart';
import 'package:vinho/model/location_result_model.dart';
import 'package:vinho/services/firestore_service.dart';
import 'package:vinho/services/functions_service.dart';
import 'package:vinho/services/location.dart';
import 'package:vinho/theme/ov_theme.dart';
import 'package:vinho/util/layout.dart';
import 'package:vinho/view/event_detail_view.dart';
import 'dart:async';
import 'package:vinho/widgets/location_autocomplete.dart';

class EventsView extends StatefulWidget {
  const EventsView({super.key});

  @override
  State<EventsView> createState() => _EventsViewState();
}

class _EventsViewState extends State<EventsView> {
  final GlobalKey<LocationAutocompleteState> locationKey =
      GlobalKey<LocationAutocompleteState>();
  final ScrollController _scrollController = ScrollController();
  List<EventModel>? _events, _searchResults, _filteredEvents;
  late final FirestoreService _firestoreService;
  late bool _isSearching;
  late bool _isSearchingSuggestion;
//  late List<LocationResult> locationSuggestions;

  // TextEditingController locationController = TextEditingController();
  final _formKey = GlobalKey<FormBuilderState>();
  String _locationQuery = '';
  StreamSubscription<dynamic>? _eventsSubscription;

  @override
  void initState() {
    super.initState();
    _isSearching = false;
    _isSearchingSuggestion = false;
    _firestoreService = FirestoreService();
    // controller = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _eventsSubscription = _firestoreService
          .getEventsStream(Localizations.localeOf(context).languageCode)
          .listen((snapshot) {
        if (mounted) {
          setState(() {
            _events = snapshot.docs
                .map((doc) => EventModel.fromFirestore(doc))
                .toList();

            _filteredEvents = _events;
          });
        }
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _eventsSubscription?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isWide = MediaQuery.of(context).size.width > 600;
    return RawScrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      trackVisibility: true,
      //  radius: Radius.circular(8),
      thumbColor: OVTheme.primaryRed,
      thickness: 3,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /*  Row(
              children: [
                Expanded(
                  flex: isWide ? 9 : 4,
                  child: LocationAutocomplete(
                    controller: controller,
                    service: LocationSearchService(),
                    onSelected: (result) {
                      print(result.label);
                      print(result.type); // district | municipality
                    },
                  ),
                ),
                SizedBox(
                  height: 46,
                  child: Container(
                    margin: const EdgeInsets.only(left: 8.0),
                    child: ElevatedButton(
                        onPressed: _isSearching
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
                        child: Text(AppLocalizations.of(context)!.viewEvents,
                            style: OVTheme.bodyBase.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w500))),
                  ),
                )
              ],
            ), */
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: searchPainelWidget(isWide),
            ),
            if (_locationQuery.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: Text(
                  AppLocalizations.of(context)!.upcomingEvents,
                  style: OVTheme.bodyBase.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    letterSpacing: 1.1,
                    wordSpacing: 2,
                  ),
                ),
              ),
            /*  if (_filteredEvents == null)
              SizedBox(
                height: 200,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(64.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: OVTheme.primaryRed),
                        const SizedBox(height: 16),
                        Text(
                          AppLocalizations.of(context)!.loading,
                          style: OVTheme.bodyBase.copyWith(
                            color: OVTheme.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ), */
            if (_isSearching)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(64.0),
                  child: JumpingDots(
                    color: OVTheme.muted,
                    radius: 10,
                    numberOfDots:
                        3, /* 
          animationDuration = Duration(milliseconds: 200), */
                  ), /* Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: OVTheme.primaryRed),
                      const SizedBox(height: 16),
                      Text(
                        AppLocalizations.of(context)!.loading,
                        style: OVTheme.bodyBase.copyWith(
                          color: OVTheme.muted,
                        ),
                      ),
                    ],
                  ), */
                ),
              ),
            if (!_isSearching) ...buildEvents()
          ],
        ),
      ),
    );
  }

  List<Widget> buildEvents() {
    return [
      if (_filteredEvents != null && _filteredEvents!.isEmpty)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            vertical: 24.0, /* horizontal: 8.0 */
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /*  if (locationSuggestions.isNotEmpty)
                Row(
                  children: [
                    Text("Talvez quis dizer",  style: OVTheme.bodyBase
                     .copyWith(
                    
                  ), textAlign: TextAlign.center,),
                    ...locationSuggestions.map((s) => TextButton(
                          onPressed: () {
                            locationKey.currentState!.setLocation(s.label);
                            _submitSearch();
                          },

                          child: Text(s.label,  style: OVTheme.bodyBase.copyWith(
                            color: OVTheme.primaryRed
   
                  ),),
                        )),
                  ],
                ), */
              Icon(
                Icons.wine_bar_outlined,
                size: 48,
                color: Colors.grey.withOpacity(0.5),
              ),
              const SizedBox(height: 12),
              FittedBox(
                child: Text(
                  AppLocalizations.of(context)!
                      .noEventsFoundByLocation(_locationQuery),
                  style: OVTheme.titlesBase.copyWith(
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),
              FittedBox(
                child: Text(
                  AppLocalizations.of(context)!
                      .noEventsFoundByLocationSecondary,
                  style: OVTheme.bodyBase.copyWith(
                    color: OVTheme.muted,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),
              FittedBox(
                child: TextButton(
                    onPressed: _resetSearch,
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(1),
                      ),
                      foregroundColor: OVTheme.primaryRed,
                      backgroundColor: OVTheme.primaryRed,
                    ),
                    child: Text(AppLocalizations.of(context)!.discoverEvents,
                        style: OVTheme.bodyBase.copyWith(
                            color: Colors.white, fontWeight: FontWeight.w500))),
              ),
              const SizedBox(height: 48),
              FittedBox(
                child: Text(
                  AppLocalizations.of(context)!.sendEventSuggestion,
                  style: OVTheme.bodyBase,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      if (_filteredEvents != null)
        ..._filteredEvents!.map((event) => GestureDetector(
              onTap: () => context.go('/event_detail', extra: event),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border:
                        Border.all(color: OVTheme.semiTransparent, width: 0.8),
                  ),
                  child: buildEventCard(event),
                ),
              ),
            ))
    ];
  }

  /*  void getSuggestions(String locationQuery) {
    locationSuggestions = LocationSearchService.getSuggestions(locationQuery);
    
  } */

  Widget buildEventCard(EventModel event) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (event.image != null && event.image!.isNotEmpty)
          Container(
            width: double.infinity,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.3,
              minHeight: MediaQuery.of(context).size.height * 0.1,
            ),
            child: Image.asset(
              "assets/images${event.image!}",
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                event.title ?? "-",
                style: OVTheme.titlesBase.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 21,
                  letterSpacing: 0.5,
                ),
              ),
              if ((event.desc ?? "").isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    event.desc!,
                    style: OVTheme.bodyBase.copyWith(
                      fontSize: 13,
                      color: OVTheme.muted,
                    ),
                    overflow: TextOverflow.fade,
                    maxLines: 5,
                  ),
                ),
              if ((event.date ?? "").isNotEmpty ||
                  (event.time ?? "").isNotEmpty)
                Container(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: [
                      if ((event.date ?? "").isNotEmpty)
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: OVTheme.primaryRed,
                                size: 16,
                              ),
                              SizedBox(width: 4),
                              Text(
                                event.date!,
                                style: OVTheme.bodyBase.copyWith(
                                  color: OVTheme.muted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      if ((event.time ?? "").isNotEmpty)
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.access_time,
                                color: OVTheme.primaryRed,
                                size: 16,
                              ),
                              SizedBox(width: 4),
                              Text(
                                event.time!,
                                style: OVTheme.bodyBase.copyWith(
                                  color: OVTheme.muted,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              if ((event.location ?? "").isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.pin_drop_outlined,
                        color: OVTheme.primaryRed,
                        size: 16,
                      ),
                      SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          event.location! +
                              (event.municipality!.isNotEmpty
                                  ? ' (${event.municipality})'
                                  : event.district!.isNotEmpty
                                      ? ' (${event.district})'
                                      : ''),
                          style: OVTheme.bodyBase.copyWith(
                            color: OVTheme.muted,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              if ((event.paxPrice ?? 0) > 0 || (event.availableSeats) > 0)
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(
                            color: OVTheme.semiTransparent, width: 0.8)),
                  ),
                  margin: const EdgeInsets.only(top: 16.0),
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: OVTheme.backgroundColor,
                        ),
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          formatCurrency.format(event.paxPrice),
                          style: OVTheme.bodyBase.copyWith(
                              color: OVTheme.primaryColor,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.2),
                        ),
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.people_outline,
                              color: OVTheme.primaryRed,
                              size: 16,
                            ),
                            SizedBox(width: 4),
                            if (event.isSoldOut)
                              Flexible(
                                child: SoldOutWidget(context: context),
                              ),
                            if (!event.isSoldOut)
                              Flexible(
                                child: Text(
                                  AppLocalizations.of(context)!.seatsLeft(
                                      event.availableSeats.toString()),
                                  style: OVTheme.bodyBase
                                      .copyWith(color: OVTheme.muted),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  /* transfer to a file and use it 
  
  Widget SoldOutWidget({required BuildContext context}) {
    return Text(
      AppLocalizations.of(context)!.soldOut,
      style: OVTheme.bodyBase.copyWith(
          color: OVTheme.primaryRed, fontWeight: FontWeight.w500),
    );
  } */

  List<Widget> searchPainelWidget(bool isWide) {
    return [
      Expanded(
        flex: isWide ? 9 : 4,
        child: LocationAutocomplete(
          key: locationKey,
          //   controller: locationController,
          onClear: () {
            _resetSearch();
          },
          onSearch: () {
            _isSearchingSuggestion = true;
            _submitSearch();
          },
          onTextChanged: (text) {
            _locationQuery = text;
          },
          onSelected: (result) {
            print(result.label);
            print(result.type);
          },
        ),
      ),

      /* FormBuilderDateRangePicker(
              style: OVTheme.bodyBase,
              name: 'quickSearchDateRange',
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
              //   enableInteractiveSelection: false,
              initialEntryMode: DatePickerEntryMode.calendarOnly,
                
              decoration: InputDecoration(
                icon: Icon(Icons.calendar_today_outlined,
                    color: OVTheme.muted),
                border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: OVTheme.blackRetro, width: 1.2)),
              ),
            ), */
      
    ];
  }

  void _resetSearch() {
    setState(() {
      locationKey.currentState?.clear();
      _filteredEvents = _events;
    });
  }

  Future<void> _submitSearch() async {
    if (_locationQuery.isEmpty) {
      setState(() {
        //_filteredEvents = _events;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    /*  try { */
    //await FunctionsService.searchEvents(_locationQuery);
    /* if (ret.success) { */
    //  Future.delayed(const Duration(seconds: 4), () async {
    _filteredEvents = await FirestoreService().searchEvents(_locationQuery);
    if (_filteredEvents!.isEmpty/*  && !_isSearchingSuggestion */) {
      locationKey.currentState!.getSuggestions();
     // _isSearchingSuggestion = true;
    }
    //setState(() {});
    if (mounted) setState(() => _isSearching = false);
    //  });

    /* } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('AppLocalizations.of(context)!.searchError'),
          backgroundColor: OVTheme.primaryRed,
        ));
      } */
    /*  } finally {
      if (mounted) setState(() => _isSearching = false);
    } */
  }
}
