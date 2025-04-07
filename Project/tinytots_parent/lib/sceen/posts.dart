import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tinytots_parent/main.dart';

class Posts extends StatefulWidget {
  const Posts({super.key, });

  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  List<Map<String, dynamic>> posts = [];
  bool isLoading = true;
  String? errorMessage;
  final TextEditingController _commentController = TextEditingController();
  Map<int, bool> loadingComments = {};
  Map<int, List<Map<String, dynamic>>> postComments = {};
  Map<int, bool> isSubmittingComment = {};

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> fetchPosts() async {
  setState(() {
    isLoading = true;
    errorMessage = null;
  });

  try {
    final List<dynamic>? response = await supabase
        .from('tbl_post')
        .select()
        .order('created_at', ascending: false);
    print(response);
    if (response == null) {
      throw Exception('No data received from API');
    }

    final currentUserId = supabase.auth.currentUser?.id;
    if (currentUserId == null) {
      throw Exception('User not authenticated');
    }

    List<Map<String, dynamic>> postsWithLikes = [];
    for (var post in response) {
      if (post == null || post['id'] == null) continue;

      final likesResponse = await supabase
          .from('tbl_like')
          .select('parent_id')
          .eq('post_id', post['id']);
      print("Liked: $likesResponse");
      bool isLiked =
          likesResponse.any((like) => like['parent_id'] == currentUserId) ?? false;

      post['like_count'] = likesResponse?.length ?? 0;
      post['is_liked_by_user'] = isLiked;

      postsWithLikes.add(Map<String, dynamic>.from(post));
    }

    print(postsWithLikes);

    setState(() {
      posts = postsWithLikes;
      isLoading = false;
    });
  } catch (e) {
    setState(() {
      isLoading = false;
      errorMessage = 'Error loading posts. Please try again.';
    });
    print('Error fetching posts: $e');
  }
}


 Future<void> toggleLike(int postId, bool isLiked) async {
  try {
    final currentUserId = supabase.auth.currentUser?.id;
    if (currentUserId == null) {
      throw Exception('User not authenticated');
    }

    // Check if the post exists
    final postExists = await supabase
        .from('tbl_post')
        .select('id')
        .eq('id', postId)
        .maybeSingle();
    
    if (postExists == null) {
      throw Exception('Post does not exist');
    }

    // Check if the user exists in tbl_staff
    final staffExists = await supabase
        .from('tbl_parent')
        .select('id')
        .eq('id', currentUserId)
        .maybeSingle();

    if (staffExists == null) {
      throw Exception('Staff does not exist');
    }

    // Optimistic UI update
    setState(() {
      for (var post in posts) {
        if (post['id'] == postId) {
          post['is_liked_by_user'] = !isLiked;
          post['like_count'] = isLiked ? (post['like_count'] - 1) : (post['like_count'] + 1);
        }
      }
    });

    if (isLiked) {
      await supabase.from('tbl_like').delete().match({
        'post_id': postId,
        'parent_id': currentUserId  // or 'parent_id' depending on your schema
      });
    } else {
      await supabase.from('tbl_like').insert({
        'post_id': postId,
        'parent_id': currentUserId  // or 'parent_id' depending on your schema
      });
    }

    // Wait a bit before refreshing data to avoid race conditions
    await Future.delayed(Duration(milliseconds: 300));
    await fetchPosts();

  } catch (e) {
    print('Error toggling like: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to update like. Please try again.')),
    );

    // Revert optimistic update if request fails
    await fetchPosts();
  }
}


  String getTimeAgo(String dateTime) {
    final date = DateTime.parse(dateTime);
    return timeago.format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      
      child: isLoading
          ? Center(child: CircularProgressIndicator(color: Color(0xFFbc6c25)))
          : errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 48, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(errorMessage!,
                          style: TextStyle(color: Colors.grey[700])),
                      SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: fetchPosts,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFbc6c25),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text("Try Again"),
                      ),
                    ],
                  ),
                )
              : posts.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.forum_outlined,
                              size: 64, color: Colors.grey[400]),
                          SizedBox(height: 16),
                          Text(
                            "No posts yet",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8),
                          
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: fetchPosts,
                      color: Color(0xFFbc6c25),
                      child: ListView.builder(
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          final post = posts[index];
                          final isLiked = post['is_liked_by_user'] ?? false;
                          final likeCount = post['like_count'] ?? 0;
                          final postId = post['id'];

                          return Card(
                            margin: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                  color: Colors.grey[200]!, width: 1),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // User info and timestamp
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    getTimeAgo(post['created_at']),
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                ),

                                // Post content
                                if (post['post_title'] != null &&
                                    post['post_title'].trim().isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 8.0),
                                    child: Text(
                                      post['post_title'],
                                      style: TextStyle(
                                        fontSize: 16,
                                        height: 1.4,
                                      ),
                                    ),
                                  ),

                                // Post image if exists
                                if (post['post_file'] != null)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: CachedNetworkImage(
                                      imageUrl: post['post_file'],
                                      placeholder: (context, url) => Container(
                                        height: 200,
                                        color: Colors.grey[300],
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: Color(0xFFbc6c25),
                                            strokeWidth: 2,
                                          ),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Container(
                                        height: 200,
                                        color: Colors.grey[300],
                                        child: Center(
                                          child: Icon(Icons.error,
                                              color: Colors.grey[500]),
                                        ),
                                      ),
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                                  ),

                                // Like and comment counts
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  child: Row(
                                    children: [
                                      if (likeCount > 0)
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.favorite,
                                              size: 16,
                                              color: Colors.pink[400],
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              '$likeCount',
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),

                                // Divider
                                Divider(
                                    height: 1,
                                    thickness: 1,
                                    color: Colors.grey[200]),

                                // Like and Comment buttons
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Expanded(
                                    child: TextButton.icon(
                                      icon: Icon(
                                        isLiked
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: isLiked
                                            ? Colors.pink[400]
                                            : Colors.grey[600],
                                      ),
                                      label: Text(
                                        'Like',
                                        style: TextStyle(
                                          color: isLiked
                                              ? Colors.blue[400]
                                              : Colors.grey[600],
                                        ),
                                      ),
                                      style: TextButton.styleFrom(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 12),
                                      ),
                                      onPressed: () =>
                                          toggleLike(postId, isLiked),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(
      //         context, MaterialPageRoute(builder: (_) => CreatePost()));
      //   },
      //   backgroundColor: Colors.blue[400],
      //   child: Icon(Icons.add, color: Colors.white),
      // ),
    );
  }
}
