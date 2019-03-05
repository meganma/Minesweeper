
import de.bezier.guido.*;
public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
public final static int NUM_BOMBS = NUM_ROWS*NUM_COLS/10;
String winMessage = new String("Winner Winner Chicken Dinner!");
String loseMessage = new String("You lost :(");
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to declare and initialize buttons goes here

    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int r = 0; r < NUM_ROWS; r++)  {
      for(int c = 0; c < NUM_COLS; c++) {
        buttons[r][c] = new MSButton(r, c);
      }
    }
    
    setBombs(NUM_BOMBS);
}
public void setBombs(int nBombs)
{
  int i = 0;

  while(i < nBombs) {
        int row = (int)(((double)NUM_ROWS)*Math.random());
        int col = (int)(((double)NUM_COLS)*Math.random());
      if(!bombs.contains(buttons[row][col])) {
        bombs.add(buttons[row][col]);
        i++;
      }
  }

}

public void draw ()
{
    background( 0 );
    if(isWon())
        displayWinningMessage();
}
public boolean isWon()
{
    int bMarked = 0;
    int tMarked = 0;

    for(int i = 0; i < bombs.size(); i++)
      if(bombs.get(i).isMarked())
        bMarked++;

    for(MSButton[] row : buttons)
      for(MSButton col : row)
        if(col.isMarked())
          tMarked++;

    if(bMarked == NUM_BOMBS && tMarked == NUM_BOMBS)
    return true;

    return false;
}
public void displayLosingMessage() {

    for(int i = 0; i < loseMessage.length(); i++)
        buttons[NUM_ROWS/2][NUM_COLS/2 - loseMessage.length()/2 + i].setLabel(loseMessage.substring(i, i+1));
}

public void displayWinningMessage() {

    for(int i = 0; i < winMessage.length(); i++)
        buttons[NUM_ROWS/2][NUM_COLS/2 - winMessage.length()/2 + i].setLabel(winMessage.substring(i, i+1));
}

public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked;
    private String label;
    
    public MSButton ( int rr, int cc )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        r = rr;
        c = cc; 
        x = c*width;
        y = r*height;
        label = "";
        marked = clicked = false;
        Interactive.add( this ); // register it with the manager
    }
    public boolean isMarked()
    {
        return marked;
    }
    public boolean isClicked()
    {
        return clicked;
    }
    // called by manager
    
    public void mousePressed () 
    {
        clicked = true;
  
        if(keyPressed) {
            marked = !marked;
            if(marked == false)
                clicked = false;
        }

        else if(bombs.contains(this))
            displayLosingMessage();

        else if(countBombs(r, c) > 0)
            label = "" + countBombs(r, c);
            
        else {
            for(int i = r - 1; i <= r + 1; i++)
                for(int j = c - 1; j <= c + 1; j++)
                    if(isValid(i, j) && !bombs.contains(buttons[i][j]) && buttons[i][j] != this && buttons[i][j].isClicked() == false) 
                        buttons[i][j].mousePressed();
        }
                
    }
   

    public void draw () 
    {    
        if (marked)
            fill(0);
        else if( clicked && bombs.contains(this) ) 
             fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(label,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        label = newLabel;
    }
    public boolean isValid(int row, int col)
    {
        if(row >= 0 && row < NUM_ROWS && col >= 0 && col < NUM_COLS)
            return true;

        return false;
    }
    public int countBombs(int row, int col)
    {
        int numBombs = 0;

        for(int i = row - 1; i <= row + 1; i++)
            for(int j = col - 1; j <= col + 1; j++)
                if(isValid(i, j) && bombs.contains(buttons[i][j]))
                    numBombs++;

        return numBombs;
    }
}


