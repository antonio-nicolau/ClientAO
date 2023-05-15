// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enums.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SentFromAdapter extends TypeAdapter<SentFrom> {
  @override
  final int typeId = 9;

  @override
  SentFrom read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SentFrom.local;
      case 1:
        return SentFrom.remote;
      default:
        return SentFrom.local;
    }
  }

  @override
  void write(BinaryWriter writer, SentFrom obj) {
    switch (obj) {
      case SentFrom.local:
        writer.writeByte(0);
        break;
      case SentFrom.remote:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SentFromAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SocketConnectionStatusAdapter
    extends TypeAdapter<SocketConnectionStatus> {
  @override
  final int typeId = 10;

  @override
  SocketConnectionStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SocketConnectionStatus.connected;
      case 1:
        return SocketConnectionStatus.disconnected;
      case 2:
        return SocketConnectionStatus.sending;
      case 3:
        return SocketConnectionStatus.receiving;
      default:
        return SocketConnectionStatus.connected;
    }
  }

  @override
  void write(BinaryWriter writer, SocketConnectionStatus obj) {
    switch (obj) {
      case SocketConnectionStatus.connected:
        writer.writeByte(0);
        break;
      case SocketConnectionStatus.disconnected:
        writer.writeByte(1);
        break;
      case SocketConnectionStatus.sending:
        writer.writeByte(2);
        break;
      case SocketConnectionStatus.receiving:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SocketConnectionStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HttpVerbAdapter extends TypeAdapter<HttpVerb> {
  @override
  final int typeId = 4;

  @override
  HttpVerb read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return HttpVerb.get;
      case 1:
        return HttpVerb.post;
      case 2:
        return HttpVerb.put;
      case 3:
        return HttpVerb.patch;
      case 4:
        return HttpVerb.delete;
      case 5:
        return HttpVerb.head;
      default:
        return HttpVerb.get;
    }
  }

  @override
  void write(BinaryWriter writer, HttpVerb obj) {
    switch (obj) {
      case HttpVerb.get:
        writer.writeByte(0);
        break;
      case HttpVerb.post:
        writer.writeByte(1);
        break;
      case HttpVerb.put:
        writer.writeByte(2);
        break;
      case HttpVerb.patch:
        writer.writeByte(3);
        break;
      case HttpVerb.delete:
        writer.writeByte(4);
        break;
      case HttpVerb.head:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HttpVerbAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
