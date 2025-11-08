import 'package:flutter/material.dart';

void main() {
  runApp(FlashcardApp());
}

class FlashcardApp extends StatelessWidget {
  const FlashcardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flashcard App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: FlashcardHomePage(),
    );
  }
}

class FlashcardHomePage extends StatefulWidget {
  const FlashcardHomePage({super.key});

  @override
  State<FlashcardHomePage> createState() => _FlashcardHomePageState();
}

class _FlashcardHomePageState extends State<FlashcardHomePage> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  List<Map<String, String>> flashcards = [
    {"question": "What is Flutter?", "answer": "An open-source UI toolkit by Google."},
    {"question": "What is Dart?", "answer": "A programming language used by Flutter."},
    {"question": "What is a Widget?", "answer": "A building block of Flutter’s UI."},
  ];

  int learnedCount = 0;

  Future<void> _refreshList() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      learnedCount = 0;
      flashcards = [
        {"question": "What is StatefulWidget?", "answer": "A widget with mutable state."},
        {"question": "What is StatelessWidget?", "answer": "A widget with immutable state."},
        {"question": "What is Hot Reload?", "answer": "Instant UI update without restarting."},
      ];
    });
  }

  void _addNewFlashcard() {
    final newCard = {
      "question": "New Question?",
      "answer": "New Answer!",
    };
    flashcards.insert(0, newCard);
    _listKey.currentState?.insertItem(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text("Flashcards (${learnedCount} of ${flashcards.length} learned)"),
            floating: true,
            expandedHeight: 100,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(color: Colors.blue.shade100),
            ),
          ),
          SliverFillRemaining(
            child: RefreshIndicator(
              onRefresh: _refreshList,
              child: AnimatedList(
                key: _listKey,
                initialItemCount: flashcards.length,
                itemBuilder: (context, index, animation) {
                  if (index >= flashcards.length) return const SizedBox();
                  final card = flashcards[index];

                  return SizeTransition(
                    sizeFactor: animation,
                    child: Dismissible(
                      key: UniqueKey(),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.green,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(Icons.check, color: Colors.white),
                      ),
                      onDismissed: (_) {
                        final removedItem = card;
                        flashcards.removeAt(index);

                        _listKey.currentState?.removeItem(
                          index,
                              (context, animation) => SizeTransition(
                            sizeFactor: animation,
                            child: FlashcardWidget(
                              question: removedItem["question"]!,
                              answer: removedItem["answer"]!,
                            ),
                          ),
                          duration: const Duration(milliseconds: 400),
                        );

                        setState(() {
                          learnedCount++;
                        });
                      },
                      child: FlashcardWidget(
                        question: card["question"]!,
                        answer: card["answer"]!,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewFlashcard,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class FlashcardWidget extends StatefulWidget {
  final String question;
  final String answer;

  const FlashcardWidget({super.key, required this.question, required this.answer});

  @override
  State<FlashcardWidget> createState() => _FlashcardWidgetState();
}

class _FlashcardWidgetState extends State<FlashcardWidget> {
  bool _showAnswer = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(_showAnswer ? widget.answer : widget.question),
        subtitle: _showAnswer
            ? const Text("Tap to hide answer")
            : const Text("Tap to see answer"),
        onTap: () {
          setState(() {
            _showAnswer = !_showAnswer;
          });
        },
      ),
    );
  }
}
