// classe Recurso
class Recurso {
  PVector cord;
  color cor;
}

// classe Cobra que é uma subclasse da classe Recurso 
class Cobra extends Recurso {

  ArrayList<PVector> corpo;
  PVector  direcao;
  float  tamanho;
  PVector lastPos;
  PVector headPos;
  
  // construtor da classe Cobra
  Cobra() {
    this.corpo = new ArrayList<PVector>();     // Cria o corpo da cobra
    this.cord = new PVector();
    this.cord.x = width/2;
    this.cord.y = height/2;
    this.corpo.add(cord);  // adiciona a primeira coordenada à cobra  
    rect(this.cord.x, this.cord.y, 20, 20); // desenha o primeiro quadrado do corpo da cobra no centro do ecrã
    direcao = new PVector(1, 0); // direcao inicial para a direita 
  }
  
  // método que faz a cobra mudar de direção
  void mudarDirecao(float x, float y) {    
    // não deixa a cobra fazer "inversão de marcha", isto é ter como nova direção a direção oposta 
    if (direcao.x != -x || direcao.y != -y)     
      direcao = new PVector(x, y);
  }

  void mover() {

    headPos = corpo.get(0);
    lastPos = new PVector(headPos.x, headPos.y);
    PVector newHead = new PVector(headPos.x, headPos.y);
    
    // move para a direita
    if (direcao.x == 1) {
      newHead.x +=20;

      // move para a esquerda
    } else if (direcao.x == -1) {
      newHead.x -=20;

      //move para cima
    } else if (direcao.y == 1) {
      newHead.y +=20;

      // move para baixo
    } else if (direcao.y == -1) {
      newHead.y -=20;
    }
    // o código anterior calcula as novas coordenadas da cabeça da cobra    
    corpo.add(0, newHead); // adiciona uma "nova" cabeça à cobra com as novas coordenadas
    corpo.remove(corpo.size() - 1); // remove o último quadrado da cauda
    headPos = corpo.get(0); // guardo a nova posição da cabeça da cobra
  }

  // desenha a cobra
  void desenhar() {
    fill(this.cor); // configura a cor da cobra
    for (PVector quadrado : corpo) { // percorre todos os quadrados que compõem a cobra
      rect(quadrado.x, quadrado.y, 20, 20); // desenha cada um dos quadrados     
    }
  }

  // calcula a direção atual da cobra
  PVector dirVelocidade() {
    
    if (direcao.x >0) { // direita
      return new PVector(1, 0);
    } else if (direcao.x <0) { // esquerda

      return new PVector(-1, 0);
    } else if (direcao.y <0) { // cima

      return new PVector(0, -1);
    } else if (direcao.y >0) { // baixo

      return new PVector(0, 1);
    } else return new PVector(0, 0);
  }

  void comer() {
    // verfico se estou a colidir com a comida
    if (this.headPos.x >= comida.cord.x && this.headPos.x <= comida.cord.x + DimensaoQuadrado/2 &&
      (this.headPos.y >= comida.cord.y && this.headPos.y <= comida.cord.y + DimensaoQuadrado/2)) {
      
      int lastIndex= corpo.size()-1;
      PVector novoQuadrado = new PVector(corpo.get(lastIndex).x + dirVelocidade().x *20, corpo.get(lastIndex).y + dirVelocidade().y *20);
      corpo.add(novoQuadrado);
      this.cor = comida.cor;
      comida = new Comida();
    }
  }

  // morre
  void morrer() {
    noLoop();
  }

  // verifica se colide com os limites da área de jogo
  void checkFronteiras() {
    PVector cord = corpo.get(0); // retorna as cordenadas da cabeça
    // verifica se as coordenadas ultrapassaram os limites 
    if (cord.x+10 > width || cord.x < 10 || cord.y+10 > height || cord.y <  10) 
      morrer();
  }
}

class Comida extends Recurso {

  // Construtor é aquele que cria a comida
  Comida() {
    this.cord = new PVector();
    
    this.cord.x = numeroAleatorio(60, width-60); //gera um nº aleatório com uma margem de 60p aos limites 
    this.cord.y = numeroAleatorio(60, height-60);
    //this.cord.y = int(random(11)) * 20; 
    this.cor = color(random(255), random(255), random(255)); // gera uma cor aleatória
    fill(this.cor);
    rect(this.cord.x, this.cord.y, 20, 20); // desenha a comida com uma cor
  }

  void desenhar() {
    fill(this.cor);
    rect(this.cord.x, this.cord.y, 20, 20);
  }

  private int numeroAleatorio(int min, int max) {

    // Ajusta min para o próximo múltiplo de 20 se necessário
    int lowerBound = (min + 19) / 20 * 20;
    // Ajusta max para o maior múltiplo de 20 se necessário
    int upperBound = (max / 20) * 20;

    // Verifica se há múltiplos de 20 no intervalo
    if (lowerBound > upperBound) {
      println("Não há múltiplos de 20 no intervalo especificado.");
      return -1; // Retorna -1 para indicar que não há múltiplos
    }

    // Calcula quantos múltiplos de 20 existem entre lowerBound e upperBound
    int count = (upperBound - lowerBound) / 20 + 1;
    int randomIndex = int(random(count)); // Gera um índice aleatório
    return lowerBound + randomIndex * 20; // Retorna o múltiplo de 20
  }
}

// declara um variável global para a cobra
Cobra cobra;
// declara um variável global para a comida

Comida comida;

int DimensaoQuadrado = 20;
void setup() {
  frameRate(5);
  background(255);
  rectMode(CENTER);
  size(620, 620);
  fill(#898787);
  cobra = new Cobra();
  comida = new Comida();
}

void draw() {
  background(255);
  cobra.mover();
  cobra.desenhar();
  comida.desenhar();
  cobra.checkFronteiras();
  cobra.comer();
}

void keyPressed() {

  if (keyCode == UP) {
    cobra.mudarDirecao(0, -1); // Muda direção para
  } else if (keyCode == DOWN) {
    cobra.mudarDirecao(0, 1);
  } else if (keyCode == LEFT) {
    cobra.mudarDirecao(-1, 0);
  } else if (keyCode == RIGHT) {
    cobra.mudarDirecao(1, 0);
  }
}
