import 'package:flutter/material.dart';
import 'package:personal_trainer_app/app/app_theme.dart';
import 'package:personal_trainer_app/common/base/toast.dart';
import 'package:personal_trainer_app/main.dart';
import 'package:personal_trainer_app/pages/training/util/training_type.dart';

class ImportInputPage extends StatefulWidget {
  const ImportInputPage({
    super.key,
    required this.trainingType,
  });

  final TrainingType trainingType;

  @override
  State<ImportInputPage> createState() => _ImportInputPageState();
}

class _ImportInputPageState extends State<ImportInputPage> {
  late final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          title: Text(
            'Импорт "${widget.trainingType.trainingPageTitle}"',
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
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              TextFormField(
                minLines: 4,
                maxLines: 24,
                cursorColor: AppTheme.white,
                style: AppTheme.description,
                controller: _controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      borderSide: BorderSide(color: AppTheme.grey)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      borderSide: BorderSide(color: AppTheme.yellow)),
                ),
              ),
              Spacer(),
              SafeArea(
                child: OutlinedButton(
                  onPressed: () {
                    if (_controller.text.isEmpty) {
                      toast(context, 'Добавь программу тренировок');
                    } else {
                      context.pop(_controller.text);
                    }
                  },
                  child: Text(
                    'Сохранить',
                    style: AppTheme.subTitle,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
