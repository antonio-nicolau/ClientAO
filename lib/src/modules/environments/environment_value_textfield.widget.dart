import 'dart:convert';
import 'dart:developer';
import 'package:client_ao/src/modules/home/states/environment.state.dart';
import 'package:client_ao/src/shared/services/hive.service.dart';
import 'package:client_ao/src/shared/utils/functions.utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http_parser/http_parser.dart';

class EnvironmentValueTextField extends HookConsumerWidget {
  const EnvironmentValueTextField(this.envName, {super.key});

  final String envName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(getEnvironmentValuesByKeyProvider(envName));
    final codeController = useTextEditingController(
      text: formatBody(json.encode(value), MediaType('text', 'json')),
    );

    return TextField(
      controller: codeController,
      keyboardType: TextInputType.multiline,
      minLines: 30,
      maxLines: 80,
      onChanged: (value) {
        try {
          if (value.isNotEmpty) {
            final map = json.decode(value.trim()) as Map<String, dynamic>;
            ref.read(hiveServiceProvider).saveEnvironmentValue(
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
