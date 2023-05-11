import 'package:client_ao/src/modules/settings/services/settings.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
                    ref.read(settingsProvider.notifier).update(darkMode: false);
                    break;
                  case 1:
                    ref.read(settingsProvider.notifier).update(darkMode: true);
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
