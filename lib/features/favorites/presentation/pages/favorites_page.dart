import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/favorites_bloc.dart';
import '../bloc/favorites_event.dart';
import '../bloc/favorites_state.dart';

final class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: BlocBuilder<FavoritesBloc, FavoritesState>(
        builder: (context, state) => switch (state) {
          FavoritesInitial() => const Center(child: Text('No favorites yet')),
          FavoritesLoaded(:final devices) =>
            devices.isEmpty
                ? const Center(child: Text('No favorites yet'))
                : ListView.builder(
                    itemCount: devices.length,
                    itemBuilder: (context, index) {
                      final device = devices[index];
                      return ListTile(
                        leading: const Icon(Icons.tv),
                        title: Text(device.name),
                        subtitle: Text(device.ipAddress),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => context.read<FavoritesBloc>().add(
                            FavoritesRemove(device.id),
                          ),
                        ),
                      );
                    },
                  ),
          FavoritesError(:final message) => Center(
            child: Text('Error: $message'),
          ),
        },
      ),
    );
  }
}
