import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:newtook/bloc/block_imports.dart';
import 'package:newtook/pages/qr/qr.dart';

class InitialPage extends StatelessWidget {
  const InitialPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => ApiClientsBloc(), child: const _InitialPageView());
  }
}

class _InitialPageView extends StatelessWidget {
  const _InitialPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApiClientsBloc, ApiClientsState>(
        builder: (context, state) {
      print(state.apiClients);
      if (state.apiClients.isEmpty) {
        return QRViewWidget();
      } else {
        return const Center(child: Text('Initial Page'));
      }
    });
  }
}
