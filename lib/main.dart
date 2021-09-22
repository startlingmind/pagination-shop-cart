import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'catergories',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ScrollController _scrollController = ScrollController();
  Map<dynamic, dynamic> items = new Map<dynamic, dynamic>();
  bool loading = false, allLoaded = false;

  // add the api call here
  void mockfetch() async {
    if (allLoaded) {
      return;
    }
    setState(() {
      loading = true;
    });
    http.Response response;
    response = await http.get(Uri.parse(
        'https://startupify-sample-apis.herokuapp.com/products?start=0&rows=20&category=kids'));

    Map<dynamic, dynamic> newData = items.length >= 
        ? []
        : List.generate(20, (index) => "List Item ${index + items.length}");
    if (newData.isNotEmpty) {
      items.addAll(newData);
    }

    setState(() {
      loading = false;
      allLoaded = newData.isEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    mockfetch();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !loading) {
        print('new data call');
        mockfetch();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text("Startupify"),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        if (items.isNotEmpty) {
          return Stack(children: [
            ListView.separated(
                controller: _scrollController,
                itemBuilder: (context, index) {
                  if (index < items.length) {
                    return ListTile(
                      title: Text(items[index]),
                    );
                  } else {
                    return Container(
                        width: constraints.maxWidth,
                        height: 50,
                        child: Center(
                          child: Text('Nothing More to load'),
                        ));
                  }
                },
                separatorBuilder: (context, index) {
                  return Divider(
                    height: 1,
                  );
                },
                itemCount: items.length + (allLoaded ? 1 : 0)),
            if (loading) ...[
              Positioned(
                  width: constraints.maxWidth,
                  left: 0,
                  bottom: 80,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ))
            ]
          ]);
        } else {
          return Container(
              child: Center(
            child: CircularProgressIndicator(),
          ));
        }
      }),
    );
  }
}
