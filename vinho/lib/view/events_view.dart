import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:vinho/generated/l10n/app_localizations.dart';
import 'package:vinho/model/event_model.dart';
import 'package:vinho/services/firestore_service.dart';
import 'package:vinho/theme/ov_theme.dart';
import 'package:vinho/util/layout.dart';
import 'package:vinho/widgets/location_autocomplete.dart';
import 'package:vinho/widgets/sold_out.dart';

class EventsView extends StatefulWidget {
  const EventsView({super.key});

  @override
  State<EventsView> createState() => _EventsViewState();
}

class _EventsViewState extends State<EventsView> {
  final ScrollController _controller = ScrollController();
  final FirestoreService _service = FirestoreService();

  final List<EventModel> _events = [];

  DocumentSnapshot? lastDoc;

  bool loading = false;
  bool hasMore = true;
  bool isSearchMode = false;

  String locationQuery = '';

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
    _loadMore();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_controller.hasClients) return;
    if (loading || !hasMore || isSearchMode) return;

   // if (_controller.position.extentAfter < 300) {
      _loadMore();
    //}
  }

  Future<void> _loadMore() async {
    if (loading || !hasMore || isSearchMode) return;

    setState(() => loading = true);

    final snap = await _service.getMoreEvents(lastDoc);

    if (!mounted) return;

    if (snap.docs.isEmpty) {
      hasMore = false;
    } else {
      lastDoc = snap.docs.last;
      _events.addAll(
        snap.docs.map((d) => EventModel.fromFirestore(d)),
      );
    }

    setState(() => loading = false);
  }

  void _resetSearch() {
    setState(() {
      _events.clear();
      lastDoc = null;
      hasMore = true;
      isSearchMode = false;
      locationQuery = '';
    });

    _loadMore();
  }

  Future<void> _search(String query) async {
    setState(() {
      isSearchMode = true;
      loading = true;
      _events.clear();
      hasMore = false;
      locationQuery = query;
    });

    final result = await _service.searchEvents(query);

    if (!mounted) return;

    setState(() {
      _events.addAll(result);
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _controller,
      slivers: [
        /* SliverAppBar(
          pinned: true,
          floating: false,
          backgroundColor: OVTheme.lightBackground,
          title: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => context.push('/leads'),
              ),
              const AppLogo(),
            ],
          ),
          actions: const [
            AppLanguage(),
          ],
        ), */
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: LocationAutocomplete(
              onClear: _resetSearch,
              onSearch: (isSuggestion) {
                _search(locationQuery);
              },
              onTextChanged: (t) => locationQuery = t,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              AppLocalizations.of(context)!.upcomingEvents,
              style: OVTheme.bodyBase.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index == _events.length - 1) {
                _loadMore();
              }

              final event = _events[index];

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: GestureDetector(
                  onTap: () => context.go(
                    '/event_detail',
                    extra: event,
                  ),
                  child: buildEventCard(event),
                ),
              );
            },
            childCount: _events.length,
          ),
        ),
        SliverToBoxAdapter(
          child: loading
              ? Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                      child: JumpingDots(
                    color: OVTheme.muted,
                    radius: 10,
                    numberOfDots: 3,
                  )),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget buildEventCard(EventModel event) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /*   if (event.image != null && event.image!.isNotEmpty)
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
          ), */
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
                          event.formattedLocation,
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
                                child: SoldOutWidget(),
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
}
