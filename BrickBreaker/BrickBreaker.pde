PImage brick, paddle;
int posPlayerX,posPlayerY,posRoadY;

// Variáveis para a bola
float ballX, ballY, ballSpeedX, ballSpeedY, ballDiameter;

// Variáveis para o paddle
float paddleX, paddleY, paddleWidth, paddleHeight, paddleSpeed;

// Variáveis para os blocos (bricks)
int rows = 5, cols = 8;
float brickWidth, brickHeight;
boolean[][] bricks; // Matriz para controlar quais blocos ainda estão ativos



void setup() {
  size(400, 400);
  
  brick = loadImage("01-Breakout-Tiles.png");
  paddle = loadImage("49-Breakout-Tiles.png");
  
  // Cria a bola
  ballX = width/2;
  ballY = height/2;
  ballSpeedX = 3;
  ballSpeedY = 3;
  ballDiameter = 20;
  
  // Cria o paddle
  paddleWidth = 80;
  paddleHeight = 21;
  paddleX = (width - paddleWidth) / 2;
  paddleY = height - 30;
  paddleSpeed = 6;
  
  // Cria os blocos
  brickWidth = 50;
  brickHeight = 17;
  bricks = new boolean[rows][cols];
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      bricks[i][j] = true; // Todos os blocos começam como ativos
    }
  }
}

void draw() {
  background(0);
  
  // Desenha e move a bola
  fill(255);
  ellipse(ballX, ballY, ballDiameter, ballDiameter);
  ballX += ballSpeedX;
  ballY += ballSpeedY;
  
  // Verifica a colisão com as laterais do ecra
  if (ballX < ballDiameter/2 || ballX > width - ballDiameter/2) {
    ballSpeedX *= -1; // Rebate nas laterais
  }
  if (ballY < ballDiameter/2) {
    ballSpeedY *= -1; // Rebate no topo
  }
  
  // Verifica a colisão com o paddle
  if (ballY + ballDiameter/2 >= paddleY && ballX > paddleX && ballX < paddleX + paddleWidth) {
    ballSpeedY *= -1; // Rebate no paddle
  }
  
  // Verifica se a bola caiu fora
  if (ballY > height) {
    ballX = width/2;
    ballY = height/2;
    ballSpeedX = 3;
    ballSpeedY = 3;
    // Reinicia o jogo ao perder
  }
  
  image(paddle, paddleX, paddleY);

  // Controlo do paddle
  if (keyPressed) {
    if (key == 'a' || key == 'A') {
      paddleX -= paddleSpeed;
    } else if (key == 'd' || key == 'D') {
      paddleX += paddleSpeed;
    }
  }
  
  // Limita o movimento do paddle aos limites da tela
  paddleX = constrain(paddleX, 0, width - paddleWidth);
  
  // Desenha os blocos
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      if (bricks[i][j]) {
        image(brick, j * brickWidth, i * brickHeight);

        // Verifica colisão da bola com os blocos
        if (ballX > j * brickWidth && ballX < (j + 1) * brickWidth &&
            ballY - ballDiameter/2 < (i + 1) * brickHeight && ballY + ballDiameter/2 > i * brickHeight) {
          bricks[i][j] = false; // Qebra um brick
          ballSpeedY *= -1; // Rebate a bola
        }
      }
    }
  }
}
