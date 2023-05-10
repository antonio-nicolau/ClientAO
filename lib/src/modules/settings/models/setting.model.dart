import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
part 'setting.model.g.dart';

@HiveType(typeId: 6)
class Setting extends Equatable {
  @HiveField(0)
  final int? requestTimeout;

  @HiveField(1)
  final String? httpScheme;

  @HiveField(2)
  final bool? darkMode;

  const Setting({
    this.requestTimeout,
    this.httpScheme,
    this.darkMode,
  });

  @override
  List<Object?> get props => [requestTimeout, httpScheme];

  Setting copyWith({
    int? requestTimeout,
    String? httpScheme,
    bool? darkMode,
  }) {
    return Setting(
      requestTimeout: requestTimeout ?? this.requestTimeout,
      httpScheme: httpScheme ?? this.httpScheme,
      darkMode: darkMode ?? this.darkMode,
    );
  }
}
