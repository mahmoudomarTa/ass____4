import 'package:ass_4/DataAccess.dart';
import 'package:ass_4/TodoItem.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyProvider extends ChangeNotifier {
  List<TodoItem> _todoItems = List();
  DataAccess _dataAccess;

  get context => null;

  allTasks(bool isComplete) {
    if (isComplete == true) {
      DataAccess().open().then((result) {
        DataAccess().getTodoItems().then((r) {
          r.forEach((element) {
            if (element.isComplete) {
              _todoItems.add(element as TodoItem);
              notifyListeners();
            }
            ;
          });
        });
      });


      Future<Null> _displayDeleteConfirmationDialog(TodoItem item) {
        return showDialog<Null>(
            context: context,
            barrierDismissible: true,
            // Allow dismiss when tapping away from dialog
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Delete TODO"),
                content: Text("Do you want to delete \"${item.name}\"?"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Cancel"),
                    onPressed: Navigator.of(context).pop, // Close dialog
                  ),
                  FlatButton(
                    child: Text("Delete"),
                    onPressed: () {
                     // _deleteTodoItem(item);
                      Navigator.of(context).pop(); // Close dialog
                    },
                  ),
                ],
              );
            });
      }

      Widget _createTodoItemWidget(TodoItem item) {
        return ListTile(
          title: Text(item.name),
          trailing: Checkbox(
            value: item.isComplete,
           // onChanged: (value) => _updateTodoCompleteStatus(item, value),
          ),
          onLongPress: () => _displayDeleteConfirmationDialog(item),
        );
      }

      _todoItems.map(_createTodoItemWidget).toList();
      notifyListeners();
      return _todoItems;
    } else {}
  }
}
