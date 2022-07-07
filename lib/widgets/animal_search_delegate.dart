import 'package:flutter/material.dart';

class AnimalSearchDelegate extends SearchDelegate {
  final Function callback;

  AnimalSearchDelegate({
    required this.callback
  });

  List<String> searchTerms = [
    'Bird',
    'Cat',
    'Chinchilla',
    'Crab',
    'Dog',
    'Frog',
    'Gerbil',
    'Guinea pig',
    'Hamster',
    'Mouse',
    'Rabbit',
    'Tortoise',
    'Turtle',
    'Others',
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      )
    ];
  }
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var animal in searchTerms) {
      if (animal.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(animal);
      }
    }
    return ListView.builder(
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
            onTap: () {
              callback(result);
              Navigator.pop(context);
            }
        );
      },
      itemCount: matchQuery.length,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var animal in searchTerms) {
      if (animal.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(animal);
      }
    }
    return ListView.builder(
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
            title: Text(result),
            onTap: () {
              callback(result);
              Navigator.pop(context);
            }
        );
      },
      itemCount: matchQuery.length,
    );
  }
}