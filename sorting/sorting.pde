PFont f;
ArrayList<Element> array = new ArrayList<Element>();
ArrayList<PVector> indexedPos = new ArrayList<PVector>();
int elemSize = 100;
InsertionSort sortFunc;

void setup(){
  size(800,800);
  f = createFont("Arial",16,true);
  color bcolor = color(255,0,0);
  
  for (int i = 5; i>0; --i){
    indexedPos.add(new PVector(width-(elemSize+10)*i , 10)); 
  }
  for (int i = 0; i<indexedPos.size(); ++i){
    array.add(new Element(5-i, elemSize, indexedPos.get(i), bcolor));
  }
  sortFunc = new InsertionSort();
}

void draw(){
 initScreen(); 
}

void initScreen(){
 background(255);
 blockHandler();
}

void blockHandler(){
  for(int i = 0; i<array.size(); ++i){
    array.get(i).drawElem();
  }
}

void keyPressed(){
  if(key == CODED){
   if(keyCode == RIGHT){
      sortFunc.play();
   }
  }
}

class Element{
  int blockSize;
  int blockValue; 
  color blockColor;
  PVector position;
  
 public Element(int value, int size, PVector pos, color c){
   blockSize = size;
   blockValue = value;
   blockColor = c;
   position = new PVector(pos.x,pos.y);
 }
 void drawElem(){
     fill(blockColor);
     rectMode(CORNER);
     rect(position.x, position.y,blockSize, blockSize);
     fill(0);
     textFont(f,20);
     text(""+blockValue+ " at "+position.x+" "+position.y, position.x, position.y, blockSize, blockSize);
 }
 void switchBlock(Element elem2){
   PVector newPosition = elem2.position;
   elem2.position = position;
   position = newPosition;
 }
}

class InsertionSort{
 int totalElem = array.size();
 int currSortBound;
 int testVal;
 int iter;
 boolean sortedFlag;
 boolean doingIter = false;
 
 public InsertionSort(){
   currSortBound = 1;
   testVal = array.get(currSortBound).blockValue;
   iter = currSortBound;
   sortedFlag = false;
   
 }
 
 void play(){
   if(sortedFlag == false){
     next();
   }
 }
 
 void next(){
   println(iter);
   if(!doingIter){
     array.get(currSortBound).position.y = 150;
     doingIter = true;
    return; 
   }
   if(iter==0){
     //prevents accessing array[-1]
     if(array.get(0).blockValue == testVal){
       //move testElem to position 0.
       insertElement(0);
     }
   }else if(array.get(iter-1).blockValue > testVal){
     //shift iter-1 to position iter
     array.get(iter-1).position = indexedPos.get(iter);
     swapArrayOrder(iter-1, iter);  //swap order on arraylist(for next call)
     println("new position for block index "+(iter-1)+" is "+indexedPos.get(iter).x +" "+indexedPos.get(iter).y);
     iter--;  
 }
   else{
       //move testElem to position iter
       insertElement(iter);
   }
   
   
 }
 
 void insertElement(int indexToInsert){
   //move currTestElem to this position
   array.get(indexToInsert).position = indexedPos.get(indexToInsert);
   
   //reset to next element
   ++currSortBound;
   if(currSortBound == totalElem){
     sortedFlag = true;
     return;
   }
   Element currentTestElem = array.get(currSortBound);  //new element to test
   testVal = currentTestElem.blockValue;
   iter = currSortBound;    //reset iter to new element's position
   
   doingIter = false;
   println("new iter and sortBound: "+iter);
 }
 
 void swapArrayOrder(int a, int b){
  Element temp = array.get(a);
  array.set(a, array.get(b));
  array.set(b, temp);
 }
 
}