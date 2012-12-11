class Rock < Type
  def initialize()
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
