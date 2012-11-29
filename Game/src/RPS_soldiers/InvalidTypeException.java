package RPS_soldiers;

public class InvalidTypeException extends Exception {
	
	InvalidTypeException(String invalid){
		super("invalid battle type: "+invalid);
	}
	
	

}
