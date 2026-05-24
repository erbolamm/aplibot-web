import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

// Estados del juego
enum GameState { menu, playing, gameOver, win }

// Direcciones
enum Direction { right, down, left, up }

class PacManGame extends StatefulWidget {
  const PacManGame({super.key});

  @override
  State<PacManGame> createState() => _PacManGameState();
}

class _PacManGameState extends State<PacManGame> with TickerProviderStateMixin {
  static const int mazeWidth = 19;
  static const int mazeHeight = 21;

  GameState gameState = GameState.menu;
  int score = 0;
  int lives = 3;
  int highScore = 0;
  double gridSize = 0;

  bool powerPelletActive = false;
  Timer? powerPelletTimer;
  int ghostsEaten = 0;

  List<List<int>> maze = [];
  List<List<int>> originalMaze = [
    [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
    [1, 2, 2, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 2, 2, 1],
    [1, 3, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 3, 1],
    [1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1],
    [1, 2, 1, 1, 1, 2, 1, 2, 1, 1, 1, 2, 1, 2, 1, 1, 1, 2, 1],
    [1, 2, 2, 2, 2, 2, 1, 2, 2, 1, 2, 2, 1, 2, 2, 2, 2, 2, 1],
    [1, 1, 1, 1, 1, 2, 1, 1, 0, 1, 0, 1, 1, 2, 1, 1, 1, 1, 1],
    [0, 0, 0, 0, 1, 2, 1, 0, 0, 0, 0, 0, 1, 2, 1, 0, 0, 0, 0],
    [1, 1, 1, 1, 1, 2, 1, 0, 1, 0, 1, 0, 1, 2, 1, 1, 1, 1, 1],
    [0, 0, 0, 0, 0, 2, 0, 0, 1, 0, 1, 0, 0, 2, 0, 0, 0, 0, 0],
    [1, 1, 1, 1, 1, 2, 1, 0, 1, 1, 1, 0, 1, 2, 1, 1, 1, 1, 1],
    [0, 0, 0, 0, 1, 2, 1, 0, 0, 0, 0, 0, 1, 2, 1, 0, 0, 0, 0],
    [1, 1, 1, 1, 1, 2, 1, 1, 0, 1, 0, 1, 1, 2, 1, 1, 1, 1, 1],
    [1, 2, 2, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 2, 2, 1],
    [1, 2, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 2, 1],
    [1, 3, 2, 2, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 2, 2, 3, 1],
    [1, 1, 1, 2, 1, 2, 1, 2, 1, 1, 1, 2, 1, 2, 1, 2, 1, 1, 1],
    [1, 2, 2, 2, 2, 2, 1, 2, 2, 1, 2, 2, 1, 2, 2, 2, 2, 2, 1],
    [1, 2, 1, 1, 1, 1, 1, 1, 2, 1, 2, 1, 1, 1, 1, 1, 1, 2, 1],
    [1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1],
    [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
  ];

  Player player = Player();
  List<Ghost> ghosts = [];

  late AnimationController mouthController;
  late AnimationController gameController;
  Timer? gameTimer;
  int totalDots = 0;

  @override
  void initState() {
    super.initState();
    mouthController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    )..repeat(reverse: true);

    gameController = AnimationController(
      duration: const Duration(milliseconds: 50),
      vsync: this,
    );

    initializeGame();
  }

  void initializeGame() {
    maze = originalMaze.map((row) => List<int>.from(row)).toList();
    totalDots = 0;
    for (var row in maze) {
      for (var cell in row) {
        if (cell == 2 || cell == 3) totalDots++;
      }
    }
    player = Player();
    ghosts = [
      Ghost(x: 9.0, y: 9.0, color: Colors.red, direction: Direction.up),
      Ghost(x: 8.0, y: 9.0, color: Colors.pinkAccent, direction: Direction.down),
      Ghost(x: 10.0, y: 9.0, color: Colors.cyanAccent, direction: Direction.left),
      Ghost(x: 9.0, y: 8.0, color: Colors.orange, direction: Direction.right),
    ];
    powerPelletActive = false;
    powerPelletTimer?.cancel();
    ghostsEaten = 0;
  }

  void startGame() {
    setState(() {
      gameState = GameState.playing;
      score = 0;
      lives = 3;
    });
    initializeGame();
    startGameLoop();
  }

  void startGameLoop() {
    gameTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (gameState == GameState.playing) {
        updateGame();
      }
    });
  }

  void updateGame() {
    movePlayer();
    moveGhosts();
    checkCollisions();
    collectDots();
    checkWinCondition();
    setState(() {});
  }

  void movePlayer() {
    double newX = player.x;
    double newY = player.y;

    switch (player.nextDirection) {
      case Direction.right: newX += 0.2; break;
      case Direction.down:  newY += 0.2; break;
      case Direction.left:  newX -= 0.2; break;
      case Direction.up:    newY -= 0.2; break;
    }

    if (!isWall(newX, newY)) {
      player.direction = player.nextDirection;
      player.x = newX;
      player.y = newY;
    } else {
      newX = player.x;
      newY = player.y;
      switch (player.direction) {
        case Direction.right: newX += 0.2; break;
        case Direction.down:  newY += 0.2; break;
        case Direction.left:  newX -= 0.2; break;
        case Direction.up:    newY -= 0.2; break;
      }
      if (!isWall(newX, newY)) {
        player.x = newX;
        player.y = newY;
      }
    }
    if (player.x < 0) player.x = mazeWidth - 1;
    if (player.x >= mazeWidth) player.x = 0;
  }

  void moveGhosts() {
    for (var ghost in ghosts) {
      if (ghost.isScared) {
        ghost.moveAway(maze, mazeWidth, mazeHeight, player.x, player.y);
      } else {
        ghost.move(maze, mazeWidth, mazeHeight);
      }
    }
  }

  bool isWall(double x, double y) {
    int gridX = x.round();
    int gridY = y.round();
    if (gridX < 0 || gridX >= mazeWidth || gridY < 0 || gridY >= mazeHeight) return true;
    return maze[gridY][gridX] == 1;
  }

  void collectDots() {
    int gridX = player.x.round();
    int gridY = player.y.round();
    if (gridX >= 0 && gridX < mazeWidth && gridY >= 0 && gridY < mazeHeight) {
      int cell = maze[gridY][gridX];
      if (cell == 2) { maze[gridY][gridX] = 0; score += 10; }
      else if (cell == 3) { maze[gridY][gridX] = 0; score += 50; activatePowerPellet(); }
      if (score > highScore) highScore = score;
    }
  }

  void activatePowerPellet() {
    powerPelletActive = true;
    ghostsEaten = 0;
    for (var ghost in ghosts) { ghost.isVulnerable = true; ghost.isScared = true; }
    powerPelletTimer?.cancel();
    powerPelletTimer = Timer(const Duration(seconds: 8), () {
      powerPelletActive = false;
      for (var ghost in ghosts) { ghost.isVulnerable = false; ghost.isScared = false; }
      setState(() {});
    });
    setState(() {});
  }

  void checkCollisions() {
    for (int i = 0; i < ghosts.length; i++) {
      var ghost = ghosts[i];
      double distance = sqrt(pow(player.x - ghost.x, 2) + pow(player.y - ghost.y, 2));
      if (distance < 0.8) {
        if (ghost.isVulnerable) {
          int points = 100 * pow(2, ghostsEaten).toInt();
          score += points;
          ghostsEaten++;
          ghost.x = 9.0; ghost.y = 9.0;
          ghost.isVulnerable = false; ghost.isScared = false;
          if (score > highScore) highScore = score;
        } else {
          lives--;
          if (lives <= 0) gameOver();
          else { player.x = 9.0; player.y = 15.0; player.direction = Direction.right; player.nextDirection = Direction.right; }
          break;
        }
      }
    }
  }

  void checkWinCondition() {
    int remainingDots = 0;
    for (var row in maze) { for (var cell in row) { if (cell == 2 || cell == 3) remainingDots++; } }
    if (remainingDots == 0) win();
  }

  void gameOver() { setState(() => gameState = GameState.gameOver); gameTimer?.cancel(); }
  void win() { setState(() => gameState = GameState.win); gameTimer?.cancel(); }
  void resetGame() { gameTimer?.cancel(); setState(() => gameState = GameState.menu); }
  void setPlayerDirection(Direction direction) { if (gameState == GameState.playing) player.nextDirection = direction; }

  @override
  void dispose() {
    mouthController.dispose();
    gameController.dispose();
    gameTimer?.cancel();
    powerPelletTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Pac-Man', style: TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue[900],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.yellow),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(child: buildGameScreen()),
    );
  }

  Widget buildGameScreen() {
    switch (gameState) {
      case GameState.menu: return buildMenuScreen();
      case GameState.playing: return buildPlayingScreen();
      case GameState.gameOver: return buildGameOverScreen();
      case GameState.win: return buildWinScreen();
    }
  }

  Widget buildMenuScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('PAC-MAN', style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.yellow, fontFamily: 'monospace')),
          const SizedBox(height: 16),
          const Text('RETRO EDITION', style: TextStyle(fontSize: 20, color: Colors.cyanAccent, fontFamily: 'monospace')),
          const SizedBox(height: 32),
          Text('High Score: $highScore', style: const TextStyle(fontSize: 18, color: Colors.white, fontFamily: 'monospace')),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: startGame,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellow, foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            child: const Text('START GAME'),
          ),
          const SizedBox(height: 16),
          const Text('Use arrow buttons to move', style: TextStyle(fontSize: 14, color: Colors.grey, fontFamily: 'monospace')),
        ],
      ),
    );
  }

  Widget buildPlayingScreen() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Score: $score', style: const TextStyle(fontSize: 16, color: Colors.yellow, fontFamily: 'monospace')),
              Text('High: $highScore', style: const TextStyle(fontSize: 16, color: Colors.cyanAccent, fontFamily: 'monospace')),
              Text('${"❤️" * lives}', style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
        Expanded(
          child: Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                double maxWidth = constraints.maxWidth;
                double maxHeight = constraints.maxHeight;
                gridSize = min(maxWidth / mazeWidth, maxHeight / mazeHeight);
                return Container(
                  width: gridSize * mazeWidth,
                  height: gridSize * mazeHeight,
                  decoration: BoxDecoration(border: Border.all(color: Colors.blue, width: 2)),
                  child: CustomPaint(
                    painter: GamePainter(maze: maze, player: player, ghosts: ghosts, mouthAnimation: mouthController, gridSize: gridSize),
                    size: Size(gridSize * mazeWidth, gridSize * mazeHeight),
                  ),
                );
              },
            ),
          ),
        ),
        buildControls(),
      ],
    );
  }

  Widget buildControls() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () => setPlayerDirection(Direction.up),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow[700], minimumSize: const Size(60, 60)),
            child: const Icon(Icons.keyboard_arrow_up, color: Colors.black, size: 30),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => setPlayerDirection(Direction.left),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow[700], minimumSize: const Size(60, 60)),
                child: const Icon(Icons.keyboard_arrow_left, color: Colors.black, size: 30),
              ),
              const SizedBox(width: 60),
              ElevatedButton(
                onPressed: () => setPlayerDirection(Direction.right),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow[700], minimumSize: const Size(60, 60)),
                child: const Icon(Icons.keyboard_arrow_right, color: Colors.black, size: 30),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => setPlayerDirection(Direction.down),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow[700], minimumSize: const Size(60, 60)),
            child: const Icon(Icons.keyboard_arrow_down, color: Colors.black, size: 30),
          ),
        ],
      ),
    );
  }

  Widget buildGameOverScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('GAME OVER', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.red, fontFamily: 'monospace')),
          const SizedBox(height: 16),
          Text('Final Score: $score', style: const TextStyle(fontSize: 24, color: Colors.yellow, fontFamily: 'monospace')),
          if (score == highScore) const Text('NEW HIGH SCORE!', style: TextStyle(fontSize: 18, color: Colors.cyanAccent, fontFamily: 'monospace')),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: resetGame,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16)),
            child: const Text('PLAY AGAIN', style: TextStyle(fontSize: 18, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget buildWinScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('YOU WIN!', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.green, fontFamily: 'monospace')),
          const SizedBox(height: 16),
          Text('Final Score: $score', style: const TextStyle(fontSize: 24, color: Colors.yellow, fontFamily: 'monospace')),
          if (score == highScore) const Text('NEW HIGH SCORE!', style: TextStyle(fontSize: 18, color: Colors.cyanAccent, fontFamily: 'monospace')),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: resetGame,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16)),
            child: const Text('PLAY AGAIN', style: TextStyle(fontSize: 18, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class Player {
  double x = 9.0;
  double y = 15.0;
  Direction direction = Direction.right;
  Direction nextDirection = Direction.right;
}

class Ghost {
  double x;
  double y;
  Color color;
  Direction direction;
  Random random = Random();
  bool isVulnerable = false;
  bool isScared = false;

  Ghost({required this.x, required this.y, required this.color, required this.direction});

  void move(List<List<int>> maze, int mazeWidth, int mazeHeight) {
    List<Direction> possibleDirections = [];
    if (x > 0 && maze[y.round()][(x - 0.3).round()] != 1) possibleDirections.add(Direction.left);
    if (x < mazeWidth - 1 && maze[y.round()][(x + 0.3).round()] != 1) possibleDirections.add(Direction.right);
    if (y > 0 && maze[(y - 0.3).round()][x.round()] != 1) possibleDirections.add(Direction.up);
    if (y < mazeHeight - 1 && maze[(y + 0.3).round()][x.round()] != 1) possibleDirections.add(Direction.down);

    if (!possibleDirections.contains(direction) || random.nextInt(20) == 0) {
      if (possibleDirections.isNotEmpty) direction = possibleDirections[random.nextInt(possibleDirections.length)];
    }

    switch (direction) {
      case Direction.right: if (possibleDirections.contains(Direction.right)) x += 0.15; break;
      case Direction.down:  if (possibleDirections.contains(Direction.down))  y += 0.15; break;
      case Direction.left:  if (possibleDirections.contains(Direction.left))  x -= 0.15; break;
      case Direction.up:    if (possibleDirections.contains(Direction.up))    y -= 0.15; break;
    }
    if (x < 0) x = mazeWidth - 1;
    if (x >= mazeWidth) x = 0;
  }

  void moveAway(List<List<int>> maze, int mazeWidth, int mazeHeight, double playerX, double playerY) {
    List<Direction> possibleDirections = [];
    if (x > 0 && maze[y.round()][(x - 0.3).round()] != 1) possibleDirections.add(Direction.left);
    if (x < mazeWidth - 1 && maze[y.round()][(x + 0.3).round()] != 1) possibleDirections.add(Direction.right);
    if (y > 0 && maze[(y - 0.3).round()][x.round()] != 1) possibleDirections.add(Direction.up);
    if (y < mazeHeight - 1 && maze[(y + 0.3).round()][x.round()] != 1) possibleDirections.add(Direction.down);

    if (possibleDirections.isEmpty) return;
    Direction bestDirection = possibleDirections[0];
    double maxDistance = 0;
    for (var dir in possibleDirections) {
      double testX = x, testY = y;
      switch (dir) { case Direction.left: testX -= 0.15; break; case Direction.right: testX += 0.15; break; case Direction.up: testY -= 0.15; break; case Direction.down: testY += 0.15; break; }
      double distance = sqrt(pow(testX - playerX, 2) + pow(testY - playerY, 2));
      if (distance > maxDistance) { maxDistance = distance; bestDirection = dir; }
    }
    direction = bestDirection;
    switch (direction) { case Direction.right: x += 0.15; break; case Direction.down: y += 0.15; break; case Direction.left: x -= 0.15; break; case Direction.up: y -= 0.15; break; }
    if (x < 0) x = mazeWidth - 1;
    if (x >= mazeWidth) x = 0;
  }
}

class GamePainter extends CustomPainter {
  final List<List<int>> maze;
  final Player player;
  final List<Ghost> ghosts;
  final AnimationController mouthAnimation;
  final double gridSize;

  GamePainter({required this.maze, required this.player, required this.ghosts, required this.mouthAnimation, required this.gridSize});

  @override
  void paint(Canvas canvas, Size size) {
    drawMaze(canvas);
    drawGhosts(canvas);
    drawPlayer(canvas);
  }

  void drawMaze(Canvas canvas) {
    for (int y = 0; y < maze.length; y++) {
      for (int x = 0; x < maze[y].length; x++) {
        double pixelX = x * gridSize;
        double pixelY = y * gridSize;
        switch (maze[y][x]) {
          case 1:
            canvas.drawRect(Rect.fromLTWH(pixelX, pixelY, gridSize, gridSize), Paint()..color = Colors.blue);
            break;
          case 2:
            canvas.drawCircle(Offset(pixelX + gridSize / 2, pixelY + gridSize / 2), gridSize * 0.12, Paint()..color = Colors.yellow);
            break;
          case 3:
            canvas.drawCircle(Offset(pixelX + gridSize / 2, pixelY + gridSize / 2), gridSize * 0.32, Paint()..color = Colors.yellow);
            break;
        }
      }
    }
  }

  void drawPlayer(Canvas canvas) {
    double pixelX = player.x * gridSize + gridSize / 2;
    double pixelY = player.y * gridSize + gridSize / 2;
    Paint playerPaint = Paint()..color = Colors.yellow;
    canvas.drawCircle(Offset(pixelX, pixelY), gridSize / 2 - 2, playerPaint);

    Paint mouthPaint = Paint()..color = Colors.black;
    double mouthAngle = mouthAnimation.value * 60;
    double startAngle = 0;
    switch (player.direction) {
      case Direction.right: startAngle = -mouthAngle / 2 * (pi / 180); break;
      case Direction.down:  startAngle = (90 - mouthAngle / 2) * (pi / 180); break;
      case Direction.left:  startAngle = (180 - mouthAngle / 2) * (pi / 180); break;
      case Direction.up:    startAngle = (270 - mouthAngle / 2) * (pi / 180); break;
    }
    canvas.drawArc(Rect.fromCircle(center: Offset(pixelX, pixelY), radius: gridSize / 2 - 2), startAngle, mouthAngle * (pi / 180), true, mouthPaint);
  }

  void drawGhosts(Canvas canvas) {
    for (var ghost in ghosts) {
      double pixelX = ghost.x * gridSize;
      double pixelY = ghost.y * gridSize;
      Color ghostColor = ghost.isVulnerable ? Colors.blue : ghost.color;
      Paint ghostPaint = Paint()..color = ghostColor;
      Path ghostPath = Path();
      ghostPath.addRRect(RRect.fromRectAndCorners(Rect.fromLTWH(pixelX + 2, pixelY + 2, gridSize - 4, gridSize - 4),
          topLeft: Radius.circular(gridSize / 2), topRight: Radius.circular(gridSize / 2)));
      canvas.drawPath(ghostPath, ghostPaint);

      Paint eyePaint = Paint()..color = Colors.white;
      Paint pupilPaint = Paint()..color = Colors.black;
      canvas.drawCircle(Offset(pixelX + gridSize * 0.32, pixelY + gridSize * 0.32), gridSize * 0.12, eyePaint);
      canvas.drawCircle(Offset(pixelX + gridSize * 0.32, pixelY + gridSize * 0.32), gridSize * 0.06, pupilPaint);
      canvas.drawCircle(Offset(pixelX + gridSize * 0.68, pixelY + gridSize * 0.32), gridSize * 0.12, eyePaint);
      canvas.drawCircle(Offset(pixelX + gridSize * 0.68, pixelY + gridSize * 0.32), gridSize * 0.06, pupilPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
