import 'package:flutter/material.dart';

class Parent_child extends StatefulWidget {
  const Parent_child({super.key});

  @override
  State<Parent_child> createState() => _Parent_childState();
}

class _Parent_childState extends State<Parent_child> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('parent'),
    );
  }
}