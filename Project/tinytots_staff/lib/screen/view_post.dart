import 'package:flutter/material.dart';
import 'package:tinytots_staff/main.dart';
import 'package:intl/intl.dart';

class ViewPost extends StatefulWidget {
  const ViewPost({super.key});

  @override
  State<ViewPost> createState() => _ViewPostState();
}

class _ViewPostState extends State<ViewPost> {
  List<Map<String,dynamic>>_postList =[];
  Future<void> display() async {
    try {
    final response = await supabase.from('tbl_post').select().order('created_at', ascending: false);;
      setState(() {
        _postList = response;
      });
    } catch (e) {
      print('ERROR DISPLAYING POST $e');
    }
  }
   String formatDate(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp);
    return DateFormat('yyyy-MM-dd').format(dateTime); // Format as needed
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    display();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffffffff),
        title: Text('Posts'),
      ),
       backgroundColor: Color(0xfff8f9fa),
      body: ListView.builder(
        itemCount:_postList.length ,
        itemBuilder: (context, index){
          final post = _postList[index];
          return Card(color: Color(0xffffffff),
          
          child: Column(
            children: [
              GestureDetector(
                child: Container(
                  height: 250,
                  
                  decoration: BoxDecoration(
                    image: DecorationImage(image: NetworkImage(post['post_file']),fit: BoxFit.cover)
                  ),
                ),
              ),
              SizedBox(height: 15,),
              Row(
                children: [
                  Expanded(child: Text(post['post_title'])),
                   Expanded(child: Text(formatDate(post['created_at']))),
                ],
              ),
              
              
            ],
          ),);

      }),
    );
  }
}