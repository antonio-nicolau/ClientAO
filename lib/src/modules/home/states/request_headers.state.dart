import 'package:client_ao/src/core/models/http_header.model.dart';
import 'package:client_ao/src/modules/home/widgets/sections/request/request_header_field.widget.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final requestHeadersStateProvider = StateProvider<Map<UniqueKey, HttpHeader>>((ref) {
  return {};
});

final requestHeaderNotifierProvider = StateNotifierProvider<HeaderNotifier, List<RequestHeaderField>?>((ref) {
  return HeaderNotifier(ref);
});

class HeaderNotifier extends StateNotifier<List<RequestHeaderField>?> {
  final Ref _ref;

  HeaderNotifier(this._ref) : super([RequestHeaderField(UniqueKey())]);

  void add() {
    state = [...(state ?? []), RequestHeaderField(UniqueKey())];
  }

  void removeAt(UniqueKey key) {
    state = [
      for (final e in state ?? <RequestHeaderField>[])
        if (e.widgetKey != key) e
    ];
    _ref.read(requestHeadersStateProvider).remove(key);
  }

  void removeAll() {
    state = [RequestHeaderField(UniqueKey())];
    _ref.invalidate(requestHeaderNotifierProvider);
  }
}
