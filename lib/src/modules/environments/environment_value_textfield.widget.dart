import 'dart:convert';
import 'dart:developer';
import 'package:client_ao/src/modules/environments/manage_environment.widget.dart';
import 'package:client_ao/src/modules/home/states/environment.state.dart';
import 'package:client_ao/src/shared/services/cache/environment_hive.service.dart';
import 'package:client_ao/src/shared/utils/functions.utils.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http_parser/http_parser.dart';

class EnvironmentValueTextField extends HookConsumerWidget {
  const EnvironmentValueTextField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final envName = ref.watch(envNameProvider);
    final value = ref.watch(getEnvironmentValuesByKeyProvider(envName)) ?? {};
    final codeController = TextEditingController(
      text: formatBody(json.encode(value), MediaType('text', 'json')),
    );

    return TextField(
      key: Key(envName),
      controller: codeController,
      keyboardType: TextInputType.multiline,
      minLines: 30,
      maxLines: 250,
      onChanged: (value) {
        try {
          if (value.isNotEmpty) {
            final map = json.decode(value.trim()) as Map<String, dynamic>;
            ref.read(environmentHiveServiceProvider).saveEnvironmentValue(
                  key: envName,
                  value: map,
                );
          }
        } catch (e) {
          log('invalid map');
        }
      },
    );
  }
}
