import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_detection_hospital/report_service.dart';
import 'package:covid_detection_hospital/widgets/change_status.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ObrolanRoom extends StatefulWidget {
  final String roomId;
  final String roomName;
  final String participantId;

  ObrolanRoom(
      {required this.roomId,
      required this.roomName,
      required this.participantId});

  @override
  State<ObrolanRoom> createState() => _ObrolanRoomState();
}

class _ObrolanRoomState extends State<ObrolanRoom> {
  final TextEditingController _messageController = TextEditingController();
  String _status = "";
  String _reportId = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(widget.roomId)
        .update({
      'isHospitalRead': true,
    });
  }

  final user = FirebaseAuth.instance.currentUser!;

  void _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('chatRooms')
          .doc(widget.roomId)
          .update({
        'lastMessage': _messageController.text,
        'lastUpdate': FieldValue.serverTimestamp(),
        'lastParticipant': user.uid,
      });
      await FirebaseFirestore.instance
          .collection('chatRooms')
          .doc(widget.roomId)
          .collection('messages')
          .add({
        'text': _messageController.text,
        'type': "text",
        'sender': user.uid,
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': false
      });
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        title: Row(
          children: [
            Text(
              widget.roomName,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15,
                color: Colors.white,
              ),
            ),
            FutureBuilder(
                future:
                    ReportService().getStatus(widget.participantId, user.uid),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  _status = snapshot.data['status'];
                  _reportId = snapshot.data['id'];
                  return Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: _status == 'Sudah ditangani'
                            ? Colors.lightGreen[200]
                            : Colors.red[200],
                        boxShadow: [
                          BoxShadow(
                              color: _status == 'Sudah ditangani'
                                  ? Colors.lightGreen
                                  : Colors.redAccent,
                              spreadRadius: 1),
                        ],
                      ),
                      child: Text(
                        _status,
                        style: TextStyle(
                            color: _status == 'Sudah ditangani'
                                ? Colors.green[900]
                                : Colors.red[900],
                            fontSize: 10.0),
                      ),
                    ),
                  );
                }),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: PopupMenuButton<String>(
              onSelected: (value) {
                // Gunakan Future.microtask untuk menangani kode asinkron
                Future.microtask(() async {
                  if (value == 'accept') {
                    // Aksi untuk Profile
                  }
                });
              },
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem<String>(
                    value: 'accept',
                    child: const Row(
                      children: [
                        SizedBox(width: 8),
                        Text('Terima Penanganan'),
                      ],
                    ),
                    onTap: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext dialogcontext) => ChangeStatus(
                            userId: widget.participantId,
                            initStatus: _status,
                            testId: _reportId,
                            callback: (val) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Berhasil ubah status'),
                                  duration: Duration(
                                      seconds:
                                          3), // Duration the Snackbar will be visible
                                  backgroundColor: Colors.lightGreen,
                                ),
                              );
                              setState(() {});
                            })),
                  ),
                ];
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chatRooms')
                  .doc(widget.roomId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                final screenHeight = MediaQuery.of(context).size.height;
                final screenWidth = MediaQuery.of(context).size.width;
                if (!snapshot.hasData) return const CircularProgressIndicator();
                return Padding(
                  padding: EdgeInsets.only(top: 5, bottom: screenHeight * 0.08),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          reverse: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot message =
                                snapshot.data!.docs[index];
                            DateTime timestamp =
                                (message['timestamp']! as Timestamp).toDate();
                            String formattedDate =
                                DateFormat('d MMMM yyyy').format(timestamp);
                            String formattedTime =
                                '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
                            return Row(
                              mainAxisAlignment: message['sender'] != user.uid
                                  ? MainAxisAlignment.start
                                  : MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                    vertical: 3,
                                  ),
                                  child: Container(
                                    constraints: BoxConstraints(
                                      maxWidth: screenWidth * 0.8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: message['type'] == 'text'
                                          ? Colors.teal
                                          : Colors.blue[700],
                                      borderRadius: BorderRadius.circular(13),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: message['type'] == 'text'
                                          ? Text(
                                              message['text'],
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                              ),
                                            )
                                          : Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 3),
                                                  child: Text(
                                                    'Dim: ${double.parse(message['dimension']!).toStringAsFixed(2)}  Size: ${double.parse(message['size']!).toStringAsFixed(2)}  Dispersi: ${double.parse(message['dispersi']!).toStringAsFixed(2)}',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      formattedTime,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.white,
                                                        fontStyle:
                                                            FontStyle.italic,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 7),
                                                    Text(
                                                      formattedDate,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.white,
                                                        fontStyle:
                                                            FontStyle.italic,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(labelText: 'Message'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
