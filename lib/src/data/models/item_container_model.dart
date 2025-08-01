// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:hive_ce/hive.dart';

part 'item_container_model.g.dart';

@HiveType(typeId: 2)
class ItemContainerModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String description;

  @HiveField(3)
  int quantity;

  ItemContainerModel({
    required this.id,
    required this.name,
    required this.description,
    required this.quantity,
  });

  ItemContainerModel copyWith({
    String? id,
    String? name,
    String? description,
    int? quantity,
  }) {
    return ItemContainerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'quantity': quantity,
    };
  }

  factory ItemContainerModel.fromMap(Map<String, dynamic> map) {
    return ItemContainerModel(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      quantity: map['quantity'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory ItemContainerModel.fromJson(String source) => ItemContainerModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ItemContainerModel(id: $id, name: $name, description: $description, quantity: $quantity)';
  }
}
