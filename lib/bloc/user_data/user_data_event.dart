part of 'user_data_bloc.dart';

abstract class UserDataEvent extends Equatable {
  const UserDataEvent();

  @override
  List<Object> get props => [];
}

class UserDataEventChange extends UserDataEvent {
  const UserDataEventChange(
      {required this.permissions,
      required this.roles,
      this.accessToken,
      this.refreshToken,
      this.accessTokenExpires,
      this.userProfile,
      required this.is_online,
      required this.tokenExpires});

  final List<String> permissions;
  final List<Role> roles;
  final String? accessToken;
  final String? refreshToken;
  final String? accessTokenExpires;
  final UserProfileModel? userProfile;
  final bool is_online;
  final DateTime tokenExpires;

  @override
  List<Object> get props => [permissions, roles, is_online, tokenExpires];
}

class UserDataEventLogout extends UserDataEvent {}
