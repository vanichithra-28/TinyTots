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
    await supabase.from('tbl_like').delete().eq('post_id', delId);

    await supabase.from('tbl_post').delete().eq('id', delId);

    await display();

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
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays == 1) {
      return '1d';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return DateFormat('MMM d').format(postTime);
    }
  }

  void _showPostDialog(BuildContext context, Map<String, dynamic> post) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(10),
          child: Stack(
            children: [
              InteractiveViewer(
                boundaryMargin: const EdgeInsets.all(20),
                minScale: 0.1,
                maxScale: 4.0,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(post['post_file']),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post['post_title'],
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        formatTimeAgo(post['created_at']),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        );
      },
    );
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
              : GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 2.0,
                    mainAxisSpacing: 2.0,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: _postList.length,
                  itemBuilder: (context, index) {
                    final post = _postList[index];
                    return Stack(
                      children: [
                        GestureDetector(
                          onTap: () => _showPostDialog(context, post),
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(post['post_file']),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 5,
                          right: 5,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black.withOpacity(0.3),
                            ),
                            child: PopupMenuButton<String>(
                              icon: HugeIcon(
                                icon: HugeIcons.strokeRoundedMoreVertical,
                                color: Colors.white,
                                size: 24.0,
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
                        ),
                      ],
                    );
                  },
                ),
    );
  }
}