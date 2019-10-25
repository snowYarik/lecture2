import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ToDoList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TodoListState();
}

class _TodoListState extends State<ToDoList> {
  final List<String> _todoItems = List<String>();
  final TextEditingController _textFieldController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ToDo List"),
      ),
      body: _buildToDoList(),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10.0),
            child: FloatingActionButton(
              tooltip: 'Delete',
              child: Icon(
                Icons.remove,
              ),
              backgroundColor: Colors.red,
              splashColor: Colors.redAccent,
              onPressed: () {
                if (_todoItems.isNotEmpty) {
                  setState(() {
                    _todoItems.removeAt(0);
                  });
                }
              },
            ),
          ),
          FloatingActionButton(
              tooltip: 'Add',
              child: Icon(
                Icons.add,
              ),
              backgroundColor: Colors.green,
              splashColor: Colors.greenAccent,
              onPressed: () => _addToDoItem(context)),
        ],
      ),
    );
  }

  Widget _buildToDoList() {
    return ListView.builder(
        padding: EdgeInsets.all(10.0),
        shrinkWrap: true,
        itemCount: _todoItems.length,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: Key("${_todoItems[index]}$index"),
            background: Container(
              color: Colors.grey,
            ),
            onDismissed: (direction) {
              setState(() {
                _todoItems.removeAt(index);
              });
            },
            child: ListTile(
              leading: _buildToDoItemNumber(index + 1),
              title: _buildToDoItemTitle(_todoItems[index]),
              trailing: _buildToDoItemDeleteButton(index),
            ),
          );
        });
  }

  Widget _buildToDoItemNumber(int itemNumber) {
    return Container(
      alignment: Alignment.centerLeft,
      width: 24.0,
      height: 24.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey,
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          itemNumber.toString(),
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'GoogleSans',
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildToDoItemTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.black,
        fontFamily: 'GoogleSans',
        fontSize: 18.0,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildToDoItemDeleteButton(int itemIndex) {
    return IconButton(
      color: Colors.red,
      icon: Icon(
        Icons.remove_circle,
        color: Colors.red,
      ),
      onPressed: () => _onDeleteItem(itemIndex),
    );
  }

  void _onDeleteItem(int itemIndex) {
    setState(() {
      _todoItems.removeAt(itemIndex);
    });
  }

  void _addToDoItem(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Write new action todo'),
          content: Form(
            key: _formKey,
            child: TextFormField(
              decoration: InputDecoration(
                hintText: "Write todo action",
              ),
              controller: _textFieldController,
              validator: (value) {
                if (value.isEmpty) {
                  return "Field mustn't be null";
                } else {
                  return null;
                }
              },
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Add'),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  setState(() {
                    _todoItems.add(_textFieldController.text);
                    _textFieldController.clear();
                  });
                  Navigator.of(context).pop();
                }
              },
            )
          ],
        );
      },
    );
  }
}
