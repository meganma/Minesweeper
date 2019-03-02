

import de.bezier.guido.*;
//Declare and initialize NUM_ROWS and NUM_COLS = 20
public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
public final static int NUM_BOMBS = 30;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs = new ArrayList <MSButton> (); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    buttons = new MSButton[20][20];
    for(int r = 0; r< 20; r++)
        for (int c = 0; c<20; c++)
            buttons[r][c] = new MSButton(r,c);
    

    //declare and initialize buttons
    setBombs();
}
public void setBombs()
{
   while (bombs.size() < NUM_BOMBS) {
    //your code
    int rowNum = (int)(Math.random()*NUM_ROWS);
    int colNum = (int)(Math.random()*NUM_COLS);
    if(!bombs.contains(buttons[rowNum][colNum])) 
        bombs.add(buttons[rowNum][colNum]);
   } 
}

public void draw ()
{
    background( 0 );
       if (isWon() == true) {
        displayWinningMessage();
       
       } 
}
public boolean isWon()
{
    //your code here
    int markBombs = 0;
    for (int i = 0; i < bombs.size(); i++) {
        if (bombs.get(i).isMarked() == true) {
            markBombs++;
        }
    if (markBombs == bombs.size()) {
        return true;
    }
    for(int j = 0; j < bombs.size(); j++) {
        if(bombs.get(j).isClicked() == true) {
            //return false;
        }
    }
    }

    return false;
}
public void displayLosingMessage()
{
    //your code here
    for(int i=0;i<bombs.size();i++)
    {
        bombs.get(i).setClicked(true);
    }
    fill(255, 0, 0);
    textSize(40);
    text("You Lose!", 190, 450);
    textSize(10);
    stroke(0);
}
public void displayWinningMessage()
{
    //your code here
    fill(0, 255, 0);
    text("You Win!", 190, 450);
    textSize(10);
    stroke(0);
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
       // marked = Math.random() < .7;
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
    public void setClicked(boolean cClicked)
    {
        clicked = cClicked;
    }    
    
  public void mousePressed () 
    {
            clicked = true;
            if(keyPressed == true) {
                marked = !marked;
            }
            else if(bombs.contains(this)) {
                System.out.println("Lost!");
                 displayLosingMessage();
            }
            else if(countBombs(r,c)>0) {
                setLabel("" + countBombs(r,c));
            }
            else {
               //  if(isValid(r+1,c) && buttons[r+1][c].isClicked()==false) {
                 //                   buttons[r+1][c].mousePressed();
               for(int i=-1;i<2;i++) {
                    for(int j=-1;j<2;j++) {
                        if(isValid(r+i,c+j) && buttons[r+i][c+j].isClicked()==false) {

                                    buttons[r+i][c+j].mousePressed();
                            }
                        }
                    }
                
            }
            //}   }
    }

    public void draw () 
    {    
        if (marked)
            fill(0);
        else if (clicked && bombs.contains(this)) 
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
    public boolean isValid(int r, int c)
    {
        //your code here
        if ((r > -1 && r < NUM_ROWS) && (c > -1 && c < NUM_COLS))
         return true;
        else
         return false;
    }
    public int countBombs(int row, int col)
    {
        int numBombs = 0;
        for (int y = -1; y < 2; y++) {
            for (int x = -1; x < 2; x++) {
                if(isValid(row + y, col + x) == true) {
                    if(bombs.contains(buttons[row+y][col+x])) {
                        numBombs++;
                    
                    }
                }
            }        
        }
        return numBombs;
    }
}
