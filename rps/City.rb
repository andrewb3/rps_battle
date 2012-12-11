
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