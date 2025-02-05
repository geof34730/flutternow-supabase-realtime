import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  final TextEditingController _messageController = TextEditingController();
  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    super.initState();
    _fetchMessages();
    _subscribeToRealtime();
  }

  // Charger les messages existants
  void _fetchMessages() async {


    final response = await supabase

        .from('messages')
        .select()
        .order('created_at', ascending: true);

    print("**************Messages: ${response}");
    setState(() {
      messages = List<Map<String, dynamic>>.from(response);
    });
  }

  // Activer la mise à jour en temps réel
  void _subscribeToRealtime() {
    supabase.channel('messages_channel')
        .onPostgresChanges(
      event: PostgresChangeEvent.insert,  // Écoute uniquement les nouveaux messages
      schema: 'public',
      table: 'messages',
      callback: (payload) {

        print("**************Nouveau message: ${payload.newRecord}");
        setState(() {
          //messages.add(payload.newRecord!);
        });
      },
    )
        .subscribe();
  }


  // Envoyer un message
  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    await supabase.from('messages').insert({
      'content': _messageController.text,
    });

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat Anonyme")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return ListTile(
                  title: Text(message['content']),
                  subtitle: Text(message['created_at']),
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
                    decoration: InputDecoration(
                      hintText: "Écrire un message...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
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
