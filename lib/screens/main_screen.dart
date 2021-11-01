import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:word_counter/models/app_provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController wordController = TextEditingController();
  String countWord = '';
  bool toggleTheme = false;
  late FlutterTts flutterTts;
  final RegExp regExp = RegExp(r"[\w-._]+");

  @override
  initState() {
    super.initState();
    flutterTts = FlutterTts();
    final bool toggleState = AdaptiveTheme.of(context).mode.isDark;
    toggleTheme = toggleState;
    Provider.of<AppProvider>(context, listen: false)
        .loadTextFunction()
        .then((getSaveText) {
      setState(() {
        countWord = getSaveText;
      });
      wordController.text = getSaveText;
    });
  }

  void _readText() {
    if (countWord.isEmpty) {
      return;
    }
    flutterTts.speak(countWord);
  }

  void _saveText() {
    Provider.of<AppProvider>(context, listen: false)
        .saveTextFunction(countWord);
    final snack = ScaffoldMessenger.of(context);
    snack.hideCurrentSnackBar();
    snack.showSnackBar(
      const SnackBar(
        content: Text("Text Saved"),
        backgroundColor: Colors.cyanAccent,
        duration: Duration(milliseconds: 2000),
      ),
    );
  }

  Widget buildButton(Icon icon, String label, Function() function) {
    return Container(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: function,
        icon: icon,
        label: Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Word Counter',
            style: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          centerTitle: true,
          actions: [
            Switch(
                value: toggleTheme,
                onChanged: (bool newValue) {
                  setState(() {
                    toggleTheme = !toggleTheme;
                  });
                  if (newValue) {
                    AdaptiveTheme.of(context).setDark();
                  } else {
                    AdaptiveTheme.of(context).setLight();
                  }
                }),
          ],
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(19, 25, 19, 10),
            child: ListView(
              children: <Widget>[
                const SizedBox(height: 20),
                const Text(
                  'Please type a sentence or a phrase below to get started',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: wordController,
                  maxLines: 8,
                  keyboardType: TextInputType.multiline,
                  onChanged: (val) {
                    setState(() {
                      countWord = val;
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: 'Text here...',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text(
                      'Count:',
                      style: TextStyle(
                        fontSize: 19.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${regExp.allMatches(countWord).length}',
                      style: const TextStyle(
                        fontSize: 19.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildButton(
                        const Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                        ),
                        'Read',
                        _readText),
                    const SizedBox(height: 16),
                    buildButton(
                        const Icon(
                          Icons.save,
                          color: Colors.white,
                        ),
                        'Save',
                        _saveText),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
