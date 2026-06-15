import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:vinho/generated/l10n/app_localizations.dart';
import 'package:vinho/l10n_helper/l10n_helper.dart';
import 'package:vinho/model/booking_summary_model.dart';
import 'package:vinho/model/event_model.dart';
import 'package:vinho/services/auth_service.dart';
import 'package:vinho/services/location.dart';
import 'package:vinho/theme/ov_theme.dart';
import 'package:vinho/view/booking_callback_view.dart';
import 'package:vinho/view/booking_view.dart';
import 'package:vinho/view/event_detail_view.dart';
import 'package:vinho/view/events_view.dart';
import 'package:vinho/view/leads_view.dart';
import 'package:vinho/view/login_view.dart';
import 'package:vinho/view/privacy_policy_view.dart';
import 'package:vinho/widgets/dialog.dart';
import 'package:vinho/widgets/language.dart';
import 'package:vinho/widgets/logo.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const AppInitializer());
}

void mains() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Uncomment to seed mock events (run once)
  // await SeedService.seedEvents();

  // await SeedService.disableEvents(); // Disable all events (for testing empty state)
  //await SeedService.seedLocations(); // Seed Portugal locations (run once)
  AuthService.ensureAuth().then((_) async {
    LocationSearchService.locations =
        await LocationSearchService.loadLocations();
    runApp(const MyApp());
  });
}

class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await AuthService.ensureAuth();
    LocationSearchService.locations =
        await LocationSearchService.loadLocations();

    if (mounted) {
      setState(() => _ready = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return Center(
        child: JumpingDots(
          color: OVTheme.muted,
          radius: 10,
          numberOfDots: 3,
        ),
      );
    }

    return const MyApp();
  }
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
  BookingSummaryModel? _bookingSummary;

  bool _dialogShown = false;

@override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.bookingSummary != widget.bookingSummary) {
      _bookingSummary = widget.bookingSummary;
      _tryShowDialog();
    }
  }


void _showDialog() {
  if (_dialogShown || _bookingSummary == null || !context.mounted) return;
  _dialogShown = true;

  showDialog(
    context: context,
    barrierColor: OVTheme.semiTransparent,
    builder: (context) => OVDialog(
      isFullscreen: false,
      content: BookingCallbackView(_bookingSummary!),
      onClose: () {
        setState(() {
          _bookingSummary = null;
          _dialogShown = false;
        });
      },
    ),
  );
}

  void _tryShowDialog() {
    if (_dialogShown) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showDialog();
    });
  }

  @override
  void initState() {
    super.initState();
    _bookingSummary = widget.bookingSummary;
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tryShowDialog();
    });
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              icon: const Icon(Icons.menu),
              iconSize: 28,
              onPressed: () {
                context.push('/leads');
              },
            ),
            const AppLogo()
          ],
        ),
        actions: [
          AppLanguage(),
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: EventsView(),
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
  late Future<Locale> _localeFuture;

  @override
  void initState() {
    super.initState();
    _localeFuture = _getDeviceLocale();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Locale>(
      future: _localeFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
              child: JumpingDots(
            color: OVTheme.muted,
            radius: 10,
            numberOfDots: 3,
          ));
        }
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
