import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var talypbox = Hive.box('mybox');
  final TextEditingController namecontrol = TextEditingController();
  final TextEditingController agecontrol = TextEditingController();

  @override
  void dispose() {
    agecontrol.dispose();
    namecontrol.dispose();
    super.dispose();
  }

  void addOrUpdate({String ? key}){
    if(key != null){
      final talyp = talypbox.get(key);
      if(talyp !=null){
        namecontrol.text = talyp['name']??"";
        agecontrol.text = talyp['age']?.toString() ?? '';
        }
      }else{
        namecontrol.clear();
        agecontrol.clear();
    }
    showModalBottomSheet(context: context,
    isScrollControlled: true,
     builder: (context){
      return Padding(
        padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 15,
        right: 15,
        top: 15, 
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: namecontrol,
            decoration: InputDecoration(
              labelText: "Adyny giriz" 
            ),
            
          ),
          TextField(
            controller: agecontrol,
            decoration: InputDecoration(
              labelText: "Yasyny giriz" 
            ),
            
          ),
          SizedBox(height: 15,),
          ElevatedButton(onPressed: () {
            final name = namecontrol.text;
            final age = int.tryParse(agecontrol.text);
            if(name.isEmpty || age == null){
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: 
                Text("Adyny we yasyny girizin")
                )
              );
              return;
            }
            if (key == null){
            final newKey = 
            DateTime.now();
            talypbox.put(newKey, {"name":name,"age":age});
            }else{
              talypbox.put(key, {"name":name,"age":age});
            }
            Navigator.pop(context);
          },
           child: Text(
            key == null ? "Add" : "Update",
           )
           ),
           SizedBox(height: 30,)
        ],
      ),
      );
     });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 70, 132, 175),
      appBar: AppBar(
        title: const Text('Flutter Hive database'),
        backgroundColor: const Color.fromARGB(255, 47, 134, 206),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 47, 102, 219),
        foregroundColor: Colors.white,
        onPressed: (){},
        child: const Icon(Icons.add),
        ),
        body: ValueListenableBuilder(valueListenable: talypbox.listenable(),
         builder: (context, box,widget){
          if(box.isEmpty){
            return Center(
              child: Text('Hic zat intak gosulmandyr'),
            );
          }
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index){
              final key = box.keyAt(index).toString();
              final items = box.get(key);
              return Padding(
                padding: EdgeInsets.all(10),
                child: ListTile(
                  title: Text(items?["name"] ?? "Unknow"),
                ), 
                );
            }
          );
         }),
    );
  }
}