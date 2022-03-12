import 'package:dealer_app/repositories/models/get_branches_model.dart';
import 'package:dealer_app/repositories/models/response_models/get_branch_detail_response_model.dart';
import 'package:flutter/cupertino.dart';

abstract class DealerInfoState {
  final List<GetBranchesModel> branches;
  final String selectedId;
  final ImageProvider? dealerImage;
  final String dealerName;
  final String dealerPhone;
  final String dealerAddress;
  final String openTime;
  final String closeTime;
  final DealerAccountBranch? dealerAccountBranch;

  DealerInfoState({
    required this.branches,
    required this.selectedId,
    required this.dealerImage,
    required this.dealerName,
    required this.dealerPhone,
    required this.dealerAddress,
    required this.openTime,
    required this.closeTime,
    required this.dealerAccountBranch,
  });
}

class LoadingState extends DealerInfoState {
  LoadingState.noData()
      : super(
          branches: [],
          dealerImage: null,
          selectedId: "",
          dealerName: "",
          dealerPhone: "",
          dealerAddress: "",
          openTime: "",
          closeTime: "",
          dealerAccountBranch: null,
        );

  LoadingState({
    required List<GetBranchesModel> branches,
    required ImageProvider? dealerImage,
    required String selectedId,
    required String dealerName,
    required String dealerPhone,
    required String dealerAddress,
    required String openTime,
    required String closeTime,
    required DealerAccountBranch? dealerAccountBranch,
  }) : super(
          branches: branches,
          dealerImage: dealerImage,
          selectedId: selectedId,
          dealerName: dealerName,
          dealerPhone: dealerPhone,
          dealerAddress: dealerAddress,
          openTime: openTime,
          closeTime: closeTime,
          dealerAccountBranch: dealerAccountBranch,
        );
}

class LoadedState extends DealerInfoState {
  LoadedState({
    required List<GetBranchesModel> branches,
    required ImageProvider? dealerImage,
    required String selectedId,
    required String dealerName,
    required String dealerPhone,
    required String dealerAddress,
    required String openTime,
    required String closeTime,
    required DealerAccountBranch? dealerAccountBranch,
  }) : super(
          branches: branches,
          dealerImage: dealerImage,
          selectedId: selectedId,
          dealerName: dealerName,
          dealerPhone: dealerPhone,
          dealerAddress: dealerAddress,
          openTime: openTime,
          closeTime: closeTime,
          dealerAccountBranch: dealerAccountBranch,
        );
}

class ErrorState extends DealerInfoState {
  final String message;
  ErrorState.noData({
    required this.message,
  }) : super(
          branches: [],
          dealerImage: null,
          selectedId: "",
          dealerName: "",
          dealerPhone: "",
          dealerAddress: "",
          openTime: "",
          closeTime: "",
          dealerAccountBranch: null,
        );
  ErrorState({
    required this.message,
    required List<GetBranchesModel> branches,
    required ImageProvider? dealerImage,
    required String selectedId,
    required String dealerName,
    required String dealerPhone,
    required String dealerAddress,
    required String openTime,
    required String closeTime,
    required DealerAccountBranch? dealerAccountBranch,
  }) : super(
          branches: branches,
          dealerImage: dealerImage,
          selectedId: selectedId,
          dealerName: dealerName,
          dealerPhone: dealerPhone,
          dealerAddress: dealerAddress,
          openTime: openTime,
          closeTime: closeTime,
          dealerAccountBranch: dealerAccountBranch,
        );
}

class SubmittedState extends DealerInfoState {
  SubmittedState.noData({
    required String message,
  }) : super(
          branches: [],
          dealerImage: null,
          selectedId: "",
          dealerName: "",
          dealerPhone: "",
          dealerAddress: "",
          openTime: "",
          closeTime: "",
          dealerAccountBranch: null,
        );

  SubmittedState({
    required String message,
    required List<GetBranchesModel> branches,
    required ImageProvider? dealerImage,
    required String selectedId,
    required String dealerName,
    required String dealerPhone,
    required String dealerAddress,
    required String openTime,
    required String closeTime,
    required DealerAccountBranch? dealerAccountBranch,
  }) : super(
          branches: branches,
          dealerImage: dealerImage,
          selectedId: selectedId,
          dealerName: dealerName,
          dealerPhone: dealerPhone,
          dealerAddress: dealerAddress,
          openTime: openTime,
          closeTime: closeTime,
          dealerAccountBranch: dealerAccountBranch,
        );
}
