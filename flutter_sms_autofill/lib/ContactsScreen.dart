import 'package:flutter/material.dart';
import 'package:flutter_sms_autofill/Models/Contact.dart';

class ContactsScreen extends StatelessWidget {
  final List<Contact> contacts = [
    Contact(
      name: 'Joe Belfiore',
      status: 'In a world far away',
      imageUrl: 'https://i.pravatar.cc/150?img=1',
      statusColor: Colors.green,
    ),
    Contact(
      name: 'Bill Gates',
      status: 'What I\'m doing here?',
      imageUrl: 'https://i.pravatar.cc/150?img=2',
      statusColor: Colors.yellow,
    ),
    Contact(
      name: 'Mark Zuckerberg',
      status: 'Really Busy, WhatsApp only',
      imageUrl: 'https://i.pravatar.cc/150?img=3',
      statusColor: Colors.red,
    ),
    Contact(
      name: 'Marissa Mayer',
      status: 'In a rush to catch a plane',
      imageUrl: 'https://i.pravatar.cc/150?img=4',
      statusColor: Colors.green,
    ),
    Contact(
      name: 'Sundar Pichai',
      status: 'Do androids dream of electric sheep?',
      imageUrl: 'https://i.pravatar.cc/150?img=5',
      statusColor: Colors.green,
    ),
    Contact(
      name: 'Jeff Bezos',
      status: 'Counting Zeroes: Prime time.',
      imageUrl: 'https://i.pravatar.cc/150?img=6',
      statusColor: Colors.green,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: Icon(Icons.menu, color: Colors.black),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Icon(Icons.search, color: Colors.black),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          return ContactTile(contact: contacts[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: Icon(Icons.edit, color: Colors.grey[700]),
        onPressed: () {},
      ),
    );
  }
}

class ContactTile extends StatelessWidget {
  final Contact contact;

  ContactTile({required this.contact});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Stack(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(contact.imageUrl),
            radius: 24,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: contact.statusColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          )
        ],
      ),
      title: Text(
        contact.name,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(contact.status),
    );
  }
}
