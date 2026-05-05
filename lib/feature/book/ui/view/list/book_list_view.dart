import 'package:flutter/material.dart';

class BookListView extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    
   return Scaffold(
      appBar: AppBar(
        title: Text('书籍'),
      ),
      body: Center(
        child: Text('Book List View'),
      ),
    );
  }

}