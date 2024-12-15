import 'package:covid_detection_hospital/report_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

typedef void StringCallback(String val);

class ChangeStatus extends StatefulWidget {
  final String userId;
  final String initStatus;
  final String testId;
  ChangeStatus(
      {super.key,
      required this.userId,
      required this.initStatus,
      required this.testId,
      required this.callback});
  final user = FirebaseAuth.instance.currentUser!;
  final StringCallback callback;

  @override
  State<ChangeStatus> createState() => _ChangeStatusState();
}

class _ChangeStatusState extends State<ChangeStatus> {
  String? reportStatus;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    reportStatus = widget.initStatus;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ubah Status Pasien'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: const Text('Menunggu persetujuan'),
            leading: Radio(
              value: 'a',
              groupValue: reportStatus,
              onChanged: (value) {
                setState(() {
                  reportStatus = value;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Bantuan diterima'),
            leading: Radio(
              value: 'b',
              groupValue: reportStatus,
              onChanged: (value) {
                setState(() {
                  reportStatus = value;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Selesai'),
            leading: Radio(
              value: 'c',
              groupValue: reportStatus,
              onChanged: (value) {
                setState(() {
                  reportStatus = value;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Tolak'),
            leading: Radio(
              value: 'c',
              groupValue: reportStatus,
              onChanged: (value) {
                setState(() {
                  reportStatus = value;
                });
              },
            ),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context, 'Cancel');
            widget.callback('cancel');
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            ReportService().updateStatus(widget.testId, reportStatus);
            widget.callback('status changed');
            Navigator.pop(context, 'status changed');
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
