import 'dart:convert';
import 'dart:ffi';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:newtook/bloc/block_imports.dart';

part 'api_clients_event.dart';
part 'api_clients_state.dart';

class ApiClientsBloc extends HydratedBloc<ApiClientsEvent, ApiClientsState> {
  ApiClientsBloc() : super(const ApiClientsInitial(apiClients: [])) {
    on<ApiClientsAdd>((event, emit) {
      final apiClients = List<ApiClients>.from(state.apiClients);
      // print(apiClients);
      apiClients.add(ApiClients(
        apiUrl: event.apiUrl,
        serviceName: event.serviceName,
        isServiceDefault: event.isServiceDefault,
      ));
      // print(apiClients);
      emit(ApiClientsInitial(apiClients: apiClients));
    });
    on<ApiClientsRemove>((event, emit) {
      final apiClients = state.apiClients;
      apiClients.removeWhere((element) =>
          element.apiUrl == event.apiUrl &&
          element.serviceName == event.serviceName &&
          element.isServiceDefault == event.isServiceDefault);
      emit(ApiClientsInitial(apiClients: apiClients));
    });
    on<ApiClientsUpdate>((event, emit) {
      final apiClients = state.apiClients;
      apiClients.removeWhere((element) =>
          element.apiUrl == event.apiUrl &&
          element.serviceName == event.serviceName &&
          element.isServiceDefault == event.isServiceDefault);
      apiClients.add(ApiClients(
        apiUrl: event.apiUrl,
        serviceName: event.serviceName,
        isServiceDefault: event.isServiceDefault,
      ));
      emit(ApiClientsInitial(apiClients: apiClients));
    });
  }

  @override
  ApiClientsState? fromJson(Map<String, dynamic> json) => json['value']
      .map<ApiClients>((item) => ApiClients.fromMap(item))
      .toList();

  @override
  Map<String, dynamic>? toJson(ApiClientsState state) =>
      {'value': jsonEncode(state.apiClients)};
}
