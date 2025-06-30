import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserAuthenticationsScreen extends StatelessWidget {
  const UserAuthenticationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Users'),
        backgroundColor: Colors.orange.shade400,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users personal data')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No user data available.'));
          }

          var users = snapshot.data!.docs;

          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                   SizedBox(width: 200,),

                    DataTable(

                      columns: const [
                        DataColumn(
                            label: Text('    Name         ',
                                style: TextStyle(fontWeight: FontWeight.bold,color: Colors.orange,fontSize: 20))),
                        DataColumn(
                            label: Text('    Email         ',
                                style: TextStyle(fontWeight: FontWeight.bold,color: Colors.orange,fontSize: 20))),
                        DataColumn(
                            label: Text('     Contact No     ',
                                style: TextStyle(fontWeight: FontWeight.bold,color: Colors.orange,fontSize: 20))),
                        DataColumn(
                            label: Text('      SignIn Time      ',
                                style: TextStyle(fontWeight: FontWeight.bold,color: Colors.orange,fontSize: 20))),
                      ],
                      rows: users.map<DataRow>((user) {
                        var userData = user.data() as Map<String, dynamic>;
                        return DataRow(cells: [
                          //DataCell(Text(userData['nanme'] ?? '')),

                          DataCell(Text(userData['name'] ?? '')),
                          DataCell(Text(userData['email'] ?? '')),
                          DataCell(Text(userData['phone'] ?? '')),
                          DataCell(Text(
                            userData['createdAt'] != null
                                ? userData['createdAt'].toDate().toString()
                                : '',
                          )),
                        ]);
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
