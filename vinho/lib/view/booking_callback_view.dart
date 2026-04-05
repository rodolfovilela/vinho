import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vinho/generated/l10n/app_localizations.dart';
import 'package:vinho/model/booking_summary_model.dart';
import 'package:vinho/theme/ov_theme.dart';

class BookingCallbackView extends StatefulWidget {
  final BookingSummaryModel bookingSummary;
  const BookingCallbackView(this.bookingSummary, {super.key});

  @override
  State<BookingCallbackView> createState() => _BookingCallbackViewState();
}

class _BookingCallbackViewState extends State<BookingCallbackView> {
  @override
  Widget build(BuildContext context) {
    if (widget.bookingSummary.response!.success) {
      return Container(
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
                                      style: OVTheme.bodyBase.copyWith(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                              if (widget.bookingSummary.event.address != null &&
                                  widget
                                      .bookingSummary.event.address!.isNotEmpty)
                                SizedBox(height: 4),
                              if (widget.bookingSummary.event.address != null &&
                                  widget
                                      .bookingSummary.event.address!.isNotEmpty)
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(width: 22),
                                    Flexible(
                                      child: Text(
                                        widget.bookingSummary.event.address ??
                                            "",
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
                      style: OVTheme.bodyBase
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                    Text(AppLocalizations.of(context)!
                        .emailBookingConfirmationWarning(
                            widget.bookingSummary.booking.email)),
                    SizedBox(height: 16),
                    if (widget.bookingSummary.event.hasMinimumPaxRequired &&
                        widget.bookingSummary.event.hasDeadlineForMinimumPax)
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: OVTheme.primaryColor, width: 1.2),
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
                        child: Text(
                            "List of other events (@TODO) - based on adPriority)")),
                  ]),
            ),
          ],
        ),
      );
    } else {
      switch (widget.bookingSummary.response!.errorCode) {
        case 'not-enough-seats':
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              children: [
                Text(
                  "not-enough-seats - Some emotionally impactful message here about limited availability and encouraging users to check out other events",
                  style: OVTheme.titlesBase.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: OVTheme.primaryRed,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  "not-enough-seats",
                  style: OVTheme.bodyBase.copyWith(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          );
        default:
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              children: [
                Text(
                  "AppLocalizations.of(context)!.bookingSubmissionFailedTitle",
                  style: OVTheme.titlesBase.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: OVTheme.primaryRed,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  "AppLocalizations.of(context)!.bookingSubmissionFailedMessage",
                  style: OVTheme.bodyBase.copyWith(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          );
      }
    }
  }
}
