import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

void main() {
  runApp(const MyForkApp());
}

class Review {
  Review({
    required this.title,
    required this.rating,
    this.comment,
  });

  final String title;
  final String? comment;
  final int rating;
}

class MyForkApp extends StatelessWidget {
  const MyForkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyFork',
      theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Review> reviews = [];

  Future<void> _openForm({Review? review, int? index}) async { //cerca nel file
    final data = await Navigator.of(context).push<Map<String, Object?>>(
      MaterialPageRoute(
        builder: (_) => ReviewFormPage(review: review),
      ),
    );

    if (data == null) return;

    final newReview = Review(
      title: data['title'] as String,
      rating: data['rating'] as int,
      comment: data['comment'] as String?,
    );

    setState(() {
      if (review == null) {
        reviews.add(newReview);
      } else {
        reviews[index!] = newReview;
      }
    });
  }

@override
Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MyFork - Aurora Gasparutti"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: reviews.length,
        itemBuilder: (context, i) {
          final r = reviews[i];
          return Card(
            child: ListTile(
              title: Text(r.title),
              subtitle: Text(
                " ${r.rating}\n${r.comment ?? ''}",
              ),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _openForm(review: r, index: i),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ReviewFormPage extends StatefulWidget {
  final Review? review; 

  const ReviewFormPage({super.key, this.review});

  @override
  State<ReviewFormPage> createState() => _ReviewFormPageState();
}

class _ReviewFormPageState extends State<ReviewFormPage> {
  late FormGroup form;

  @override
  void initState() {
    super.initState();

    form = FormGroup({
      'title': FormControl<String>(
        value: widget.review?.title, 
        validators: [RequiredValidator()], 
      ),
      'rating': FormControl<int>(
        value: widget.review?.rating ?? 1, 
        validators: [RequiredValidator(), Validators.min(1),Validators.max(5),],
      ),
      'comment': FormControl<String>(
        value: widget.review?.comment, 
      )
    });
  }

  void _submit() { 
    if (form.valid) {
      Navigator.of(context).pop(form.value);
    } else {
      form.markAllAsTouched();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Review"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ReactiveForm(
          formGroup: form,
          child: Column(
            children: [
              ReactiveTextField<String>(
                formControlName: 'title',
                decoration: const InputDecoration(
                  labelText: "Titolo",
                ),
                validationMessages: {
                  ValidationMessage.required: (_) => "Il titolo è obbligatorio",
                },
              ),
              const SizedBox(height: 16),
              ReactiveTextField<int>(
                formControlName: 'rating',
                decoration: const InputDecoration(
                  labelText: "Rating (1-5)",
                ),
                keyboardType: TextInputType.number,
                validationMessages: {
                  ValidationMessage.required: (_) => "Rating obbligatorio",
                  ValidationMessage.min: (_) => "Minimo 1",
                  ValidationMessage.max: (_) => "Massimo 5",
                },
              ),
              const SizedBox(height: 16),
              ReactiveTextField<String>(
                formControlName: 'comment',
                decoration: const InputDecoration(
                  labelText: "Commento (opzionale)",
                ),
                maxLines: 3,
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _submit,
                child: const Text("Salva"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}