// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RequestModelAdapter extends TypeAdapter<RequestModel> {
  @override
  final int typeId = 0;

  @override
  RequestModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RequestModel(
      url: fields[0] as String?,
      body: fields[1] as String?,
      method: fields[2] as HttpVerb,
      headers: (fields[3] as List?)?.cast<KeyValueRow>(),
      urlParams: (fields[4] as List?)?.cast<KeyValueRow>(),
      name: fields[5] as String?,
      folderId: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, RequestModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.url)
      ..writeByte(1)
      ..write(obj.body)
      ..writeByte(2)
      ..write(obj.method)
      ..writeByte(3)
      ..write(obj.headers)
      ..writeByte(4)
      ..write(obj.urlParams)
      ..writeByte(5)
      ..write(obj.name)
      ..writeByte(6)
      ..write(obj.folderId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RequestModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
