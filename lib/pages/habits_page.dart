import 'package:flutter/material.dart';
import "/widgets/custom_card.dart"; // Make sure this path is correct

import 'package:flutter/material.dart';

class HabitsPage extends StatefulWidget {
  const HabitsPage({super.key});

  @override
  State<HabitsPage> createState() => _HabitsPageState();
}

class _HabitsPageState extends State<HabitsPage> {
  // 1. Move the Tasks list inside the State class
  final List<StatCard> _tasks = []; // It's good practice to make it private

  // It's also better to create new controllers inside the state
  final TextEditingController _taskLabelController = TextEditingController();
  final TextEditingController _taskValueController = TextEditingController();

  @override
  void dispose() {
    // 4. Dispose of the controllers when the widget is removed
    _taskLabelController.dispose();
    _taskValueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tasks.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.track_changes_outlined,
                    size: 80,
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.5),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Habits Page',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Habits-Tracking management coming soon!',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: ListView.builder(
                // Use the length of the state's task list
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  // Access the task from the state's list
                  var singleTask = _tasks[index];
                  return singleTask;
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // <<< NO CHANGES OUTSIDE THE showDialog CALL

          showDialog(
            context: context,
            builder: (context) {
              // Get the screen width to make the dialog responsive
              final screenWidth = MediaQuery.of(context).size.width;

              return AlertDialog(
                // Use insetPadding to give some space from the screen edges
                insetPadding: const EdgeInsets.symmetric(horizontal: 20),
                title: const Text("Add Habit" , 
                style : TextStyle(
                  fontSize: 30 , 
                  fontWeight: FontWeight.bold ,
                  
                )
                ),

                // <<< HERE IS THE FIX
                // Wrap your Column in a SizedBox to control the width
                content: SizedBox(
                  // Set the width to be 90% of the screen width
                  width: screenWidth * 0.9,
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // This is important!
                    children: [
                      TextField(
                        controller: _taskValueController,
                        decoration:
                            const InputDecoration(hintText: "Habit Name..." , hintStyle: TextStyle(fontSize: 20 , color: Color.fromARGB(195, 0, 0, 0))),
                        style : TextStyle(fontSize: 20) , 
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _taskLabelController,
                        decoration:
                            const InputDecoration(hintText: "Description..." ,  hintStyle: TextStyle(fontSize: 20, color : Color.fromARGB(195, 0, 0, 0))),
                                                  style : TextStyle(fontSize: 20) , 

                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Get the values from the controllers
                      final String taskLabelString = _taskLabelController.text;
                      final String taskValueString = _taskValueController.text;
                      
                      late StatCard newItem;

                      newItem = StatCard(
                        label: taskLabelString,
                        value: taskValueString,
                        icon: Icons.import_contacts,
                        color: Theme.of(context).colorScheme.primary,
                        progress: 0.1,
                        onDelete: () => deleteItem(newItem),
                        onTap: () {
                          // will open it again for edit
                        },
                      );

                      setState(() {
                        _tasks.add(newItem);
                      });

                      _taskLabelController.clear();
                      _taskValueController.clear();
                      Navigator.pop(context);
                    },
                    child: const Text('Save' , style: TextStyle(fontWeight: FontWeight.bold , fontSize: 16),),
                  )
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    
    
    );
  }


  // define the functions : 
  // ON delete : 
  void deleteItem(StatCard item) {
    _tasks.remove(item) ;
    setState(() {
      
    });
  }


}
