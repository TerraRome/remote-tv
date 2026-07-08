import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../di/injection.dart';
import '../../features/discovery/presentation/bloc/discovery_bloc.dart';
import '../../features/discovery/presentation/pages/discovery_page.dart';
import '../../features/discovery/domain/entities/tv_device.dart';
import '../../features/pairing/presentation/bloc/pairing_bloc.dart';
import '../../features/pairing/presentation/pages/pairing_page.dart';
import '../../features/remote/presentation/bloc/remote_bloc.dart';
import '../../features/remote/presentation/pages/remote_page.dart';
import '../../features/favorites/presentation/bloc/favorites_bloc.dart';
import '../../features/favorites/presentation/pages/favorites_page.dart';

final class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/discovery',
    routes: [
      GoRoute(
        path: '/discovery',
        name: 'discovery',
        builder: (context, state) => BlocProvider(
          create: (_) => getIt<DiscoveryBloc>(),
          child: const DiscoveryPage(),
        ),
      ),
      GoRoute(
        path: '/pair/:deviceId',
        name: 'pair',
        builder: (context, state) {
          final device = state.extra as TvDevice;
          return BlocProvider(
            create: (_) => getIt<PairingBloc>(),
            child: PairingPage(device: device),
          );
        },
      ),
      GoRoute(
        path: '/favorites',
        name: 'favorites',
        builder: (context, state) => BlocProvider(
          create: (_) => getIt<FavoritesBloc>(),
          child: const FavoritesPage(),
        ),
      ),
      GoRoute(
        path: '/remote/:deviceId',
        name: 'remote',
        builder: (context, state) {
          final device = state.extra as TvDevice;
          return BlocProvider(
            create: (_) => getIt<RemoteBloc>(),
            child: RemotePage(device: device),
          );
        },
      ),
    ],
  );
}
