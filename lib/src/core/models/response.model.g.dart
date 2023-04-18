// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ResponseModelAdapter extends TypeAdapter<ResponseModel> {
  @override
  final int typeId = 1;

  @override
  ResponseModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ResponseModel(
      statusCode: fields[0] as int?,
      headers: (fields[1] as Map?)?.cast<String, String>(),
      requestUri: fields[9] as String?,
      requestHeaders: (fields[2] as Map?)?.cast<String, String>(),
      contentType: fields[3] as String?,
      mediaType: fields[4] as String?,
      body: fields[5] as String?,
      formattedBody: fields[6] as String?,
      bodyBytes: fields[7] as Uint8List?,
      time: fields[8] as Duration?,
    );
  }

  @override
  void write(BinaryWriter writer, ResponseModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.statusCode)
      ..writeByte(1)
      ..write(obj.headers)
      ..writeByte(2)
      ..write(obj.requestHeaders)
      ..writeByte(3)
      ..write(obj.contentType)
      ..writeByte(4)
      ..write(obj.mediaType)
      ..writeByte(5)
      ..write(obj.body)
      ..writeByte(6)
      ..write(obj.formattedBody)
      ..writeByte(7)
      ..write(obj.bodyBytes)
      ..writeByte(8)
      ..write(obj.time)
      ..writeByte(9)
      ..write(obj.requestUri);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResponseModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
