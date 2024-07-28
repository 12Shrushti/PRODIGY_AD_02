import 'package:flutter/material.dart';
import 'package:tic_tac_toe/color.dart';
import 'package:tic_tac_toe/game_logic.dart';


void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GameScreen(),
    );
  }
}
class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);
  @override
  _GameScreenState createState() => _GameScreenState();
}
class _GameScreenState extends State<GameScreen> {
  // adding the necessary variables
  String lastValue = "X";
  bool gameOver = false;
  int turn = 0; // to check the draw
  String result = "";
  List<int> scoreboard = [
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0
  ];
  // the score are for the different combination
  // of the game [Row1,2,3, Col1,2,3, Diagonal1,2];
  // let's declare a new Game components
  Game game = Game();
  // let's initi the GameBoard
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    game.board = Game.initGameBoard();
    print(game.board);
  }
  @override
  Widget build(BuildContext context) {
    double boardWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: MainColor.color,
        body:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              ""
                  "${lastValue} turn".toUpperCase(),
              style: TextStyle(
                color: Colors.deepPurpleAccent,
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            // now we will make the game board
            // but first we will create a Game class
            // that will contains all the data
            // and method that we will need
            Container(
              width: boardWidth,
              height: boardWidth,
              child: GridView.count(
                crossAxisCount: Game.boardlenth ~/
                    3, // the ~/ operator allows you to evide to integer and return an Int as a result
                padding: EdgeInsets.all(16.0),
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
                children: List.generate(Game.boardlenth, (index) {
                  return InkWell(
                    onTap: gameOver
                        ? null
                        : () {
                      // when we click we need to add the new value
                      // to the board and refrech the screen
                      // we need also to toggle the player
                      // now we need to apply the click only if the field is empty
                      // now let's create a button to repeat the game
                      if (game.board![index] == "") {
                        setState(() {
                          game.board![index] = lastValue;
                          turn++;
                          gameOver = game.winnerCheck(
                              lastValue, index, scoreboard, 3);

                          if (gameOver) {
                            result = "$lastValue is the Winner";
                          } else if (!gameOver && turn == 9) {
                            result = " It's a Draw! ";
                            gameOver = true;
                          }
                          if (lastValue == "X")
                            lastValue = "O";
                          else
                            lastValue = "X";
                        });
                      }
                    },
                    child: Container(
                      width: Game.blocSize,
                      height: Game.blocSize,
                      decoration: BoxDecoration(
                        color: MainColor.secondaryColor,
                        borderRadius: BorderRadius.circular(25.0),

                      ),
                      child: Center(
                        child: Text(
                          game.board![index],
                          style: TextStyle(
                            color: game.board![index] == "X"
                                ? Colors.redAccent
                                : Colors.yellowAccent,
                            fontSize: 64.0,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              result,
              style: TextStyle(color: Colors.pink, fontSize: 44.0),
            ),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  // erase the board
                  game.board = Game.initGameBoard();
                  lastValue = "X";
                  gameOver = false;
                  turn = 0;
                  result = "";
                  scoreboard = [0, 0, 0, 0, 0, 0, 0, 0];
                });
              },
              icon: Icon(Icons.replay),
              label: Text("RESTART"),
            ),
          ],
        ));
    // the first step is organise
    // our project folder structure
  }
}