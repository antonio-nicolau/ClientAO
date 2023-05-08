import 'package:client_ao/src/shared/models/pop_up.model.dart';
import 'package:client_ao/src/shared/utils/theme/app_theme.dart';
import 'package:client_ao/src/shared/utils/theme/app_theme.state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const settingsMenuOptions = [
  PopupMenuModel(
    label: 'Themes',
    icon: Icons.perm_data_setting_outlined,
    widget: ThemeSettings(),
  ),
  PopupMenuModel(label: 'General'),
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

class ThemeSettings extends ConsumerWidget {
  const ThemeSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themes = [
      {'src': 'light-theme.svg', 'label': 'Light'},
      {'src': 'dark-theme.svg', 'label': 'Dark'},
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
      ),
      itemCount: themes.length,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: [
            GestureDetector(
              onTap: () {
                switch (index) {
                  case 0:
                    ref.read(themesProvider.notifier).changeTheme(false);
                    break;
                  case 1:
                    ref.read(themesProvider.notifier).changeTheme(true);
                    break;
                }
              },
              child: SvgPicture.asset(
                'src/svg/${themes[index]["src"]}',
                height: 300,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${themes[index]["label"]}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        );
      },
    );
  }
}
