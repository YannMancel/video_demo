import 'package:hooks_riverpod/hooks_riverpod.dart'
    show ProviderBase, ProviderContainer, ProviderObserver;
import 'package:video_demo/_features.dart';

enum EventType {
  add,
  update,
  fail,
  dispose;

  int get _lengthMax {
    return EventType.values
        .map((e) => e.name.length)
        .reduce((a, b) => (a < b) ? b : a);
  }

  String get formattedName => name.toUpperCase().padRight(_lengthMax);
}

class AppObserver extends ProviderObserver {
  const AppObserver();

  String _eventMessage({
    required EventType eventType,
    required ProviderBase provider,
    Object? value,
  }) {
    final event = eventType.formattedName;
    final name = provider.name ?? provider.runtimeType;
    final result = (value != null) ? '- $value' : '';

    return '[$event] $name - $result';
  }

  @override
  void didAddProvider(
    ProviderBase provider,
    Object? value,
    ProviderContainer container,
  ) {
    Logger.debug(
      message: _eventMessage(
        eventType: EventType.add,
        provider: provider,
        value: value,
      ),
    );
  }

  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    Logger.info(
      message: _eventMessage(
        eventType: EventType.update,
        provider: provider,
        value: newValue,
      ),
    );
  }

  @override
  void providerDidFail(
    ProviderBase provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    Logger.warning(
      message: _eventMessage(
        eventType: EventType.fail,
        provider: provider,
      ),
    );
  }

  @override
  void didDisposeProvider(
    ProviderBase provider,
    ProviderContainer containers,
  ) {
    Logger.wtf(
      message: _eventMessage(
        eventType: EventType.dispose,
        provider: provider,
      ),
    );
  }
}
