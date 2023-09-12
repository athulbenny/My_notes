import 'package:flutter/material.dart';

import 'notepad.dart';

void main(){
  runApp( MaterialApp(debugShowCheckedModeBanner: false, home: Notepad()));
}

// class Notepad extends StatefulWidget {
//   const Notepad({Key? key}) : super(key: key);
//
//   @override
//   State<Notepad> createState() => _NotepadState();
// }
//
// class _NotepadState extends State<Notepad> {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         body: Center(
//           child: ElevatedButton(onPressed: (){
//             Navigator.push(context, MaterialPageRoute(builder: (builder){
//               return HiveExampleUi();
//             }));
//           }, child: Text('switch')),
//         ),
//       ),
//     );
//   }
// }
