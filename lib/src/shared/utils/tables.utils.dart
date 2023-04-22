import 'package:client_ao/src/shared/models/key_value_row.model.dart';
import 'package:client_ao/src/shared/widgets/key_textfield.widget.dart';
import 'package:client_ao/src/shared/widgets/value_textfield.widget.dart';
import 'package:davi/davi.dart';
import 'package:flutter/material.dart';

DaviModel<KeyValueRow> createDaviTable({
  List<KeyValueRow>? rows,
  String? keyColumnName,
  String? valueColumnName,
  String? keyFieldHintText,
  String? valueFieldHintText,
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
        cellBuilder: (context, row) {
          return KeyTextField(
            index: row.index,
            rows: rows,
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
        sortable: false,
        cellBuilder: (context, row) {
          return ValueTextField(
            index: row.index,
            rows: rows,
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
