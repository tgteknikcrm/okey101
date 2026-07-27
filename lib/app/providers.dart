import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Active UI locale. Null means "follow the device".
///
/// Riverpod 3.x manual API only - no code generation anywhere in this project.
final localeProvider = NotifierProvider<LocaleNotifier, Locale?>(
  LocaleNotifier.new,
);

class LocaleNotifier extends Notifier<Locale?> {
  @override
  Locale? build() => const Locale('tr');

  void setLocale(Locale? locale) => state = locale;
}
