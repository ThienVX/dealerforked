import 'package:dealer_app/repositories/models/gender_model.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:formz/formz.dart';

class ProfileState extends Equatable {
  ProfileState({
    this.id = Symbols.empty,
    this.name = Symbols.empty,
    this.phone = Symbols.empty,
    this.email,
    this.gender = Gender.male,
    this.address,
    this.birthDate,
    this.image,
    this.idCard = Symbols.empty,
    this.totalPoint = 0,
    this.status = FormzStatus.pure,
    this.imageProfile,
    this.dealerType = 0,
  });
  final String id;
  final String name;
  final String phone;
  final String? email;
  final Gender gender;
  final String? address;
  final DateTime? birthDate;
  final String? image;
  final String idCard;
  final int totalPoint;
  final FormzStatus status;
  final ImageProvider<Object>? imageProfile;
  final int dealerType;

  ProfileState copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    Gender? gender,
    String? address,
    DateTime? birthDate,
    String? image,
    String? idCard,
    int? totalPoint,
    double? rate,
    FormzStatus? status,
    ImageProvider<Object>? imageProfile,
    int? dealerType,
  }) {
    return ProfileState(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      birthDate: birthDate ?? this.birthDate,
      image: image ?? this.image,
      idCard: idCard ?? this.idCard,
      totalPoint: totalPoint ?? this.totalPoint,
      status: status ?? this.status,
      imageProfile: imageProfile ?? this.imageProfile,
      dealerType: dealerType ?? this.dealerType,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        phone,
        email,
        gender,
        address,
        birthDate,
        idCard,
        image,
        totalPoint,
        status,
        imageProfile,
        dealerType,
      ];
}
