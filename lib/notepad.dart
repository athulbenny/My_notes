import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notepad/person1.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';



//flutter pub run build_runner build


  class Notepad extends StatefulWidget {
  const Notepad({super.key});

  @override
  _NotepadState createState() => _NotepadState();
  }

  class _NotepadState extends State<Notepad> {
  @override
  void initState() {
    super.initState();
    Hive.registerAdapter(PersonModelAdapter());
    _openBox();
  }
 var dir;
  Future _openBox() async {
    if(kIsWeb){
        //dir = await ;
    }
    else{
     dir = await getApplicationDocumentsDirectory();}
    Hive.init(dir.path);
    if (kDebugMode) {
      print(dir.path);
    }
    _personBox =
    await Hive.openBox('personBox'); //Hive.box<DataModel>(dataBoxName);
    return;
  }

  Box? _personBox;
  TextEditingController textTitle = TextEditingController();
  TextEditingController textContent = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orangeAccent[400],
          title: const Text("MY REMINDER"),
          centerTitle: true,
        ),
        body: Column(
            children: <Widget>[
              // Text("Data in database"),
              const SizedBox(height: 40,),
              _personBox == null
                  ? const Text("")
                  : Expanded(
                  child:



                  WatchBoxBuilder(
                      box: _personBox!,
                      builder: (context, box) {
                        Map<dynamic, dynamic> raw = box.toMap();
                        List list = raw.values.toList();
                        return Container(padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: GridView.count(crossAxisCount: 2,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0,
                            shrinkWrap: true,
                            children: List.generate(list.length, (index) {
                              PersonModel personModel = list[index];
                              return GestureDetector(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  color: Colors.grey[300],
                                  child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(personModel.title.length<50?
                                      personModel.title:"${personModel.title.substring(0,50)} ...",
                                        style: const TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                                      Text(
                                           "${personModel.dt
                                              .toLocal()
                                              .toString()
                                              .split(' ')
                                              .last
                                              .toString()
                                              .split(':')
                                              [0]}:${personModel.dt
                                                  .toLocal()
                                                  .toString()
                                                  .split(' ')
                                                  .last
                                                  .toString()
                                                  .split(':')
                                              [1]} ${personModel.dt
                                                  .toLocal()
                                                  .toString()
                                                  .split(' ')
                                                  .first.split('-')[2]}-${personModel.dt
                                                  .toLocal()
                                                  .toString()
                                                  .split(' ')
                                                  .first.split('-')[1]}-${personModel.dt
                                                  .toLocal()
                                                  .toString()
                                                  .split(' ')
                                                  .first.split('-')[0]}"
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  showDialog(
                                      context: context, builder: (builder) {
                                    return SingleChildScrollView(
                                      child: AlertDialog(
                                        title: GestureDetector(child: Text(personModel.title),
                                           onLongPress: (){Clipboard.setData(ClipboardData(text: personModel.title));}
                                        ),
                                        actions: [ SizedBox(
                                          height: MediaQuery
                                              .of(context)
                                              .size
                                              .height / 5,
                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width / 1.5,
                                          child: Center(
                                            child: SingleChildScrollView(
                                              child: GestureDetector(
                                                child: Text(personModel.content,
                                                  style: const TextStyle(
                                                      fontSize: 25),),
                                                onLongPress: (){
                                                  Clipboard.setData(ClipboardData(text: personModel.content));

                                                },
                                              ),),
                                          ),
                                        ),

                                          TextButton(onPressed: () {
                                            showDialog(context: context,
                                                builder: (builder) {
                                              textTitle.text=personModel.title;
                                                  textContent.text =
                                                      personModel.content;
                                                  return AlertDialog(
                                                    title: TextFormField(
                                                      style: const TextStyle(
                                                          fontSize: 25),
                                                      controller: textTitle,
                                                    ),
                                                    content: TextFormField(
                                                      keyboardType: TextInputType.multiline,
                                                      maxLines: 100,minLines: 1,
                                                      style: const TextStyle(
                                                          fontSize: 25),
                                                      controller: textContent,
                                                    ), actions: [
                                                    ElevatedButton(onPressed: () {
                                                      personModel.content =
                                                          textContent.text;
                                                      personModel.title=textTitle.text;
                                                      _personBox?.putAt(
                                                          index, personModel);
                                                      textContent.clear();textTitle.clear();
                                                      Navigator.pop(context);
                                                    }, child: const Text("Save")),
                                                  ],
                                                  );
                                                });
                                          }, child: const Text('Modify')),
                                          ElevatedButton(onPressed: () {
                                            _personBox?.deleteAt(index);
                                            Navigator.pop(context);
                                          }, child: const Text('Delete'))
                                        ],
                                      ),
                                    );
                                  });
                                },
                              );
                            }),
                          ),
                        );
                })
              ),
              Wrap(
                children: <Widget>[
                  ElevatedButton(
                    child: const Text("Add item "),
                    onPressed: () {
                      showDialog(context: context, builder: (builder) {
                        textContent.text = "";textTitle.text="";
                        return SingleChildScrollView(
                          child: AlertDialog(
                            title: const Text("Enter Data"),
                            actions: [ Column(
                              children: [
                                Row(
                                  children: [
                                    const Text(""), SizedBox(width: MediaQuery
                                        .of(context)
                                        .size
                                        .width / 10,),
                                    SizedBox(width: MediaQuery
                                        .of(context)
                                        .size
                                        .width / 3,
                                      child: TextField(autofocus: true,
                                        controller: textTitle,
                                        decoration: const InputDecoration(
                                            hintText: 'Enter title'),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: MediaQuery
                                    .of(context)
                                    .size
                                    .height / 18,),
                                const Text("Enter Content"),
                                SizedBox(width: MediaQuery
                                    .of(context)
                                    .size
                                    .width,
                                  child: TextField(
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 100,minLines: 1,
                                    controller: textContent,
                                  ),
                                ),
                              ],
                            ),

                              ElevatedButton(onPressed: () {
                                PersonModel personModel = PersonModel(
                                    _personBox!.toMap().length + 1,
                                    textTitle.text, DateTime.now(),
                                    textContent.text);
                                _personBox?.add(
                                    personModel);
                                textTitle.clear();
                                textContent.clear();
                                Navigator.pop(context);
                              }, child: const Text('save'))
                            ],
                          ),
                        );
                      });
                      if (kDebugMode) {
                        print("added");
                      }
                    },
                  ),
                ],
              ),
            ]
        )
    );
  }
}


/*

 WatchBoxBuilder(
                      box: _personBox!,
                      builder: (context, box) {
                        Map<dynamic, dynamic> raw = box.toMap();
                        List list = raw.values.toList();
                        return Container(padding: EdgeInsets.symmetric(horizontal: 20),
                          child: GridView.count(crossAxisCount: 2,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0,
                            shrinkWrap: true,
                            children: List.generate(list.length, (index) {
                              PersonModel personModel = list[index];
                              return GestureDetector(
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  color: Colors.grey[300],
                                  child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(personModel.title.length<50?
                                      personModel.title:"${personModel.title.substring(0,50)} ...",
                                        style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                                      Text(
                                           "${personModel.dt
                                              .toLocal()
                                              .toString()
                                              .split(' ')
                                              .last
                                              .toString()
                                              .split(':')
                                              [0]}:${personModel.dt
                                                  .toLocal()
                                                  .toString()
                                                  .split(' ')
                                                  .last
                                                  .toString()
                                                  .split(':')
                                              [1]} ${personModel.dt
                                                  .toLocal()
                                                  .toString()
                                                  .split(' ')
                                                  .first.split('-')[2]}-${personModel.dt
                                                  .toLocal()
                                                  .toString()
                                                  .split(' ')
                                                  .first.split('-')[1]}-${personModel.dt
                                                  .toLocal()
                                                  .toString()
                                                  .split(' ')
                                                  .first.split('-')[0]}"
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  showDialog(
                                      context: context, builder: (builder) {
                                    return SingleChildScrollView(
                                      child: AlertDialog(
                                        title: GestureDetector(child: Text(personModel.title),
                                           onLongPress: (){Clipboard.setData(new ClipboardData(text: personModel.title));}
                                        ),
                                        actions: [ Container(
                                          height: MediaQuery
                                              .of(context)
                                              .size
                                              .height / 5,
                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width / 1.5,
                                          child: Center(
                                            child: SingleChildScrollView(
                                              child: GestureDetector(
                                                child: Text(personModel.content,
                                                  style: TextStyle(
                                                      fontSize: 25),),
                                                onLongPress: (){
                                                  Clipboard.setData(new ClipboardData(text: personModel.content));

                                                },
                                              ),),
                                          ),
                                        ),

                                          TextButton(onPressed: () {
                                            showDialog(context: context,
                                                builder: (builder) {
                                              textTitle.text=personModel.title;
                                                  textContent.text =
                                                      personModel.content;
                                                  return AlertDialog(
                                                    title: TextFormField(
                                                      style: TextStyle(
                                                          fontSize: 25),
                                                      controller: textTitle,
                                                    ),
                                                    content: TextFormField(
                                                      keyboardType: TextInputType.multiline,
                                                      maxLines: 100,minLines: 1,
                                                      style: TextStyle(
                                                          fontSize: 25),
                                                      controller: textContent,
                                                    ), actions: [
                                                    ElevatedButton(onPressed: () {
                                                      personModel.content =
                                                          textContent.text;
                                                      personModel.title=textTitle.text;
                                                      _personBox?.putAt(
                                                          index, personModel);
                                                      textContent.clear();textTitle.clear();
                                                      Navigator.pop(context);
                                                    }, child: Text("Save")),
                                                  ],
                                                  );
                                                });
                                          }, child: Text('Modify')),
                                          ElevatedButton(onPressed: () {
                                            _personBox?.deleteAt(index);
                                            Navigator.pop(context);
                                          }, child: Text('Delete'))
                                        ],
                                      ),
                                    );
                                  });
                                },
                              );
                            }),
                          ),
                        );
                })

////////////////////////////////////////////////////////////////////////////////

ValueListenableBuilder(
                        valueListenable: _personBox.listenable,
                        builder: (context,box,child){
                          Map<dynamic, dynamic> raw = box.toMap();
                          List list = raw.values.toList();
                          return Container(padding: EdgeInsets.symmetric(horizontal: 20),
                            child: GridView.count(crossAxisCount: 2,
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 10.0,
                              shrinkWrap: true,
                              children: List.generate(list.length, (index) {
                                PersonModel personModel = list[index];
                                return GestureDetector(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    color: Colors.grey[300],
                                    child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(personModel.title.length<50?
                                        personModel.title:"${personModel.title.substring(0,50)} ...",
                                          style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                                        Text(
                                            "${personModel.dt
                                                .toLocal()
                                                .toString()
                                                .split(' ')
                                                .last
                                                .toString()
                                                .split(':')
                                            [0]}:${personModel.dt
                                                .toLocal()
                                                .toString()
                                                .split(' ')
                                                .last
                                                .toString()
                                                .split(':')
                                            [1]} ${personModel.dt
                                                .toLocal()
                                                .toString()
                                                .split(' ')
                                                .first.split('-')[2]}-${personModel.dt
                                                .toLocal()
                                                .toString()
                                                .split(' ')
                                                .first.split('-')[1]}-${personModel.dt
                                                .toLocal()
                                                .toString()
                                                .split(' ')
                                                .first.split('-')[0]}"
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    showDialog(
                                        context: context, builder: (builder) {
                                      return SingleChildScrollView(
                                        child: AlertDialog(
                                          title: GestureDetector(child: Text(personModel.title),
                                              onLongPress: (){Clipboard.setData(new ClipboardData(text: personModel.title));}
                                          ),
                                          actions: [ Container(
                                            height: MediaQuery
                                                .of(context)
                                                .size
                                                .height / 5,
                                            width: MediaQuery
                                                .of(context)
                                                .size
                                                .width / 1.5,
                                            child: Center(
                                              child: SingleChildScrollView(
                                                child: GestureDetector(
                                                  child: Text(personModel.content,
                                                    style: TextStyle(
                                                        fontSize: 25),),
                                                  onLongPress: (){
                                                    Clipboard.setData(new ClipboardData(text: personModel.content));

                                                  },
                                                ),),
                                            ),
                                          ),

                                            TextButton(onPressed: () {
                                              showDialog(context: context,
                                                  builder: (builder) {
                                                    textTitle.text=personModel.title;
                                                    textContent.text =
                                                        personModel.content;
                                                    return AlertDialog(
                                                      title: TextFormField(
                                                        style: TextStyle(
                                                            fontSize: 25),
                                                        controller: textTitle,
                                                      ),
                                                      content: TextFormField(
                                                        keyboardType: TextInputType.multiline,
                                                        maxLines: 100,minLines: 1,
                                                        style: TextStyle(
                                                            fontSize: 25),
                                                        controller: textContent,
                                                      ), actions: [
                                                      ElevatedButton(onPressed: () {
                                                        personModel.content =
                                                            textContent.text;
                                                        personModel.title=textTitle.text;
                                                        _personBox?.putAt(
                                                            index, personModel);
                                                        textContent.clear();textTitle.clear();
                                                        Navigator.pop(context);
                                                      }, child: Text("Save")),
                                                    ],
                                                    );
                                                  });
                                            }, child: Text('Modify')),
                                            ElevatedButton(onPressed: () {
                                              _personBox?.deleteAt(index);
                                              Navigator.pop(context);
                                            }, child: Text('Delete'))
                                          ],
                                        ),
                                      );
                                    });
                                  },
                                );
                              }),
                            ),
                          );
                        },
                      ),
 */
