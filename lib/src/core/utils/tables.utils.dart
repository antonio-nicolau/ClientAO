import 'package:client_ao/src/core/models/http_header.model.dart';
import 'package:client_ao/src/core/widgets/key_textfield.widget.dart';
import 'package:client_ao/src/core/widgets/value_textfield.widget.dart';
import 'package:davi/davi.dart';
import 'package:flutter/material.dart';

DaviModel<KeyValueRow> createDaviTable({
  List<KeyValueRow>? rows,
  String? keyColumnName,
  String? valueColumnName,
  String? keyFieldHintText,
  String? valueFieldHintText,
  Function(List<KeyValueRow>?)? onFieldsChange,
  VoidCallback? onRemoveTaped,
}) {
  return DaviModel<KeyValueRow>(
    rows: rows ?? <KeyValueRow>[],
    columns: [
      DaviColumn(
        name: keyColumnName,
        grow: 1,
        cellBuilder: (context, row) {
          return KeyTextField(
            index: row.index,
            row: row.data,
            keyFieldHintText: keyFieldHintText,
            onKeyFieldChanged: onFieldsChange,
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
        cellBuilder: (context, row) {
          return ValueTextField(
            index: row.index,
            row: row.data,
            valueFieldHintText: valueFieldHintText,
            onValueFieldChanged: onFieldsChange,
          );
        },
      ),
      DaviColumn(
        width: 30,
        cellBuilder: (BuildContext context, DaviRow<KeyValueRow> row) {
          return InkWell(
            onTap: onRemoveTaped,
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
