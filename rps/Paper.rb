class Paper < Type
  def initialize()
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