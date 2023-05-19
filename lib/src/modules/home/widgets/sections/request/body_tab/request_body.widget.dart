import 'package:client_ao/src/modules/home/widgets/sections/request/body_tab/no_request_body.widget.dart';
import 'package:client_ao/src/modules/home/widgets/sections/request/body_tab/request_body_json.widget.dart';
import 'package:client_ao/src/modules/home/widgets/sections/request/body_tab/request_body_tab.widget.dart';
import 'package:client_ao/src/shared/constants/enums.dart';
import 'package:client_ao/src/shared/models/pop_up.model.dart';
import 'package:client_ao/src/shared/utils/theme/app_theme.state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RequestBody extends HookConsumerWidget {
  const RequestBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themMode = ref.watch(themesProvider);
    final bodyType = ref.watch(requestBodyTypeProvider);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      decoration: BoxDecoration(
        color: themMode == ThemeMode.dark ? Colors.grey.shade800 : Colors.grey[300],
        borderRadius: BorderRadius.circular(30),
      ),
      child: getRequestBodyByType(bodyType),
    );
  }

  Widget getRequestBodyByType(PopupMenuModel? bodyType) {
    switch (bodyType?.method) {
      case BodyType.json:
        return const RequestBodyJson();
      default:
        return const NoRequestBody();
    }
  }
}
