import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../Services/Supabase-Auth.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  late final Stream<List<Map<String, dynamic>>> _messagesStream;
  final streamMessage = Supabase.instance.client.from('messages').stream(primaryKey: ['id','content']);

  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    subscribeChannelMessages();
    _messagesStream = supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .order('created_at')
        .map((maps) => maps.cast<Map<String, dynamic>>());
  }

  void subscribeChannelMessages() {
    supabase.channel('messages').onPostgresChanges(
      event: PostgresChangeEvent.all,
      schema: 'public',
      table: 'messages',
      callback: (payload) {
        print('Change received: ${payload.toString()}');
      },
    ).subscribe((status, [error]) {
          if (status == RealtimeSubscribeStatus.closed) {
            print('!!!!!! CLOSED !!!!!!!');
          }
          else{
            print('!!!!!! OPEN !!!!!!!');
          }
        }
    );
  }

  void handleInserts(payload) {
    print('Change received! $payload');
  }






  bool messageOwner(Map<String, dynamic> message) {
    return message['user_id'] == supabase.auth.currentUser!.id;
  }

  // Envoyer un message
  void _sendMessage() async {
    //if (_messageController.text.trim().isEmpty) return;
    print(supabase.auth.currentUser!.id);
    await supabase
        .from('messages')
        .insert({'content': _messageController.text, 'user_id': supabase.auth.currentUser!.id});

    print(_messageController.text);
  /*  await supabase.from('messages').insert({
      'content': _messageController.text,
    });
*/
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat Anonyme")),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _messagesStream,
              builder: (context, snapshot) {
                print("snapshot.data: ${snapshot.data}");


                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Aucun élément'));
                }
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                        return ListTile(
                          title: Container(
                            constraints: BoxConstraints(
                                 minWidth: 10, maxWidth: 20),
                            alignment: messageOwner(snapshot.data![index]) ? Alignment.centerLeft : Alignment.centerRight,
                            decoration: BoxDecoration(

                              color: messageOwner(snapshot.data![index]) ? Colors.green : Colors.grey,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.all(10),
                            child: Text(
                                snapshot.data![index]['content'],
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                            ),
                          )
                        );
                    }
                );
              },
            )
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
          ElevatedButton(onPressed: _sendMessage, child: Text("Envoyer")),
          ElevatedButton(
            onPressed: () {
              SupabaseAuthService().signOutUser();
            },
            child: const Text('Log Out'),
          )
        ],
      ),
    );
  }
}
