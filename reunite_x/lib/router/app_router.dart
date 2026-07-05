import 'package:go_router/go_router.dart';
import 'package:reunite_x/features/auth/view/register.dart';

import '../shared/layout/app_shell.dart';
import '../features/auth/view/login.dart';
import '../features/feeds/view/feeds.dart';
import '../features/report/view/reporting.dart';
import '../features/profile/view/profile.dart';
import '../features/sighting/view/sighting_screen.dart';
import '../features/ai_match/view/face_match.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const Login(),

    ),
   GoRoute(
  path: '/register',
  builder: (context, state) => const OnboardingFlow(),
),

    ShellRoute(
      builder: (context, state, child) {
        return AppShell(child: child);
      },
      routes: [
        GoRoute(
          path: '/map',
          builder: (context, state) => const FeedScreen(),
        ),
        GoRoute(
          path: '/attendance',
          builder: (context, state) => const AI_Match(),
        ),
        GoRoute(
          path: '/chat',
          builder: (context, state) => const Reporting(),
        ),
        GoRoute(
          path: '/notifications',
          builder: (context, state) => const Sightings(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const Profile(),
        ),
      ],
    ),
  ],
);