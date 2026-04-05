import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vinho/generated/l10n/app_localizations.dart';
import 'package:vinho/model/booking_summary_model.dart';
import 'package:vinho/theme/ov_theme.dart';

class BookingSummaryView extends StatefulWidget {
  final BookingSummaryModel bookingSummary;
  const BookingSummaryView(this.bookingSummary, {super.key});

  @override
  State<BookingSummaryView> createState() => _BookingSummaryViewState();
}

class _BookingSummaryViewState extends State<BookingSummaryView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      //  height: MediaQuery.of(context).size.height - kToolbarHeight,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        children: [
          Text(
            "${AppLocalizations.of(context)!.bookingSummaryTitle} - ${widget.bookingSummary.event.title}",
            style: OVTheme.titlesBase.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: OVTheme.primaryRed,
            ),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.bookingSummary.event.date != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today,
                              color: OVTheme.primaryRed, size: 20),
                          SizedBox(width: 8),
                          Text(widget.bookingSummary.event.date!,
                              style: OVTheme.bodyBase
                                  .copyWith(fontWeight: FontWeight.w500)),
                          if (widget.bookingSummary.event.time != null) ...[
                            SizedBox(width: 16),
                            Icon(Icons.access_time,
                                color: OVTheme.primaryRed, size: 20),
                            SizedBox(width: 8),
                            Text(widget.bookingSummary.event.time!,
                                style: OVTheme.bodyBase
                                    .copyWith(fontWeight: FontWeight.w500)),
                          ]
                        ],
                      ),
                    ),
                  if ((widget.bookingSummary.event.location ?? "").isNotEmpty)
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
                                    widget.bookingSummary.event.location!,
                                    style: OVTheme.bodyBase
                                        .copyWith(fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                            if (widget.bookingSummary.event.address != null &&
                                widget.bookingSummary.event.address!.isNotEmpty)
                              SizedBox(height: 4),
                            if (widget.bookingSummary.event.address != null &&
                                widget.bookingSummary.event.address!.isNotEmpty)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(width: 22),
                                  Flexible(
                                    child: Text(
                                      widget.bookingSummary.event.address ?? "",
                                      style: OVTheme.bodyBase.copyWith(
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
                    AppLocalizations.of(context)!.bookingSummarySeats(
                        widget.bookingSummary.booking.seats),
                    style:
                        OVTheme.bodyBase.copyWith(fontWeight: FontWeight.w500),
                  ),
                  Text(AppLocalizations.of(context)!
                      .emailBookingConfirmationWarning(
                          widget.bookingSummary.booking.email)),
                  SizedBox(height: 16),
                  if (widget.bookingSummary.event.hasMinimumPaxRequired &&
                      widget.bookingSummary.event.hasDeadlineForMinimumPax)
                    Container(
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: OVTheme.primaryColor, width: 1.2),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      width: double.infinity,
                      child: Text(
                        AppLocalizations.of(context)!
                            .minimumPaxRequiredWithDeadlineDisclaimer(
                                widget.bookingSummary.event.minimumPaxRequired
                                    .toString(),
                                DateFormat.yMMMd().add_jm().format(widget
                                    .bookingSummary
                                    .event
                                    .deadlineForMinimumPax!)),
                        style: OVTheme.bodyBase.copyWith(
                          height: 1.6,
                          fontSize: 13,
                          color: OVTheme.muted,
                        ),
                      ),
                    ),
                  TextButton(
                      onPressed: null, child: Text("Invite friends (@TODO)")),
                  TextButton(
                      onPressed: null,
                      child: Text("List of other events (@TODO)")),
                ]),
          ),
        ],
      ),
    );
  }
}
