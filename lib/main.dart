import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyAuthPage(),
    );
  }
}
class MyAuthPage extends StatefulWidget {
  @override
  _MyAuthPageState createState() => _MyAuthPageState();
}
class _MyAuthPageState extends State<MyAuthPage> {
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
        title: Text('ログイン画面'),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(32),
          child: Column(
            children: <Widget>[
              TextFormField(
                // テキスト入力のラベルを設定
                decoration: InputDecoration(labelText: "メールアドレス"),
                onChanged: (String value) {
                  setState(() {
                    loginUserEmail = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "パスワード（６文字以上）"),
                // パスワードが見えないようにする
                obscureText: true,
                onChanged: (String value) {
                  setState(() {
                    loginUserPassword = value;
                  });
                },
              ),
              RaisedButton(
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
                    // "push"で新規画面に遷移
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) {
                        // 遷移先の画面としてリスト追加画面を指定
                        return ListPage();
                      }),
                    );
                  } catch (e) {
                    // ログインに失敗した場合
                    setState(() {
                      infoText = "ログインNG：${e.message}";
                    });
                  }
                },
                child: Text("ログイン"),
              ),
              RaisedButton(
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
                child: Text("ユーザー登録"),
              ),
              Container(height: 32),
              Text(infoText),
            ],
          ),
        ),
      ),
    );
  }
}

// リスト画面用Widget
class ListPage extends StatefulWidget {
  @override
  _ListPage createState() => _ListPage();
}
class _ListPage extends State<ListPage> {
  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   // AppBarを表示し、タイトルも設定
    //   appBar: AppBar(
    //     title: Text('一覧画面'),
    //   ),
    //   body: Center(
    //     child: Container(
    //       padding: EdgeInsets.all(32),
    //       child: Column(
    //         children: <Widget>[
    //           DataTable(
    //             columns: const <DataColumn>[
    //               DataColumn(
    //                 label: Text(
    //                   'コレクション',
    //                   style: TextStyle(fontStyle: FontStyle.italic),
    //                 ),
    //               ),
    //               DataColumn(
    //                 label: Text(
    //                   'ドキュメント',
    //                   style: TextStyle(fontStyle: FontStyle.italic),
    //                 ),
    //               ),
    //               DataColumn(
    //                 label: Text(
    //                   'キー',
    //                   style: TextStyle(fontStyle: FontStyle.italic),
    //                 ),
    //               ),
    //               DataColumn(
    //                 label: Text(
    //                   '値',
    //                   style: TextStyle(fontStyle: FontStyle.italic),
    //                 ),
    //               ),
    //             ],
    //             rows: const <DataRow>[
    //               DataRow(
    //                 cells: <DataCell>[
    //                   DataCell(Text('Sarah')),
    //                   DataCell(Text('19')),
    //                   DataCell(Text('Student')),
    //                   DataCell(Text('Student')),
    //                 ],
    //               ),
    //               DataRow(
    //                 cells: <DataCell>[
    //                   DataCell(Text('Janine')),
    //                   DataCell(Text('43')),
    //                   DataCell(Text('Professor')),
    //                   DataCell(Text('Student')),
    //                 ],
    //               ),
    //               DataRow(
    //                 cells: <DataCell>[
    //                   DataCell(Text('William')),
    //                   DataCell(Text('27')),
    //                   DataCell(Text('Associate Professor')),
    //                   DataCell(Text('Student')),
    //                 ],
    //               ),
    //             ],
    //           ),
    //           FlatButton(
    //             // ボタンをクリックした時の処理
    //             onPressed: () {
    //               // "pop"で前の画面に戻る
    //               Navigator.of(context).pop();
    //             },
    //             child: Text('ログイン画面（クリックで戻る）'),
    //           ),
    //         ]
    //       ),
    //     ),
    //   ),
    //   floatingActionButton: FloatingActionButton(
    //     onPressed: () {
    //       // "push"で新規画面に遷移
    //       Navigator.of(context).push(
    //         MaterialPageRoute(builder: (context) {
    //           // 遷移先の画面としてリスト追加画面を指定
    //           return AddPage();
    //         }),
    //       );
    //     },
    //     child: Icon(Icons.add),
    //   )
    // );
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc('id_abc').get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data.data();
          var keys = data.keys.toList();
          //return Text("Full Name: ${data['full_name']} ${data['last_name']}");
          return Scaffold(
            // AppBarを表示し、タイトルも設定
            appBar: AppBar(
              title: Text('一覧画面'),
            ),
            body: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  child: Card(
                    child: ListTile(
                      title: Text(keys[index]+"="+data[keys[index]]),
                    ),
                  ),
                );
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                // "push"で新規画面に遷移
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    // 遷移先の画面としてリスト追加画面を指定
                    return AddPage();
                  }),
                );
              },
              child: Icon(Icons.add),
            )
          );
        }

        return Text("loading");
      },
    );
  }
}

// リスト追加画面用Widget
class AddPage extends StatefulWidget {
  @override
  _AddPage createState() => _AddPage();
}
class _AddPage extends State<AddPage> {
  // 入力されたコレクション
  String collection = "";
  // 入力されたドキュメント
  String document = "";
  // 入力されたキー
  String key = "";
  // 入力された値
  String value = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBarを表示し、タイトルも設定
      appBar: AppBar(
        title: Text('追加画面'),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(32),
          child: Column(
            children: <Widget>[
              TextFormField(
                // テキスト入力のラベルを設定
                decoration: InputDecoration(labelText: "コレクション"),
                onChanged: (String value) {
                  setState(() {
                    collection = value;
                  });
                },
              ),
              TextFormField(
                // テキスト入力のラベルを設定
                decoration: InputDecoration(labelText: "ドキュメント"),
                onChanged: (String value) {
                  setState(() {
                    document = value;
                  });
                },
              ),
              TextFormField(
                // テキスト入力のラベルを設定
                decoration: InputDecoration(labelText: "キー"),
                onChanged: (String value) {
                  setState(() {
                    key = value;
                  });
                },
              ),
              TextFormField(
                // テキスト入力のラベルを設定
                decoration: InputDecoration(labelText: "値"),
                onChanged: (String value) {
                  setState(() {
                    this.value = value;
                  });
                },
              ),
              RaisedButton(
                child: Text('データ作成'),
                onPressed: () async {
                  // ドキュメント作成
                  await FirebaseFirestore.instance
                      .collection(collection) // コレクションID
                      .doc(document) // ドキュメントID
                      .set({key: value}); // データ
                      //.delete();
                  // "pop"で前の画面に戻る
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                // ボタンをクリックした時の処理
                onPressed: () {
                  // "pop"で前の画面に戻る
                  Navigator.of(context).pop();
                },
                child: Text('一覧画面（クリックで戻る）'),
              ),
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