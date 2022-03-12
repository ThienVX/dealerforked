import 'package:dealer_app/constants/common_constants.dart';
import 'package:dealer_app/repositories/models/collect_deal_transaction_detail_model.dart';
import 'package:dealer_app/repositories/models/scrap_category_model.dart';
import 'package:dealer_app/utils/env_util.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomTexts {
  static const String categoryScreenTitle = 'Danh mục';
  static const String addCategoryScreenTitle = 'Thêm danh mục';
  static const String categoryDetailScreenTitle = 'Chi tiết';
  static const String createTransactionScreenTitle = 'Tạo giao dịch';
  static const String transactionHistoryScreenTitle = 'Lịch sử giao dịch';
  static const String transactionHistoryDetailScreenTitle =
      'Chi tiết giao dịch';
  static const String promotion = 'Ưu đãi';
  //login_view
  static const String loginToContinue = 'Đăng nhập để tiếp tục';
  static const String loginFailed = 'Đăng nhập thất bại';
  static const String loginButton = 'Đăng nhập';
  static const String phoneError = 'Số điện thoại không hợp lệ';
  static const String phoneBlank = 'Số điện thoại không được để trống';
  static const String phoneNotExist = 'Không tìm thấy số điện thoại';
  static const String passwordLabel = 'Mật khẩu';
  static const String phoneLabel = 'Số điện thoại';
  static const String wrongPasswordOrPhone =
      'Số điện thoại hoặc mật khẩu không chính xác';
  static const String loginError =
      'Đăng nhập thất bại, xin thử lại sau vài phút';
  static const String forgetPassword = 'Bạn quên mật khẩu?';
  static const String forgetPasswordTextButton = 'Lấy lại mật khẩu';
  static const String forgetPasswordText = 'Quên mật khẩu';
  static const String register = 'Bạn chưa có tài khoản?';
  static const String registerTextButton = 'Đăng ký';
  //register
  static const String registerWelcomeText =
      'Xin chào, số điện thoại của bạn là?';
  static const String next = 'Tiếp';
  static const String resendOTPButton = 'Gửi lại mã số';
  static const String resendOTPText = 'Bạn chưa nhận được mã số?';
  static const String otpMessage =
      'Một mã số gồm 6 chữ số vừa được gửi đến số điện thoại';
  static const String otpErrorMessage =
      'Gửi mã số thất bại, xin đợi 5 phút và thử lại';
  static const String invalidOTP = 'Mã số không hợp lệ';
  static const String checkOTPErrorMessage =
      'Đã có lỗi xảy ra, xin đợi 5 phút và thử lại';
  static const String appBarPersonalInfoText = 'Thông tin cá nhân';
  static const String nameLabel = 'Họ và Tên';
  static const String invalidName = 'Tên không hợp lệ';
  static const String idLabel = 'CMND/CCCD/Bằng lái xe';
  static const String idBlank = 'Mục này không được để trống';
  static const String birthDateLabel = 'Ngày sinh';
  static const String birthDatePickerHelpText = 'Chọn ngày sinh';
  static const String addressLabel = 'Địa chỉ';
  static const String sexLabel = 'Giới tính';
  static const String rePasswordLabel = 'Nhập lại mật khẩu';
  static const String rePasswordError = 'Nhập lại mật khẩu không khớp';
  static const String rePasswordBlank = 'Nhập lại mật khẩu không được để trống';
  static const String passwordError = 'Mật khẩu phải chứa ít nhất 6 ký tự';
  static const String passwordBlank = 'Mật khẩu không được để trống';
  static const String nameBlank = 'Tên không được để trống';
  static const String appBarBranchOptionText = 'Thông tin vựa';
  static const String isBranchText =
      'Vựa mới của bạn có phải là chi nhánh của một vựa khác đã đăng ký trước đó không?';
  static const String mainBranchIdLabel = 'Tên vựa chính';
  static const String mainBranchIdBlank = 'Tên vựa chính không được để trống';
  static const String storeNameLabel = 'Tên vựa';
  static const String storePhoneLabel = 'Số điện thoại vựa';
  static const String storeAddressLabel = 'Địa chỉ vựa';
  static const String storeNameBlank = 'Tên vựa không được để trống';
  static const String storePhoneBlank = 'Số điện thoại vựa không được để trống';
  static const String storePhoneError = 'Số điện thoại vựa không hợp lệ';
  static const String storeAddressBlank = 'Địa chỉ vựa không được để trống';
  static const String appBarStoreInfoText = 'Thông tin vựa';
  static const String cameraText = 'Máy ảnh';
  static const String galleryText = 'Thư viện';
  static const String storeFrontImageText = 'Ảnh chụp mặt trước cửa hàng';
  static const String logoutButtonText = 'Đăng xuất';
  static const String registerCompleteGreeting = 'Xin chào ';
  static const String registerCompleteCongrat =
      'Bạn đã đăng ký làm đối tác chủ vựa phế liệu của VeChaiXANH thành công';
  static const String registerCompleteNote =
      'Vui lòng lên văn phòng VeChaiXANH để hoàn tất thủ tục để bạn có thể sử dụng dịch vụ của chúng tôi';
  //create transaction
  static const String cancelButtonText = 'Huỷ';
  static const String createTransactionButtonText = 'Tạo giao dịch';
  static const String detailText = 'Chi tiết';
  static const String subTotalText = 'Tạm tính';
  static const String totalText = 'Khách hàng nhận';
  static const String promotionText = 'Ưu đãi';
  static const String collectorPhoneLabel = 'SĐT người bán';
  static const String collectorNameLabel = 'Tên người bán';
  static const String calculatedByUnitPriceText = 'Tính theo đơn giá';
  static const String calculatedByUnitPriceExplainationText =
      'Tính tiền bằng đơn giá nhân số lượng';
  static const String scrapTypeLabel = 'Loại phế liệu';
  static const String unitLabel = 'Đơn vị';
  static const String quantityLabel = 'Số lượng';
  static const String unitPriceLabel = 'Đơn giá';
  static const String totalLabel = 'Tổng cộng';
  static const String vndSymbolText = 'đ';
  static const String vndSymbolUnderlined = '₫';
  static String promotionAppliedText({required String promotionCode}) =>
      '* Ưu đãi $promotionCode đang được áp dụng';
  static const String generalErrorMessage =
      'Đã có lỗi xảy ra, vui lòng thử lại';
  static const String totalBlank = 'Tổng cộng không được để trống';
  static const String quantityBlank = '$quantityLabel không được để trống';
  static const String quantityZero = '$quantityLabel phải lớn hơn 0';
  static const String unitPriceBlank = '$unitPriceLabel không được để trống';
  static const String unitPriceNegative = '$unitPriceLabel không được là số âm';
  static const String scrapTypeBlank = '$scrapTypeLabel không được để trống';
  static const String scrapTypeNotChoosenError = 'Xin chọn $scrapTypeLabel';
  static const String emptyString = '';
  static const String promotionNotAppliedText =
      'Không có ưu đãi nào được áp dụng';
  static const String addScrapButtonText = 'Thêm phế liệu';
  static const String saveUpdateButtonText = 'Lưu thay đổi';
  static const String isItemTotalLowerThanZero = '$totalLabel phải lớn hơn 0 đ';
  static const String totalOverLimit = '$totalLabel thấp hơn 100 triệu đồng';
  static const String scrapCategoryUnitBlank = 'Xin chọn $unitLabel';
  static const String zeroString = '0';
  static const String closeText = 'Đóng';
  static const String pleaseWaitText = 'Xin vui lòng đợi';
  static const String createTransactionSuccessfullyText =
      'Tạo giao dịch thành công';
  static const String noItemsErrorText = 'Giao dịch phải có một phế liệu';
  static const String deleteItemButtonText = 'Xoá';
  // Add category
  static const String eachScrapCategoryHasAtLeastOneUnit =
      'Mỗi loại phế liệu nên có tối thiểu một đơn vị';
  static const String image = 'Hình ảnh';
  static const String scrapCategoryName = 'Tên danh mục phế liệu';
  static const String inputScrapCategoryName = 'Nhập tên loại phế liệu';
  static const String detail = 'Chi tiết';
  static const String unit = 'Đơn vị';
  static const String unitIsExisted = 'Đơn vị đã có';
  static const String unitPrice = 'Đơn giá';
  static const String camera = 'Máy ảnh';
  static const String gallery = 'Thư viện';
  static const String cancel = 'Huỷ';
  static const String addScrapCategory = 'Thêm danh mục';
  static const String addScrapCategorySucessfull = 'Thêm danh mục thành công';
  static const String errorHappenedTryAgain =
      'Đã có lỗi xảy ra, vui lòng thử lại';
  static const String processing = 'Đang xử lí...';
  static const String scrapNameExisted = 'Tên phế liệu đã tồn tại';
  static const String updateScrapCategorySucessfull = 'Lưu danh mục thành công';
  static const String deleteScrapCategorySucessfull = 'Xoá danh mục thành công';
  static const String ok = 'Đồng ý';
  static const String delete = 'Xoá';
  static String deleteScrapCategory({required String name}) =>
      'Xoá danh mục $name ?';
  static const String upcoming = 'Sắp diễn ra';
  static const String ongoing = 'Đang diễn ra';
  static const String finished = 'Đã kết thúc';
  static const String noPromotion = 'Không có ưu đãi';
  static const String searchPromotionName = 'Tìm tên ưu đãi';
  static const String promotionDetail = 'Chi tiết ưu đãi';
  static const String appliedScrapCategory = 'Danh mục phế liệu được áp dụng';
  static const String promotionNameBlank = 'Tên ưu đãi không được để trống';
  static const String scrapCategoryBlank = 'Danh mục không được để trống';
  static const String appliedAmountBlank =
      'Mức giá áp dụng ưu đãi không được để trống';
  static const String bonusAmountBlank =
      'Số tiền ưu đãi không được để trống';
  static const String appliedAmountNegative =
      'Mức giá áp dụng ưu đãi phải lớn hơn 0đ';
  static const String bonusAmountNegative =
      'Số tiền ưu đãi phải là số dương';
  static const String promotionDuration = 'Thời gian áp dụng ưu đãi';
  static const String promotionName = 'Tên ưu đãi';
  static const String appliedAmount = 'Mức giá áp dụng ưu đãi';
  static const String bonusAmount = 'Số tiền ưu đãi';
  static const String addPromotion = 'Thêm ưu đãi';
  static const String promotionStartDateBlank =
      'Ngày bắt đầu ưu đãi không được để trống';
  static const String promotionEndDateBlank =
      'Ngày kết thúc ưu đãi không được để trống';
}

class CustomApiUrl {
  //api id4
  static const String apiUrlTokenLink = 'connect/token';
  //app api
  static const String apiUrlDealerInfoLink =
      '/api/v3/dealer/account/dealer-info';
  static const String apiUrlPutDeviceId = '/api/v3/dealer/account/device-id';
  static const String apiUrlGetPromotions = '/api/v3/promotion/get';
  static const String apiUrlGetScrapCategoriesFromData =
      '/api/v3/trans/scrap-categories';
  static const String apiUrlGetScrapCategoryDetails =
      '/api/v3/trans/scrap-category-detail';
  static const String apiUrlGetCollectorPhones =
      '/api/v3/auto-complete/collector-phone';
  static const String apiUrlGetInfoReview =
      '/api/v3/transaction/collect-deal/info-review';
  static const String apiUrlPostCollectDealTransaction =
      '/api/v3/transaction/collect-deal/create';
  static const String apiUrlGetCollectDealHistories =
      '/api/v3/transaction/collect-deal/histories';
  static const String apiUrlGetCollectDealHistoryDetail =
      '/api/v3/transaction/collect-deal/history-detail';
  static const String apiUrlGetScrapCategoriesFromScrapCategory =
      '/api/v3/scrap-category/get';
  static const String apiUrlGetImage = '/api/v3/image/get';
  static const String apiUrlPostImage = '/api/v3/scrap-category/upload-image';
  static const String apiUrlPostScrapCategory = '/api/v3/scrap-category/create';
  static const String apiUrlGetCheckScrapCategoryName =
      '/api/v3/scrap-category/check-name';
  static const String apiUrlGetScrapCategorDetailFromScrapCategory =
      '/api/v3/scrap-category/get-detail';
  static const String apiUrlPutScrapCategory = '/api/v3/scrap-category/update';
  static const String apiUrlDeleteScrapCategory =
      '/api/v3/scrap-category/remove';
  static const String apiUrlPostPromotion = '/api/v3/promotion/create';
  static const String apiUrlGetPromotionDetail = '/api/v3/promotion/get-detail';
  static const String apiUrlGetDealerInfoFromDealerInformation =
      '/api/v3/dealer-information/get';
  static const String apiUrlGetBranchesFromDealerInformation =
      '/api/v3/dealer-information/get-branchs';
  static const String apiUrlGetBranchDetailFromDealerInformation =
      '/api/v3/dealer-information/get-branch-detail';
  static const String apiUrlPutPromotion = '/api/v3/promotion/finish';

  // TienTD
  static final apiUrl = '${EnvBaseAppSettingValue.baseApiUrl}api/v3/';
  // notification
  static final notificationGet = '${apiUrl}notification/get';
  static final notificationRead = '${apiUrl}notification/read';
  static final notificationUnreadCount = '${apiUrl}notification/unread-count';

  //
  static final accountCollectorInfo = '${apiUrl}dealer/account/dealer-info';

  static final imageGet = '${apiUrl}image/get';

  //forget pass
  static final restorePassOTP = '${apiUrl}dealer/account/restore-pass-otp';
  static final confirmRestorePassOTP =
      '${EnvID4AppSettingValue.apiUrl}api/identity/account/confirm-otp';
  static final restorePassword =
      '${EnvID4AppSettingValue.apiUrl}api/identity/account/restore-password';
  static final getBranches = '${apiUrl}dealer-information/branchs';
  static final getStatistic = '${apiUrl}statistic/get';
  static final createComplaint = '${apiUrl}complaint/collect-deal-trans';
  static final dealerInformation = '${apiUrl}dealer-information/get';
  static final changeStatusDealer = '${apiUrl}dealer-information/change-status';
}

class CustomAPIError {
  static const String loginFailedException = 'Login failed';
  static const String refreshTokenException = 'refresh token failed';
  static const String fetchTokenFailedException = 'Failed to fetch token';
  static const String fetchDealerInfoFailedException =
      'Failed to fetch user info';
  static const String putDeviceIdFailedException = 'Failed to put device Id';
  static const String getPromotionsFailedException = 'Failed to get promotions';
  static const String putPromotionsFailedException = 'Failed to put promotions';
  static const String getScrapCategoriesFailedException =
      'Failed to get scrap categories';
  static const String getScrapCategoryDetailsFailedException =
      'Failed to get scrap category details';
  static const String getCollectorPhonesFailedException =
      'Failed to get collector phones';
  static const String getInfoReviewFailedException =
      'Failed to get info review';
  static const String postCollectDealTransactionFailedException =
      'Failed to put collect deal transaction';
  static const String getCollectDealHistoriesFailedException =
      'Failed to Get Collect Deal Histories';
  static const String missingBearerToken =
      'Missing bearer token from secure storage';
  static const String getCollectDealHistoryDetailFailedException =
      'Failed to Get Collect Deal History Detail';
  static const String getImageFailedException = 'Failed to Get Image';
  static const String postImageFailedException = 'Failed to Post Image';
  static const String postScrapCategoryFailedException =
      'Failed to Post Scrap Category';
  static const String getPromotionDetailFailedException =
      'Failed to get promotion detail';
  static const String fetchBranchesFailedException = 'Failed to fetch branches';
  static const String fetchBranchDetailFailedException =
      'Failed to fetch branch detail';
}

class CustomFormats {
  static const String birthday = 'dd/MM/yyyy';
  static String numberFormat(int value) {
    return replaceCommaWithDot(NumberFormat('###,###').format(value));
  }

  static NumberFormat quantityFormat = NumberFormat('##0.##');
  static String removeNotNumber(String string) =>
      string.replaceAll(RegExp(r'[^0-9]'), '');
  static String replaceCommaWithDot(String string) =>
      string.replaceAll(RegExp(r','), '.');
  static String replaceDotWithComma(String string) =>
      string.replaceAll(RegExp(r'\.'), ',');
  static String currencyFormat(int value) {
    return replaceCommaWithDot(
        NumberFormat('###,### ${CustomTexts.vndSymbolUnderlined}')
            .format(value));
  }
}

class CustomRegexs {
  static const String phoneRegex = r'^0[0-9]{9}$';
  static const String passwordRegex = r'^.{6,}$';
  static const String otpRegex = r'^[0-9]{6}$';
}

class CustomAssets {
  static const String logo = 'assets/images/vua_192x192.png';
  static const String logoAndText = 'assets/images/logo_and_text.png';
}

class CustomRoutes {
  static const String botNav = '/navBar';
  static const String addCategory = '/addCategory';
  static const String categoryDetail = '/categoryDetail';
  static const String categoryList = '/categoryList';
  static const String register = '/register';
  static const String registerOTP = '/registerOTP';
  static const String registerPersonalInfo = '/registerPersonalInfo';
  static const String registerBranchOption = '/registerBranchOption';
  static const String registerStoreInfo = '/registerStoreInfo';
  static const String registerComplete = '/registerComplete';
  static const String login = '/login';
  static const String createTransaction = '/createTransaction';
  static const String transactionHistory = '/transactionHistory';
  static const String transactionFilter = '/transactionFilter';
  static const String transactionHistoryDetailView =
      '/transactionHistoryDetailView';
  static const String promotionListView = '/promotionListView';
  static const String promotionDetailView = '/promotionDetailView';
  static const String addPromotion = '/addPromotion';
  static const String dealerInfo = '/dealerInfo';
  static const profilePasswordEdit = 'profilePasswordEdit';
  static const profileEdit = 'profileEdit';

  //edit password
  static const forgetPasswordPhoneNumber = 'editPasswordPhoneNumber';
  static const forgetPasswordOTP = 'forgetPasswordOTP';
  static const forgetPasswordNewPassword = 'forgetPasswordNewPassword';
}

class CustomKeys {
  static const String accessToken = 'accessToken';
  static const String refreshToken = 'refreshToken';
}

class CustomTickerDurations {
  static const int resendOTPDuration = 30;
}

class CustomColors {
  static const Color lightGray = const Color.fromARGB(255, 248, 248, 248);
}

enum Process {
  neutral,
  processing,
  processed,
  valid,
  invalid,
  error,
}

enum Sex {
  male,
  female,
}

//sex dropdown form field
const Map<Sex, String> sexFormFieldItems = {
  Sex.male: 'Nam',
  Sex.female: 'Nữ',
};

//isBranch options
const Map<bool, String> isBranchRadioOptions = {
  false: 'Không',
  true: 'Có',
};

class CustomVar {
  static final unnamedScrapCategory = ScrapCategoryModel.createTransactionModel(
    id: '00000000-0000-0000-0000-000000000000',
    appliedAmount: null,
    name: 'Chưa phân loại',
    bonusAmount: null,
  );

  static final noPromotion = CollectDealTransactionDetailModel(
    dealerCategoryId: '00000000-0000-0000-0000-000000000000',
    quantity: 0,
    promotionId: '00000000-0000-0000-0000-000000000000',
    bonusAmount: 0,
    total: 0,
    price: 0,
    isCalculatedByUnitPrice: false,
  );

  static const totalLimit = 100000000;

  static const String zeroId = '00000000-0000-0000-0000-000000000000';

  static const int refreshTime = 17900;
}

class Symbols {
  static const String vietnamLanguageCode = 'vi';
  static const String forwardSlash = '/';
  static const String vietnamISOCode = 'VN';
  static const String vietnamCallingCode = '+84';
  static const String empty = '';
  static const String space = ' ';
  static const String comma = ',';
  static const String minus = '-';
}

class ImagesPaths {
  static const String imagePath = 'assets/images';
  static const String logo = '$imagePath/logo_and_text.png';
  static const String maleProfile = '$imagePath/male_profile.png';
  static const String femaleProfile = '$imagePath/female_profile.png';
  static const String createNewIcon = '$imagePath/newRequestIcon.png';
  static const String categoriesIcon = '$imagePath/categoryIcon.png';
  static const String emptyActivityList = '$imagePath/empty_activity_list.png';
  static const String ticketLogo = '$imagePath/ticket_logo.png';
}

class AppColors {
  // Green
  static const Color greenFF61C53D = Color(0xFF61C53D);
  static const Color greenFF66D095 = Color(0xFF66D095);
  static const Color greenFF39AC8F = Color(0xFF39AC8F);
  static const Color greenFF80D063 = Color(0xFF80D063);
  static const Color greenFF01C971 = Color(0xFF01C971);

  // Grey
  static const Color greyFF9098B1 = Color(0xFF9098B1);
  static const Color greyFFDADADA = Color(0xFFDADADA);
  static const Color greyFFEEEEEE = Color(0xFFEEEEEE);
  static const Color greyFF939393 = Color(0xFF939393);
  static const Color greyFF848484 = Color(0xFF848484);
  static const Color greyFFB5B5B5 = Color(0xFFB5B5B5);
  static const Color greyFF969090 = Color(0xFF969090);
  static const Color greyFFF8F8F8 = Color(0xFFF8F8F8);

  //Orange
  static const Color orangeFFF5670A = Color(0xFFF5670A);
  static const Color orangeFFF9CB79 = Color(0xFFF9CB79);
  static const Color orangeFFF67622 = Color(0xFFF67622);
  static const Color orangeFFF7853B = Color(0xFFF7853B);
  static const Color orangeFFF5A91F = Color(0xFFF5A91F);

  //White
  static const Color white = Colors.white;

  //Black
  static const Color black = Colors.black;
  static const Color blackBB000000 = Color(0xBB000000);

  //Red
  static const Color red = Colors.red;

  //Yellow
  static const Color yellowFFF3F09A = Color(0xFFF3F09A);

  static const Color errorButtonBorder = greyFFB5B5B5;
  static final Color errorButtonText = Colors.grey[700]!;
}

class IdentityAPIConstants {
  static final urlConnectToken = '${EnvID4AppSettingValue.apiUrl}connect/token';
  static final urlConnectRevocation =
      '${EnvID4AppSettingValue.apiUrl}connect/revocation';
  static final urlChangePassword =
      '${EnvID4AppSettingValue.apiUrl}api/identity/account/change-password';

  //Query parameter name
  static const clientIdParamName = 'client_id';
  static const clientSecretParamName = 'client_secret';
  static const grantTypeParamName = 'grant_type';
  static const scopeParamName = 'scope';
  static const usernameParamName = 'username';
  static const passwordParamName = 'password';
  static const token = 'token';
  static const tokenTypeHint = 'token_type_hint';

  //value
  static const accessToken = 'access_token';
  static const refreshToken = 'refresh_token';

  static const notApprovedAccountCode = 'ANA0001';
  static const isApprovedBuOtherCollector = 'ICR0001';
}

class PhoneNumberSignupLayoutConstants {
  static const String welcomeTitle =
      'Chào mừng bạn! Số điện thoại của bạn là gì?';
  static const String phoneNumberHint = '87654321';
  static const String next = 'Tiếp';
  static const String errorText = 'Số di động có vẻ không chính xác.';
  static const String progressIndicatorLabel =
      'Progress Indicator for waiting to register Phone Nubmer.';
  static const String waiting = 'Vui lòng chờ...';
}

class OTPFillPhoneNumberLayoutConstants {
  static const String title = 'Nhập mã gồm 6 chữ số đã gửi tới';
  static const String notHaveCode = 'Chưa nhận được mã?';

  static const String hintText = '000000';
  static const int inputLength = Others.otpLength;
  static const int countdown = 30;

  static const String requetsNewCode =
      'Yêu cầu mã mới trong 00:$replacedSecondVar';
  static const String replacedSecondVar = '{second}';

  static const String checking = 'Đang kiểm tra.';
  static const String checkingProgressIndicator = 'Checking Progress Indicator';

  static const String resendOTP = 'Đang gửi lại mã OTP';
  static const String resendOTPProgressIndicator =
      'Resend OTP Progress Indicator';
}

class RegexConstants {
  static final String otpCode = r'^\d{' + Others.otpLength.toString() + r'}$';
  static final String email =
      r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
}

class DealerType {
  static const int manager = 3;
  static const int member = 5;
}

enum DealerRoleKey {
  MAIN_BRANCH,
  MEMBER_BRANCH,
}

extension DealerRoleKeyExtension on DealerRoleKey {
  int get number {
    switch (this) {
      case DealerRoleKey.MAIN_BRANCH:
        return 3;
      case DealerRoleKey.MEMBER_BRANCH:
        return 5;
      default:
        return 0;
    }
  }
}

class FeedbackToSystemStatus {
  static const int canNotGiveFeedback = 1;
  static const int canGiveFeedback = 2;
  static const int haveGivenFeedback = 3;
  static const int adminReplied = 4;
}
