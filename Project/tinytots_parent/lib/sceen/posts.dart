import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:tinytots_parent/main.dart';
import 'package:intl/intl.dart';


class Posts extends StatefulWidget {
  const Posts({super.key});

  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> {
   List<Map<String, dynamic>> _postList = [];
  

  Future<void> display() async {
    try {
      final response = await supabase
          .from('tbl_post')
          .select()
          .order('created_at', ascending: false);
      ;
      setState(() {
        _postList = response;
      });
    } catch (e) {
      print('ERROR DISPLAYING POST $e');
    }
  }
   String formatTimeAgo(String timestamp) {
  DateTime postTime = DateTime.parse(timestamp);
  Duration difference = DateTime.now().difference(postTime);

  if (difference.inMinutes < 1) {
    return 'Just now';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes} minutes ago';
  } else if (difference.inHours < 24) {
    return '${difference.inHours} hours ago';
  } else if (difference.inDays == 1) {
    return '1 day ago at ${DateFormat('HH:mm').format(postTime)}';
  } else if (difference.inDays < 7) {
    return '${difference.inDays} days ago';
  } else {
    return ' ${DateFormat('MMMM d, yyyy').format(postTime)}';
  }
}


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    display();
  }
  @override
  Widget build(BuildContext context) {
    return  ListView.builder(
          itemCount: _postList.length,
          itemBuilder: (context, index) {
            final post = _postList[index];
            return Container(
              color: Color(0xffffffff),
              child: Column(
                children: [
                  Stack(children: [
                    Container(
                      height: 620,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 2.5),
                          image: DecorationImage(
                              image: NetworkImage(post['post_file']),
                              fit: BoxFit.cover)),
                    ),
                    Positioned(
                      top: 5,
                      right: 5,
                      child: PopupMenuButton<String>(
                        icon: HugeIcon(
  icon: HugeIcons.strokeRoundedMoreVertical,
  color: Colors.white,
  size: 35.0,
),
                        onSelected: (String result) {
                         
                        },
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(
                            value: '',
                            child: Text('...'),
                          ),
                          // Add more menu items here if needed
                        ],
                      ),
                    ),
                  ]),
                  SizedBox(
                    height: 15,
                  ),
                  Text(post['post_title']),
                  Text(formatTimeAgo(post['created_at'])),
                ],
              ),
            );
          });
  }
}