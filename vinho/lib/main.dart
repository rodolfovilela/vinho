import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:vinho/generated/l10n/app_localizations.dart';
import 'package:vinho/l10n_helper/l10n_helper.dart';
import 'package:vinho/model/booking_model.dart';
import 'package:vinho/model/booking_summary_model.dart';
import 'package:vinho/model/event_model.dart';
import 'package:vinho/services/auth_service.dart';
import 'package:vinho/theme/ov_theme.dart';
import 'package:vinho/view/booking_summary_view.dart';
import 'package:vinho/view/booking_view.dart';
import 'package:vinho/view/event_detail_view.dart';
import 'package:vinho/view/events_view.dart';
import 'package:vinho/view/leads_view.dart';
import 'package:vinho/view/login_view.dart';
import 'package:vinho/view/privacy_policy_view.dart';
import 'package:vinho/widgets/dialog.dart';
import 'package:vinho/widgets/logo.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Uncomment to seed mock events (run once)
  // await SeedService.seedEvents();

  // await SeedService.disableEvents(); // Disable all events (for testing empty state)

  AuthService.ensureAuth().then((_) {
    runApp(const MyApp());
  });
}

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return HomeScreen(
            bookingSummary: state.extra is BookingSummaryModel
                ? state.extra as BookingSummaryModel
                : null);
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'login',
          builder: (BuildContext context, GoRouterState state) {
            return const LoginView();
          },
        ),
        GoRoute(
          path: 'leads',
          builder: (BuildContext context, GoRouterState state) {
            return LeadsView();
          },
        ),
        GoRoute(
          path: 'event_detail',
          builder: (BuildContext context, GoRouterState state) {
            return state.extra != null && state.extra is EventModel
                ? EventDetailView(state.extra as EventModel)
                : HomeScreen();
          },
        ),
        GoRoute(
          path: 'booking',
          builder: (BuildContext context, GoRouterState state) {
            return state.extra != null && state.extra is EventModel
                ? BookingView(state.extra as EventModel)
                : HomeScreen();
          },
        ),
        GoRoute(
          path: 'privacy_policy',
          builder: (BuildContext context, GoRouterState state) {
            return state.extra != null && state.extra is EventModel
                ? PrivacyPolicyView()
                : HomeScreen();
          },
        ),
      ],
    ),
  ],
);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.bookingSummary});

  final BookingSummaryModel? bookingSummary;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    BookingSummaryModel bookingSummary = BookingSummaryModel(
        booking: BookingModel(
            eventId: 'eventId',
            seats: 2,
            name: 'name',
            email: ' email',
            phone: ' phone'),
        event: EventModel(
            id: 'eventId',
            title: 'Event Title',
            date: '2024-12-31',
            time: '20:00',
            address: 'Event Address',
            deadlineForMinimumPax: DateTime.now(),
            minimumPaxRequired: 10,
            location: 'Event Location'),
        isSuccessful: true,
        extraMessage: 'Extra message');
        
    _scrollController = ScrollController();
    if (/* widget. */bookingSummary != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          showDialog(
            context: context,
            barrierColor: OVTheme.semiTransparent,
            builder: (context) => OVDialog(
              content: BookingSummaryView(/* widget. */bookingSummary!),
            ),
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OVTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: OVTheme.lightBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        title: SizedBox(
          width: MediaQuery.of(context).size.width - 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [const AppLogo()],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            iconSize: 28,
            onPressed: () {
              context.push('/leads');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: RawScrollbar(
          controller: _scrollController,
          thumbVisibility: true,
          trackVisibility: true,
          thumbColor: OVTheme.primaryRed,
          thickness: 3,
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  /* QuickSearchView(), 
                  SizedBox(height: 16), */
                  EventsView(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? locale;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Locale>(
      future: _getDeviceLocale(),
      builder: (context, snapshot) {
        final deviceLocale = snapshot.data ?? const Locale('pt');
        return L10nHelper(
          currentLocaleCallback: () => locale ?? deviceLocale,
          localChangeCallback: (l) => setState(() => locale = l),
          child: MaterialApp.router(
            locale: locale ?? deviceLocale,
            theme: ThemeData(
              inputDecorationTheme: OVTheme.inputDecorationTheme,
            ),
            routerConfig: _router,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            builder: (context, child) => ResponsiveBreakpoints.builder(
              child: child!,
              breakpoints: [
                const Breakpoint(start: 0, end: 450, name: MOBILE),
                const Breakpoint(start: 451, end: 800, name: TABLET),
                const Breakpoint(start: 801, end: 1920, name: DESKTOP),
                const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<Locale> _getDeviceLocale() async {
    final lang = WidgetsBinding.instance.platformDispatcher.locale.languageCode;
    return lang.startsWith('pt') ? const Locale('pt') : const Locale('en');
  }
}
