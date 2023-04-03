import 'package:client_ao/src/core/constants/enums.dart';
import 'package:client_ao/src/core/models/request_model.model.dart';
import 'package:client_ao/src/core/services/client.service.interface.dart';
import 'package:client_ao/src/core/services/http_client.service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

final apiRequestProvider = Provider<IApiRequest>((ref) {
  final httpClient = ref.read(httpClientProvider);
  return ApiRequest(httpClient);
});

final apiRequestNotifierProvider = StateNotifierProvider<ApiRequestNotifier, AsyncValue<Response?>?>((ref) {
  final apiRequest = ref.read(apiRequestProvider);
  return ApiRequestNotifier(apiRequest);
});

class ApiRequest implements IApiRequest {
  final HttpClient _httpClient;

  const ApiRequest(this._httpClient);

  @override
  Future<http.Response> request(RequestModel requestModel) async {
    Response? response;
    final headers = Map.fromEntries(
      requestModel.headers!.map((e) => MapEntry<String, String>(e.key ?? '', e.value ?? '')),
    );

    switch (requestModel.method) {
      case RequestMethod.get:
        response = await _httpClient.get(requestModel.uri, headers: headers);
        break;
      case RequestMethod.post:
        response = await _httpClient.post(requestModel.uri, headers: headers);
        break;
      case RequestMethod.put:
        response = await _httpClient.put(requestModel.uri, headers: headers);
        break;
      case RequestMethod.patch:
        response = await _httpClient.patch(requestModel.uri, headers: headers);
        break;
      case RequestMethod.delete:
        response = await _httpClient.delete(requestModel.uri, headers: headers);
        break;
    }

    return response;
  }
}

class ApiRequestNotifier extends StateNotifier<AsyncValue<http.Response?>?> {
  ApiRequestNotifier(this._apiRequest) : super(null);

  final IApiRequest _apiRequest;

  void request(RequestModel requestModel) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      return _apiRequest.request(requestModel);
    });
  }
}
