import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_todo_list/controllers/task_controller.dart';
import 'package:smart_todo_list/entities/repeat_enum.dart';
import 'package:smart_todo_list/entities/task.dart';
import 'package:smart_todo_list/ui/theme.dart';
import 'package:smart_todo_list/ui/widgets/button.dart';
import 'package:smart_todo_list/ui/widgets/input_field.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _taskController = Get.put(TaskController());
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.fromDateTime(DateTime.now().add(const Duration(minutes: 30)));

  int _selectedRemind = 5;
  final List<int> remindList = [5, 10, 15, 20];

  RepeatEnum _selectedRepeat = RepeatEnum.none;

  int _indexSelectedColor = 0;

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: _appBar(),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Добавление задачи', style: headingStyle),
                CustomInputField(title: 'Заголовок', hint: 'Укажите заголовок задачи', controller: _titleController),
                CustomInputField(title: 'Описание', hint: 'Укажите описание задачи', controller: _noteController),
                CustomInputField(
                  title: 'Дата',
                  hint: DateFormat.yMMMMd().format(_selectedDate),
                  widget: IconButton(
                    icon: const Icon(Icons.calendar_today_outlined, color: Colors.grey),
                    onPressed: () => _getDateFromUser().then((value) => setState((){ _selectedDate = value ?? _selectedDate; })),
                  ),
                ),
                Row(children: [
                  Expanded(
                    child: CustomInputField(
                      title: 'Начало',
                      hint: Task.timeOfDayToString(_startTime),
                      widget: IconButton(
                        icon: const Icon(Icons.access_time_rounded, color: Colors.grey),
                        onPressed: () => _getTimeFromUser().then((value) => setState(() {_startTime = value ?? _startTime;})),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomInputField(
                      title: 'Конец',
                      hint: Task.timeOfDayToString(_endTime),
                      widget: IconButton(
                        icon: const Icon(Icons.access_time_rounded, color: Colors.grey),
                        onPressed: () => _getTimeFromUser().then((value) => setState(() {_endTime = value ?? _endTime;})),
                        ),
                      ),
                    ),
                ]),
                CustomInputField(title: 'Напоминания', hint: 'Каждые $_selectedRemind минут',
                  widget: DropdownButton(
                    icon: const Icon( Icons.keyboard_arrow_down, color: Colors.grey ),
                    iconSize: 32,
                    elevation: 4,
                    style: subTitleStyle,
                    underline: Container(),
                    onChanged: (int? value) {
                      setState(() {
                        _selectedRemind = value ?? _selectedRemind;
                      });
                    },
                    items: remindList.map<DropdownMenuItem<int>>((int element) {
                      return DropdownMenuItem<int>(
                          value: element,
                          child: Text(element.toString())
                      );
                    }).toList(),
                  ),
                ),
                CustomInputField(title: 'Повторять', hint: _selectedRepeat.string,
                  widget: DropdownButton(
                    icon: const Icon( Icons.keyboard_arrow_down, color: Colors.grey ),
                    iconSize: 32,
                    elevation: 4,

                    style: subTitleStyle,
                    underline: Container(),
                    onChanged: (RepeatEnum? value) {
                      setState(() {
                        _selectedRepeat = value ?? _selectedRepeat;
                      });
                    },
                    items: RepeatEnum.values.map<DropdownMenuItem<RepeatEnum>>((RepeatEnum element) {
                      return DropdownMenuItem<RepeatEnum>(
                          value: element,
                          child: Text(element.string)
                      );
                    }).toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _colorPalette(),
                      CustomButton(text: 'Создать', onTab: () => _createTask())
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _appBar() {
    return AppBar(
      backgroundColor: Theme.of(context).backgroundColor,
      elevation: 0,
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Icon(Icons.arrow_back_ios, size: 30, color: Get.isDarkMode ? white : darkGreyClr),
      ),
      actions: [
        Container(
          width: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: darkGreyClr,
              width: 2,
            ),
          ),
          child: const CircleAvatar(
              backgroundImage: AssetImage('assets/images/default_user_image.png'),
              backgroundColor: Colors.white,
              radius: 22),
        ),
        const SizedBox(width: 20)
      ],
    );
  }

  Future<DateTime?> _getDateFromUser() async {
    final currentDate = DateTime.now();

    DateTime? _pickerDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(currentDate.year - 7),
      lastDate: DateTime(currentDate.year + 7),
    );

    return _pickerDate;
  }

  Future<TimeOfDay?> _getTimeFromUser() async {
    TimeOfDay? _pickedTime = await showTimePicker(
        context: context,
        initialEntryMode: TimePickerEntryMode.input,
        initialTime: const TimeOfDay(hour: 9, minute: 0));

    return _pickedTime;
  }

  bool _validateCurrentTask(){

    double timeOfDayToDouble(TimeOfDay myTime) => myTime.hour + myTime.minute/60.0;

    if (timeOfDayToDouble(_startTime) >  timeOfDayToDouble(_endTime)){
      Get.snackbar( 'Ошибка', 'Неверно указано время задачи!',
        snackPosition: SnackPosition.TOP,
        colorText: pinkClr,
        icon: const Icon(Icons.warning_amber_rounded, size: 32, color: pinkClr)
      );
      return false;
    }

    if (_noteController.text.isEmpty || _titleController.text.isEmpty){
      Get.snackbar( 'Ошибка', 'Все поля должны быть заполнены!',
          snackPosition: SnackPosition.TOP,
          colorText: pinkClr,
          icon: const Icon(Icons.warning_amber_rounded, size: 32, color: pinkClr)
      );
      return false;
    }

    return true;
  }

  Future<void> _createTask() async{
    if (_validateCurrentTask()) {

      // Добавление в базу данных
      await _taskController.addTask(task: Task(
          note: _noteController.text,
          title: _titleController.text,
          date: _selectedDate,
          startTime: _startTime,
          endTime: _endTime,
          repeat: _selectedRepeat,
          indexColor: _indexSelectedColor,
          isCompleted: false,
          remind: _selectedRemind
      ));

      // Вернуться на главную страницу
      Get.back();
    }
  }

  _colorPalette() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Цвета', style: titleStyle),
        const SizedBox(height: 10),
        Wrap(children: List<Widget>.generate(Task.availableColors.length, (index) =>
            GestureDetector(
              onTap: () { setState(() {
                _indexSelectedColor = index;
              }); },
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(
                  _indexSelectedColor == index? Icons.check_circle : Icons.circle,
                  size: 36,
                  color: Task.availableColors[index],
                ),
              ),
            ))
        )
      ]
    );
  }
}
