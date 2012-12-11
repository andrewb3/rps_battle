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
  def eql?(other)
    if ((other.getX == self.posX) && (other.getY == self.posY))
      return true
    else 
      return false
    end
  end
  def hash
    return posX * 100 + posY  ##this is ugly (but there should be a better way to get uniq value from a location obv... to work with hash...)
  end
end