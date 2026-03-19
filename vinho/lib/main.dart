import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:vinho/generated/l10n/app_localizations.dart';
import 'package:vinho/l10n_helper/l10n_helper.dart';
import 'package:vinho/model/event_model.dart';
import 'package:vinho/model/lead_model.dart';
import 'package:vinho/theme/ov_theme.dart';
import 'package:vinho/view/event_detail_view.dart';
import 'package:vinho/view/events_view.dart';
import 'package:vinho/view/leads_view.dart';
import 'package:vinho/view/login_view.dart';

import 'firebase_options.dart';

List<LeadModel> leads = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Uncomment to seed mock events (run once)
  // await SeedService.seedEvents();
  
  runApp(const MyApp());
}

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
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
            if (leads.isEmpty) {
              leads = leads = [
                LeadModel(
                  title: AppLocalizations.of(context)!.ourMissionTitle,
                  description:
                      AppLocalizations.of(context)!.ourMissionDesc,
                  icon: Icons.adjust_outlined,
                  //  route: '/leads',
                ),
                LeadModel(
                  title: AppLocalizations.of(context)!.hostsTitle,
                  description:
                      AppLocalizations.of(context)!.hostsDesc,
                  icon: Icons.storefront_outlined,
                  //route: '/leads',
                ),
                LeadModel(
                  title: AppLocalizations.of(context)!.sommeliersTitle,
                  description:
                      AppLocalizations.of(context)!.sommeliersDesc,
                  icon: Icons.work_outline,
                  // route: '/reports',
                ),
              ];
            }

            return const LeadsView();
          },
        ),
        GoRoute(
          path: 'event_detail',
          builder: (BuildContext context, GoRouterState state) {
            return state.extra != null && state.extra is EventModel
                ? EventDetailView(state.extra as EventModel)
                : const HomeScreen();
          },
        ),
      ],
    ),
  ],
);


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
  return Scaffold(
      backgroundColor: OVTheme.backgroundColor,
     
      appBar: AppBar(
        backgroundColor: OVTheme.lightBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: FittedBox(
            fit: BoxFit.contain,
            child: Image.asset(
              'assets/images/glass.png',
              height: kToolbarHeight * 0.8,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              context.push('/leads');
            },
          ),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
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

