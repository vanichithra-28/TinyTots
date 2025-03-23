import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChildActivity extends StatefulWidget {
  const ChildActivity({super.key});

  @override
  State<ChildActivity> createState() => _ChildActivityState();
}

class _ChildActivityState extends State<ChildActivity> {
  final supabase = Supabase.instance.client;
  List<dynamic> children = [];

  Future<void> display() async {
    try {
      final response = await supabase.from('tbl_child').select();
      setState(() {
        children = response;
      });
    } catch (e) {
      print('ERROR DISPLAYING CHILDREN: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    display();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Child Activity'),
      ),
      backgroundColor: const Color(0xfff8f9fa),
      body: Container(
        height: 750,
        width: 500,
        color: Colors.white,
        child: ListView.builder(
          itemCount: children.length,
          itemBuilder: (context, index) {
            final child = children[index];
            return Card(
              color: Color(0xfff8f9fa),
              child:  Text(child['name'] ?? 'No Name'),
            );
          },
        ),
      ),
    );
  }
}
