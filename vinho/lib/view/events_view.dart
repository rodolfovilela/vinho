import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vinho/generated/l10n/app_localizations.dart';
import 'package:vinho/model/event_model.dart';
import 'package:vinho/services/firestore_service.dart';
import 'package:vinho/theme/ov_theme.dart';
import 'package:vinho/util/layout.dart';

class EventsView extends StatefulWidget {
  const EventsView({super.key});

  @override
  State<EventsView> createState() => _EventsViewState();
}

class _EventsViewState extends State<EventsView> {
  final ScrollController _scrollController = ScrollController();
  List<EventModel>? _events;
  late final FirestoreService _firestoreService;

  @override
  void initState() {
    super.initState();
    _firestoreService = FirestoreService();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _firestoreService
          .getEventsStream(Localizations.localeOf(context).languageCode)
          .listen((snapshot) {
        setState(() {
          _events = snapshot.docs
              .map((doc) => EventModel.fromFirestore(doc))
              .toList();
        });
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RawScrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      trackVisibility: true,
      //  radius: Radius.circular(8),
      thumbColor: OVTheme.primaryRed,
      thickness: 4,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.upcomingEvents,
              style: OVTheme.bodyBase.copyWith(
                fontWeight: FontWeight.w500,
                letterSpacing: 1.1,
                wordSpacing: 2,
              ),
            ),
            if (_events == null)
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
                          'Carregando eventos...',
                          style: OVTheme.bodyBase.copyWith(
                            color: OVTheme.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            if (_events != null && _events!.isEmpty)
              Padding(
                padding: const EdgeInsets.all(64.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.event_busy,
                      size: 64,
                      color: OVTheme.muted,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context)!.noEventsForNow,
                      style: OVTheme.titlesBase.copyWith(
                        fontSize: 20,
                        color: OVTheme.muted,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppLocalizations.of(context)!.sendEventSuggestion,
                      style: OVTheme.bodyBase.copyWith(
                        color: OVTheme.muted,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            if (_events != null)
              ..._events!.map((event) => GestureDetector(
                    onTap: () => context.go('/event_detail', extra: event),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              color: OVTheme.semiTransparent, width: 0.8),
                        ),
                        child: buildEventCard(event),
                      ),
                    ),
                  ))
          ],
        ),
      ),
    );
  }

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
                                Icons.calendar_month_outlined,
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
                          event.location!,
                          style: OVTheme.bodyBase.copyWith(
                            color: OVTheme.muted,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              if ((event.paxPrice ?? 0) > 0 || (event.availableSeats ?? 0) > 0)
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
                            Flexible(
                              child: Text(
                                AppLocalizations.of(context)!
                                    .seatsLeft(event.availableSeats.toString()),
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
}
