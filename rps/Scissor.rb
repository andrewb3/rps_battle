class Scissor < rps::Type
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