import 'package:flutter/material.dart';
import 'package:tinytots_admin/main.dart';

class FeedbackReply extends StatefulWidget {
  const FeedbackReply({super.key});

  @override
  State<FeedbackReply> createState() => _FeedbackReplyState();
}

class _FeedbackReplyState extends State<FeedbackReply> {
  final Map<int, TextEditingController> _replyControllers = {};
  List<Map<String, dynamic>> feedbackContent = [];
  final Set<int> _repliedFeedbacks = {};

  Future<void> submitReply(int feedbackId, int index) async {
    final replyText = _replyControllers[index]?.text ?? '';
    if (replyText.trim().isEmpty) return;
    try {
      await supabase.from('tbl_feedback').update({
        'reply': replyText,
        'status': 1,
      }).eq('id', feedbackId);
      setState(() {
        _repliedFeedbacks.add(feedbackId);
        _replyControllers[index]?.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Reply sent!')),
      );
      fetchFeedback(); // Refresh feedback list
    } catch (e) {
      print("Error submitting reply: $e");
    }
  }

  void fetchFeedback() async {
    try {
      // Join tbl_feedback with tbl_parent to get parent name
      final response = await supabase
          .from('tbl_feedback')
          .select('*, tbl_parent(parent_name)')
          .order('id', ascending: false);

      setState(() {
        feedbackContent = response;
        _replyControllers.clear();
        for (int i = 0; i < feedbackContent.length; i++) {
          _replyControllers[i] = TextEditingController();
        }
      });
    } catch (e) {
      print("Error fetching feedback: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchFeedback();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Color(0xfff4f6fa),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.12),
                  spreadRadius: 4,
                  blurRadius: 12,
                  offset: Offset(0, 4),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Feedback Reply",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xff3e53a0)),
                ),
                SizedBox(height: 20),
                Text(
                  "Feedbacks from users:",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                SizedBox(height: 8),
                feedbackContent.isEmpty
                    ? Text("No feedbacks yet.")
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: feedbackContent.length,
                        itemBuilder: (context, index) {
                          final feedback = feedbackContent[index];
                          final feedbackId = feedback['id'] as int;
                          final canReply = (feedback['status'] ?? 0) == 0;
                          final alreadyReplied = (feedback['status'] ?? 0) == 1 || _repliedFeedbacks.contains(feedbackId);
                          bool isEditing = feedback['isEditing'] == true;

                          return Container(
                            margin: EdgeInsets.only(bottom: 18),
                            padding: EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // User Name
                                Text(
                                  "From: ${feedback['tbl_parent']?['parent_name'] ?? 'Unknown'}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: Color(0xff3e53a0),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  feedback['title'] ?? 'No Title',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Color(0xff3e53a0),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  feedback['details'] ?? 'No Details',
                                  style: TextStyle(fontSize: 15),
                                ),
                                SizedBox(height: 12),
                                if (canReply && !alreadyReplied) ...[
                                  Text(
                                    "Your Reply:",
                                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                                  ),
                                  SizedBox(height: 6),
                                  TextField(
                                    controller: _replyControllers[index],
                                    maxLines: 2,
                                    enabled: true,
                                    decoration: InputDecoration(
                                      hintText: "Type your reply here...",
                                      filled: true,
                                      fillColor: Color(0xffeceef0),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xff3e53a0),
                                          foregroundColor: Color(0xffeceef0),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 18),
                                        ),
                                        onPressed: () => submitReply(feedbackId, index),
                                        icon: Icon(Icons.reply, color: Color(0xffffffff)),
                                        label: Text("Send Reply"),
                                      ),
                                    ],
                                  ),
                                ] else ...[
                                  Text(
                                    "Admin Reply:",
                                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                                  ),
                                  SizedBox(height: 6),
                                  if (isEditing) ...[
                                    TextField(
                                      controller: _replyControllers[index]?..text = feedback['reply'] ?? '',
                                      maxLines: 2,
                                      decoration: InputDecoration(
                                        hintText: "Edit your reply...",
                                        filled: true,
                                        fillColor: Color(0xffeceef0),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color(0xff3e53a0),
                                            foregroundColor: Color(0xffeceef0),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 18),
                                          ),
                                          onPressed: () async {
                                            final newReply = _replyControllers[index]?.text;
                                            if (newReply!.trim().isEmpty) return;
                                            try {
                                              await supabase.from('tbl_feedback').update({
                                                'reply': newReply,
                                              }).eq('id', feedbackId);
                                              setState(() {
                                                feedback['reply'] = newReply;
                                                feedback['isEditing'] = false;
                                              });
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text('Reply updated!')),
                                              );
                                            } catch (e) {
                                              print("Error updating reply: $e");
                                            }
                                          },
                                          icon: Icon(Icons.save, color: Color(0xffffffff)),
                                          label: Text("Save"),
                                        ),
                                        SizedBox(width: 10),
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              feedback['isEditing'] = false;
                                            });
                                          },
                                          child: Text("Cancel"),
                                        ),
                                      ],
                                    ),
                                  ] else ...[
                                    Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Color(0xffeceef0),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        feedback['reply'] ?? 'No reply yet.',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        if (alreadyReplied)
                                          Padding(
                                            padding: const EdgeInsets.only(top: 8.0, right: 10),
                                            child: Text(
                                              "Replied",
                                              style: TextStyle(
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        if (alreadyReplied)
                                          TextButton.icon(
                                            onPressed: () {
                                              setState(() {
                                                feedback['isEditing'] = true;
                                              });
                                            },
                                            icon: Icon(Icons.edit, size: 18, color: Color(0xff3e53a0)),
                                            label: Text(
                                              "Edit Reply",
                                              style: TextStyle(color: Color(0xff3e53a0)),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ],
                              ],
                            ),
                          );
                        },
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}