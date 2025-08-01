// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_container_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ItemContainerModelAdapter extends TypeAdapter<ItemContainerModel> {
  @override
  final typeId = 2;

  @override
  ItemContainerModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ItemContainerModel(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      quantity: (fields[3] as num).toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, ItemContainerModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.quantity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemContainerModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
