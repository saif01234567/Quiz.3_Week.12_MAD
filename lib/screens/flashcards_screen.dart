import 'package:flutter/material.dart';

class FlashcardsScreen extends StatefulWidget {
  const FlashcardsScreen({super.key});

  @override
  State<FlashcardsScreen> createState() => _FlashcardsScreenState();
}

class _FlashcardsScreenState extends State<FlashcardsScreen> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  List<Map<String, String>> flashcards = [
    {"question": "What is Flutter?", "answer": "A UI toolkit by Google."},
    {"question": "What is Dart?", "answer": "Programming language for Flutter."},
    {"question": "What is a StatefulWidget?", "answer": "Widget that can change state."},
    {"question": "What is Hot Reload?", "answer": "Feature to instantly update UI during dev."},
  ];

  int learnedCount = 0;

  Future<void> _refreshList() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      flashcards.shuffle(); // simulate new quiz set
      learnedCount = 0;
    });
  }

  void _addFlashcard() {
    final newCard = {
      "question": "New Question #${flashcards.length + 1}",
      "answer": "This is its answer."
    };
    flashcards.insert(0, newCard);
    _listKey.currentState?.insertItem(0, duration: const Duration(milliseconds: 400));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _addFlashcard,
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshList,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: 150,
              flexibleSpace: FlexibleSpaceBar(
                title: Text("Learned: $learnedCount of ${flashcards.length}"),
                background: Container(color: Colors.tealAccent),
              ),
            ),
            SliverToBoxAdapter(
              child: AnimatedList(
                key: _listKey,
                initialItemCount: flashcards.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index, animation) {
                  final card = flashcards[index];
                  return SizeTransition(
                    sizeFactor: animation,
                    child: Dismissible(
                      key: UniqueKey(),
                      onDismissed: (_) {
                        setState(() {
                          flashcards.removeAt(index);
                          learnedCount++;
                        });
                      },
                      background: Container(
                        color: Colors.green,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(Icons.check, color: Colors.white),
                      ),
                      child: FlashcardWidget(
                        question: card["question"]!,
                        answer: card["answer"]!,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
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
    return GestureDetector(
      onTap: () => setState(() => _showAnswer = !_showAnswer),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: AnimatedCrossFade(
              duration: const Duration(milliseconds: 300),
              firstChild: Text(
                widget.question,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              secondChild: Text(
                widget.answer,
                style: const TextStyle(fontSize: 18, color: Colors.teal),
              ),
              crossFadeState: _showAnswer
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
            ),
          ),
        ),
      ),
    );
  }
}
