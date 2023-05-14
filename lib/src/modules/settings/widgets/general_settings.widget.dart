import 'package:client_ao/src/modules/settings/widgets/request_response_section.widget.dart';
import 'package:client_ao/src/modules/settings/widgets/setting_section.widget.dart';
import 'package:client_ao/src/modules/settings/widgets/setting_section_item.widget.dart';
import 'package:client_ao/src/shared/services/cache/collection_hive.service.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class GeneralSettings extends ConsumerWidget {
  const GeneralSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: const Column(
        children: [
          SettingSection(
            title: 'Request/ Response',
            body: RequestAndResponseSettingsSection(),
          ),
          SettingSection(
            title: 'Data',
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SettingSectionItem(
                  label: 'Remove cache',
                  hasButton: true,
                  hasTextField: false,
                  buttonText: 'Clear',
                  onButtonClick: clearAllCache,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
