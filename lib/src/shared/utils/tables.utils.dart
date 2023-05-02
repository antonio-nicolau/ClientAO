import 'package:client_ao/src/shared/models/key_value_row.model.dart';
import 'package:client_ao/src/shared/widgets/custom_textfield.widget.dart';
import 'package:davi/davi.dart';
import 'package:flutter/material.dart';

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
          return CustomValueTextField(
            rows: rows,
            defaultValue: row.data.key,
            valueFieldHintText: keyFieldHintText,
            onValueFieldChanged: (value) => updateRows.call(
              rows: rows,
              row: row.data,
              index: row.index,
              value: value,
              updateKey: true,
              callback: (newRows) => onFieldsChange?.call(newRows),
            ),
            parentContext: context,
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
          return CustomValueTextField(
            rows: rows,
            defaultValue: row.data.value,
            valueFieldHintText: valueFieldHintText,
            onValueFieldChanged: (value) => updateRows.call(
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
