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
  def eql?(other)
    if ((other.getX == self.posX) && (other.getY == self.posY)
      return true
    else 
      return false
    end
  end
  def hash
    return posX * 100 + posY  ##this is ugly (but there should be a better way to get uniq value from a location obv... to work with hash...)
  end
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
    return otherReg.getSoldNum()
  end
end

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

class World
  def initialize(rows, cols)
    @rows = rows
    @cols = cols
    @worldmap = Hash.new
    for i in 0..(rows - 1)
      for j in 0..(cols - 1)
        worldmap[[i,j]] = Location,new(i, j)
      end
    end
  end
  def getLocation(row, col)
    if (row >= 0 && row < rows && col >= 0 && col < cols)
      return worldmap[[row,col]]
    else
      return nil
    end
  end
end


class game
  def initialize(rows, cols, name1, x1, x2, y1, y2, name2)
    @world = World.new(rows, cols) 
    @player1 = Player.new(name1, world.getLocation(x1,x2))
    @player2 = Player.new(name2, world.getLocation(y1,y2))
  end
  def main()
    play = true;
    introPrompt()
    while(play)
      promptPlayer(Player1)
      if player2.isDead()
        victory(Player2)
        break
      end
      promptPlayer(Player2)
      if player1.isDead()
        victory(Player2)
        break
      end
    end
  end    
end        
      
class SplashScreen < Gosu::Window
    def initialize
       super 1000,700,false
       self.caption = 'RPS BATTLE'      
      
       @background_image = Gosu::Image.new(self, "TPN70.gif")
      
    end
   
    def update
     
    end
   
    def draw
      @grid = Hash.new
      for i in 0..(6)
        for j in 0..(9)
          draw_quad(j* 100 ,  i * 70 , Gosu::Color.argb(0xff00ff00), (j * 100) + 100, i * 70, Gosu::Color.argb(0xffffffff), j * 100, (i * 70) + 70, Gosu::Color.argb(0xffffffff), (j * 100) + 100, (i * 70) + 70, Gosu::Color.argb(0xff00ff00), z = 0, mode = :default)
        end
      end
     
      #draw_line(0, 0, Gosu::Color.argb(0xff808080), 100, 100, Gosu::Color.argb(0xff808080), z = 0, mode = :default)
    end
end

class GameWindow < Gosu::Window
    def initialize
       super 640,480,false
       self.caption = 'RPS BATTLE'      
      
       @background_image = Gosu::Image.new(self, "TPN70.gif")
    end
   
    def update
     
    end
   
    def draw
      @background_image.draw(0,0,0)
    end
end

class EndScreen < Gosu::Window
    def initialize
       super 640,480,false
       self.caption = 'RPS BATTLE'
      
       @background_image = Gosu::Image.new(self, "TPN70.gif")
    end
   
    def update
     
    end
   
    def draw
      @background_image.draw(0,0,0)
    end
end

window = SplashScreen.new
window.show