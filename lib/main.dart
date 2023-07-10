// // ignore_for_file: prefer_const_constructors

// import 'package:flutter/material.dart';

// import 'package:recipi/views/home.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Food recipe',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.deepPurple,
//         primaryColor: Colors.white,
//         textTheme: TextTheme(
//           bodyText2: TextStyle(color: Colors.white),
//         ),
//       ),
//       home: HomePage(),
//     );
//   }
// }

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipi/recipe_card_asset.dart';
import 'package:recipi/signin_screen.dart';
import 'package:recipi/views/widgets/recipe_card.dart';

import 'package:share_plus/share_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class Recipe {
  final String title;
  final String description;
  final String imageUrl;
  final String cookTime;
  final String rateScore;

  Recipe(
    this.title,
    this.description,
    this.imageUrl,
    this.cookTime,
    this.rateScore,
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe Sharing App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: SignInScreen(),
    );
  }
}

class RecipeList extends StatefulWidget {
  @override
  _RecipeListState createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  TextEditingController searchController = TextEditingController();
  List<Recipe> recipes = [];
  List templist = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    templist = recipes;
  }

  void runfilter(searchkeyword) {
    List results = [];
    if (searchkeyword.isEmpty) {
      results = recipes;
    } else {
      results = recipes
          .where((element) =>
              element.title.toLowerCase().contains(searchkeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      templist = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant_menu),
            SizedBox(width: 10),
            Text('Food Recipe')
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
            ),
            child: SizedBox(
              height: 7 * size.height / 100,
              child: TextField(
                keyboardType: TextInputType.text,
                onChanged: (value) {
                  runfilter(value);
                },
                cursorColor: Colors.black,
                controller: searchController,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                  hintText: 'Seacrh for a recipe',
                  hintStyle: GoogleFonts.dmSans(
                    textStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff979797),
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: templist.length,
              itemBuilder: (context, index) {
                final recipe = templist[index];

                if (templist.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'You have no Recipes yet\nClick the button below to add a recipe',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  );
                } else {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecipeDetails(recipe),
                        ),
                      );
                    },
                    child: RecipeAssetCard(
                      title: recipe.title,
                      thumbnailUrl: recipe.imageUrl,
                      cookTime: recipe.cookTime,
                      rating: recipe.rateScore,
                    ),
                  );
                }

                // ListTile(
                //   title: Text(recipe.title),
                //   leading: CircleAvatar(
                //     backgroundImage: AssetImage(recipe.imageUrl),
                //   ),
                //   onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => RecipeDetails(recipe),
                //   ),
                // );
                //   },
                // );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipeCreation(),
            ),
          ).then((newRecipe) {
            if (newRecipe != null) {
              setState(() {
                recipes.add(newRecipe);
              });
            }
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class RecipeCreation extends StatefulWidget {
  @override
  _RecipeCreationState createState() => _RecipeCreationState();
}

class _RecipeCreationState extends State<RecipeCreation> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController ratingController = TextEditingController();
  TextEditingController cookController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Recipe'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Title',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Recipes',
                hintText: 'seperate each recipe with a comma',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: ratingController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Rate Score',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: cookController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Cook Time',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final newRecipe = Recipe(
                  titleController.text,
                  descriptionController.text,
                  'assets/pancake.jpg',
                  ratingController.text,
                  cookController.text,
                );
                Navigator.pop(context, newRecipe);
              },
              child: Text('Save Recipe'),
            ),
          ],
        ),
      ),
    );
  }
}

class RecipeDetails extends StatelessWidget {
  final Recipe recipe;

  RecipeDetails(this.recipe);

  @override
  Widget build(BuildContext context) {
    List<String> textList = recipe.description.split(',');
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe Details'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () {
                Share.share('check out this my recipies $recipe',
                    subject: 'Look what I made!');
              },
              child: Icon(
                Icons.share,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              recipe.title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 200,
                width: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage(recipe.imageUrl),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            for (String item in textList)
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                child: Row(
                  children: [
                    Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.deepPurple,
                      ),
                    ),
                    SizedBox(width: 30),
                    Text(
                      item.trim(),
                      style: GoogleFonts.aBeeZee(
                        textStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
