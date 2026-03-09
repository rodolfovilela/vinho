import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:vinho/generated/l10n/app_localizations.dart';
import 'package:vinho/l10n_helper/l10n_helper.dart';
import 'package:vinho/mock/mock_data.dart';
import 'package:vinho/model/event_model.dart';
import 'package:vinho/theme/ov_theme.dart';

class EventsView extends StatefulWidget {
  const EventsView({super.key});

  @override
  State<EventsView> createState() => _EventsViewState();
}

class _EventsViewState extends State<EventsView> {
  final ScrollController _scrollController = ScrollController();

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
    final formatCurrency = NumberFormat.simpleCurrency(locale: 'pt_PT');
    return RawScrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      trackVisibility: true,
      /*   thumbColor: OVTheme.magentaNeon,
      trackColor: Colors.transparent, */
      thickness: 8,
      radius: const Radius.circular(12),
      minThumbLength: 50,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.upcomingEvents,
              style: OVTheme.bodyBase.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 18,
                letterSpacing: 1.1,
                wordSpacing: 2,
              ),
            ),
            ...buildEventsCards(formatCurrency),
          ],
        ),
      ),
    );
  }

  List<Widget> buildEventsCards(NumberFormat formatCurrency) {
    List<Widget> cards = [];
    for (var c in mockedEvents) {
      cards.add(
        GestureDetector(
          onTap: () {
            context.go('/event_detail', extra: c);
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 6),
            width: double.infinity,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: OVTheme.semiTransparent, width: 0.8),
                /*  boxShadow: [
                  BoxShadow(
                    color: OVTheme.primaryColor.withOpacity(0.1),
                    blurRadius:2,
                    offset: Offset(0, 4),
                  ),
                ], */
              ),
              child: buildEventCard(c, formatCurrency),
            ),
          ),
        ),
      );
    }

    return cards;
  }

  Widget buildEventCard(EventModel event, NumberFormat formatCurrency) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (event.image != null && event.image!.isNotEmpty)
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: Container(
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
                  fontWeight: FontWeight.w500,
                  fontSize: 22,
                  letterSpacing: 0.5,
                ),
              ),
              if ((event.desc ?? "").isNotEmpty)
                Text(
                  event.desc!,
                  style: OVTheme.bodyBase.copyWith(
                    fontSize: 13,
                    color: OVTheme.muted,
                  ),
                ),
              if ((event.date ?? "").isNotEmpty ||
                      (event.time ?? "")
                          .isNotEmpty /* ||
                  (event.location ?? "").isNotEmpty */
                  )
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
                            //   fontsize: 14,
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
                      Text(
                        formatCurrency.format(event.paxPrice),
                        style: OVTheme.bodyBase.copyWith(
                            color: OVTheme.primaryColor,
                            fontWeight: FontWeight.w600),
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
                                "${event.availableSeats.toString()} ${AppLocalizations.of(context)!.seatsLeft}",
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
              /*  Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(
                            color: OVTheme.semiTransparent, width: 0.8)),
                  ),
                  margin: const EdgeInsets.only(top: 16.0),
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formatCurrency.format(event.paxPrice),
                        style: OVTheme.bodyBase.copyWith(
                            color: OVTheme.primaryColor,
                            fontWeight: FontWeight.w600),
                      ),
                      Flexible(
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
                                "${event.availableSeats.toString()} ${AppLocalizations.of(context)!.seatsLeft}",
                                style: OVTheme.bodyBase.copyWith(
                                    color: OVTheme.muted),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ), */
            ],
          ),
        ),
      ],
    );
  }
}
