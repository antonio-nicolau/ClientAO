import 'package:client_ao/src/modules/code_generator/code_generator.page.dart';
import 'package:client_ao/src/shared/constants/enums.dart';
import 'package:client_ao/src/shared/models/request.model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final codegenServiceProvider = StateProvider.family<String?, RequestModel?>((ref, request) {
  return CodegenService(ref, request).getCode();
});

class CodegenService {
  /// class responsible to generate code based on [ProgramLanguages] and [RequestModel]
  final Ref _ref;
  final RequestModel? _request;

  const CodegenService(this._ref, this._request);

  String? getCode() {
    final language = _ref.watch(selectedSupportedLanguageProvider);
    final package = _ref.watch(selectedSupportedPackageProvider);

    if (_request == null) return null;

    final response = language?.packages.where((e) => e == package).toList();

    if (response?.isNotEmpty == true) {
      return response?.first.instance.build();
    }
    return null;
  }
}
