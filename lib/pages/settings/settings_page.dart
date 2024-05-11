import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_trainer_app/app/app_theme.dart';
import 'package:personal_trainer_app/common/base/ok_dialog.dart';
import 'package:personal_trainer_app/common/util/extensions.dart';
import 'package:personal_trainer_app/common/util/seconds_converter.dart';
import 'package:personal_trainer_app/di/di_module.dart';
import 'package:personal_trainer_app/domain/entity/max_reps.dart';
import 'package:personal_trainer_app/domain/gateway/settings_gateway.dart';
import 'package:personal_trainer_app/main.dart';
import 'package:personal_trainer_app/pages/check_level/check_level_page.dart';
import 'package:personal_trainer_app/pages/settings/bloc/settings_bloc.dart';
import 'package:personal_trainer_app/pages/training/util/training_type.dart';

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
                style: AppTheme.appBarTitle,
              ),
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: false,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  SettingsItem(
                    title: 'Время отдыха',
                    value: parseSeconds(state.restDuration.inSeconds),
                    onTap: () {
                      _showNumberPicker(context, state.restDuration.inSeconds)
                          .then((value) {
                        if (value != null) {
                          context
                              .read<SettingsBloc>()
                              .setRestTime(Duration(seconds: value));
                        }
                      });
                    },
                  ),
                  const SettingsTitle(title: 'Личные достижения: '),
                  ...TrainingType.values.map(
                    (e) {
                      final MaxReps? maxReps = state.maxReps[e];
                      return SettingsItem(
                        value: maxReps != null ? maxReps.value.toString() : '-',
                        title: e.settingsPageStatisticsTitle,
                        description: maxReps != null
                            ? 'Ваш текущий уровень: ${maxReps.level}'
                            : null,
                        onTap: () {
                          context
                              .push<bool>(CheckLevelPage(trainingType: e))
                              .then((value) {
                            if (value != null && value) {
                              context.read<SettingsBloc>().updateReps();
                            }
                          });
                        },
                      );
                    },
                  ),
                  const SettingsTitle(title: 'Очистить данные: '),
                  ...TrainingType.values.map((type) {
                    return SettingsItem(
                      title: type.settingsPageClearDataTitle,
                      onTap: () {
                        showOkDialog(context,
                                title: 'Удаление данных',
                                description:
                                    '${type.settingsPageClearDataTitle}?')
                            .then((value) {
                          if (value != null && value) {
                            context.read<SettingsBloc>().clearHistory(type);
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Данные успешно удалены!')));
                          }
                        });
                      },
                    );
                  }),
                  32.h,
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<int?> _showNumberPicker(
      BuildContext context, int currentDurationInSec) {
    const kStartKoef = 30;
    final listNumbers = List.generate(31, (index) => (index * 5) + kStartKoef);
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
                        initialItem: (currentDurationInSec - kStartKoef) ~/ 5,
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
                      context.pop((value * 5) + kStartKoef);
                    },
                    child: Text(
                      'Ok',
                      style: AppTheme.valueItem,
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

class SettingsTitle extends StatelessWidget {
  final String title;

  const SettingsTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: AppTheme.titleSettings,
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsItem extends StatelessWidget {
  final String title;
  final String? value;
  final String? description;
  final VoidCallback? onTap;

  const SettingsItem({
    super.key,
    required this.title,
    this.value,
    this.description,
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTheme.titleItem,
                    ),
                    if (description != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Text(
                          description!,
                          style: AppTheme.smallDescription,
                        ),
                      )
                  ],
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              if (value != null)
                Text(
                  value!,
                  style: AppTheme.valueItem,
                ),
              if (onTap != null)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Icon(
                    Icons.keyboard_arrow_right_rounded,
                    color: AppTheme.white,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
