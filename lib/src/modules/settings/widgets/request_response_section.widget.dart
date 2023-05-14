import 'package:client_ao/src/modules/settings/services/settings.service.dart';
import 'package:client_ao/src/modules/settings/widgets/setting_section_item.widget.dart';
import 'package:client_ao/src/shared/constants/enums.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RequestAndResponseSettingsSection extends ConsumerWidget {
  const RequestAndResponseSettingsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.38,
          child: SettingSectionItem(
            label: 'Request timeout',
            textfieldDefaultValue: (settings?.requestTimeout ?? 30).toString(),
            onChanged: (value) {
              final timeout = int.tryParse(value);
              if (value.isNotEmpty && timeout != null) {
                ref.read(settingsProvider.notifier).update(requestTimeout: timeout);
              }
            },
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: SettingSectionItem(
            textfieldDefaultValue: settings?.httpScheme ?? Protocol.https,
            label: 'Http Scheme',
            onChanged: (value) {
              if (Protocol.values.contains(value)) {
                ref.read(settingsProvider.notifier).update(httpScheme: value);
              }
            },
          ),
        ),
      ],
    );
  }
}
