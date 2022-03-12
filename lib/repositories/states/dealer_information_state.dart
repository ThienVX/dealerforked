import 'package:dealer_app/utils/param_util.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

class DealerInformationState extends Equatable {
  DealerInformationState({
    this.id = Symbols.empty,
    this.dealerName = Symbols.empty,
    this.dealerImageUrl,
    this.dealerLatitude = 0,
    this.dealerLongtitude = 0,
    this.dealerAddress = Symbols.empty,
    this.dealerPhone = Symbols.empty,
    this.openTime = Symbols.empty,
    this.closeTime = Symbols.empty,
    this.isActive = false,
    this.status = FormzStatus.pure,
  });
  final String id;
  final String dealerName;
  final String? dealerImageUrl;
  final double dealerLatitude;
  final double dealerLongtitude;
  final String dealerAddress;
  final String dealerPhone;
  final String openTime;
  final String closeTime;
  final bool isActive;
  final FormzStatus status;

  DealerInformationState copyWith({
    String? id,
    String? dealerName,
    String? dealerImageUrl,
    double? dealerLatitude,
    double? dealerLongtitude,
    String? dealerAddress,
    String? dealerPhone,
    String? openTime,
    String? closeTime,
    bool? isActive,
    FormzStatus? status,
  }) {
    return DealerInformationState(
      id: id ?? this.id,
      dealerName: dealerName ?? this.dealerName,
      dealerImageUrl: dealerImageUrl ?? this.dealerImageUrl,
      dealerLatitude: dealerLatitude ?? this.dealerLatitude,
      dealerLongtitude: dealerLongtitude ?? this.dealerLongtitude,
      dealerAddress: dealerAddress ?? this.dealerAddress,
      dealerPhone: dealerPhone ?? this.dealerPhone,
      openTime: openTime ?? this.openTime,
      closeTime: closeTime ?? this.closeTime,
      isActive: isActive ?? this.isActive,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        id,
        dealerName,
        dealerImageUrl,
        dealerLatitude,
        dealerLongtitude,
        dealerAddress,
        dealerPhone,
        openTime,
        closeTime,
        isActive,
        status,
      ];
}
