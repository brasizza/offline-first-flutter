// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'box_container_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BoxContainerModelAdapter extends TypeAdapter<BoxContainerModel> {
  @override
  final typeId = 1;

  @override
  BoxContainerModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BoxContainerModel(
      id: fields[0] as String,
      name: fields[1] as String,
      responsiblePerson: fields[2] as String,
      items: (fields[3] as List).cast<ItemContainerModel>(),
      createdAt: fields[4] as DateTime,
      updatedAt: fields[5] as DateTime,
      isSynced: fields[6] as bool,
      remoteId: fields[7] as String?,
      isDeleted: fields[8] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, BoxContainerModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.responsiblePerson)
      ..writeByte(3)
      ..write(obj.items)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.updatedAt)
      ..writeByte(6)
      ..write(obj.isSynced)
      ..writeByte(7)
      ..write(obj.remoteId)
      ..writeByte(8)
      ..write(obj.isDeleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BoxContainerModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
