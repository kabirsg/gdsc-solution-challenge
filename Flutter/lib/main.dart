// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'raspberry_pi.dart';
import 'package:pie_chart/pie_chart.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ffi';

typedef RunCilentAnalyticsFunc = void Function();
typedef RunCilentAnalytics = void Function();

void main() {
  final dylib = Platform.isWindows
      ? DynamicLibrary.open('ffi_python_c.dll')
      : DynamicLibrary.open('ffi_python_c.so');

  final RunCilentAnalytics runCilentAnalytics = dylib
      .lookup<NativeFunction<RunCilentAnalyticsFunc>>('run_cilent_analytics')
      .asFunction();

  runCilentAnalytics();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme:
              ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 2, 164, 239)),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  var history = <WordPair>[];
  var _correct = 2;
  var _mode = 0;
  var _rpi;

  //mode getter
  void getMode() {
    print("getMode");
    if (_mode >= 1) {
      _mode = 0; // this is paper mode
    } else {
      _mode = _mode + 1; //this switches from paper to other mode
    }
    notifyListeners();
  }

  int returnMode() {
    return _mode;
  }

  set mode(int value) {
    _mode = value;
    notifyListeners();
  }

  // Getter
  void getCorrect() {
    if (_correct == 2) {
      _correct = 0;
    } else {
      _correct = _correct + 1;
    }
    notifyListeners();
    print(_correct);
  }

  int returnCorrect() {
    return _correct;
  }

  // Setter
  setcorrect(int value) {
    _correct = value;
    notifyListeners();
  }

  GlobalKey? historyListKey;

  var favorites = <WordPair>[];

  void toggleFavorite([WordPair? pair]) {
    pair = pair ?? current;
    if (favorites.contains(pair)) {
      favorites.remove(pair);
    } else {
      favorites.add(pair);
    }
    notifyListeners();
  }

  void removeFavorite(WordPair pair) {
    favorites.remove(pair);
    notifyListeners();
  }

  bool showCheckmark(correct) {
    return correct == 1;
  }

  bool showCross(correct) {
    return correct == 2;
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = ChangeModePage();
        break;
      case 2:
        page = StatsPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    // The container for the current page, with its background color
    // and subtle switching animation.
    var mainArea = ColoredBox(
      color: colorScheme.surfaceVariant,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 200),
        child: page,
      ),
    );

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 450) {
            // Use a more mobile-friendly layout with BottomNavigationBar
            // on narrow screens.
            return Column(
              children: [
                Expanded(child: mainArea),
                SafeArea(
                  child: BottomNavigationBar(
                    items: [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        label: 'Home',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.autorenew),
                        label: 'Mode Screen',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.pie_chart),
                        label: 'Stats',
                      )
                    ],
                    currentIndex: selectedIndex,
                    onTap: (value) {
                      setState(() {
                        selectedIndex = value;
                      });
                    },
                  ),
                )
              ],
            );
          } else {
            return Row(
              children: [
                SafeArea(
                  child: NavigationRail(
                    extended: constraints.maxWidth >= 600,
                    destinations: [
                      NavigationRailDestination(
                        icon: Icon(Icons.home),
                        label: Text('Home'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.autorenew),
                        label: Text('Mode Screen'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.pie_chart),
                        label: Text('Stats'),
                      ),
                    ],
                    selectedIndex: selectedIndex,
                    onDestinationSelected: (value) {
                      setState(() {
                        selectedIndex = value;
                      });
                    },
                  ),
                ),
                Expanded(child: mainArea),
              ],
            );
          }
        },
      ),
    );
  }
}

class StatsPage extends StatelessWidget {
  //this screen shows a pie chart of statistics
  @override
  Widget build(BuildContext context) {
    return Center(
      //TODO: add pie chart
      //maybe somehting like
      //var scores = context.watch "blahblahblah"
      //,
      //PieChart(dataMap: getappState.scores())
      child: PieChart(dataMap: {
        "Correct Disposals": 5,
        "Incorrect": 3,
      }),
    );
  }
}

class GeneratorPage extends StatelessWidget {
  get correct => null;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.undo_sharp;
    } else {
      icon = Icons.undo_outlined;
    }

    String text = "";

    if (appState.showCheckmark(appState.returnCorrect())) {
      text = "Nice ✅";
    } else if (appState.showCross(appState.returnCorrect())) {
      text = "Invalid ❌";
    } else {
      text = "waiting 🙂";
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: HistoryListView(),
          ),
          SizedBox(height: 10),
          BigCard(
            text: text,
            showCheckmark: appState.showCheckmark(correct),
            showCross: appState.showCross(correct),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.getCorrect();
                },
                icon: Icon(icon),
                label: Text('Undo'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  print("pressed!");
                  communicateWithRaspberryPi();
                },
                child: Text('Raspberry Pi'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  //appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
          Spacer(flex: 2),
        ],
      ),
    );
  }
}

class ChangeModePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var appState = context.watch<MyAppState>();
    var text;
    if (appState.returnMode() == 0) {
      text = "You are currently in paper mode! ";
    } else {
      text = "You are currently in other mode! ";
    }
    context.watch<MyAppState>().setcorrect(2);
    //var modeName = getModeName(context.watch<MyAppState>);

    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RichText(
            text: TextSpan(
              text:
                  'Please make sure that you are on the same wifi network as the detector',
              style: DefaultTextStyle.of(context).style,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          SmallCard(
            type: text,
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 100,
            width: 250,
            child: ElevatedButton.icon(
              onPressed: () {
                appState.getMode();
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              icon: Icon(Icons.autorenew),
              label: Text("Switch Mode"),
            ),
          ),
          SizedBox(height: 10),
        ]);
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    Key? key,
    required this.text,
    required this.showCheckmark,
    required this.showCross,
  }) : super(key: key);

  final String text;
  final bool showCheckmark;
  final bool showCross;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: AnimatedSize(
          duration: Duration(milliseconds: 200),
          child: MergeSemantics(
            child: Wrap(
              children: [
                Text(
                  text,
                  style: style.copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 10),
                Visibility(
                  visible: showCheckmark,
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 50,
                  ),
                ),
                SizedBox(width: 10),
                Visibility(
                  visible: showCross,
                  child: Icon(
                    Icons.cancel,
                    color: Colors.red,
                    size: 50,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SmallCard extends StatelessWidget {
  const SmallCard({
    required this.type,
  });

  final String type;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          type,
          style: style,
        ),
      ),
    );
  }
}

class ModePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(30),
          child: Text('You have '
              '${appState.favorites.length} favorites:'),
        ),
        Expanded(
          // Make better use of wide windows with a grid.
          child: GridView(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 400,
              childAspectRatio: 400 / 80,
            ),
            children: [
              for (var pair in appState.favorites)
                ListTile(
                  leading: IconButton(
                    icon: Icon(Icons.delete_outline, semanticLabel: 'Delete'),
                    color: theme.colorScheme.primary,
                    onPressed: () {
                      appState.removeFavorite(pair);
                    },
                  ),
                  title: Text(
                    pair.asLowerCase,
                    semanticsLabel: pair.asPascalCase,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class HistoryListView extends StatefulWidget {
  const HistoryListView({Key? key}) : super(key: key);

  @override
  State<HistoryListView> createState() => _HistoryListViewState();
}

class _HistoryListViewState extends State<HistoryListView> {
  /// Needed so that [MyAppState] can tell [AnimatedList] below to animate
  /// new items.
  final _key = GlobalKey();

  /// Used to "fade out" the history items at the top, to suggest continuation.
  static const Gradient _maskingGradient = LinearGradient(
    // This gradient goes from fully transparent to fully opaque black...
    colors: [Colors.transparent, Colors.black],
    // ... from the top (transparent) to half (0.5) of the way to the bottom.
    stops: [0.0, 0.5],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();
    appState.historyListKey = _key;

    return ShaderMask(
      shaderCallback: (bounds) => _maskingGradient.createShader(bounds),
      // This blend mode takes the opacity of the shader (i.e. our gradient)
      // and applies it to the destination (i.e. our animated list).
      blendMode: BlendMode.dstIn,
      child: AnimatedList(
        key: _key,
        reverse: true,
        padding: EdgeInsets.only(top: 100),
        initialItemCount: appState.history.length,
        itemBuilder: (context, index, animation) {
          final pair = appState.history[index];
          return SizeTransition(
            sizeFactor: animation,
            child: Center(
              child: TextButton.icon(
                onPressed: () {
                  appState.toggleFavorite(pair);
                },
                icon: appState.favorites.contains(pair)
                    ? Icon(Icons.favorite, size: 12)
                    : SizedBox(),
                label: Text(
                  pair.asLowerCase,
                  semanticsLabel: pair.asPascalCase,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

//THIS IS THE COMMUNICATION PART

Future<void> communicateWithRaspberryPi() async {
  try {
    Socket socket = await Socket.connect('127.0.0.1',
        5001); // Replace with your Raspberry Pi's IP address and port number

    socket.listen((List<int> data) {
      String message = utf8.decode(data);
      print('Received message: $message');
    });

    // Send a message to the Raspberry Pi
    String message = 'Hello from Flutter!';
    socket.write(utf8.encode(message));
  } catch (e) {
    print('Error: $e'); //see if you can configure this to select mode
  }
}
