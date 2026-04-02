import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vinho/generated/l10n/app_localizations.dart';
import 'package:vinho/model/booking_model.dart';
import 'package:vinho/model/event_model.dart';
import 'package:vinho/theme/ov_theme.dart';

class BookingSummaryView extends StatefulWidget {
  final EventModel event;
  final BookingModel booking;
  const BookingSummaryView(this.event, this.booking, {super.key});

  @override
  State<BookingSummaryView> createState() => _BookingSummaryViewState();
}

class _BookingSummaryViewState extends State<BookingSummaryView> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return RawScrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      trackVisibility: true,
      thumbColor: OVTheme.primaryRed,
      thickness: 4,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Container(
          height: MediaQuery.of(context).size.height - kToolbarHeight,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            children: [
              Text(
                "${AppLocalizations.of(context)!.bookingSummaryTitle} - ${widget.event.title}",
                style: OVTheme.titlesBase.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: OVTheme.primaryRed,
                ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(),
                child: RawScrollbar(
                  controller: _scrollController,
                  thumbVisibility: true,
                  trackVisibility: true,
                  thumbColor: OVTheme.primaryRed,
                  thickness: 4,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (widget.event.date != null)
                                Text(widget.event.date!,
                                    style: OVTheme.bodyBase.copyWith(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16)),
                              if (widget.event.time != null)
                                Text(widget.event.time!,
                                    style: OVTheme.bodyBase
                                        .copyWith(fontWeight: FontWeight.w500)),
                              if ((widget.event.location ?? "").isNotEmpty)
                                Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                widget.event.location!,
                                                style: OVTheme.bodyBase
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.w600),
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (widget.event.address != null &&
                                            widget.event.address!.isNotEmpty)
                                          SizedBox(height: 4),
                                        if (widget.event.address != null &&
                                            widget.event.address!.isNotEmpty)
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SizedBox(width: 22),
                                              Flexible(
                                                child: Text(
                                                  widget.event.address ?? "",
                                                  style:
                                                      OVTheme.bodyBase.copyWith(
                                                    color: OVTheme.muted,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                      ],
                                    )),
                              SizedBox(height: 16),
                              Text(
                                AppLocalizations.of(context)!
                                    .bookingSummarySeats(widget.booking.seats),
                                style: OVTheme.bodyBase
                                    .copyWith(fontWeight: FontWeight.w500),
                              ),
                              Text(AppLocalizations.of(context)!
                                  .emailBookingConfirmationWarning(
                                      widget.booking.email)),
                              SizedBox(height: 16),
                              if (widget.event.hasMinimumPaxRequired &&
                                  widget.event.hasDeadlineForMinimumPax)
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: OVTheme.primaryColor,
                                        width: 1.2),
                                  ),
                                  padding: const EdgeInsets.all(16.0),
                                  width: double.infinity,
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .minimumPaxRequiredWithDeadlineDisclaimer(
                                            widget.event.minimumPaxRequired
                                                .toString(),
                                            DateFormat.yMMMd().add_jm().format(
                                                widget.event
                                                    .deadlineForMinimumPax!)),
                                    style: OVTheme.bodyBase.copyWith(
                                      height: 1.6,
                                      fontSize: 13,
                                      color: OVTheme.muted,
                                    ),
                                  ),
                                ),
                              TextButton(
                                  onPressed: null,
                                  child: Text("Invite friends (@TODO)")),
                                  
                            ])),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
