import 'package:client_ao/src/shared/constants/enums.dart';
import 'package:client_ao/src/shared/models/key_value_row.model.dart';
import 'package:client_ao/src/shared/models/websocket_message.model.dart';
import 'package:client_ao/src/shared/widgets/text_fields/textField_with_environment_suggestion.widget.dart';
import 'package:davi/davi.dart';
import 'package:flutter/material.dart';

// Query params and Headers Table
DaviModel<KeyValueRow> createDaviTable({
  List<KeyValueRow>? rows,
  String? keyColumnName,
  String? valueColumnName,
  String? keyFieldHintText,
  String? valueFieldHintText,
  required BuildContext context,
  Function(List<KeyValueRow>?)? onFieldsChange,
  Function(int index)? onRemoveTaped,
}) {
  return DaviModel<KeyValueRow>(
    rows: rows ?? <KeyValueRow>[],
    columns: [
      DaviColumn(
        name: keyColumnName,
        grow: 1,
        sortable: false,
        cellBuilder: (_, row) {
          return TextFieldWithEnvironmentSuggestion(
            rows: rows,
            defaultValue: row.data.key,
            hintText: keyFieldHintText,
            onChanged: (value) => updateRows.call(
              rows: rows,
              row: row.data,
              index: row.index,
              value: value,
              updateKey: true,
              callback: (newRows) => onFieldsChange?.call(newRows),
            ),
            parentContext: context,
            displaySuggestion: false,
          );
        },
      ),
      DaviColumn(
        width: 30,
        cellBuilder: (BuildContext context, DaviRow<KeyValueRow> row) {
          return const Text("=");
        },
      ),
      DaviColumn(
        name: valueColumnName,
        grow: 1,
        sortable: false,
        cellBuilder: (_, row) {
          return TextFieldWithEnvironmentSuggestion(
            rows: rows,
            defaultValue: row.data.value,
            hintText: valueFieldHintText,
            onChanged: (value) => updateRows.call(
              rows: rows,
              row: row.data,
              index: row.index,
              value: value,
              updateValue: true,
              callback: (newRows) => onFieldsChange?.call(newRows),
            ),
            parentContext: context,
          );
        },
      ),
      DaviColumn(
        width: 30,
        cellBuilder: (_, row) {
          return InkWell(
            onTap: () => onRemoveTaped?.call(row.index),
            child: Icon(
              Icons.remove_circle,
              size: 16,
              color: Colors.red.withOpacity(0.9),
            ),
          );
        },
      ),
    ],
  );
}

void updateRows({
  List<KeyValueRow>? rows,
  required KeyValueRow row,
  String? value,
  bool updateKey = false,
  bool updateValue = false,
  required int index,
  required Function(List<KeyValueRow>?) callback,
}) {
  List<KeyValueRow> newRows = rows ?? [];

  if (updateKey) {
    row = row.copyWith(key: value);
  } else if (updateValue) {
    row = row.copyWith(value: value);
  }

  newRows = [
    ...newRows.sublist(0, index),
    row,
    ...newRows.sublist(index + 1),
  ];

  callback.call(newRows);
}

/// Build webSocket response table
DaviModel<WebSocketMessage> createWebSocketResponseTable(BuildContext context, List<WebSocketMessage>? allMessages) {
  return DaviModel<WebSocketMessage>(
    rows: allMessages ?? <WebSocketMessage>[],
    columns: [
      DaviColumn(
        width: 30,
        cellBuilder: (_, row) {
          return getIconByStatusAndSentFrom(context, row.data);
        },
      ),
      DaviColumn(
        name: 'Data',
        grow: 1,
        sortable: false,
        cellBuilder: (_, row) {
          return Text(row.data.message);
        },
      ),
      DaviColumn(
        name: 'Time',
        width: 100,
        sortable: false,
        cellBuilder: (_, row) {
          return Text(
            row.data.time,
            maxLines: 1,
          );
        },
      ),
    ],
  );
}

Widget getIconByStatusAndSentFrom(BuildContext context, WebSocketMessage message) {
  if (message.status == SocketConnectionStatus.connected) {
    return const Icon(
      Icons.check_circle_outline_rounded,
      color: Colors.green,
      size: 16,
    );
  } else if (message.status == SocketConnectionStatus.disconnected) {
    return const Icon(
      Icons.close_rounded,
      color: Colors.amber,
      size: 16,
    );
  }
  return Icon(
    message.from == SentFrom.local ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
    size: 16,
    color: message.from == SentFrom.local ? Theme.of(context).colorScheme.secondary : Colors.green,
  );
}
