import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:smart_todo_list/services/notification_services.dart';
import 'package:smart_todo_list/services/theme_services.dart';
import 'package:smart_todo_list/ui/theme.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:smart_todo_list/ui/widgets/button.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late NotificationService notifyHelper;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    notifyHelper = NotificationService()..initializeNotification();
    initializeDateFormatting();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Column(children: [
        _addTaskBar(),
        _addDateBar()
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
        onDateChange: (date) => _selectedDate = date,
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
        CustomButton(text: '+ Добавить', onTab: () => null),
      ]),
    );
  }
}
