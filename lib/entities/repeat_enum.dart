enum RepeatEnum {
  none,
  daily,
  weekly,
  monthly
}

extension RepeatEnumExtension on RepeatEnum {
  String get string{
    switch (this) {
      case RepeatEnum.daily:
        return 'Каждый день';
      case RepeatEnum.monthly:
        return 'Каждый месяц';
      case RepeatEnum.weekly:
        return 'Каждую неделю';
      default:
        return 'Нет';
    }
  }
}