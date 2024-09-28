import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_detection_hospital/report_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ObrolanRoom extends StatelessWidget {
  final String roomId;
  final String roomName;
  final String participantId;
  final TextEditingController _messageController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser!;

  ObrolanRoom(
      {required this.roomId,
      required this.roomName,
      required this.participantId});

  void _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('chatRooms')
          .doc(roomId)
          .update({
        'lastMessage': _messageController.text,
        'address': FieldValue.serverTimestamp(),
      });
      await FirebaseFirestore.instance
          .collection('chatRooms')
          .doc(roomId)
          .collection('messages')
          .add({
        'text': _messageController.text,
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
              roomName,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15,
                color: Colors.white,
              ),
            ),
            FutureBuilder(
                future: ReportService().getStatus(participantId, user.uid),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  final status = snapshot.data['status'];
                  return Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: status == 'Sudah ditangani'
                            ? Colors.lightGreen[200]
                            : Colors.red[200],
                        boxShadow: [
                          BoxShadow(
                              color: status == 'Sudah ditangani'
                                  ? Colors.lightGreen
                                  : Colors.redAccent,
                              spreadRadius: 1),
                        ],
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                            color: status == 'Sudah ditangani'
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
                return const [
                  PopupMenuItem<String>(
                    value: 'accept',
                    child: Row(
                      children: [
                        SizedBox(width: 8),
                        Text('Terima Penanganan'),
                      ],
                    ),
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
                  .doc(roomId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                if (!snapshot.hasData) return const CircularProgressIndicator();
                return ListView.builder(
                  reverse: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot message = snapshot.data!.docs[index];
                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(message['sender'])
                          .get(),
                      builder: (context, userSnapshot) {
                        if (!userSnapshot.hasData) {
                          return const SizedBox.shrink();
                        }
                        var userData =
                            userSnapshot.data!.data() as Map<String, dynamic>;
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            textDirection: userSnapshot.data!.id == user.uid
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.person,
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userSnapshot.data!.id == user.uid
                                        ? 'You'
                                        : userData['name'],
                                    style: TextStyle(
                                        fontSize: 10.0,
                                        fontWeight: FontWeight.w200,
                                        color: Colors.grey[700]),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0),
                                    child: Text(
                                      message['text'],
                                      style: const TextStyle(),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    );
                  },
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
