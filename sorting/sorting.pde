//MADE BY STEVEN STEVEN
//LAST UPDATED 5/12/2018

int screenMode;        //0: init screen,  1: sorting screen

//global Var for Insertion Sort Execution
PFont f;
ArrayList<Element> array = new ArrayList<Element>();
ArrayList<PVector> indexedPos = new ArrayList<PVector>();    //position of all the blocks
int BLOCKHEIGHT = 100;      //Height of each block
int blockWidth;            //dynamic depending on amount of blocks
InsertionSort sortFunc;    //
PVector diagramPos;   //x and y position of sorting diagram
int blockNum;         //number of blocks
int[] blockValues;    //values and initial order of blocks

ArrayList<Button> btnList = new ArrayList<Button>();    //UI Buttons to display

//GLobal Variables for screen init
String userInput = "";
PVector input1Pos;                                      //center position of input field (relative to origin)
String question1 = "Enter how many integers to sort";
String question2 = "Enter your integers (comma seperated, and no space)";
int questionIndex = 0;                                  //current question
float prevInputHeight;
boolean nextQuestion = false;                           //if true animate for changing question

//error alert controls
color inputTextColor;  //display red when error
boolean inputError = false;
String errorMsg="";

/*-------SETUP------*/
void setup() {
  size(800, 800);
  f = createFont("Arial", 16, true);
  screenMode =0;

  input1Pos = new PVector(width/2, height/2);
  prevInputHeight = input1Pos.y;

  //initialize all buttons
  btnList.add(new Button("submit", ">>", 50, new PVector(100, 100), new PVector(width-100, height-100)));
  btnList.add(new Button("random", "Random Sample", 20, new PVector(300, 80), new PVector(10, height/2+300)));
  btnList.add(new Button("restart", "Restart", 20, new PVector(150, 30), new PVector(10, height/2+200)));
}

//called once everytime starting mainScreen()
void setupBlock() {                 
  color bcolor = color(255, 0, 0);
  blockWidth = width/blockNum-10;  //calculate blockWidth to fit in the screen

  diagramPos = new PVector(width-(blockWidth+10)*blockNum+5, height-BLOCKHEIGHT-10);  //Define the top left corner of the insertionSort diagram
  for (int i = 0; i<blockNum; ++i) {
    indexedPos.add(new PVector(diagramPos.x+(blockWidth+10)*i, diagramPos.y));
    array.add(new Element(blockValues[i], blockWidth, BLOCKHEIGHT, indexedPos.get(i), bcolor));
  }
  sortFunc = new InsertionSort();  //begin insertionSort Function
}

void restart(){
  screenMode = 0;
  for (int i = blockNum-1; i>=0; --i) {
    indexedPos.remove(i);
    array.remove(i);
  }
}

/*-------DRAW------*/
void draw() {
  if (screenMode == 0) {
    //setup button
    initScreen();    //short questionare screen
  } else {
    mainScreen();    //insertion sort screen
  }
}

void initScreen() {
  background(0);
  buttonHandler();
  
  //Questions
  fill(255);
  textAlign(CENTER);
  textSize(30);
  text(question1, input1Pos.x, input1Pos.y-30);
  textSize(25);
  text(question2, input1Pos.x, input1Pos.y+100-30);

  if (nextQuestion ==true) {  //transition animation to next question
    shiftQuestionUp();
  }

  rect(0, height/2, width, 100);  //input box
  stroke(0);

  //input line
  fill(0);
  textSize(50);
  float cursorPosition = width/2+textWidth(userInput)/2;
  line(cursorPosition, height/2, cursorPosition, height/2+100);

  //inputText
  inputTextColor = inputError? color(255, 0, 0): color(0);
  fill(inputTextColor);
  text(userInput, width/2, height/2+50);

  if (inputError) {  //show error message
    textSize(25);
    text(errorMsg, width/2, height/2+200);
  }
}

void mainScreen() { 
  fill(0);//black
  background(255);
  textFont(f, 60);
  textAlign(CENTER);
  text("INSERTION SORT", width/2, 80);
  sortFunc.instructionDisplay();
  buttonHandler();
  blockHandler();
}



/*-------DRAWING HANDLER------*/

void buttonHandler() {
  if (screenMode ==0) {
    //Submit input button
    for (int i = 0; i<2; ++i) {  //control/display first 2 botton in arraylist
      btnList.get(i).drawBtn();
      if (overRect(btnList.get(i).pos, btnList.get(i).size)) {
        btnList.get(i).btnHovered = true;
      } else {
        btnList.get(i).btnHovered = false;
      }
    }
  }else{
    for (int i = 2; i<btnList.size(); ++i) {  //control/display first 2 botton in arraylist
      btnList.get(i).drawBtn();
      if (overRect(btnList.get(i).pos, btnList.get(i).size)) {
        btnList.get(i).btnHovered = true;
      } else {
        btnList.get(i).btnHovered = false;
      }
    }
  }
}

void blockHandler() {
  for (int i = 0; i<array.size(); ++i) {  //draw all blocks iteratively
    array.get(i).drawElem();
  }
}


/*-------HELPER FUNCTIONS------*/
void shiftQuestionUp() {  //animate transition to next question
  if (input1Pos.y > prevInputHeight-100) {
    input1Pos.y-=5;
  } else {
    prevInputHeight = input1Pos.y;
    questionIndex++;
    nextQuestion = false;
  }
}


void processAnswer() {    //Called when User submit their inputs
  errorMsg = "";
  if (questionIndex==0) {
    try {
      blockNum = Integer.parseInt(userInput);
      question1+=": "+blockNum;
      userInput = "";
      nextQuestion = true;
      inputError = false;
    }
    catch (NumberFormatException e) {
      errorMsg = "Please enter a valid integer";
      inputError = true;
    }
  } else if (questionIndex ==1) {
    blockValues = new int[blockNum];
    try {
      //process each blockNumber
      String[] tmp = split(userInput, ',');
     
      //blockValues = int(split(userInput, ','));
      if (tmp.length!=blockNum) {
        errorMsg = "Please enter "+blockNum+" values";
        inputError = true;
        return;
      }
      for(int i = 0; i<tmp.length;++i){  //copy over each values (validate number)
        blockValues[i] = int(tmp[i]);
        if(blockValues[i] == 0 && tmp[i] != "0"){
           errorMsg = "'"+tmp[i]+"' is not a proper integer";
           inputError = true;
           return;
        }
      }
      setupBlock();
      screenMode = 1;
    }
    catch (NumberFormatException e) {
      errorMsg = "Please enter valid integers";
      inputError = true;
    }
  }
}

/*-------USER Interface Interrupts------*/

void keyPressed() {
  if (screenMode == 0) {  //typing enabled in init screen
    if (key == CODED || key=='\n' ||key =='\t') {
      if (keyCode == ENTER || keyCode == TAB || keyCode == RETURN) {
        processAnswer();
      }
    } else {

      //typing
      if (key == BACKSPACE) {
        if (userInput.length() > 0) {
          userInput = userInput.substring(0, userInput.length()-1);
        }
      } else if (textWidth(userInput+key) < width) {
        userInput = userInput + key;
        println("key is "+key);
      }
    }
  } else {
    if ((key == CODED && keyCode == RIGHT)||key == ' ' || key == '\n') {
        sortFunc.play();
    }
  }
}
void mousePressed() {
  if (screenMode ==0) {
    //iterate 2 bottons
    if (btnList.get(0).btnHovered) {
      processAnswer();
    }
    if (btnList.get(1).btnHovered) {  //pick Random Sample
      blockNum = int(random(1, 15));
      blockValues = new int[blockNum];
      for (int i = 0; i<blockNum; ++i) {
        blockValues[i]=int(random(0, 99));
      }
      setupBlock();
      screenMode = 1;
    }
  } else {
    if (btnList.get(2).btnHovered) {  //restart Button
      restart();
    }
  }
}

boolean overRect(PVector pos, PVector size) {
  if (mouseX >= pos.x && mouseX <= pos.x+size.x &&
    mouseY >= pos.y && mouseY <= pos.y+size.y) {
    return true;
  } else {
    return false;
  }
}



/*------- CLASSES ------*/

//Element: Individual blocks to sort and display

class Element { 
  int block_width;
  int BLOCKHEIGHT;
  int blockValue; 
  color blockColor;
  PVector position;

  public Element(int value, int size_width, int size_height, PVector pos, color c) {
    block_width = size_width;
    BLOCKHEIGHT = size_height;
    blockValue = value;
    blockColor = c;
    position = new PVector(pos.x, pos.y);
  }
  void drawElem() {
    fill(blockColor);
    rectMode(CORNER);
    rect(position.x, position.y, block_width, BLOCKHEIGHT);
    fill(0);
    textFont(f, 30);
    textAlign(CENTER, CENTER);
    text(""+blockValue, position.x, position.y, block_width, BLOCKHEIGHT);
    //<!--text(""+blockValue+ " at "+position.x+" "+position.y, position.x, position.y, blockSize, blockSize);-->
  }
  void switchBlock(Element elem2) {    //switch PVector position
    PVector newPosition = elem2.position;
    elem2.position = position;
    position = newPosition;
  }
}

//InsertionSort: class keeps track of the sorting process

class InsertionSort {          //Sorting execution
  int totalElem = array.size();
  int currSortBound;            //num of elements in sorted array / index of next element to insert (1 means insert elem[1])
  int testVal;                  //value of element to insert
  int iter;                     //index to traverse sorted array (iter points to blank space/current element to insert)
  boolean sortedFlag;
  boolean doingIter = false;
  int sortedArrayWidth = blockWidth + 10; //display sorted array rectangle's width
  int instructionCount;
  int inversionCount;

  public InsertionSort() {  //construct Iteration Execution
    currSortBound = 0;
    testVal = array.get(currSortBound).blockValue;
    iter = currSortBound;
    sortedFlag = false;

    instructionCount = 0;
    inversionCount = 0;
  }

  void play() {
    if (sortedFlag == false) {
      next();
    }
  }

  void next() {
    //<!--println(iter);-->
    if (!doingIter) {        //pick the next element to insert
      instructionCount = 1;
      array.get(currSortBound).position.y -= 120;
      doingIter = true;
      sortedArrayWidth = (blockWidth+10)*(currSortBound+1);
      return;
    }
    if (iter==0) {  //Element is the smallest (belongs at index 0)
      instructionCount = 2;
      //prevents accessing array[-1]
      if (array.get(0).blockValue == testVal) {
        //move testElem to position 0.
        insertElement(0);
      }
    } else if (array.get(iter-1).blockValue > testVal) {    //test value smaller than iter-1
      instructionCount = 3;
      //shift iter-1 to position iter
      array.get(iter-1).position = indexedPos.get(iter);
      swapArrayOrder(iter-1, iter);  //swap order on arraylist(for next call)
      //<!--println("new position for block index "+(iter-1)+" is "+indexedPos.get(iter).x +" "+indexedPos.get(iter).y);-->
      --iter;
      ++inversionCount;
    } else {    //correct place
      //move testElem to position iter
      instructionCount = 2;
      insertElement(iter);
    }
  }

  void insertElement(int indexToInsert) {
    //move currTestElem to this position
    array.get(indexToInsert).position = indexedPos.get(indexToInsert);

    //reset to next element
    ++currSortBound;
    if (currSortBound == totalElem) {  //if insertion execution is done
      sortedFlag = true;
      instructionCount = 4;
      return;
    }
    Element currentTestElem = array.get(currSortBound);  //new element to test
    testVal = currentTestElem.blockValue;
    iter = currSortBound;    //reset iter to new element's index

    doingIter = false;
  }

  void swapArrayOrder(int a, int b) {  //switch 'value' of element at index b and a
    Element temp = array.get(a);
    array.set(a, array.get(b));
    array.set(b, temp);
  }

  //Displays Step Instructions
  void instructionDisplay() {
    rect(diagramPos.x-10, diagramPos.y-10, sortedArrayWidth+5, BLOCKHEIGHT+20);

    textFont(f, 30);
    textAlign(LEFT);

    pushMatrix();
    translate(0, 100);
    fill(0);
    if (instructionCount == 0||instructionCount == 2) {
      fill(144, 238, 144);
      noStroke();
      rect(10,20,width,90);
      fill(0, 102, 153);
    }
    text("1. While (sortedArray size < totalElements)", 20, 60);
    text("Select unsorted element to insert", 60, 100);
    fill(0);
    if (instructionCount == 1) {
      fill(144, 238, 144);
      noStroke();
      rect(50,110,width,50);
      fill(0, 102, 153);
    }
    text("2. Compare next element in sorted array", 60, 150);
    fill(0);
    if (instructionCount == 2) {
      fill(144, 238, 144);
      noStroke();
      rect(90,160,width,90);
      fill(0, 102, 153);
    }
    text("3. If (elem_to_insert > sorted_element)", 100, 200);
    text("Insert. Go to Step 1.", 140, 240);
    fill(0);
    if (instructionCount == 3) {
      fill(144, 238, 144);
      noStroke();
      rect(90,250,width,50);
      fill(0, 102, 153);
    }
    text("4. Else, shift sorted element. Go to step 2", 100, 290);
    fill(0);
    if (instructionCount == 4) {
      fill(144, 238, 144);
      noStroke();
      rect(10,300,width,50);
      fill(0, 102, 153);
    }
    text("5. Done", 20, 340);
    fill(0);
    popMatrix();
    
    text("Number of Inversions: "+ inversionCount, 20, 540);
    textFont(f,15);
    text("Press 'right' or 'space' or 'enter' button on your keyboard to play", 20, height-BLOCKHEIGHT-35);

    //indicate block color for comparison
    for (int i = 0; i<blockNum; ++i) {  //turn all element red
      array.get(i).blockColor = color(255, 0, 0) ;
    }
    if (instructionCount == 1||instructionCount == 3) {  //turn blue if instr 1 or 3.(compare begin and shift)
      array.get(iter).blockColor = color(0, 102, 153) ;
      if (iter-1>0) {
        array.get(iter-1).blockColor = color(0, 102, 153) ;
      } else {
        array.get(0).blockColor = color(0, 102, 153) ;
      }
    }
  }
}

//Button Class: Implemented property of all UI Buttons

class Button {
  String id;
  String tag;
  PVector size; //x = width; y = height
  PVector pos; //left top corner
  boolean btnHovered;
  int fontSize;

  public Button(String id, String text, int font_size, PVector size, PVector pos) {
    this.id = id;
    tag = text;
    this.size = size;
    this.pos = pos;
    btnHovered = false;
    fontSize = font_size;
  }

  void drawBtn() {
    if (btnHovered) {
      fill(0);  //background black if hovered
    } else {
      fill(255); //else white (default)
    }
    stroke(0);
    rectMode(CORNER);
    rect(pos.x, pos.y, size.x, size.y);

    if (btnHovered) {
      fill(255);
    } else {
      fill(0);
    }
    textFont(f, fontSize);
    textAlign(CENTER, CENTER);
    text(tag, pos.x, pos.y, size.x, size.y);
  }
}