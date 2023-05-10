
import 'package:client_ao/src/modules/settings/models/setting.model.dart';
import 'package:hive/hive.dart';

final settingsBox = Hive.box<Setting>('settings');
