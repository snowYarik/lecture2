import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ToDoList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TodoListState();
}

class _TodoListState extends State<ToDoList> {
  final List<String> _todoItems = List<String>();
  final TextEditingController _textFieldController = TextEditingController();
  bool _isValid = true;

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
                  Icons.delete,
                ),
                backgroundColor: Colors.red,
                splashColor: Colors.redAccent,
                //TODO refactor
                onPressed: () {
                  if (_todoItems.length > 0) {}
                  setState(() {
                    _todoItems.removeAt(0);
                  });
                }),
          ),
          FloatingActionButton(
              tooltip: 'Add',
              child: Icon(
                Icons.add,
              ),
              backgroundColor: Colors.green,
              splashColor: Colors.greenAccent,
              onPressed: () => _addTodoItem(context)),
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
              leading: _buildTodoItemNumber(index + 1),
              title: _buildTodoItemTitle(_todoItems[index]),
              trailing: _buildTodoItemDeleteButton(index),
            ),
          );
        });
  }

  Widget _buildTodoItemNumber(int itemNumber) {
    return Container(
      alignment: Alignment.centerLeft,
      width: 30.0,
      height: 30.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black,
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

  Widget _buildTodoItemTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.black,
        fontFamily: 'GoogleSans',
        fontSize: 15.0,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildTodoItemDeleteButton(int itemIndex) {
    return IconButton(
      color: Colors.red,
      icon: Icon(Icons.delete),
      onPressed: () => _onDeleteItem(itemIndex),
    );
  }

  void _onDeleteItem(int itemIndex) {
    setState(() {
      _todoItems.removeAt(itemIndex);
    });
  }

  void _addTodoItem(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Write new action todo'),
            content: TextField(
              controller: _textFieldController,
              decoration: InputDecoration(
                  hintText: 'Todo action',
                  errorText: _isValid ? null : "Field can't be empty"),
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
                  if (_textFieldController.text.isNotEmpty) {
                    print("valid");
                    setState(() {
                      _isValid = true;
                      _todoItems.add(_textFieldController.text);
                      _textFieldController.clear();
                    });
                    Navigator.of(context).pop();
                  } else {
                    print("invalid");
                    setState(() {
                      _isValid = false;
                    });
                  }
                },
              )
            ],
          );
        });
  }
}
