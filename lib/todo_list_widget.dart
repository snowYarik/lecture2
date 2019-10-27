import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ToDoList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TodoListState();
}

class _TodoListState extends State<ToDoList> {
  final _todoItems = <String>[];
  final _textFieldController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  //final _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDo List'),
      ),
      body: _buildToDoList(),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 10.0),
            child: FloatingActionButton(
              tooltip: 'Delete',
              child: Icon(
                Icons.remove,
              ),
              backgroundColor: Colors.red,
              splashColor: Colors.redAccent,
              onPressed: () {
                if (_todoItems.isNotEmpty) {
                  setState(() => _todoItems.removeAt(0));
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
              onPressed: () => _onAddToDoItem(context)),
        ],
      ),
    );
  }

  Widget _buildToDoList() {
    return ListView.builder(
        padding: const EdgeInsets.all(10.0),
        shrinkWrap: true,
        itemCount: _todoItems.length,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: Key('${_todoItems[index]}$index'),
            background: Container(
              color: Colors.grey,
            ),
            onDismissed: (direction) {
              setState(() => _todoItems.removeAt(index));
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
      onPressed: () => _onDeleteToDoItem(itemIndex),
    );
  }

  void _onDeleteToDoItem(int itemIndex) {
    setState(() {
      _todoItems.removeAt(itemIndex);
    });
  }

  void _onAddToDoItem(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Write new action todo'),
          content: Form(
            key: _formKey,
            child: TextFormField(
              autofocus: true,
              //focusNode: _focusNode,
              decoration: InputDecoration(
                hintText: 'Write todo action',
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
              child: const Text('Cancel'),
              onPressed: () {
                _textFieldController.clear();
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: const Text('Add'),
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
