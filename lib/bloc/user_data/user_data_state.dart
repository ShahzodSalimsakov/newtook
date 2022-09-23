// ignore_for_file: public_member_api_docs, s

part of 'user_data_bloc.dart';

class Role {
  final String name;
  final bool active;

  Role({
    required this.name,
    required this.active,
  });

  Role copyWith({
    String? name,
    bool? active,
  }) {
    return Role(
      name: name ?? this.name,
      active: active ?? this.active,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'active': active,
    };
  }

  factory Role.fromMap(Map<String, dynamic> map) {
    return Role(
      name: map['name'] as String,
      active: map['active'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Role.fromJson(String source) =>
      Role.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Role(name: $name, active: $active)';

  @override
  bool operator ==(covariant Role other) {
    if (identical(this, other)) return true;

    return other.name == name && other.active == active;
  }

  @override
  int get hashCode => name.hashCode ^ active.hashCode;
}

class UserProfileModel {
  final String? first_name;
  final String? last_name;
  final String? phone;
  final bool? is_super_user;

  UserProfileModel(
      {required this.first_name,
      required this.last_name,
      required this.phone,
      required this.is_super_user});

  UserProfileModel copyWith({
    String? first_name,
    String? last_name,
    String? phone,
    bool? is_super_user,
  }) {
    return UserProfileModel(
      first_name: this.first_name ?? '',
      last_name: this.last_name ?? '',
      phone: this.phone ?? '',
      is_super_user: this.is_super_user ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'first_name': first_name,
      'last_name': last_name,
      'phone': phone,
      'is_super_user': is_super_user,
    };
  }

  factory UserProfileModel.fromMap(Map<String, dynamic> map) {
    return UserProfileModel(
      first_name:
          map['first_name'] != null ? map['first_name'] as String : null,
      last_name: map['last_name'] != null ? map['last_name'] as String : null,
      phone: map['phone'] != null ? map['phone'] as String : null,
      is_super_user:
          map['is_super_user'] != null ? map['is_super_user'] as bool : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserProfileModel.fromJson(String source) =>
      UserProfileModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserProfileModel(first_name: $first_name, last_name: $last_name, phone: $phone, is_super_user: $is_super_user)';
  }

  @override
  bool operator ==(covariant UserProfileModel other) {
    if (identical(this, other)) return true;

    return other.first_name == first_name &&
        other.last_name == last_name &&
        other.phone == phone &&
        other.is_super_user == is_super_user;
  }

  @override
  int get hashCode {
    return first_name.hashCode ^
        last_name.hashCode ^
        phone.hashCode ^
        is_super_user.hashCode;
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
  const UserDataState(
      {required this.permissions,
      required this.roles,
      this.accessToken,
      this.refreshToken,
      this.accessTokenExpires,
      this.userProfile,
      required this.is_online});

  @override
  List<Object> get props => [];
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
  }) : super(
            permissions: permissions,
            roles: roles,
            accessToken: accessToken,
            refreshToken: refreshToken,
            accessTokenExpires: accessTokenExpires,
            userProfile: userProfile,
            is_online: is_online);

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
    );
  }
}
