package RPS_soldiers;

abstract class Type {
	private int Level;
	
	abstract float getMultiplyer(Type other)throws InvalidTypeException;
	
	public void setLevel(int newLevel){this.Level=newLevel;}
	
	public int getLevel(){return Level;}
	
	abstract String getName();
	
	public String toString(){return this.getName()+" level: "+this.getLevel();}
	
	
}
