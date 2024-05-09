import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_trainer_app/app/app_colors.dart';
import 'package:personal_trainer_app/common/util/seconds_converter.dart';
import 'package:personal_trainer_app/di/get_it.dart';
import 'package:personal_trainer_app/domain/gateway/settings_gateway.dart';
import 'package:personal_trainer_app/main.dart';
import 'package:personal_trainer_app/pages/settings/bloc/settings_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SettingsBloc>(
      create: (_) => SettingsBloc(
        gateway: getIt.get<SettingsGateway>(),
      ),
      child: BlocBuilder<SettingsBloc, SettingsModel>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              title: Text(
                'Настройки',
                style: AppConst.appBarTitle,
              ),
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: false,
            ),
            body: Column(
              children: [
                SettingsItem(
                  title: 'Время отдыха',
                  value: parseSeconds(state.restDuration.inSeconds),
                  onTap: () {
                    _showNumberPicker(context, state.restDuration.inSeconds).then((value) {
                      if(value != null){
                        context.read<SettingsBloc>().setRestTime(Duration(seconds: value));
                      }
                    });
                  },
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Future<int?> _showNumberPicker(BuildContext context, int currentDurationInSec) {
    const kStartKoef = 30;
    final listNumbers = List.generate(151, (index) => index + kStartKoef);
    return showCupertinoDialog<int?>(
      context: context,
      builder: (_) {
        int value = currentDurationInSec;
        return CupertinoAlertDialog(
          content: StatefulBuilder(builder: (context, setState) {
            return SizedBox(
              height: 264,
              child: Column(
                children: [
                  SizedBox(
                    height: 216,
                    child: CupertinoPicker(
                      magnification: 1.22,
                      squeeze: 1.2,
                      useMagnifier: true,
                      itemExtent: 32,
                      // This sets the initial item.
                      scrollController: FixedExtentScrollController(
                        initialItem: currentDurationInSec - kStartKoef,
                      ),
                      onSelectedItemChanged: (int selectedItem) {
                        setState(() {
                          value = selectedItem;
                        });
                      },
                      children: List<Widget>.generate(listNumbers.length,
                          (int index) {
                        return Center(
                            child: Text(listNumbers[index].toString()));
                      }),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      context.pop(value + kStartKoef);
                    },
                    child: Text(
                      'Ok',
                      style: AppConst.valueItem,
                    ),
                  )
                ],
              ),
            );
          }),
        );
      },
    );
  }
}

class SettingsItem extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback? onTap;

  const SettingsItem({
    super.key,
    required this.value,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Text(
                title,
                style: AppConst.titleItem,
              ),
              const Spacer(),
              Text(
                value,
                style: AppConst.valueItem,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
