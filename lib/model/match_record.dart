import 'package:hive/hive.dart';

part 'match_record.g.dart';

@HiveType(typeId: 0)
class MatchRecord extends HiveObject {

  @HiveField(0)
  String eventName;

  @HiveField(1)
  DateTime date;

  @HiveField(2)
  String format;

  @HiveField(3)
  String usedLrig;

  @HiveField(4)
  int round;

  @HiveField(5)
  String opponentLrig;

  @HiveField(6)
  String firstSecond;

  @HiveField(7)
  String result;

  @HiveField(8)
  int selfLb;

  @HiveField(9)
  int opponentLb;

  @HiveField(10)
  String memo;

  @HiveField(11)
String? imagePath;

  MatchRecord({
    required this.eventName,
    required this.date,
    required this.format,
    required this.usedLrig,
    required this.round,
    required this.opponentLrig,
    required this.firstSecond,
    required this.result,
    required this.selfLb,
    required this.opponentLb,
    required this.memo,
    this.imagePath,
  });
}