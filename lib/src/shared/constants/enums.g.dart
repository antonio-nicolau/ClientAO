// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enums.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

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
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is HttpVerbAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
