import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:load_switch/load_switch.dart';
import 'package:newtook/bloc/block_imports.dart';

class HomeViewWorkSwitch extends StatefulWidget {
  const HomeViewWorkSwitch({super.key});

  @override
  State<HomeViewWorkSwitch> createState() => _HomeViewWorkSwitchState();
}

class _HomeViewWorkSwitchState extends State<HomeViewWorkSwitch> {
  bool value = false;

  Future<bool> _toggleWork() async {
    print(value);
    await Future.delayed(const Duration(seconds: 2));
    return !value;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserDataBloc, UserDataState>(
      builder: (context, state) {
        return Container(
          child: LoadSwitch(
            value: state.is_online,
            future: _toggleWork,
            onChange: (v) {
              value = v;
              print('Value changed to $v');
              setState(() {});
            },
            onTap: (bool) {},
          ),
        );
      },
    );
  }
}
