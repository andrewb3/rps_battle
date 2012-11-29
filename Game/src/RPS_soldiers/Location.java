package RPS_soldiers;

public class Location {
	
	private final int xPosition;
	private final int yPosition;
	
	Location(int x, int y){
		xPosition=x;
		yPosition=y;
	}
	
	public int getXPosition(){return xPosition;}
	
	public int getYPosition(){return yPosition;}

}
