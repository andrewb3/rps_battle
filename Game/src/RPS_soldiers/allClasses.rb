class Type
  def initialize(name)
    @name = name
  end
  def getName
    return name
  end
  def getMultiplyer
    return 1
  end
end


class Scissor < Type
  def initialize()
    super(Scissor)
  end
  def getMultiplyer(other)
    if (getName(other) == Rock)
      return 0.8
    else if (getName(other) == Scissor)
      return 1
    else
      return 1.25
    end
  end  
end

class Rock < Type
  def initialize(level)
    super(Rock)
  end
  def getMultiplyer(other)
    if (getName(other) == Rock)
      return 1
    else if (getName(other) == Scissor)
      return 1.25
    else
      return 0.8
    end  
  end
end

class Paper < Type
  def initialize(level)
    super(Paper)
  end
  def getMultiplyer(other)
    if (getName(other) == Rock)
      return 1.25
    else if (getName(other) == Scissor)
      return 0.8
    else
      return 1
    end
  end  
end

class Location
  def initialize(posX, posY)
    @posX = posX
    @posY = posY
  end
  def getX()
    return posX
  end
  def getY()
    return posY
  end

class Regiment 
  def initialize(Type, soldNum, Location)
    @Type = Type
    @soldNum = soldNum
    @Location = Location
  end
  def getType
     return Type
  end
  def fight(otherReg)
    multSelf = self.Type.getMultiplyer(otherReg.getType())
    multOther = otherReg.getType().getMultiplyer(self)
    numKilledOther = multSelf * self.soldNum
    numKilledSelf = multOther * otherReg.getSoldNum()
    otherReg.killSoldiers(numKilledOther)
    self.killSoldiers(numKilledSelf)
    if (self.isDead() && otherReg.isDead())
      return 0
    else if (self.isDead)
      return -1
    else if (otherReg.isDead)
      return 1
    else
      return nil#do something?? (shouldn't happen with right variables...)
    end
  end
  def move(Location)
    @Location = Location
  end
  def getSoldNum()
    return soldNum
  end
  def killSoldiers(num)
    soldNum = soldNum - num
    if soldNum < 0
      soldNum = 0
    end
  end
  def isDead
    if soldNum == 0
      return true
    else
      return false
    end
  end
  def reinforce(otherReg)
    @soldNum += otherReg.getSoldNum()
    return true
  end
end

class Player
  def initialize(name, location)
    @name = name
    @city = City(location)
    @regiments = new(array)
  end
  def reinforce(locReg1, locReg2)
  end
end

class City
  def initialize(location)
    @location = location
    @health = 100 #change for magic numbers...
  end
  def damageCity(damageAmt)
    health = health - damageAmt
    if health < 0
      health = 0
    end
  end
  def isDead()
    if health == 0
      return true
    else
      return false
      end
  end
end

class world
  def initialize(rows, cols)
    
  end
end
