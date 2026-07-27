import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:okey101/app/app.dart';
import 'package:okey101/app/providers.dart';
import 'package:okey101/data/local_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // shared_preferences maps to localStorage on web and has to be opened before
  // the first frame, so settings and any saved game are there synchronously
  // from then on.
  final store = await LocalStore.open();
  runApp(
    ProviderScope(
      overrides: [localStoreProvider.overrideWithValue(store)],
      child: const Okey101App(),
    ),
  );
}
