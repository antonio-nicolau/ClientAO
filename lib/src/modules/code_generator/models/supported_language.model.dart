import 'package:client_ao/src/modules/code_generator/models/supported_package.model.dart';
import 'package:client_ao/src/shared/constants/enums.dart';
import 'package:equatable/equatable.dart';

class SupportedLanguage extends Equatable {
  final ProgramLanguages language;
  final String highlightLanguage;
  final List<SupportedPackage> packages;

  const SupportedLanguage({
    required this.language,
    required this.highlightLanguage,
    required this.packages,
  });

  @override
  List<Object?> get props => [language, highlightLanguage, packages];
}
