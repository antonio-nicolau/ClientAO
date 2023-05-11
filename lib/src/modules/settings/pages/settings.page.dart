import 'package:client_ao/src/modules/settings/widgets/general_settings.widget.dart';
import 'package:client_ao/src/modules/settings/widgets/theme_settings.widget.dart';
import 'package:client_ao/src/shared/models/pop_up.model.dart';
import 'package:client_ao/src/shared/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const settingsMenuOptions = [
  PopupMenuModel(
    label: 'Themes',
    icon: Icons.dark_mode_outlined,
    widget: ThemeSettings(),
  ),
  PopupMenuModel(label: 'General', widget: GeneralSettings()),
];

class SettingsPage extends HookConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    final widget = useState<Widget?>(settingsMenuOptions.first.widget);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.15,
              child: ListView.builder(
                itemCount: settingsMenuOptions.length,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final item = settingsMenuOptions[index];
                  return ListTile(
                    hoverColor: colors.selectedColor(),
                    title: Text(item.label),
                    onTap: () {
                      widget.value = settingsMenuOptions[index].widget;
                    },
                  );
                },
              ),
            ),
            VerticalDivider(
              color: Theme.of(context).colorScheme.surfaceVariant,
            ),
            Expanded(
              child: widget.value ?? const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
