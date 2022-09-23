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
      this.userProfile});

  final List<String> permissions;
  final List<Role> roles;
  final String? accessToken;
  final String? refreshToken;
  final String? accessTokenExpires;
  final UserProfileModel? userProfile;

  @override
  List<Object> get props => [permissions, roles];
}
