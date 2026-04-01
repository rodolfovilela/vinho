import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vinho/generated/l10n/app_localizations.dart';
import 'package:vinho/model/booking_model.dart';
import 'package:vinho/model/event_model.dart';
import 'package:vinho/services/functions_service.dart';
import 'package:vinho/services/toast_service.dart';
import 'package:vinho/theme/ov_theme.dart';
import 'package:vinho/view/privacy_policy_view.dart';

class BookingView extends StatefulWidget {
  final EventModel event;
  const BookingView(this.event, {super.key});

  @override
  State<BookingView> createState() => _BookingViewState();
}

class _BookingViewState extends State<BookingView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _countryCodeController = TextEditingController(text: '+351');
  bool _privacyConsent = false;
  int _paxCount = 1;
  bool _isSubmitting = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    //_firestoreService = FirestoreService();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submitBooking() async {
    print('🔥 _submitBooking called');
    if (!_privacyConsent) {
      print('❌ Privacy consent missing');
      if (mounted) {
        ToastService.error(
          context,
          AppLocalizations.of(context)!.privacyPolicyError,
        );
      }
      return;
    }
    print('✅ Privacy OK');
    if (_formKey.currentState!.validate()) {
      print('✅ Form validated');
      setState(() => _isSubmitting = true);
      try {
        print('📋 Creating booking, event.id: ${widget.event.id}');
        final fullPhone = _countryCodeController.text + _phoneController.text;
        final booking = BookingModel(
          eventId: widget.event.id!,
          seats: _paxCount,
          name: _nameController.text,
          email: _emailController.text,
          phone: fullPhone,
        );

        print('🚀 Calling FunctionsService.bookSeats...');

        bool ret = await FunctionsService.bookSeats(widget.event.id!, booking);
        print('✅ bookSeats returned: $ret');

        if (mounted) {
          if (ret) {
            Navigator.pop(context);

            ToastService.success(
              context,
              AppLocalizations.of(context)!.bookingSuccessfullyDone,
            );
          } else {
             ToastService.error(
              context,
              AppLocalizations.of(context)!.bookingError,
            );
          }
        }
      } catch (e) {
        if (kDebugMode) print('Booking submit error: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error saving booking. Try again.')),
          );
        }
      } finally {
        if (mounted) setState(() => _isSubmitting = false);
      }
    }
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
                child: Container(
                  height: MediaQuery.of(context).size.height - kToolbarHeight,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  child: bookingForm(),
                ),
              ),
            ),
            Positioned(
              bottom: 4,
              left: 16,
              right: 16,
              child: SafeArea(
                child: Column(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.onlySeatsLeft(
                          widget.event.availableSeats ?? 0),
                      style: OVTheme.bodyBase.copyWith(
                        color: OVTheme.muted,
                        fontSize: 11,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: _isSubmitting ? null : _submitBooking,
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
                          child: _isSubmitting
                              ? SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : Text(AppLocalizations.of(context)!.bookNow,
                                  style: OVTheme.bodyBase.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500))),
                    ),
                  ],
                ),
                /* ElevatedButton(
                  onPressed: _showBookingConfirmation,
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
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                ), */
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bookingForm() {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              //  mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.numberOfGuests,
                  style: OVTheme.bodyBase.copyWith(
                    color: OVTheme.blackRetro,
                    fontSize: 14,
                  ),
                ),
                IconButton(
                  onPressed:
                      _paxCount > 1 ? () => setState(() => _paxCount--) : null,
                  icon: Icon(Icons.remove, color: OVTheme.muted),
                ),
                Container(
                  width: 60,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: OVTheme.blackRetro),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '$_paxCount',
                    style: OVTheme.bodyBase.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: OVTheme.blackRetro,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => setState(() => _paxCount++),
                  icon: Icon(Icons.add, color: OVTheme.primaryRed),
                ),
              ],
            ),
          ),
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              //hintText: "hinttext",
              labelText: AppLocalizations.of(context)!.fullName,
            ),

            /*  decoration: OVTheme.inputDecorationTheme.copyWith(
              labelText: AppLocalizations.of(context)!.fullName,
            ), */
            cursorColor: OVTheme.blackRetro,
            validator: (value) => value == null || value.isEmpty
                ? AppLocalizations.of(context)!.nameRequired
                : null,
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.email,
            ),
            cursorColor: OVTheme.blackRetro,
            validator: (value) => value == null || !value.contains('@')
                ? AppLocalizations.of(context)!.validEmailRequired
                : null,
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: 68,
                  child: TextFormField(
                    controller: _countryCodeController,
                    decoration: InputDecoration(
                      labelText:
                          AppLocalizations.of(context)!.countryCallingCode,
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 8),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _countryCodeController.text = '+351';
                          if (mounted) setState(() {});
                        });
                        return null;
                      } else if (!RegExp(r'^\+[1-9]\d{1,3}$').hasMatch(value)) {
                        return AppLocalizations.of(context)!.invalidCallingCode;
                      }
                      return null;
                    },
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                flex: 3,
                child: SizedBox(
                  height: 68,
                  child: TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.phoneNumber,
                      border: OutlineInputBorder(),
                    ),
                    cursorColor: OVTheme.blackRetro,
                    validator: (value) => value == null || value.isEmpty
                        ? AppLocalizations.of(context)!.phoneRequired
                        : null,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.privacyPolicyDisclaimer,
                style: OVTheme.bodyBase.copyWith(
                  color: OVTheme.muted,
                  fontSize: 11,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(
                    value: _privacyConsent,
                    onChanged: (value) {
                      setState(() {
                        _privacyConsent = value ?? false;
                      });
                    },
                    activeColor: OVTheme.primaryRed,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PrivacyPolicyView(),
                        ),
                      ),
                      child: RichText(
                        text: TextSpan(
                          style: OVTheme.bodyBase
                              .copyWith(fontSize: 14, color: OVTheme.muted),
                          children: [
                            TextSpan(
                                text:
                                    '${AppLocalizations.of(context)!.iHaveReadAndAccept} '),
                            TextSpan(
                              text: AppLocalizations.of(context)!.privacyPolicy,
                              style: TextStyle(
                                  color: OVTheme.primaryRed,
                                  decoration: TextDecoration.underline,
                                  fontSize: 14),
                            ),
                            const TextSpan(text: '.'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
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
      centerTitle: true,
      title: Text(
        AppLocalizations.of(context)!.yourDetails,
        style: OVTheme.bodyBase
            .copyWith(fontSize: 16, fontWeight: FontWeight.w600),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
