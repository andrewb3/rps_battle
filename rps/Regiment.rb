class Regiment 
  def initialize(type, soldNum, location)
    @type = type
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
  def move(location)
    @location = location
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
    return otherReg.getSoldNum()
  end
end