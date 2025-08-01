// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ItemContainerModel {
  String id;
  String name;
  String description;
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

  @override
  bool operator ==(covariant ItemContainerModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name && other.description == description && other.quantity == quantity;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ description.hashCode ^ quantity.hashCode;
  }
}
