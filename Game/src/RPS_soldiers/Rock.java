package RPS_soldiers;

public class Rock extends Type{
	
	
	Rock(int level){this.setLevel(level);}

	@Override
	public float getMultiplyer(Type other)throws InvalidTypeException {
		if(other.getName().equals("Paper"))
			return ((float) .75)*this.getLevel();
		else if(other.getName().equals("Rock"))
			return (float)this.getLevel();
		else if(other.getName().equals("Scisors"))
			return ((float)1.25)*this.getLevel();
		else
			throw new InvalidTypeException(other.getName());
	}

	@Override
	public String getName() {return "Rock";}

}
