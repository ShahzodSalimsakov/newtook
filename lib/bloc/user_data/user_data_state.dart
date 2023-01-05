// ignore_for_file:  sort_constructors_first
// ignore_for_file: public_member_api_docs, s

part of 'user_data_bloc.dart';

class Role {
  final String name;
  final String code;
  final bool active;

  Role({
    required this.name,
    required this.code,
    required this.active,
  });

  Role copyWith({
    String? name,
    String? code,
    bool? active,
  }) {
    return Role(
        name: name ?? this.name,
        active: active ?? this.active,
        code: code ?? this.code);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'code': code,
      'active': active,
    };
  }

  factory Role.fromMap(Map<String, dynamic> map) {
    return Role(
      name: map['name'] as String,
      code: map['code'] as String,
      active: map['active'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Role.fromJson(String source) =>
      Role.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Role(name: $name, active: $active, code: $code)';

  @override
  bool operator ==(covariant Role other) {
    if (identical(this, other)) return true;

    return other.name == name && other.active == active && other.code == code;
  }

  @override
  int get hashCode => name.hashCode ^ active.hashCode;
}

class UserProfileModel {
  final String? id;
  final String? first_name;
  final String? last_name;
  final String? phone;
  final bool? is_super_user;
  final List<String>? terminal_id;
  final int? wallet_balance;

  UserProfileModel(
      {required this.id,
      required this.first_name,
      required this.last_name,
      required this.phone,
      required this.is_super_user,
      required this.terminal_id,
      required this.wallet_balance});

  UserProfileModel copyWith({
    String? id,
    String? first_name,
    String? last_name,
    String? phone,
    bool? is_super_user,
    List<String>? terminal_id,
    int? wallet_balance,
  }) {
    return UserProfileModel(
      id: id ?? this.id,
      first_name: this.first_name ?? '',
      last_name: this.last_name ?? '',
      phone: this.phone ?? '',
      is_super_user: this.is_super_user ?? false,
      terminal_id: this.terminal_id ?? [],
      wallet_balance: this.wallet_balance ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'first_name': first_name,
      'last_name': last_name,
      'phone': phone,
      'is_super_user': is_super_user,
      'terminal_id': terminal_id,
      'wallet_balance': wallet_balance,
    };
  }

  factory UserProfileModel.fromMap(Map<String, dynamic> map) {
    return UserProfileModel(
      id: map['id'] as String,
      first_name:
          map['first_name'] != null ? map['first_name'] as String : null,
      last_name: map['last_name'] != null ? map['last_name'] as String : null,
      phone: map['phone'] != null ? map['phone'] as String : null,
      is_super_user:
          map['is_super_user'] != null ? map['is_super_user'] as bool : null,
      terminal_id: map['terminal_id'] != null
          ? map['terminal_id'] as List<String>
          : null,
      wallet_balance: map['wallet_balance'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserProfileModel.fromJson(String source) =>
      UserProfileModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserProfileModel(first_name: $first_name, last_name: $last_name, phone: $phone, is_super_user: $is_super_user, id: $id)';
  }

  @override
  bool operator ==(covariant UserProfileModel other) {
    if (identical(this, other)) return true;

    return other.first_name == first_name &&
        other.last_name == last_name &&
        other.phone == phone &&
        other.is_super_user == is_super_user &&
        other.id == id &&
        other.wallet_balance == wallet_balance;
  }

  @override
  int get hashCode {
    return first_name.hashCode ^
        last_name.hashCode ^
        phone.hashCode ^
        is_super_user.hashCode ^
        id.hashCode ^
        wallet_balance.hashCode;
  }
}

abstract class UserDataState extends Equatable {
  final List<String> permissions;
  final List<Role> roles;
  final String? accessToken;
  final String? refreshToken;
  final String? accessTokenExpires;
  final UserProfileModel? userProfile;
  final bool is_online;
  final DateTime tokenExpires;
  const UserDataState(
      {required this.permissions,
      required this.roles,
      this.accessToken,
      this.refreshToken,
      this.accessTokenExpires,
      this.userProfile,
      required this.is_online,
      required this.tokenExpires});

  static copyWith({
    List<String>? permissions,
    List<Role>? roles,
    String? accessToken,
    String? refreshToken,
    String? accessTokenExpires,
    UserProfileModel? userProfile,
    bool? is_online,
    DateTime? tokenExpires,
  }) {
    return UserDataInitial(
      permissions: permissions ?? [],
      roles: roles ?? [],
      accessToken: accessToken ?? '',
      refreshToken: refreshToken ?? '',
      accessTokenExpires: accessTokenExpires ?? '',
      userProfile: userProfile ??
          UserProfileModel(
            first_name: '',
            last_name: '',
            phone: '',
            is_super_user: false,
            id: '',
            terminal_id: [],
            wallet_balance: 0,
          ),
      is_online: is_online ?? false,
      tokenExpires: tokenExpires ?? DateTime.now(),
    );
  }

  @override
  List<Object> get props => [permissions, roles, is_online, tokenExpires];
}

class UserDataInitial extends UserDataState {
  const UserDataInitial({
    required List<String> permissions,
    required List<Role> roles,
    required String? accessToken,
    required String? refreshToken,
    required String? accessTokenExpires,
    required UserProfileModel? userProfile,
    required bool is_online,
    required DateTime tokenExpires,
  }) : super(
            permissions: permissions,
            roles: roles,
            accessToken: accessToken,
            refreshToken: refreshToken,
            accessTokenExpires: accessTokenExpires,
            userProfile: userProfile,
            is_online: is_online,
            tokenExpires: tokenExpires);

  static fromJson(json) {
    return UserDataInitial(
      permissions: json['permissions'] as List<String>,
      roles:
          List<Role>.from(json['roles'].map((e) => Role.fromJson(e)).toList()),
      accessToken: json['accessToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
      accessTokenExpires: json['accessTokenExpires'] as String?,
      userProfile: UserProfileModel.fromJson(json['userProfile']),
      is_online: json['is_online'] as bool,
      tokenExpires: DateTime.parse(json['tokenExpires']),
    );
  }

  static toJson(UserDataState state) {
    return {
      'permissions': state.permissions,
      'roles': state.roles.map((e) => e.toJson()).toList(),
      'accessToken': state.accessToken,
      'refreshToken': state.refreshToken,
      'accessTokenExpires': state.accessTokenExpires,
      'userProfile': state.userProfile?.toJson(),
      'is_online': state.is_online,
      'tokenExpires': state.tokenExpires.toIso8601String(),
    };
  }

  static copyWith(UserDataState state) {
    return UserDataInitial(
      permissions: state.permissions,
      roles: state.roles,
      accessToken: state.accessToken,
      refreshToken: state.refreshToken,
      accessTokenExpires: state.accessTokenExpires,
      userProfile: state.userProfile,
      is_online: state.is_online,
      tokenExpires: state.tokenExpires,
    );
  }
}

class UserDataLogout extends UserDataState {
  const UserDataLogout({
    required List<String> permissions,
    required List<Role> roles,
    required String? accessToken,
    required String? refreshToken,
    required String? accessTokenExpires,
    required UserProfileModel? userProfile,
    required bool is_online,
    required DateTime tokenExpires,
  }) : super(
            permissions: permissions,
            roles: roles,
            accessToken: accessToken,
            refreshToken: refreshToken,
            accessTokenExpires: accessTokenExpires,
            userProfile: userProfile,
            is_online: is_online,
            tokenExpires: tokenExpires);

  static fromJson(json) {
    return UserDataLogout(
      permissions: json['permissions'] as List<String>,
      roles:
          List<Role>.from(json['roles'].map((e) => Role.fromJson(e)).toList()),
      accessToken: json['accessToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
      accessTokenExpires: json['accessTokenExpires'] as String?,
      userProfile: UserProfileModel.fromJson(json['userProfile']),
      is_online: json['is_online'] as bool,
      tokenExpires: DateTime.parse(json['tokenExpires']),
    );
  }

  static toJson(UserDataState state) {
    return {
      'permissions': state.permissions,
      'roles': state.roles.map((e) => e.toJson()).toList(),
      'accessToken': state.accessToken,
      'refreshToken': state.refreshToken,
      'accessTokenExpires': state.accessTokenExpires,
      'userProfile': state.userProfile?.toJson(),
      'is_online': state.is_online,
      'tokenExpires': state.tokenExpires.toIso8601String(),
    };
  }

  static copyWith(UserDataState state) {
    return UserDataLogout(
      permissions: state.permissions,
      roles: state.roles,
      accessToken: state.accessToken,
      refreshToken: state.refreshToken,
      accessTokenExpires: state.accessTokenExpires,
      userProfile: state.userProfile,
      is_online: state.is_online,
      tokenExpires: state.tokenExpires,
    );
  }
}
