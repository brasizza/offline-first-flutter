// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:hive_ce/hive.dart';

part 'contato_model.g.dart';

@HiveType(typeId: 0)
class ContatoModel extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String email;
  @HiveField(3)
  String phoneNumber;
  @HiveField(4)
  bool isSynced;
  @HiveField(5)
  String? remoteId;

  ContatoModel({required this.id, required this.name, required this.email, required this.phoneNumber, this.isSynced = false, this.remoteId});

  ContatoModel copyWith({String? id, String? name, String? email, String? phoneNumber, bool? isSynced, String? remoteId}) {
    return ContatoModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isSynced: isSynced ?? this.isSynced,
      remoteId: remoteId ?? this.remoteId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'isSynced': isSynced,
      'remoteId': remoteId,
    };
  }

  factory ContatoModel.fromMap(Map<String, dynamic> map) {
    return ContatoModel(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      phoneNumber: map['phoneNumber'] as String,
      isSynced: map['isSynced'] as bool,
      remoteId: map['remoteId'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory ContatoModel.fromJson(String source) => ContatoModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ContatoModel(id: $id, name: $name, email: $email, phoneNumber: $phoneNumber, isSynced: $isSynced, remoteId: $remoteId)';
  }

  @override
  bool operator ==(covariant ContatoModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name && other.email == email && other.phoneNumber == phoneNumber && other.isSynced == isSynced && other.remoteId == remoteId;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ email.hashCode ^ phoneNumber.hashCode ^ isSynced.hashCode ^ remoteId.hashCode;
  }
}
