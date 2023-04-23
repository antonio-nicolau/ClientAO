import 'package:client_ao/src/shared/constants/enums.dart';
import 'package:client_ao/src/shared/models/key_value_row.model.dart';
import 'package:client_ao/src/shared/models/request.model.dart';
import 'package:client_ao/src/shared/services/client.service.interface.dart';
import 'package:client_ao/src/shared/services/custom_http_client.service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

final apiRequestProvider = Provider<IApiRequest>((ref) {
  final httpClient = ref.read(httpClientProvider);
  return ApiRequest(httpClient);
});

class ApiRequest implements IApiRequest {
  final CustomHttpClient _httpClient;

  const ApiRequest(this._httpClient);

  @override
  Future<(http.Response,Duration)> request(RequestModel request) async {
    Response? response;
    final headers = Map.fromEntries(
      request.headers!.map((e) => MapEntry<String, String>(e.key ?? '', e.value ?? '')),
    );

    Uri? uri =  getUriWithQueryParams(request);

    final body = request.body;

    final stopWatch = Stopwatch()..start();

    switch (request.method) {
      case HttpVerb.get:
        response = await _httpClient.get(uri!, headers: headers);
        break;
      case HttpVerb.post:
        response = await _httpClient.post(uri!, headers: headers, body: body);
        break;
      case HttpVerb.put:
        response = await _httpClient.put(uri!, headers: headers, body: body);
        break;
      case HttpVerb.patch:
        response = await _httpClient.patch(uri!, headers: headers, body: body);
        break;
      case HttpVerb.delete:
        response = await _httpClient.delete(uri!, headers: headers, body: body);
        break;
    }

    stopWatch.stop();

    return (response,stopWatch.elapsed);
  }

  Uri? getUriWithQueryParams(RequestModel request) {

    request = serializeUrl(request);

    final urlParamsList = request.urlParams;
    final uri = Uri.tryParse(request.url ?? '');

    final queryParams = <String, String>{};

    if (uri != null) {
      final currentQueryParams = uri.queryParameters;
      if (currentQueryParams.isNotEmpty) {
        queryParams.addAll(currentQueryParams);
      }

      for (final e in urlParamsList ?? <KeyValueRow>[]) {
        if (e.key != null) {
          queryParams[e.key.toString()] = e.value ?? '';
        }
      }

      return uri.replace(queryParameters: queryParams);
    }
    return null;
  }

  RequestModel serializeUrl(RequestModel request) {
    if(request.url?.startsWith(RegExp('[http|https]'))==false){
      request = request.copyWith(url: '${Protocol.https}${request.url}');
    }
    return request;
  }
}

