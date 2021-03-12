import 'package:flutter/material.dart';

class NewTransaction extends StatelessWidget {
  final titleController = TextEditingController();
  final amountController = TextEditingController();

  final Function onPressAction;

  NewTransaction(this.onPressAction);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Title'),
              controller: titleController,
              // onChanged: (value) => titleInput = value,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Amount'),
              controller: amountController,
            ),
            TextButton(
              onPressed: () {
                onPressAction(
                  titleController.text,
                  double.parse(amountController.text),
                );
              },
              style: TextButton.styleFrom(primary: Colors.purple),
              child: Text('Add Transaction'),
            )
          ],
        ),
      ),
      elevation: 5,
    );
  }
}
