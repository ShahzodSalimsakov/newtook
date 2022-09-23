import 'package:bloc/bloc.dart';
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:newtook/bloc/block_imports.dart';

part 'user_data_event.dart';
part 'user_data_state.dart';

class UserDataBloc extends HydratedBloc<UserDataEvent, UserDataState> {
  UserDataBloc()
      : super(const UserDataInitial(
            accessToken: '',
            accessTokenExpires: '',
            permissions: [],
            refreshToken: '',
            roles: [],
            userProfile: null)) {
    on<UserDataEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<UserDataEventChange>((event, emit) {
      emit(UserDataInitial(
          accessToken: event.accessToken,
          accessTokenExpires: event.accessTokenExpires,
          permissions: event.permissions,
          refreshToken: event.refreshToken,
          roles: event.roles,
          userProfile: event.userProfile));
    });
  }

  @override
  UserDataState? fromJson(Map<String, dynamic> json) =>
      UserDataInitial.fromJson(json['value']);

  @override
  Map<String, dynamic>? toJson(UserDataState state) =>
      {'value': jsonEncode(state)};
}
