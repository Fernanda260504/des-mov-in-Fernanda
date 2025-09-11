import 'package:flutter_application_2/person.dart';

class Student extends Person {
  
  String enrollment;

  Student({required String name,required this.enrollment}):super(name);
}