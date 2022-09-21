import 'dart:convert';
import 'dart:ffi';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'api_clients_event.dart';
part 'api_clients_state.dart';

class ApiClientsBloc extends Bloc<ApiClientsEvent, ApiClientsState> {
  ApiClientsBloc() : super(ApiClientsInitial()) {
    on<ApiClientsEvent>((event, emit) {});
    on<ApiClientsAdd>((event, emit) {
      final apiClients = state.apiClients;
      apiClients.add(ApiClients(
        apiUrl: event.apiUrl,
        serviceName: event.serviceName,
        isServiceDefault: event.isServiceDefault,
      ));
      emit(ApiClientsState(apiClients: apiClients));
    });
    on<ApiClientsRemove>((event, emit) {
      final apiClients = state.apiClients;
      apiClients.removeWhere((element) =>
          element.apiUrl == event.apiUrl &&
          element.serviceName == event.serviceName &&
          element.isServiceDefault == event.isServiceDefault);
      emit(ApiClientsState(apiClients: apiClients));
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
      emit(ApiClientsState(apiClients: apiClients));
    });
  }

  @override
  List<ApiClients> fromJson(Map<String, dynamic> json) => json['value']
      .map<ApiClients>((item) => ApiClients.fromMap(item))
      .toList();

  @override
  Map<String, dynamic> toJson(List<ApiClients> state) =>
      {'value': jsonEncode(state)};
}
