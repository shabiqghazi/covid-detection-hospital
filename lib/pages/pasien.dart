import 'package:covid_detection_hospital/report_service.dart';
import 'package:covid_detection_hospital/widgets/change_status.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Pasien extends StatefulWidget {
  const Pasien({super.key});

  @override
  State<Pasien> createState() => _PasienState();
}

class _PasienState extends State<Pasien> {
  String _status = "Belum diterima";
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: ReportService().getDocs(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No data found'));
              }

              // Step 5: Display the combined data
              List<dynamic> combinedData = snapshot.data!;
              return ListView.builder(
                itemCount: combinedData.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> testHistory =
                      combinedData[index]['test_history'];
                  String testId = combinedData[index]['test_id'];
                  Map<String, dynamic> user = combinedData[index]['user'];
                  String formattedDate = DateFormat('dd/MM/yy')
                      .format(testHistory['createdAt'].toDate());
                  return ListTile(
                    onTap: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext dialogcontext) => ChangeStatus(
                            userId: testHistory['userId'],
                            initStatus: testHistory['status'],
                            testId: testId,
                            callback: (val) {
                              if (val == "status changed") {
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
                              }
                            })),
                    leading: const Icon(Icons.person),
                    title: Text('${user['name']}'),
                    subtitle: Text(testHistory['diseaseType']),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(formattedDate),
                        const SizedBox(height: 4.0),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: testHistory['status'] == 'Sudah ditangani'
                                ? Colors.lightGreen[200]
                                : Colors.red[200],
                            boxShadow: [
                              BoxShadow(
                                  color:
                                      testHistory['status'] == 'Sudah ditangani'
                                          ? Colors.lightGreen
                                          : Colors.redAccent,
                                  spreadRadius: 1),
                            ],
                          ),
                          child: Text(
                            '${testHistory['status']}',
                            style: TextStyle(
                              color: testHistory['status'] == 'Sudah ditangani'
                                  ? Colors.green[900]
                                  : Colors.red[900],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }));
  }
}
