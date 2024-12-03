import java.util.ArrayList; //<>//


class Asset {
  float x;
  float y;
  boolean enable;
  int _width;
  int _height;
  color _color;

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

  void Draw() {
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
  }

  void Draw() {
    if (enable) {
      fill(_color);
      rect(x, y, _width, _height);
    }
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

  float cooldownTime = 500; // Cooldown time in milliseconds
  float lastShotTime = 0; // Time of the last shot

  private Game() {
    enemies = new Enemy[5][5];
    bullets = new ArrayList<Bullet>();
    player = new Player(width/2, height - playerHeight, #0F91FF);
  }

  void increaseScore(int score) {
    this.score = score;
  }

  void DrawPlayer() {
    player.Draw();
  }

  void DrawEnemies() {
    for (int i = 0; i < enemies.length; i++) {
      for (int j = 0; j < enemies[i].length; j++) {
        enemies[i][j].Draw();
      }
    }
  }

  void DrawBullets() {
    for (int i = 0; i < bullets.size(); i++) {
      Bullet bullet = bullets.get(i);
      if (bullet.enable) {
        bullet.Draw();
      } else
        bullets.remove(i);
    }
  }

  void Shoot() {
    if (bullets.size() <=5 && this.CoolDownShoot()) {

      float bulletX = player.x + player._width / 2;
      float bulletY = player.y - player._height;

      Bullet bullet = new Bullet(bulletX, bulletY, 255);
      bullets.add(bullet);
    }
  }

  boolean CoolDownShoot() {
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

int enemyWidth = 30;
int enemyHeight = 20;
int enemySpeed = 2;
int enemyDirection = 1; // 1 para direita, -1 para esquerda

Game game;
void setup() {
  size(400, 400);
  game = new Game();
  // Inicializa os inimigos
  for (int i = 0; i < game.enemies.length; i++) {
    for (int j = 0; j < game.enemies[i].length; j++) {
      Enemy enemy = new Enemy(j * (enemyWidth + 10) + 30, i * (enemyHeight + 10) + 30, #FC0303);
      game.enemies[i][j] = enemy;
    }
  }
}

void draw() {
  background(0);

  game.DrawEnemies();
  game.DrawPlayer();
  game.DrawBullets();
}


void keyPressed() {
  if (keyCode == LEFT) {
    game.player.x -= 10;
  } else if (keyCode == RIGHT) {
    game.player.x += 10;
  } else if (key == ' ') {
    game.Shoot();
  }
}

void moveEnemies() {
  boolean hitWall = false;
  for (int i = 0; i < game.enemies.length; i++) {
    for (int j = 0; j < game.enemies[i].length; j++) {
      if (game.enemies[i][j].enable) {
        if (j * (enemyWidth + 10) + 30 + enemyWidth >= width || j * (enemyWidth + 10) + 30 <= 0) {
          hitWall = true;
        }
      }
    }
  }

  if (hitWall) {
    enemyDirection *= -1;
    for (int i = 0; i < game.enemies.length; i++) {
      for (int j = 0; j < game.enemies[i].length; j++) {
        if (game.enemies[i][j].enable) {
          game.enemies[i][j].enable = false; // Remove o inimigo
        }
      }
    }
  }

  for (int i = 0; i < game.enemies.length; i++) {
    for (int j = 0; j < game.enemies[i].length; j++) {
      if (game.enemies[i][j].enable) {
        game.enemies[i][j].enable = true; // Mantém o inimigo
      }
    }
  }
}
