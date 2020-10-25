
class Block {
  float xpos, ypos, blockwidth;
  float blockheight = 40;
  color c;
  
  Block(float x, float y, float z){ 
    xpos = x;
    ypos = y;
    blockwidth = z;
    c = color(random(255), random(255), random(255));
  }
  
  void display(){
    noStroke();
    fill(c);
    rect(xpos, ypos, blockwidth, blockheight); // Height is 40.  
  }
  
}

int score = 0;
float speed = 5;
boolean game = true;
Block obj = new Block(0, 760, 150);
ArrayList<Block> placed = new ArrayList<Block>();

void setup(){
  size(400, 800);
}

void update(){
 obj.xpos = obj.xpos + speed;
 // Update the obj box coordinates and return back from the walls
 if (obj.xpos + obj.blockwidth > width || obj.xpos < 0){
   speed = speed * -1;
 }
 obj.display();
 if (placed.size() > 0){
   for (int i = 0; i < placed.size(); i = i+1){
     placed.get(i).display();
   }
 }
}  

void printScore(){
  // score shown in the middle of the game
  textSize(30);
  text("Score: " + score, 20, 50);
  fill(0);
}

void printOver(){
  // display of score after the game ends
  fill(0);
  textSize(30);
  text("Game Over!", 20, 50);
  fill(0);
  textSize(30);
  text("Final Score: " + (score - 2), 20, 80);
}

void stackBlock(){
  
  placed.add(obj);
  Block last = placed.get(placed.size()-1); // Used to be the obj of block. Now top of the 'stack,' and
                                            // the new obj of block has not been created yet.
  float xa1 = last.xpos;
  float xa2 = last.xpos + last.blockwidth;
  if (placed.size() > 1 ){
   float xb1 = placed.get(placed.size() - 2).xpos;
   float xb2 = placed.get(placed.size() - 2).xpos + placed.get(placed.size() - 2).blockwidth;
   // we have the 'ends' of both blocks. Considering that the obj block is the same size as the block beneath it.
   if (xa2 <= xb1 || xa1 >= xb2){
     // OUT OF BOUNDS, FAILED TO STACK - GAME OVER
     speed = 0;
     game = false;
   }
   else if (xa1 < xb1 && xa2 > xb1){
     // removing extra block on the left
     last.blockwidth = last.blockwidth - (xb1 - xa1);
     last.xpos = placed.get(placed.size() - 2).xpos;
   }
   else if (xa2 > xb2 && xa1 < xb2){
     // removing extra block on the right
     last.blockwidth = last.blockwidth - (xa2 - xb2);
   }
  }
  if (game){ obj = new Block(last.xpos, last.ypos - 40, last.blockwidth); }
  score = score + 1;
  // Preserve the direction of the moving block
  if (speed < 0){ speed -= 1; }
  if (speed > 0){ speed += 1; }
}           

void draw(){
  background(255);
  update();
  if (!game){ printOver(); }
  else { printScore(); }
}

void mouseClicked(){
  if (game){ stackBlock(); }
}
