import 'package:fostershare/core/models/data/child_log/child_log.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'child.g.dart';

@HiveType(typeId: 3)
@JsonSerializable(createToJson: false)
class Child {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String firstName;

  @HiveField(2)
  final String lastName;

  @HiveField(3)
  final DateTime dateOfBirth;

  int get age => this._age();

  @HiveField(4)
  final String image; // TODO upgrade to save uri

  @HiveField(8)
  final String imageURL; // TODO upgrade to save uri

  @HiveField(5)
  final int logsCount;

  @HiveField(6)
  final String agentName;

  @HiveField(7)
  final List<ChildLog> recentLogs;

  @HiveField(9)
  final String nickName;

  const Child({
    this.id,
    this.firstName,
    this.lastName,
    this.dateOfBirth,
    this.image,
    this.imageURL,
    this.logsCount,
    this.agentName,
    this.recentLogs,
    this.nickName,
  });

  factory Child.fromJson(Map<String, dynamic> json) => _$ChildFromJson(json);

  int _age() {
    if (this.dateOfBirth == null) {
      return null;
    }

    final DateTime now = DateTime.now();
    final DateTime localDateOfBirth = this.dateOfBirth.toLocal();

    int age = now.year - localDateOfBirth.year;
    final int nowMonth = now.month;
    final int dobMonth = localDateOfBirth.month;
    if (dobMonth > nowMonth) {
      age--;
    } else if (nowMonth == dobMonth) {
      final int nowDay = now.day;
      final int dobDay = localDateOfBirth.day;
      if (dobDay > nowDay) {
        age--;
      }
    }

    return age;
  }
}
