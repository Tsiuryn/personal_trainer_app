import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_trainer_app/app/app_theme.dart';
import 'package:personal_trainer_app/common/base/toast.dart';
import 'package:personal_trainer_app/common/util/extensions.dart';
import 'package:personal_trainer_app/main.dart';
import 'package:personal_trainer_app/pages/import_export/import_export_bloc.dart';
import 'package:personal_trainer_app/pages/import_export/import_input_page.dart';
import 'package:personal_trainer_app/pages/training/util/training_type.dart';

class ImportExportPage extends StatelessWidget {
  const ImportExportPage({
    super.key,
    required this.type,
  });

  final IEPageType type;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Text(
          type.pageTitle(),
          style: AppTheme.appBarTitle,
        ),
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(
            Icons.arrow_back,
            color: AppTheme.white,
          ),
        ),
      ),
      body: BlocProvider<ImportExportBloc>(
        create: (_) => ImportExportBloc(),
        child: Builder(builder: (context) {
          return BlocListener<ImportExportBloc, ImportExportState>(
            listener: (context, state) {
              if (state.message.isNotEmpty) {
                toast(context, state.message);
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          type.pageDescription(),
                          style: AppTheme.description,
                        ),
                      ),
                    ],
                  ),
                  16.h,
                  ...TrainingType.values.map((value) {
                    return ListTile(
                      onTap: () => onTapTile(context, value),
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        value.trainingPageTitle,
                        style: AppTheme.titleItem.copyWith(
                          color: AppTheme.yellow,
                        ),
                      ),
                      trailing: Icon(
                        type.leadingIcon,
                        color: AppTheme.yellow,
                      ),
                    );
                  })
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  void onTapTile(BuildContext context, TrainingType trainingType) {
    if (type == IEPageType.import) {
      context
          .push(
        ImportInputPage(
          trainingType: trainingType,
        ),
      )
          .then((value) {
        if (value is String && context.mounted) {
          context.read<ImportExportBloc>().importData(trainingType, value);
        }
      });
    } else {
      context.read<ImportExportBloc>().exportData(trainingType);
    }
  }
}

enum IEPageType {
  import,
  export;

  String pageTitle() => switch (this) {
        IEPageType.import => 'Импортировать тренировки',
        IEPageType.export => 'Экспортировать тренировки',
      };

  String pageDescription() => switch (this) {
        IEPageType.import =>
          'Выбирите файл с необходимой программой тренировки. Нажмите импортировать. Выбранная тренировка перезапишет сохраненную тренировку.',
        IEPageType.export =>
          'Нажмите на необходимую программу. Данные тренировки будут выгружены в файл с возможностью поделиться либо сохранить в необходимом месте.',
      };

  IconData get leadingIcon => switch (this) {
        IEPageType.import => Icons.download_rounded,
        IEPageType.export => Icons.upload_rounded,
      };
}
