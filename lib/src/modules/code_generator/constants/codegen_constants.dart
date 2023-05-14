import 'package:client_ao/src/modules/code_generator/models/supported_language.model.dart';
import 'package:client_ao/src/modules/code_generator/models/supported_package.model.dart';
import 'package:client_ao/src/modules/code_generator/templates/dart_http/dart_http_template.dart';
import 'package:client_ao/src/modules/code_generator/templates/nodejs_http/nodejs_http_template.dart';
import 'package:client_ao/src/modules/code_generator/templates/nodejs_axios/nodejs_axios_template.dart';
import 'package:client_ao/src/shared/constants/enums.dart';
import 'package:client_ao/src/shared/models/base_request.interface.dart';

/// return a List<SupportedLanguage> containing all languages supported by Codegen
List<SupportedLanguage> getSupportedLanguages(BaseRequestModel? request) {
  return [
    SupportedLanguage(
      language: ProgramLanguages.dart,
      highlightLanguage: 'dart',
      packages: [
        SupportedPackage(
          label: 'Http',
          package: Packages.http,
          instance: DartWithHttpTemplate(request),
        ),
      ],
    ),
    SupportedLanguage(
      language: ProgramLanguages.nodeJs,
      highlightLanguage: 'javascript',
      packages: [
        SupportedPackage(
          label: 'Http',
          package: Packages.http,
          instance: NodejsWithHttpTemplate(request),
        ),
        SupportedPackage(
          label: 'Axios',
          package: Packages.axios,
          instance: NodejsWithAxiosTemplate(request),
        ),
      ],
    ),
  ];
}
