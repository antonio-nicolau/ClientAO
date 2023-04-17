// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enums.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RequestMethodAdapter extends TypeAdapter<RequestMethod> {
  @override
  final int typeId = 4;

  @override
  RequestMethod read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return RequestMethod.get;
      case 1:
        return RequestMethod.post;
      case 2:
        return RequestMethod.put;
      case 3:
        return RequestMethod.patch;
      case 4:
        return RequestMethod.delete;
      default:
        return RequestMethod.get;
    }
  }

  @override
  void write(BinaryWriter writer, RequestMethod obj) {
    switch (obj) {
      case RequestMethod.get:
        writer.writeByte(0);
        break;
      case RequestMethod.post:
        writer.writeByte(1);
        break;
      case RequestMethod.put:
        writer.writeByte(2);
        break;
      case RequestMethod.patch:
        writer.writeByte(3);
        break;
      case RequestMethod.delete:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RequestMethodAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
