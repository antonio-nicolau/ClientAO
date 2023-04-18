import 'dart:io';
import 'package:client_ao/src/modules/home/states/collections.state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RequestStatus extends HookConsumerWidget {
  const RequestStatus({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeId = ref.watch(activeIdProvider);
    final responseAsync = ref.watch(responseStateProvider(activeId));

    return responseAsync?.when(
          data: (data) {
            if (data == null || data.statusCode == null) return const SizedBox.shrink();

            return Container(
              color: Colors.amber,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    color: data.statusCode == HttpStatus.ok ? Colors.green : Colors.red,
                    child: Text(
                      data.statusCode.toString(),
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            );
          },
          error: (error, _) {
            return const Text('Error');
          },
          loading: () => Center(
            child: SpinKitThreeBounce(
              color: Theme.of(context).primaryColor,
            ),
          ),
        ) ??
        const SizedBox.shrink();
  }
}
