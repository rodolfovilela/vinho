import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vinho/generated/l10n/app_localizations.dart';
import 'package:vinho/model/booking_summary_model.dart';
import 'package:vinho/model/function_response_model.dart';
import 'package:vinho/services/functions_service.dart';
import 'package:vinho/theme/ov_theme.dart';

class BookingConfirmationView extends StatefulWidget {
  BookingSummaryModel bookingSummaryModel;
  BookingConfirmationView({super.key, required this.bookingSummaryModel});

  @override
  State<BookingConfirmationView> createState() =>
      _BookingConfirmationViewState();
}

class _BookingConfirmationViewState extends State<BookingConfirmationView> {
  final _formKey = GlobalKey<FormState>();
  final _verificationCodeController = TextEditingController();
  bool _isSubmitting = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _verificationCodeController.dispose();
    super.dispose();
  }

  Future<void> _submitBooking() async {
    //if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);
      try {
          widget.bookingSummaryModel.booking.verificationCode =
          _verificationCodeController.text;
            if (widget.bookingSummaryModel.event.id != null) {
          FunctionResponseModel ret = await FunctionsService.bookSeats(
            widget.bookingSummaryModel.event.id!,
            widget.bookingSummaryModel.booking);
          widget.bookingSummaryModel.response = ret;
        }

        if (mounted) {
          context.go(
            '/',
            extra: widget.bookingSummaryModel,
          );
        }
      } finally {
        if (mounted) setState(() => _isSubmitting = false);
      }
  //  }
  }

  @override
  Widget build(BuildContext context) {
    return RawScrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      trackVisibility: true,
      thumbColor: OVTheme.primaryRed,
      thickness: 3,
      child: SingleChildScrollView(
          controller: _scrollController,
          physics: const NeverScrollableScrollPhysics(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.confirmYourEmail,
                  style: OVTheme.titlesBase.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: OVTheme.primaryRed,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                      AppLocalizations.of(context)!.confirmationCodeSentTo(
                          widget.bookingSummaryModel.booking.email),
                      style:
                          OVTheme.bodyBase.copyWith(fontWeight: FontWeight.w600, fontSize: 14)),
                ),
                Text(AppLocalizations.of(context)!
                    .bookingCodeConfirmationWarning),
                Container(
                  margin: const EdgeInsets.only(top: 32, bottom: 8),
                  child: TextFormField(
                    controller: _verificationCodeController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.confirmationCode,
                      hintText: '0000',
                    ),
                    cursorColor: OVTheme.blackRetro,
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    style: OVTheme.bodyBase.copyWith(
                      fontSize: 24,
                      letterSpacing: 16,
                      fontFamily: 'monospace',
                    ),
                    textAlign: TextAlign.center,
                    validator: (value) => value == null || value.length != 4
                        ? AppLocalizations.of(context)!.invalidCode
                        : null,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _submitBooking,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: OVTheme.primaryRed,
                        foregroundColor: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(1),
                        ),
                        elevation: 4,
                      ),
                      child: _isSubmitting
                          ? SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(AppLocalizations.of(context)!.confirmButton,
                              style: OVTheme.bodyBase.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500))),
                ),
                Text(AppLocalizations.of(context)!.checkSpamFolder,
                    style: OVTheme.bodyBase
                        .copyWith(fontSize: 12, color: OVTheme.muted)),
              ],
            ),
          )),
    );
  }
}
