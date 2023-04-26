import 'package:client_ao/src/shared/constants/enums.dart';
import 'package:client_ao/src/shared/models/key_value_row.model.dart';
import 'package:client_ao/src/shared/models/request.model.dart';
import 'package:client_ao/src/shared/repositories/api_request.repository.interface.dart';
import 'package:client_ao/src/shared/services/custom_http_client.service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

final apiRequestProvider = Provider<IApiRequestRepository>((ref) {
  final httpClient = ref.read(httpClientProvider);
  return ApiRequest(httpClient);
});

class ApiRequest implements IApiRequestRepository {
  final CustomHttpClient _httpClient;

  const ApiRequest(this._httpClient);

  @override
  Future<(http.Response,Duration)> request(RequestModel request) async {
    final headers = Map.fromEntries(
      request.headers!.map((e) => MapEntry<String, String>(e.key ?? '', e.value ?? '')),
    );

    Uri? uri =  getUriWithQueryParams(request);

    final body = request.body;

    final stopWatch = Stopwatch()..start();
    
    final methodHandlers = <HttpVerb, Future<Response>>{
      HttpVerb.get: _httpClient.get(uri!, headers: headers),
      HttpVerb.post: _httpClient.post(uri!, headers: headers, body: body),
      HttpVerb.put: _httpClient.put(uri!, headers: headers, body: body),
      HttpVerb.patch: _httpClient.patch(uri!, headers: headers, body: body),
      HttpVerb.delete: _httpClient.delete(uri!, headers: headers, body: body),
  };

    if (!methodHandlers.containsKey(request.method)) {
      throw UnsupportedError('Unsupported HTTP method: ${request.method}');
    }

    final response = await methodHandlers[request.method]!;

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

