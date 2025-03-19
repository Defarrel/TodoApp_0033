import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  DateTime? dateTime;
  List<String> tasks = [];
  List<String> dates = [];
  List<bool> taskStatus = [];
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final key = GlobalKey<FormState>();

  void addTask() {
    setState(() {
      tasks.add(nameController.text);
      dates.add(
        '${dateTime!.day}-${dateTime!.month}-${dateTime!.year} ${dateTime!.hour}:${dateTime!.minute}',
      );
      taskStatus.add(false);
      nameController.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Task added successfully',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 22, 122, 112),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showDatePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder:
          (BuildContext context) => Container(
            height: 300,
            color: Colors.white,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Set Task Date & Time',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Colors.black,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(Icons.close, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 200,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.dateAndTime,
                    initialDateTime: dateTime,
                    onDateTimeChanged: (DateTime newDateTime) {
                      setState(() => dateTime = newDateTime);
                    },
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: Text('Select', style: TextStyle(color: Colors.white)),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: const Text('Form Page'))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Task Date:', style: TextStyle(fontSize: 16)),
                    Text(
                      dateTime != null
                          ? '${dateTime!.day}-${dateTime!.month}-${dateTime!.year} ${dateTime!.hour}:${dateTime!.minute}'
                          : 'Select a date',
                      style: TextStyle(fontSize: 16),
                    ),
                    if (dateTime ==
                        null) 
                      Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: Text(
                          'Please select a date!',
                          style: TextStyle(color: Colors.red, fontSize: 14),
                        ),
                      ),
                  ],
                ),
                IconButton(
                  color: Colors.blue,
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _showDatePicker(context),
                ),
              ],
            ),
            SizedBox(height: 16),
            Form(
              key: key,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your todo';
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        labelText: 'Todo List',
                        hintText: 'Enter your todo list',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (key.currentState != null &&
                          key.currentState!.validate()) {
                        addTask();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 62, 45, 92),
                      padding: EdgeInsets.symmetric(
                        horizontal: 27,
                        vertical: 10,
                      ),
                    ),
                    child: Text(
                      'Submit',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            Text(
              'List Tasks',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 227, 227, 227),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [BoxShadow()],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tasks[index],
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Deadline: ${dates[index]}',
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                              Text(
                                taskStatus[index] ? 'Done' : 'Not Done',
                                style: TextStyle(
                                  color:
                                      taskStatus[index]
                                          ? Colors.green
                                          : Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Checkbox(
                          value: taskStatus[index],
                          onChanged: (bool? newValue) {
                            setState(() {
                              taskStatus[index] = newValue!;
                            });
                          },
                          activeColor: Color.fromARGB(255, 62, 45, 92),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
