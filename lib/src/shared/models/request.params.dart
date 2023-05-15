import 'package:client_ao/src/shared/models/base_request.interface.dart';
import 'package:equatable/equatable.dart';

class RequestParams extends Equatable {
  final BaseRequestModel? request;
  final Duration? requestInterval;
  final Duration? sendAfterDelay;
  final bool repeatRequest;

  const RequestParams({
    this.request,
    this.requestInterval,
    this.sendAfterDelay,
    this.repeatRequest = false,
  });

  @override
  List<Object?> get props => [request, requestInterval, sendAfterDelay, repeatRequest];
}
