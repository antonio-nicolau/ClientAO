// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'websocket_message.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WebSocketMessageAdapter extends TypeAdapter<WebSocketMessage> {
  @override
  final int typeId = 8;

  @override
  WebSocketMessage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WebSocketMessage(
      message: fields[0] as String?,
      from: fields[2] as SentFrom?,
      status: fields[3] as SocketConnectionStatus?,
      time: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, WebSocketMessage obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.message)
      ..writeByte(1)
      ..write(obj.time)
      ..writeByte(2)
      ..write(obj.from)
      ..writeByte(3)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WebSocketMessageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
