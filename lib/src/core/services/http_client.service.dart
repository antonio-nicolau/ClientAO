import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

final httpClientProvider = Provider<HttpClient>((ref) {
  return HttpClient(http.Client());
});

class HttpClient extends http.BaseClient {
  final http.Client _inner;

  HttpClient(this._inner);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _inner.send(request);
  }
}
