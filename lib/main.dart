import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'footer.dart'; 

void main() {
  runApp(ChatApp());
}

class ChatApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // ユーザー情報を渡す
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ChatApp',
        theme: ThemeData(
          // テーマカラー
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        // ログイン画面を表示
        home: LoginPage(),
      );
  }
}
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {
  // 登録・ログインに関する情報を表示
  String infoText = "";
  // 入力されたメールアドレス（ログイン）
  String loginUserEmail = "";
  // 入力されたパスワード（ログイン）
  String loginUserPassword = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBarを表示し、タイトルも設定
      appBar: AppBar(
        title: Text('チャット投稿アプリ'),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                constraints: BoxConstraints(minWidth: 400, maxWidth: 800),
                child: TextFormField(
                  // テキスト入力のラベルを設定
                  decoration: InputDecoration(labelText: "メールアドレス"),
                  onChanged: (String value) {
                    setState(() {
                      loginUserEmail = value;
                    });
                  },
                ),
              ),
              Container(
                constraints: BoxConstraints(minWidth: 400, maxWidth: 800),
                child: TextFormField(
                  decoration: InputDecoration(labelText: "パスワード（６文字以上）"),
                  // パスワードが見えないようにする
                  obscureText: true,
                  onChanged: (String value) {
                    setState(() {
                      loginUserPassword = value;
                    });
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.all(8),
                // メッセージ表示
                child: Text(infoText),
              ),
              Container(
                padding: EdgeInsets.all(5),
                height: 50,
                constraints: BoxConstraints(minWidth: 150, maxWidth: 300),
                width: double.infinity,
                // ログイン登録ボタン
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.blue)
                  ),
                  child: const Text('ログイン'),
                  // label: Text("ログイン"),
                  // icon: Icon(Icons.login),
                  color: Colors.blue,
                  textColor: Colors.white,
                  onPressed: () async {
                    try {
                      // メール/パスワードでログイン
                      final FirebaseAuth auth = FirebaseAuth.instance;
                      final UserCredential result =
                          await auth.signInWithEmailAndPassword(
                        email: loginUserEmail,
                        password: loginUserPassword,
                      );
                      // ログインに成功した場合
                      final User user = result.user;
                      setState(() {
                        infoText = "ログインOK：${user.email}";
                      });
                      // チャット画面に遷移＋ログイン画面を破棄
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) {
                          return ChatPage(user);
                        }),
                      );
                    } catch (e) {
                      // ログインに失敗した場合
                      setState(() {
                        infoText = "ログインNG：${e.message}";
                      });
                    }
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.all(5),
                height: 50,
                constraints: BoxConstraints(minWidth: 150, maxWidth: 300),
                width: double.infinity,
                // ユーザー登録ボタン
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.blue)
                  ),
                  child: const Text('ユーザー登録'),
                  // label: Text("ユーザー登録"),
                  // icon: Icon(Icons.add),
                  textColor: Colors.blue,
                  onPressed: () async {
                    try {
                      // メール/パスワードでユーザー登録
                      final FirebaseAuth auth = FirebaseAuth.instance;
                      final UserCredential result =
                          await auth.createUserWithEmailAndPassword(
                        email: loginUserEmail,
                        password: loginUserPassword,
                      );
                      // 登録したユーザー情報
                      final User user = result.user;
                      setState(() {
                        infoText = "登録OK：${user.email}";
                      });
                    } catch (e) {
                      // 登録に失敗した場合
                      setState(() {
                        infoText = "登録NG：${e.message}";
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// リスト画面用Widget
class ChatPage extends StatelessWidget  {
  // 引数からユーザー情報を受け取れるようにする
  ChatPage(this.user);

  // ユーザー情報
  final User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBarを表示し、タイトルも設定
      appBar: AppBar(
        title: Text('チャット'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              // ログアウト処理
              // 内部で保持しているログイン情報等が初期化される
              // （現時点ではログアウト時はこの処理を呼び出せばOKと、思うぐらいで大丈夫です）
              await FirebaseAuth.instance.signOut();
              // ログイン画面に遷移＋チャット画面を破棄
              await Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) {
                  return LoginPage();
                }),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(8),
            child: Text('ログイン情報：${user.email}'),
          ),
          Expanded(
            // StreamBuilder
            // 非同期処理の結果を元にWidgetを作れる
            child: StreamBuilder<QuerySnapshot>(
              // 投稿メッセージ一覧を取得（非同期処理）
              // 投稿日時でソート
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .orderBy('date')
                  .snapshots(),
                  //.get(),
              builder: (context, snapshot) {
                // データが取得できた場合
                if (snapshot.hasData) {
                  final List<DocumentSnapshot> documents =
                      snapshot.data.docs;
                  // 取得した投稿メッセージ一覧を元にリスト表示
                  return ListView(
                    children: documents.map((document) {
                      IconButton deleteIcon;
                      // 自分の投稿メッセージの場合は削除ボタンを表示
                      if (document['email'] == user.email) {
                        deleteIcon = IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            // 投稿メッセージのドキュメントを削除
                            await FirebaseFirestore.instance
                                .collection('posts')
                                .doc(document.id)
                                .delete();
                          },
                        );
                      }
                      return Card(
                        child: ListTile(
                          title: Text(document['text']),
                          subtitle: Text(document['email']),
                          trailing: deleteIcon,
                        ),
                      );
                    }).toList(),
                  );
                }
                // データが読込中の場合
                return Center(
                  child: Text('読込中...'),
                );
              },
            ),
          ),
        ]
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // "push"で新規画面に遷移
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              // 遷移先の画面としてリスト追加画面を指定
              return AddPostPage(user);
            }),
          );
        },
        label: Text("投稿"),
        tooltip: "チャットを投稿",
        icon: Icon(Icons.add),
      ),
      bottomNavigationBar: Footer(),  // Footerを追加
    );
  }
}

// リスト追加画面用Widget
class AddPostPage extends StatefulWidget {
  // 引数からユーザー情報を受け取る
  AddPostPage(this.user);
  // ユーザー情報
  final User user;

  @override
  _AddPostPageState createState() => _AddPostPageState();
}
class _AddPostPageState extends State<AddPostPage> {
  // 入力した投稿メッセージ
  String messageText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBarを表示し、タイトルも設定
      appBar: AppBar(
        title: Text('チャット投稿'),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // 投稿メッセージ入力
              TextFormField(
                decoration: InputDecoration(labelText: '投稿メッセージ'),
                // 複数行のテキスト入力
                keyboardType: TextInputType.multiline,
                // 最大3行
                maxLines: 3,
                onChanged: (String value) {
                  setState(() {
                    messageText = value;
                  });
                },
              ),
              Container(
                padding: EdgeInsets.all(8),
                height: 50,
                constraints: BoxConstraints(minWidth: 150, maxWidth: 300),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.blue)
                  ),
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: Text('投稿'),
                  onPressed: () async {
                    final date =
                        DateTime.now().toLocal().toIso8601String(); // 現在の日時
                    final email = widget.user.email; // AddPostPage のデータを参照
                    // 投稿メッセージ用ドキュメント作成
                    await FirebaseFirestore.instance
                        .collection('posts') // コレクションID指定
                        .doc() // ドキュメントID自動生成
                        .set({
                          'text': messageText,
                          'email': email,
                          'date': date
                        });
                    // 1つ前の画面に戻る
                    Navigator.of(context).pop();
                  },
                ),
              )
            ]
          ),
        ),
      ),
    );
  }
}

// コレクションクラス
class Collection {
  String name;
  List<Document> documentList;

  Collection() {
    documentList = new List<Document>();
  }

  void setDocument(Document doc) {
    documentList.add(doc);
  }

  void removeDocument(Document doc) {
    documentList.remove(documentList.where((element) => element.name == doc.name).single);
  }
}

// ドキュメントクラス
class Document {
  String name;
  Map<String, String> data;
  List<Collection> subCollectionList;

  Document() {
    subCollectionList = new List<Collection>();
  }

  void setData(String key, String val) {
    data[key] = val;
  }

  void removeData(String key) {
    data.remove(key);
  }

  void setSubCollection(Collection collection) {
    subCollectionList.add(collection);
  }

  void removeSubCollection(Collection collection) {
    subCollectionList.remove(subCollectionList.where((element) => element.name == collection.name).single);
  }
}