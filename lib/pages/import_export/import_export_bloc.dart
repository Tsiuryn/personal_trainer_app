import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:personal_trainer_app/di/di_module.dart';
import 'package:personal_trainer_app/domain/entity/trainer.dart';
import 'package:personal_trainer_app/domain/gateway/training_gateway.dart';
import 'package:personal_trainer_app/pages/training/util/training_type.dart';
import 'package:share_plus/share_plus.dart';

class ImportExportBloc extends Cubit<ImportExportState> {
  ImportExportBloc() : super(ImportExportState.initial());

  void exportData(TrainingType trainingType) async {
    final gateway =
        getIt.get<TrainingGateway>(instanceName: trainingType.value);

    final json = (await gateway.getTrainer()).toJson();

    final programm = jsonEncode(json);

    Share.shareXFiles(
      [XFile.fromData(utf8.encode(programm), mimeType: 'text/plain')],
      fileNameOverrides: [
        '${trainingType.trainingPageTitle}_${_currentDate()}.json'
      ],
    );
  }

  String _currentDate() =>
      DateFormat('dd_MM_yyyy__HH_mm_ss').format(DateTime.now());

  void importData(TrainingType trainingType, String programm) async {
    final gateway =
        getIt.get<TrainingGateway>(instanceName: trainingType.value);
    try {
      final trainer = Trainer.fromJson(jsonDecode(programm));
      await gateway.setTrainer(trainer);
      emit(ImportExportState(
          '"${trainingType.trainingPageTitle}" успешно сохранена !'));
    } catch (_) {
      emit(ImportExportState(
          'Ошибка сохранения "${trainingType.trainingPageTitle}"'));
    }
  }
}

class ImportExportState {
  ImportExportState(this.message);
  ImportExportState.initial() : message = '';

  final String message;
}
