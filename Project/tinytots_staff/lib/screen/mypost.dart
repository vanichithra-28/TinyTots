import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:tinytots_staff/main.dart';

class Mypost extends StatefulWidget {
  const Mypost({super.key});

  @override
  State<Mypost> createState() => _MypostState();
}

class _MypostState extends State<Mypost> {
  List<Map<String, dynamic>> _postList = [];
  bool _isLoading = true;

  Future<void> delete(int delId) async {
    try {
      await supabase.from('tbl_post').delete().eq('id', delId);
      await display(); // Refresh list after deletion
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Post deleted',
            style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.black54,
        ),
      );
    } catch (e) {
      print('ERROR DELETING POST $e');
    }
  }

  Future<void> display() async {
    try {
      
      final response = await supabase
          .from('tbl_post')
          .select()
          .order('created_at', ascending: false);
      
      setState(() {
        _postList = response;
        _isLoading = false;
      });
    } catch (e) {
      print('ERROR DISPLAYING POST $e');
      setState(() => _isLoading = false);
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
      return 'on ${DateFormat('MMMM d, yyyy').format(postTime)}';
    }
  }

  @override
  void initState() {
    super.initState();
    display();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _postList.isEmpty
              ? const Center(child: Text('No posts available'))
              : ListView.builder(
                  itemCount: _postList.length,
                  itemBuilder: (context, index) {
                    final post = _postList[index];
                    return Container(
                      color: const Color(0xffffffff),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                height: 620,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white, width: 2.5),
                                  image: DecorationImage(
                                    image: NetworkImage(post['post_file']),
                                    fit: BoxFit.cover,
                                    
                                  ),
                                ),
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
                                    if (result == 'delete') {
                                      delete(post['id']);
                                    }
                                  },
                                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                    const PopupMenuItem<String>(
                                      value: 'delete',
                                      child: Text('Delete'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Text(post['post_title']),
                          Text(formatTimeAgo(post['created_at'])),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}