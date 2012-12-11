class Player
  def initialize(name, location)
    @name = name
    @city = City(location)
    @regiments = Hash.new
    @regiments.default = nil
  end
  def loseRegiment(loc)
    regiments.delete[loc]
  end
  def attack(otherPlayer, fromLoc, toLoc)
    x = regiments[fromLoc].fight(otherPlayer.regiments[toLoc])
  if x == 0 
    regiments[fromloc].delete
    otherPlayer.regiments.remove[toLoc]
  else if x == 1
    regiments.delete[fromloc]
    else
    otherPlayer.loseregiment(toLoc)
    regiments[toLoc] = regiments[fromLoc]
    regiments.delete[fromLoc]
    end
  end
  def getRegAtLoc(location)
    return regiments[location]
  end
end