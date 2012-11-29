package RPS_soldiers;

public class Regiment {
	
	final private String Name;
	final private Type Attribute;
	private int soldiers;
	private Location location;
	final private int movementRate;

	Regiment(String Type, int Level,int soldierNumber, int xPosition, int yPosition, int movementRate, String Name) throws InvalidTypeException{
		if(Type=="Rock")
			Attribute = new Rock(Level);
		else if(Type=="Paper")
			Attribute = new Paper(Level);
		else if(Type=="Scisors")
			Attribute = new Scisor(Level);
		else
			throw new InvalidTypeException(Type);
		soldiers=soldierNumber;
		location = new Location(xPosition,yPosition);
		this.movementRate=movementRate;
		this.Name=Name;
	}
	
	public String getName(){return Name;}
	
	
	
	
	
	
	
	
	

}
