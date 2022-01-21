import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_todo_list/entities/task.dart';

class TaskTile extends StatelessWidget {
  final Task? task;

  TaskTile(this.task);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(16), color: Task.availableColors[task?.indexColor ?? 0]),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task?.title ?? "",
                    style: GoogleFonts.lato(
                        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        color: Colors.grey.shade200,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        task != null
                            ? Task.timeOfDayToString(task!.startTime ?? const TimeOfDay(hour: 0, minute: 0)) +
                                '-' +
                                Task.timeOfDayToString(task!.endTime ?? const TimeOfDay(hour: 23, minute: 59))
                            : "Время не указано",
                        style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 13, color: Colors.grey.shade100)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                      task?.note ?? "",
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(fontSize: 15, color: Colors.grey.shade200),
                      ))
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              height: 60,
              width: 0.5,
              color: Colors.grey.shade200.withOpacity(0.7),
            ),
            RotatedBox(
              quarterTurns: 3,
              child: Text(
                task?.isCompleted ?? false ? "COMPLETED" : "TODO",
                style: GoogleFonts.lato(
                    textStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
