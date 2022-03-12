class CollectorAccountModel {
  int id;
  String name;
  String userName;
  String email;
  int? gender;
  String phone;
  String address;
  String birthDate;
  String image;
  int roleKey;
  String roleName;
  String idCard;
  double? totalPoint;
  String createdTime;
  int? status;

  CollectorAccountModel({
    required this.id,
    required this.name,
    required this.userName,
    required this.email,
    this.gender,
    required this.phone,
    required this.address,
    required this.birthDate,
    required this.image,
    required this.roleKey,
    required this.roleName,
    required this.idCard,
    this.totalPoint,
    required this.createdTime,
    this.status,
  });

  get getId => this.id;

  set setId(id) => this.id = id;

  get getName => this.name;

  set setName(name) => this.name = name;

  get getUserName => this.userName;

  set setUserName(userName) => this.userName = userName;

  get getEmail => this.email;

  set setEmail(email) => this.email = email;

  get getGender => this.gender;

  set setGender(gender) => this.gender = gender;

  get getPhone => this.phone;

  set setPhone(phone) => this.phone = phone;

  get getAddress => this.address;

  set setAddress(address) => this.address = address;

  get getBirthDate => this.birthDate;

  set setBirthDate(birthDate) => this.birthDate = birthDate;

  get getImage => this.image;

  set setImage(image) => this.image = image;

  get getRoleKey => this.roleKey;

  set setRoleKey(roleKey) => this.roleKey = roleKey;

  get getRoleName => this.roleName;

  set setRoleName(roleName) => this.roleName = roleName;

  get getIdCard => this.idCard;

  set setIdCard(idCard) => this.idCard = idCard;

  get getTotalPoint => this.totalPoint;

  set setTotalPoint(totalPoint) => this.totalPoint = totalPoint;

  get getCreatedTime => this.createdTime;

  set setCreatedTime(createdTime) => this.createdTime = createdTime;

  get getStatus => this.status;

  set setStatus(status) => this.status = status;
}
