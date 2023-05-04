import 'package:client_ao/src/modules/code_generator/templates/interfaces/codegen_template.interface.dart';
import 'package:client_ao/src/shared/constants/enums.dart';
import 'package:equatable/equatable.dart';

class SupportedPackage extends Equatable {
  final String label;
  final Packages package;
  final ICodeGenTemplate instance;

  const SupportedPackage({
    required this.label,
    required this.package,
    required this.instance,
  });

  @override
  List<Object?> get props => [label, package, instance];
}
