import 'package:client_ao/src/core/models/http_header.model.dart';
import 'package:client_ao/src/modules/home/widgets/sections/request/request_header_field.widget.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final urlStateProvider = StateProvider<Uri?>((ref) {
  return Uri();
});

final requestUrlParamsStateProvider = StateProvider<Map<UniqueKey, HttpHeader>>((ref) {
  return {};
});

final requestUrlParamsNotifierProvider = StateNotifierProvider<HeaderUrlParamsNotifier, List<RequestHeaderField>?>((ref) {
  return HeaderUrlParamsNotifier(ref);
});

class HeaderUrlParamsNotifier extends StateNotifier<List<RequestHeaderField>?> {
  final Ref _ref;

  HeaderUrlParamsNotifier(this._ref) : super(null) {
    final key = UniqueKey();
    state = [
      RequestHeaderField(
        key,
        keyFieldHintText: 'name',
        valueFieldHintText: 'value',
        onKeyFieldChanged: (value) => _onKeyFieldChanged(key, value),
        onValueFieldChanged: (value) => _onValueFieldChanged(key, value),
      ),
    ];
  }

  void add() {
    final key = UniqueKey();
    state = [
      ...(state ?? []),
      RequestHeaderField(
        key,
        keyFieldHintText: 'name',
        valueFieldHintText: 'value',
        onKeyFieldChanged: (value) => _onKeyFieldChanged(key, value),
        onValueFieldChanged: (value) => _onValueFieldChanged(key, value),
      )
    ];
  }

  void _addParamsToUrl() {
    final urlParamsList = _ref.read(requestUrlParamsStateProvider).entries.map((e) => e.value);

    final queryParams = Map.fromEntries(
      urlParamsList.map((e) => MapEntry<String, dynamic>(e.key ?? '', e.value)),
    );

    final uri = _ref.read(urlStateProvider);
    final uriWithParams = Uri(
      scheme: uri?.scheme,
      path: uri?.path,
      host: uri?.host,
      queryParameters: queryParams,
    );

    _ref.read(urlStateProvider.notifier).state = uriWithParams;
  }

  void removeAt(UniqueKey key) {
    state = [
      for (final e in state ?? <RequestHeaderField>[])
        if (e.widgetKey != key) e
    ];
    _ref.read(requestUrlParamsStateProvider).remove(key);
  }

  void removeAll() {
    state = [
      RequestHeaderField(
        UniqueKey(),
        keyFieldHintText: 'name',
        valueFieldHintText: 'value',
      )
    ];
    _ref.invalidate(requestUrlParamsStateProvider);
  }

  void _onKeyFieldChanged(UniqueKey key, String value) {
    HttpHeader? header = _ref.read(requestUrlParamsStateProvider)[key];
    header ??= HttpHeader();
    _ref.read(requestUrlParamsStateProvider.notifier).state[key] = header.copyWith(key: value);
    _addParamsToUrl();
  }

  void _onValueFieldChanged(UniqueKey key, String value) {
    HttpHeader? header = _ref.read(requestUrlParamsStateProvider)[key];
    header ??= HttpHeader();
    _ref.read(requestUrlParamsStateProvider.notifier).state[key] = header.copyWith(value: value);
    _addParamsToUrl();
  }
}
