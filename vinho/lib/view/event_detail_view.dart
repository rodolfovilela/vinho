import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:vinho/generated/l10n/app_localizations.dart';
import 'package:vinho/model/event_model.dart';
import 'package:vinho/theme/ov_theme.dart';
import 'package:vinho/util/layout.dart';

class EventDetailView extends StatefulWidget {
  final EventModel event;
  const EventDetailView(this.event, {super.key});

  @override
  State<EventDetailView> createState() => _EventDetailViewState();
}

class _EventDetailViewState extends State<EventDetailView> {
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Hero(tag: 'app_bar', child: buildHeader(context)),
      ),
      backgroundColor: OVTheme.backgroundColor,
      body: SingleChildScrollView(
        child: buildEventCard(widget.event),
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
            margin: const EdgeInsets.only(bottom: 8.0),
            width: double.infinity,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.heightOf(context) * 0.25,
              minHeight: MediaQuery.heightOf(context) * 0.1,
            ),
            child: Image.asset(
              "assets/images${event.image}",
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(),
            ),
          ),
        Container(
          padding: EdgeInsets.all(8),
          margin: EdgeInsets.all(8),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: OVTheme.semiTransparent, width: 0.8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if ((event.date ?? "").isNotEmpty)
                Container(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.calendar_month_outlined,
                          color: OVTheme.primaryRed,
                          size: 18,
                        ),
                        SizedBox(width: 4),
                        Text(
                          event.date!,
                          style: OVTheme.bodyBase /* .copyWith(fontSize: 18) */,
                        ),
                      ],
                    ),
                  ),
                ),
              if ((event.time ?? "").isNotEmpty)
                Container(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.access_time,
                          color: OVTheme.primaryRed,
                          size: 18,
                        ),
                        SizedBox(width: 4),
                        Text(
                          event.time!,
                          style: OVTheme.bodyBase /* .copyWith(fontSize: 18) */,
                        ),
                      ],
                    ),
                  ),
                ),
              if ((event.location ?? "").isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.pin_drop_outlined,
                            color: OVTheme.primaryRed,
                            size: 18,
                          ),
                          SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              event.location!,
                              style: OVTheme
                                  .bodyBase /* .copyWith(fontSize: 18) */,
                              /*   overflow: TextOverflow.ellipsis,
                              maxLines: , */
                            ),
                          ),
                        ],
                      ),
                      if (event.address != null && event.address!.isNotEmpty)
                        SizedBox(height: 4),
                      if (event.address != null && event.address!.isNotEmpty)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(width: 22),
                            Flexible(
                              child: Text(
                                event.address ?? "",
                                style: OVTheme.bodyBase.copyWith(
                                  color: OVTheme.muted,
                                  fontSize: 13,
                                ),
                                /*   overflow: TextOverflow.ellipsis,
                                maxLines: 2, */
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              if (event.availableSeats != null || event.totalSeats != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: /* (event.totalSeats == null)
                            ?  */
                            MainAxisAlignment
                                .start /* : MainAxisAlignment.spaceBetween */,
                        children: [
                          if (event.totalSeats == null)
                            Icon(
                              Icons.people_outline,
                              color: OVTheme.primaryRed,
                              size: 18,
                            ),
                          if (event.totalSeats == null) SizedBox(width: 4),
                          if (event.totalSeats == null)
                            Text(
                              AppLocalizations.of(context)!
                                  .seatsLeft(event.availableSeats.toString()),
                              style: OVTheme.bodyBase.copyWith(
                                fontSize: 13,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          if (event.availableSeats != null &&
                              event.totalSeats != null)
                            Expanded(
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.people_outline,
                                    color: OVTheme.primaryRed,
                                    size: 18,
                                  ),
                                  SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .seatsRemaining(
                                              event.availableSeats.toString(),
                                              event.totalSeats ?? 0),
                                      style: OVTheme.bodyBase.copyWith(
                                        fontSize: 13,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  /*  Flexible(
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .availability,
                                      style: OVTheme.bodyBase.copyWith(
                                        color: OVTheme.muted,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ), */
                                ],
                              ),
                            ),
                          /* if (event.availableSeats != null &&
                              event.totalSeats != null)
                            Flexible(
                              child: Text(
                                AppLocalizations.of(context)!.seatsRemaining(
                                    event.availableSeats.toString(),
                                    event.totalSeats ?? 0),
                                style: OVTheme.bodyBase.copyWith(
                                  fontSize: 13,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ), */
                        ],
                      ),
                      if (event.availableSeats != null &&
                          event.totalSeats != null)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(top: 6, left: 13),
                          child: LinearPercentIndicator(
                            percent: (((event.availableSeats ?? 0) /
                                        (event.totalSeats ?? 1)) -
                                    1) *
                                -1,
                            lineHeight: 6.0,
                            linearStrokeCap: LinearStrokeCap.roundAll,
                            animation: true,
                            animationDuration: 1000,
                            curve: Curves.easeInOut,
                            animateFromLastPercent: true,
                            progressColor: OVTheme.primaryRed,
                            backgroundColor: OVTheme.semiTransparent,
                          ),
                        ),
                    ],
                  ),
                ),
              if (event.paxPrice != null && event.paxPrice! >= 0)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.money_outlined,
                          color: OVTheme.primaryRed,
                          size: 18,
                        ),
                        SizedBox(width: 4),
                        Text(
                          (event.paxPrice != null && event.paxPrice! > 0)
                              ? AppLocalizations.of(context)!.paxPrice(
                                  formatCurrency.format(event.paxPrice))
                              : AppLocalizations.of(context)!.freeEntrance,
                          style: OVTheme.bodyBase.copyWith(
                              color: OVTheme.primaryColor,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                )
            ],
          ),
        ),

        /*  if ((event.paxPrice ?? 0) > 0 || (event.availableSeats ?? 0) > 0)
          Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border(
                    top:
                        BorderSide(color: OVTheme.semiTransparent, width: 0.8)),
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
                          fontWeight: FontWeight.w500),
                    ),
                    FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          Icon(
                            Icons.people_outline,
                            color: OVTheme.primaryRed,
                            size: 16,
                          ),
                          SizedBox(width: 4),
                          Text(
                            "${event.availableSeats.toString()} ${AppLocalizations.of(context)!.seatsLeft}",
                            style:
                                OVTheme.bodyBase.copyWith(color: OVTheme.muted),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ])),
                  ])), */
        if ((event.detailedDesc ?? "").isNotEmpty)
          Container(
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    AppLocalizations.of(context)!.aboutThisEvent,
                    style: OVTheme.titlesBase.copyWith(
                      //fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: OVTheme.primaryColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                HtmlWidget(event.detailedDesc!,
                    textStyle: OVTheme.bodyBase.copyWith(
                      fontSize: 16,
                      color: OVTheme.primaryColor,
                    ))
                /*  Text(
                  event.detailedDesc!,
                  style: OVTheme.bodyBase.copyWith(
                    fontSize: 16,
                    color: OVTheme.primaryColor,
                  ),
                ), */
              ],
            ),
          ),
        if (event.hostName != null && event.hostName!.isNotEmpty)
          Container(
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            width: double.infinity,
            decoration: BoxDecoration(
              color: OVTheme.lightBackground,
              border: Border.all(color: OVTheme.semiTransparent, width: 0.8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    AppLocalizations.of(context)!.hostedBy,
                    style: OVTheme.titlesBase.copyWith(
                      //  fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: OVTheme.primaryColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Text(
                  event.hostName!,
                  style: OVTheme.bodyBase.copyWith(
                    fontSize: 16,
                    color: OVTheme.muted,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget buildHeader(BuildContext context) {
    return AppBar(
      elevation: 0,
      shadowColor: Colors.transparent,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      backgroundColor: OVTheme.lightBackground,
      leading: ModalRoute.of(context)!.canPop
          ? IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back,
                color: OVTheme.primaryColor,
                size: 16,
              ),
            )
          : null,
      iconTheme: IconThemeData(color: OVTheme.primaryColor),
      titleSpacing: 0.0,
      title: Flexible(
        child: Text(
          widget.event.title ?? "",
          style: OVTheme.titlesBase.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
            fontSize: 21,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
        ),
      ), /* FittedBox(
        fit: BoxFit.scaleDown,
        child: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Text(
            widget.event.title ?? "",
            style: OVTheme.titlesBase.copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
              fontSize: 21,
            ),
          ),
        ),
      ), */
    );
  }
}
