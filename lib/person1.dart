import 'package:hive/hive.dart';

part 'person1.g.dart';

@HiveType(typeId: 1)
class PersonModel{
  @HiveField(0)
  int id;
  @HiveField(1)
  String title;
  @HiveField(2)
  DateTime dt ;
  @HiveField(3)
  String content;
  PersonModel(this.id, this.title, this.dt,this.content);
}