import 'package:hooks_riverpod/hooks_riverpod.dart'
    show ProviderBase, ProviderContainer, ProviderObserver;
import 'package:video_demo/_features.dart';

enum ProviderEvent { add, update, fail, dispose }

class AppObserver extends ProviderObserver {
  const AppObserver();

  String _eventMessage({
    required ProviderEvent providerEvent,
    required ProviderBase provider,
    Object? value,
  }) {
    final event = providerEvent.name;
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
        providerEvent: ProviderEvent.add,
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
        providerEvent: ProviderEvent.update,
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
        providerEvent: ProviderEvent.fail,
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
        providerEvent: ProviderEvent.dispose,
        provider: provider,
      ),
    );
  }
}
