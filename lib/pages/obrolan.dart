import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_detection_hospital/obrolan_service.dart';
import 'package:covid_detection_hospital/pages/obrolan_room.dart';
import 'package:covid_detection_hospital/report_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Obrolan extends StatefulWidget {
  final User? user;
  const Obrolan({super.key, required this.user});

  @override
  State<Obrolan> createState() => _ObrolanState();
}

class _ObrolanState extends State<Obrolan> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<QuerySnapshot>(
            stream: ObrolanService().getChatRoomList(widget.user!.uid),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }
              if (!snapshot.hasData) return const CircularProgressIndicator();
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot room = snapshot.data!.docs[index];
                  List<String> participants =
                      List<String>.from(room['participants']);
                  participants.remove(widget.user!.uid);
                  return StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(participants.first)
                        .snapshots(),
                    builder: (context, userSnapshot) {
                      if (!userSnapshot.hasData) return const SizedBox.shrink();
                      var userData =
                          userSnapshot.data!.data() as Map<String, dynamic>;
                      String formattedDate = DateFormat('dd/MM/yy')
                          .format(room['lastUpdates'].toDate());
                      return ListTile(
                        leading: const Icon(Icons.person),
                        title: Row(
                          children: [
                            Text('${userData['name'] ?? 'Unknown User'}'),
                            FutureBuilder(
                                future: ReportService().getStatus(
                                    participants.first, widget.user!.uid),
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
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
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
                        subtitle:
                            Text(room['lastMessage'] ?? 'No messages yet'),
                        trailing: Text(formattedDate),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ObrolanRoom(
                                roomId: room.id,
                                roomName: userData['name'],
                                participantId: participants.first),
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            }));
  }
}
