import 'package:client_ao/src/modules/code_generator/models/supported_language.model.dart';
import 'package:client_ao/src/modules/code_generator/models/supported_package.model.dart';
import 'package:client_ao/src/modules/code_generator/templates/dart/dart_http_template.dart';
import 'package:client_ao/src/modules/code_generator/templates/nodejs/nodejs_http_template.dart';
import 'package:client_ao/src/shared/constants/enums.dart';
import 'package:client_ao/src/shared/models/request.model.dart';

/// return a List<SupportedLanguage> containing all languages supported by Codegen
List<SupportedLanguage> getSupportedLanguages(RequestModel? request) {
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
          instance: NodejsWithHttpTemplate(request),
        ),
      ],
    ),
  ];
}
