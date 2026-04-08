import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/routines/presentation/routine_view_screen.dart';
import '../../features/routines/presentation/routine_edit_screen.dart';
import '../../features/routines/presentation/routine_history_screen.dart';
import '../../features/routines/presentation/routine_week_view_screen.dart';
import '../../features/routines/presentation/routine_date_view_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/onboarding/presentation/onboarding_providers.dart';
import '../ui/animations.dart';

part 'app_router.g.dart';

@riverpod
GoRouter router(Ref ref) {
  // Watch the onboarding completion status to trigger rebuilds
  final onboardingCompleteAsync = ref.watch(onboardingCompleteProvider);

  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      // Get the onboarding status synchronously from the async value
      final isComplete = onboardingCompleteAsync.maybeWhen(
        data: (isComplete) => isComplete,
        orElse: () => false, // Default to false while loading
      );

      // If not complete and not already on onboarding screen, redirect
      if (!isComplete && state.matchedLocation != '/onboarding') {
        return '/onboarding';
      }

      // If complete and on onboarding screen, redirect to home
      if (isComplete && state.matchedLocation == '/onboarding') {
        return '/';
      }

      return null; // No redirect
    },
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const RoutineViewScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SwissAnimations.pageTransition(
              animation: animation,
              child: child,
              type: PageTransitionType.fade,
            );
          },
        ),
      ),
      GoRoute(
        path: '/routine',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const RoutineViewScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SwissAnimations.pageTransition(
              animation: animation,
              child: child,
              type: PageTransitionType.fade,
            );
          },
        ),
      ),
      GoRoute(
        path: '/routine/edit/:routineId',
        pageBuilder: (context, state) {
          final routineId = state.pathParameters['routineId']!;
          return CustomTransitionPage(
            key: state.pageKey,
            child: RoutineEditScreen(routineId: routineId),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return SwissAnimations.pageTransition(
                    animation: animation,
                    child: child,
                    type: PageTransitionType.slideUp,
                  );
                },
          );
        },
      ),
      GoRoute(
        path: '/routine/history',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const RoutineHistoryScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SwissAnimations.pageTransition(
              animation: animation,
              child: child,
              type: PageTransitionType.slideUp,
            );
          },
        ),
      ),
      GoRoute(
        path: '/routine/week',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const RoutineWeekViewScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SwissAnimations.pageTransition(
              animation: animation,
              child: child,
              type: PageTransitionType.slideLeft,
            );
          },
        ),
      ),
      GoRoute(
        path: '/routine/date/:timestamp',
        pageBuilder: (context, state) {
          final timestamp = int.parse(state.pathParameters['timestamp']!);
          final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
          return CustomTransitionPage(
            key: state.pageKey,
            child: RoutineDateViewScreen(date: date),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return SwissAnimations.pageTransition(
                    animation: animation,
                    child: child,
                    type: PageTransitionType.slideUp,
                  );
                },
          );
        },
      ),
      GoRoute(
        path: '/onboarding',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const OnboardingScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SwissAnimations.pageTransition(
              animation: animation,
              child: child,
              type: PageTransitionType.scale,
            );
          },
        ),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const _PlaceholderScreen(title: 'Login'),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const _PlaceholderScreen(title: 'Sign Up'),
      ),
      GoRoute(
        path: '/routines',
        builder: (context, state) => const RoutineViewScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const _PlaceholderScreen(title: 'Profile'),
      ),
      GoRoute(
        path: '/calendars',
        builder: (context, state) =>
            const _PlaceholderScreen(title: 'Calendars'),
      ),
    ],
    errorBuilder: (context, state) => _ErrorScreen(error: state.error),
  );
}

/// Placeholder screen for routes not yet implemented
class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.construction, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              '$title Screen',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Coming soon...',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

/// Error screen shown when navigation fails
class _ErrorScreen extends StatelessWidget {
  const _ErrorScreen({this.error});

  final Exception? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Navigation Error',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            if (error != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  error.toString(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}
