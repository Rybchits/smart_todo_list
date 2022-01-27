import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:smart_todo_list/controllers/task_controller.dart';
import 'package:smart_todo_list/entities/repeat_enum.dart';
import 'package:smart_todo_list/entities/task.dart';
import 'package:smart_todo_list/services/notification_services.dart';
import 'package:smart_todo_list/services/theme_services.dart';
import 'package:smart_todo_list/ui/add_task_page.dart';
import 'package:smart_todo_list/ui/theme.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:smart_todo_list/ui/widgets/button.dart';
import 'package:smart_todo_list/ui/widgets/task_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late NotificationService notifyHelper;
  DateTime _selectedDate = DateTime.now();
  final _taskController = Get.put(TaskController());

  @override
  void initState() {
    notifyHelper = NotificationService()..initializeNotification();
    initializeDateFormatting();
    _taskController.getTasks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Column(children: [
        _addTaskBar(),
        _addDateBar(),
        _showTasks()
      ]),
    );
  }

  _appBar() {
    return AppBar(
      backgroundColor: Theme.of(context).backgroundColor,
      elevation: 0,
      leading: GestureDetector(
        onTap: () {
          ThemeService().switchTheme();
          notifyHelper.displayNotification(
              title: 'Тема приложения была изменена!',
              body: Get.isDarkMode ? 'Была активирована светлая тема!' : 'Была активирована темная тема!');
        },
        child: Icon(
            Get.isDarkMode ? Icons.wb_sunny_rounded : Icons.nightlight_round,
            size: 30,
            color: Get.isDarkMode ? white : darkGreyClr
        ),
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

  _addDateBar() {
    return Container(
      margin: const EdgeInsets.all(5),
      child: DatePicker(
        DateTime.now(),
        daysCount: 365,
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: bluishClr,
        selectedTextColor: Colors.white,
        dateTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey
            )
        ),
        dayTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey
            )
        ),
        monthTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey
            )
        ),
        locale: 'ru',
        onDateChange: (date) => setState((){_selectedDate = date;}),
      ),
    );
  }

  _addTaskBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(DateFormat.yMMMMd('ru').format(DateTime.now()), style: subHeadingStyle),
          Text('Сегодня', style: headingStyle)
        ]),
        CustomButton(text: '+ Добавить', onTab: () async {
          await Get.to(() => AddTaskPage());
          _taskController.getTasks();
        }),
      ]),
    );
  }

  _showTasks(){
    return Expanded(
      child: Obx(() {
        return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 10),
            itemCount: _taskController.taskList.length,
            itemBuilder: (_, index) {
              Task task = _taskController.taskList[index];

              // Дата этой задачи в будущем
              bool isFutureTask = _selectedDate.isBefore(task.date ?? DateTime.now());
              bool showTask = false;

              switch(task.repeat ?? RepeatEnum.none){
                case RepeatEnum.none:
                  showTask = task.date?.year == _selectedDate.year
                      && task.date?.month == _selectedDate.month && task.date?.day == _selectedDate.day;
                  break;
                case RepeatEnum.daily:
                  showTask = !isFutureTask;
                  break;
                case RepeatEnum.weekly:
                  showTask = !isFutureTask && _selectedDate.difference(task.date ?? DateTime.now()).inDays % 7 == 0;
                  break;
                case RepeatEnum.monthly:
                  showTask = !isFutureTask && _selectedDate.day == (task.date ?? DateTime.now()).day;
                  break;
              }

              return showTask? AnimationConfiguration.staggeredList(
                  position: index,
                  child: FadeInAnimation(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => _showBottomSheet(context, task),
                            child: TaskTile(task),
                          )
                        ],
                      )
                  )
              ) : Container();
            });
      }),
    );
  }

  _showBottomSheet(BuildContext context, Task task){
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 4),
        height: MediaQuery.of(context).size.height * 0.25,
        color: Theme.of(context).backgroundColor,
        child: Column(
          children: [
            Container(
              height: 6,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Get.isDarkMode? Colors.grey.shade600 : Colors.grey.shade300
              ),
            ),
            const SizedBox(height: 30),
            _bottomSheetButton(
                color: bluishClr,
                label: task.isCompleted ?? false? 'Отметить невыполненной' : 'Выполнить задачу',
                onClick: () {
                  _taskController.switchIsCompletedTask(task);
                  Get.back();
                }),
            _bottomSheetButton(
                color: pinkClr,
                label: 'Удалить задачу',
                onClick: () {
                  _taskController.delete(task);
                  Get.back();
                })
          ],
        ),
      )
    );
  }

  Widget _bottomSheetButton({required String label, Color color = bluishClr, Function()? onClick}){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          textStyle: const TextStyle(fontSize: 20),
          primary: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // <-- Radius
          ),
        ),
        onPressed: onClick,
        child: Text(label),
      ),
    );
  }
}
