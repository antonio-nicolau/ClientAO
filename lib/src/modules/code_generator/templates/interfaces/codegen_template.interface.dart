abstract class ICodeGenTemplate {
  /// Interface for all Codegen Templates, every codegen must @override those
  /// method to build template structure
  String? output = '';
  void importAndRequestMethod();
  String? addQueryParams();
  String? addBody();
  String? addHeaders();
  void requestEnd();
  String? build();
}
