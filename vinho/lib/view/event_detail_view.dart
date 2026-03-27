import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:go_router/go_router.dart';
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
      body: SafeArea(
        child: Stack(
          children: [
            RawScrollbar(
              controller: _scrollController,
              thumbVisibility: true,
              trackVisibility: true,
              //  radius: Radius.circular(8),
              thumbColor: OVTheme.primaryRed,
              thickness: 2,
              child: SingleChildScrollView(
                controller: _scrollController,
                child: buildEventCard(widget.event),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 16,
              right: 16,
              child: SafeArea(
                child: ElevatedButton(
                  onPressed: () =>
                      context.push('/booking', extra: widget.event),

                  style: ElevatedButton.styleFrom(
                    backgroundColor: OVTheme.primaryRed,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(1),
                    ),
                    elevation: 4,
                  ),
                  //icon: Icon(Icons.event_seat, color: Colors.white),
                  child: Text(
                    AppLocalizations.of(context)!.bookYourSeats,
                    style: OVTheme.bodyBase.copyWith(
                        color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildEventCard(EventModel event) {
    return Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (event.title != null && event.title!.isNotEmpty)
                Text(
                  widget.event.title ?? "",
                  style: OVTheme.titlesBase.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    fontSize: 21,
                  ),
                ),
              if (event.desc != null && event.desc!.isNotEmpty)
                Text(
                  event.desc!,
                  style: OVTheme.bodyBase.copyWith(
                    color: OVTheme.muted,
                    height: 1.6,
                    fontSize: 15,
                  ),
                ),
              if (event.title != null && event.title!.isNotEmpty ||
                  ((event.desc != null) && event.desc!.isNotEmpty))
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 16.0),
                  width: double.infinity,
                  height: 1,
                  color: OVTheme.semiTransparent,
                ),
              if (event.image != null && event.image!.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      image: AssetImage('assets/images/${event.image}'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              Container(
                // color: OVTheme.magentaNeon,
                // padding: EdgeInsets.all(8),
                margin: EdgeInsets.symmetric(vertical: 16),
                width: double.infinity,
                /*  decoration: BoxDecoration(
                  //color: Colors.white,
                  border:
                      Border.all(color: OVTheme.semiTransparent, width: 0.8),
                ), */
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (event.date != null && event.time != null) ...[
                      Row(
                        children: [
                          Icon(Icons.calendar_today,
                              color: OVTheme.primaryRed, size: 20),
                          SizedBox(width: 8),
                          Text(event.date!,
                              style: OVTheme.bodyBase
                                  .copyWith(fontWeight: FontWeight.w500)),
                          SizedBox(width: 16),
                          Icon(Icons.access_time,
                              color: OVTheme.primaryRed, size: 20),
                          SizedBox(width: 8),
                          Text(event.time!,
                              style: OVTheme.bodyBase
                                  .copyWith(fontWeight: FontWeight.w500)),
                        ],
                      ),
                      if ((event.location ?? "").isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
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
                                      style: OVTheme.bodyBase.copyWith(
                                          fontWeight: FontWeight.w600),
                                      /*   overflow: TextOverflow.ellipsis,
                              maxLines: , */
                                    ),
                                  ),
                                ],
                              ),
                              if (event.address != null &&
                                  event.address!.isNotEmpty)
                                SizedBox(height: 4),
                              if (event.address != null &&
                                  event.address!.isNotEmpty)
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
                      if (event.availableSeats != null ||
                          event.totalSeats != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
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
                                  if (event.totalSeats == null)
                                    SizedBox(width: 4),
                                  if (event.totalSeats == null)
                                    Text(
                                      AppLocalizations.of(context)!.seatsLeft(
                                          event.availableSeats.toString()),
                                      style: OVTheme.bodyBase.copyWith(
                                          //    fontSize: 13,
                                          fontWeight: FontWeight.w600),
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
                                                      event.availableSeats
                                                          .toString(),
                                                      event.totalSeats ?? 0),
                                              style: OVTheme.bodyBase.copyWith(
                                                  //        fontSize: 13,
                                                  fontWeight: FontWeight.w600),
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
                                  padding:
                                      const EdgeInsets.only(top: 6, left: 13),
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
                          padding: const EdgeInsets.only(top: 8.0),
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
                                  (event.paxPrice != null &&
                                          event.paxPrice! > 0)
                                      ? formatCurrency.format(event.paxPrice)
                                      : AppLocalizations.of(context)!
                                          .freeEntrance,
                                  style: OVTheme.bodyBase.copyWith(
                                      color: OVTheme.primaryColor,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        )
                    ],
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 16.0),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (event.detailedDesc != null &&
                        event.detailedDesc!.isNotEmpty) ...[
                      Text(
                        AppLocalizations.of(context)!.aboutThisEvent,
                        style: OVTheme.titlesBase.copyWith(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 12),
                      HtmlWidget(
                        event.detailedDesc!,
                        textStyle: OVTheme.bodyBase.copyWith(
                          height: 1.6,
                          fontSize: 14,
                          color: OVTheme.muted,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 60),
            ]));
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
      /*  titleSpacing: 0.0,
      title: Text(
        widget.event.title ?? "",
        style: OVTheme.titlesBase.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          fontSize: 21,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ), */
    );
  }
}
