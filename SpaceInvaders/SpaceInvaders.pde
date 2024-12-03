import java.util.ArrayList; //<>//


class Asset {
  float x;
  float y;
  boolean enable;
  int _width;
  int _height;
  color _color;
  float speed;
  Asset(float x, float y, color _color) {
    this.x = x;
    this.y = y;
    this._color = _color;
    enable = true;
  }
}

class Player extends Asset {

  Player(float x, float y, color _color) {
    super(x, y, _color);
    super._width = 40;
    super._height = 20;
  }

  void draw() {
    if (enable) {
      fill(_color);
      rect(x, height - _width, _width, _height);
    }
  }
}

class Enemy extends Asset {


  Enemy(int x, int y, color _color) {
    super(x, y, _color);
    _width  = 30;
    _height = 20;
    speed = 1;
  }

  void draw() {
    if (enable) {
      fill(_color);
      rect(x, y, _width, _height);    
    }
  }

  void move() {    
      this.x += enemyDirection * speed;    
  }
}

class Bullet extends Asset {

  Bullet(float x, float y, color _color) {
    super(x, y, _color);
    _width=5;
    _height=5;
  }

  void Draw() {
    fill(255);
    ellipse(x, y, 5, 10);
    this.Move();
    this.BulletColision();
  }

  void Move() {
    y -= 5;
    if (y < 0) {
      this.enable = false;
    }
  }

  void BulletColision() {
    for (int i = 0; i < game.enemies.length; i++) {
      for (int j = 0; j < game.enemies[i].length; j++) {
        if (game.enemies[i][j].enable) {
          if (this.x > game.enemies[i][j].x
            && this.x < game.enemies[i][j].x + game.player._width
            && this.y > game.enemies[i][j].y
            && this.y < game.enemies[i][j].y + game.player._height) {
            game.enemies[i][j].enable = false;
            this.enable=false;
          }
        }
      }
    }
  }
}


class  Game {

  int score=0;
  int playerHeight = 20;
  Enemy[][] enemies;
  ArrayList<Bullet> bullets;
  Player player;
  int enemyWidth = 30;
  int enemyHeight = 20;

  float cooldownTime = 500; // Cooldown time in milliseconds
  float lastShotTime = 0; // Time of the last shot
  private int numHitWall=0;
  
  private final int enemySpeedY = 20;
  private final int numHitWallMax = 2;
  
  private Game() {
    enemies = new Enemy[5][5];
    bullets = new ArrayList<Bullet>();
    player = new Player(width/2, height - playerHeight, #0F91FF);
  }

  void increaseScore(int score) {
    this.score = score;
  }

  void drawPlayer() {
    player.draw();
  }


  void createEnemies() {
    // Inicializa os inimigos
    for (int i = 0; i < game.enemies.length; i++) {
      for (int j = 0; j < game.enemies[i].length; j++) {
        Enemy enemy = new Enemy(j * (enemyWidth + 10) + 30, i * (enemyHeight + 10) + 30, #FC0303);
        game.enemies[i][j] = enemy;
      }
    }
  }
  
  void drawEnemies() {
    enemyHitWall();
    for (int i = 0; i < enemies.length; i++) {
      for (int j = 0; j < enemies[i].length; j++) {
        enemies[i][j].draw();
        enemies[i][j].move();
      }
    }
  }

  void enemyHitWall() {
    int row = enemies.length-1;
    int col = enemies[row].length-1;
    if (enemies[0][0].x <= 0 || enemies[row][col].x + enemyWidth> width) {
      enemyDirection *= -1;
      numHitWall++;
    }
    if (numHitWall == numHitWallMax){
      increaseYCoordEnemies();
      numHitWall=0;  
    }
  }

  void increaseYCoordEnemies() {
    for (int i = 0; i < game.enemies.length; i++) {
      for (int j = 0; j < game.enemies[i].length; j++) {
        game.enemies[i][j].y += enemySpeedY;
     }
    }
  }

  void drawBullets() {
    for (int i = 0; i < bullets.size(); i++) {
      Bullet bullet = bullets.get(i);
      if (bullet.enable) {
        bullet.Draw();
      } else
        bullets.remove(i);
    }
  }

  void shoot() {
    if (bullets.size() <=5 && this.coolDownShoot()) {

      float bulletX = player.x + player._width / 2;
      float bulletY = player.y - player._height;

      Bullet bullet = new Bullet(bulletX, bulletY, 255);
      bullets.add(bullet);
    }
  }

  boolean coolDownShoot() {
    // Get the current time in milliseconds
    float currentTime = millis();
    if (currentTime - lastShotTime >= cooldownTime) {
      // Update the last shot time
      lastShotTime = currentTime;
      return true;
    } else {
      return false;
    }
  }
}



int playerX;


float enemySpeed = 0.05;
int enemyDirection = 1; // 1 para direita, -1 para esquerda

Game game;
void setup() {
  size(400, 800);
  game = new Game();
  game.createEnemies();
}

void draw() {
  background(0);

  game.drawEnemies();
  game.drawPlayer();
  game.drawBullets();
}


void keyPressed() {
  if (keyCode == LEFT) {
    game.player.x -= 10;
  } else if (keyCode == RIGHT) {
    game.player.x += 10;
  } else if (key == ' ') {
    game.shoot();
  }
}
