require 'set'
require 'rubygems'
require 'gosu'

## project by James Nichols, Andrew Bosnik, and Lewis Brant

class Type
  def initialize(name)
    @name = name
  end

  def getName()
    return @name
  end

  def getMultiplyer
    return 1
  end
end
##Scissor type class, represents the scissors in RPS
class Scissor < Type
  def initialize()
    super("Scissor")
  end

  def getMultiplyer(other)
    if (other.getName() == "Rock")
      return 0.8
    elsif (other.getName() == "Scissor")
      return 1
    else
      return 1.25
    end
  end
end
##Rock type class, represents the rock in RPS
class Rock < Type
  def initialize()
    super("Rock")
  end

  def getMultiplyer(other)
    if (other.getName() == "Rock")
      return 1
    elsif (other.getName() == "Scissor")
      return 1.25
    else
      return 0.8
    end
  end
end
##Paper type class, represents the rock in Paper
class Paper < Type
  def initialize()
    super("Paper")
  end

  def getMultiplyer(other)
    if (other.getName() == "Rock")
      return 1.25
    elsif (other.getName() == "Scissor")
      return 0.8
    else
      return 1
    end
  end
end
##Location: Ordered pair to be used for grid like implementation of the game
class Location
  def initialize(posX, posY)
    @posX = posX
    @posY = posY
  end

  def getX()
    return @posX
  end

  def getY()
    return @posY
  end

  def eql?(other)
    if ((other.getX == @posX) and (other.getY == @posY))
      return true
    else
      return false
    end
  end

  def isAdjacent(other)
    if (@posX - other.getX).abs == 1
      if (@posY - other.getY).abs == 1 or (@posY - other.getY) == 0
        return true
      else
        return false
      end
    elsif (@posX - other.getY) == 0
      if (@posY - other.getY).abs == 1 
        return true
      else
        return false
      end
    else
      return false
    end

  end

  def hash
    return @posX * 100 + @posY 
  end
end
##Regime: Represents a set of a certain type of RPS soldier, can be rock paper or scissors
# holds a value for its # of soldiers and its location, can fight and die, bravely
class Regime
  def initialize(type, soldNum, location)
    @Type = type
    @soldNum = soldNum
    @Location = location
  end

  def getType
    return @Type
  end

  def fight(otherReg)
    
    multSelf = @Type.getMultiplyer(otherReg.getType())
    
    multOther = otherReg.getType().getMultiplyer(@Type)
   
    numKilledOther = (multSelf * @soldNum).floor
    numKilledSelf = (multOther * otherReg.getSoldNum()).floor
    otherReg.killSoldiers(numKilledOther)
    killSoldiers(numKilledSelf)
  end

  def move(location)
    @Location = location
  end

  def addSold(num)
    @soldNum += num
  end

  def killSoldiers(num)
    @soldNum = @soldNum - num
    if @soldNum < 0
      @soldNum = 0
    end
  end

  def isDead
    if @soldNum == 0
      return true
    else
      return false
    end
  end

  def getLocation()
    return @Location
  end

  def getSoldNum()
    return @soldNum
  end

end
## Player: represents all that the player controls, their regimines and their city
# can add and remove
class Player
  def initialize(name, location)
    @name = name
    @city = City.new(location)
    @Regimes = Set.new

  end
 #remove all regimes that have died
  def removeDeadRegimes()
    @Regimes.each do |regime|
      if regime.isDead()
        @Regimes.delete(regime)
      end
    end
  end

  def removeRegime(regime)
    @Regimes.delete(regime)
  end

  def addRegime(type,soldiers,loc)
    @Regimes << Regime.new(type,soldiers,loc)
  end

  def getRegimes
    return @Regimes
  end

  def getCity
    return @city
  end

  def getName
    return @name
  end

end
## City: represents the base that you will be protecting in the game, has health and can generate troops.
class City
  def initialize(location)
    @location = location
    @health = 1000 #change for magic numbers...
  end

  def damageCity(damageAmt)
    @health = @health - damageAmt
    if @health < 0
      @health = 0
    end
  end

  def getHealth()
    return @health
  end

  def getLocation()
    return @location
  end

  def isDead()
    if @health == 0
      return true
    else
      return false
    end
  end
end
## World:hold everything above including a table to represent the game grid!
class World
  def initialize(one,two)
    @playerOne = one
    @playerTwo = two
    @worldmap = Array.new(10)
    for i in 0..(9)
      array = Array.new
      for j in 0..(6)
        array << Location.new(i, j)
      end
      @worldmap << array
    end
  end

  def getPlayerOne
    return @playerOne
  end

  def getPlayerTwo
    return @playerTwo
  end
end


#GameWindow: Where the magic happens
# this is the main game loop, it starts, then waits on mouse clicks
# and looks at the grid where they were clicked, and does actions accordinly

class GameWindow < Gosu::Window
  def initialize
    super 1000,700,false
    self.caption = 'RPS BATTLE'
    @state = "normal"
    @mouseImage = Gosu::Image.new(self, "Sword.png")
    @cityImage = Gosu::Image.new(self,"castle.png")
    @paperImage = Gosu::Image.new(self,"paper.png")
    @rockImage = Gosu::Image.new(self,"rock.png")
    @scissorImage = Gosu::Image.new(self,"scissors.png")
    @cancelImage = Gosu::Image.new(self,"cancel.png")
    @validMove = false;
    @choice = ""

    
    
    @font = Gosu::Font.new(self, Gosu::default_font_name,20)
    @fontHuge = Gosu::Font.new(self, Gosu::default_font_name,50)
    @playerTurn = 1
    @boxCoords = []
    @clickQueue = []

    @world = World.new(Player.new("P1",Location.new(0,3)),Player.new("P2",Location.new(9,3)))

  end

  def draw
    #normal state is the grid layout
    if @state == "normal"
      for i in 0..(6)
        for j in 0..(9)
          draw_quad(j* 100 ,  i * 100 , Gosu::Color.argb(0xff00ff00), (j * 100) + 100, i * 100, Gosu::Color.argb(0xff00ff00), j * 100, (i * 100) + 100, Gosu::Color.argb(0xff00ff00), (j * 100) + 100, (i * 100) + 100, Gosu::Color.argb(0xff00ff00), z = 0, mode = :default)
          if @world.getPlayerOne().getCity().getLocation().eql?(Location.new(j,i))
            @cityImage.draw(j*100,i*100,0)
            @font.draw(@world.getPlayerOne().getCity().getHealth(),j*100,i*100,0, factor_x=1,factor_y=1,color = 0xffff0f00, mode = :default)
            @font.draw(@world.getPlayerOne().getName(),j*100,i*110,0, factor_x=1,factor_y=1,color = 0xffff0f00, mode = :default)

          elsif @world.getPlayerTwo().getCity().getLocation().eql?(Location.new(j,i))
            @cityImage.draw(j*100,i*100,0)
            @font.draw(@world.getPlayerTwo().getCity().getHealth(),j*100,i*100,0, factor_x=1,factor_y=1,color = 0xffff0f00, mode = :default)
            @font.draw(@world.getPlayerTwo().getName(),j*100,i*110,0, factor_x=1,factor_y=1,color = 0xffff0f00, mode = :default)

          end
          #first player
          @world.getPlayerOne().getRegimes().each do |regime|
           
            if(regime.getType().getName() == "Scissor")
              @scissorImage.draw(regime.getLocation().getX*100,regime.getLocation().getY*100,0)

            elsif(regime.getType().getName() == "Rock")
              @rockImage.draw(regime.getLocation().getX*100,regime.getLocation().getY*100,0)

            elsif(regime.getType().getName() == "Paper")
              @paperImage.draw(regime.getLocation().getX*100,regime.getLocation().getY*100,0)
              

            end

            @font.draw(@world.getPlayerOne.getName() + " " + regime.getSoldNum().to_s + " men",regime.getLocation().getX*100,regime.getLocation().getY*100,0, factor_x=1,factor_y=1,color = 0xffff0f00, mode = :default)
          end
          #second player
          @world.getPlayerTwo().getRegimes().each do |regime|

            if(regime.getType().getName() == "Scissor")
              @scissorImage.draw(regime.getLocation().getX*100,regime.getLocation().getY*100,0)
              
            elsif(regime.getType().getName() == "Rock")
              @rockImage.draw(regime.getLocation().getX*100,regime.getLocation().getY*100,0)
              
            elsif(regime.getType().getName() == "Paper")
              @paperImage.draw(regime.getLocation().getX*100,regime.getLocation().getY*100,0)
            end
            @font.draw(@world.getPlayerTwo.getName() + " " + regime.getSoldNum().to_s + " men",regime.getLocation().getX*100,regime.getLocation().getY*100,0, factor_x=1,factor_y=1,color = 0xffff0f00, mode = :default)
          end
        end
      end

      for i in 0..(9)
        draw_line(i * 100,0,Gosu::Color.argb(0xffffffff),i * 100,700,Gosu::Color.argb(0xffffffff), z = 0, mode = :default)
      end
      for i in 0..(6)
        draw_line(0,i * 100,Gosu::Color.argb(0xffffffff),1000,i * 100,Gosu::Color.argb(0xffffffff), z = 0, mode = :default)
      end
      @boxCoords.each do |coords|
        if coords[0] != nil and coords[1] != nil
          draw_line(coords[0],coords[1], Gosu::Color.argb(0xffff0000), coords[0] + 100, coords[1], Gosu::Color.argb(0xffff0000), z = 0, mode = :default)
          draw_line(coords[0] ,coords[1]+ 100, Gosu::Color.argb(0xffff0000),coords[0], coords[1], Gosu::Color.argb(0xffff0000), z = 0, mode = :default)
          draw_line(coords[0] + 100,coords[1], Gosu::Color.argb(0xffff0000), coords[0] + 100, coords[1] + 100, Gosu::Color.argb(0xffff0000), z = 0, mode = :default)
          draw_line(coords[0],coords[1] + 100, Gosu::Color.argb(0xffff0000), coords[0] + 100, coords[1] + 100, Gosu::Color.argb(0xffff0000), z = 0, mode = :default)
        end
      end
      if @playerTurn == 1
        @font.draw("It is Player One's turn!",480,20,0, factor_x=1,factor_y=1,color = 0xffff0f00, mode = :default)
      elsif @playerTurn == 2
        @font.draw("It is Player Two's turn!",480,20,0, factor_x=1,factor_y=1,color = 0xffff0f00, mode = :default)
      end

      @mouseImage.draw(mouse_x,mouse_y,0)
      #recruit layout is where we recruit soldiers from, clicking on pictures for reference
      if @winner != nil
        @fontHuge.draw(@winner + " WINS!",350,350,0, factor_x=1,factor_y=1,color = 0xffffffff, mode = :default)
      end
      
    elsif @state == "recruit"
      draw_quad(0 ,  0 , Gosu::Color.argb(0xffffffff), 400, 0, Gosu::Color.argb(0xffffffff), 0, 100, Gosu::Color.argb(0xffffffff), 400, 100, Gosu::Color.argb(0xffffffff), z = 0, mode = :default)
      @rockImage.draw(0,0,0)
      @paperImage.draw(100,0,0)
      @scissorImage.draw(200,0,0)
      @cancelImage.draw(300,0,0)
      @mouseImage.draw(mouse_x,mouse_y,0)
    end
  end

  def button_down(id)
    case id
    when Gosu::MsLeft
      if @state == "normal"
        @X =  (mouse_x / 100 ).to_i
        @Y =  (mouse_y / 100 ).to_i
        @coordX = @X * 100
        @coordY = @Y * 100
        @playerOneCityPosition = @world.getPlayerOne().getCity().getLocation()
        @playerTwoCityPosition = @world.getPlayerTwo().getCity().getLocation()

        @playerOneRegimes = @world.getPlayerOne().getRegimes()
        @playerTwoRegimes = @world.getPlayerTwo().getRegimes()

        if @boxCoords.count == 2
          @boxCoords.clear
          if(@playerTurn == 1)
            @playerTurn = 2
          else
            @playerTurn = 1
          end
        end
        #attacking cities
        if @RegimeToMove != nil
          tempNewLocation = Location.new(@X,@Y)
          if @playerTurn == 2  ##weird bug fix?
            if @playerTwoCityPosition.eql?(Location.new(@X,@Y)) and @RegimeToMove.getLocation().isAdjacent(Location.new(@X,@Y))
              puts "wtf"
              @world.getPlayerTwo().getCity().damageCity(@RegimeToMove.getSoldNum)
              attacked = true
              @RegimeToMove = nil
            else
              ## player 1 reinforcing
              @playerOneRegimes.each do |regime|
                if regime.getLocation().eql?(Location.new(@X,@Y)) and regime.getLocation().isAdjacent(Location.new(@X,@Y))
                  @world.getPlayerOne().removeRegime(@RegimeToMove)
                  puts "ll"
                  regime.addSold(@RegimeToMove.getSoldNum)
                end
              end
              ## player 1 attacking
              attacked = false
              @playerTwoRegimes.each do |regime|
                if regime.getLocation().eql?(Location.new(@X,@Y)) and regime.getLocation().isAdjacent(Location.new(@X,@Y))
                  @RegimeToMove.fight(regime)
                  attacked = true
                end
              end

              ## player 1 moving
              if(!attacked)
                if (@RegimeToMove.getLocation().isAdjacent(Location.new(@X,@Y)))
                  @RegimeToMove.move(Location.new(@X,@Y))
                end
              end
              @RegimeToMove = nil
            end
          elsif @playerTurn == 1
            if @playerOneCityPosition.eql?(Location.new(@X,@Y)) and @RegimeToMove.getLocation().isAdjacent(Location.new(@X,@Y))

              @world.getPlayerOne().getCity().damageCity(@RegimeToMove.getSoldNum)
              @RegimeToMove = nil
            else
              ## player 2 reinforcing
              @playerTwoRegimes.each do |regime|
                if regime.getLocation().eql?(Location.new(@X,@Y)) and regime.getLocation().isAdjacent(Location.new(@X,@Y))
                  @world.getPlayerTwo().removeRegime(@RegimeToMove)

                  regime.addSold(@RegimeToMove.getSoldNum)
                end
              end

              ## player 1 attacking
              attacked = false
              @playerOneRegimes.each do |regime|
                if regime.getLocation().eql?(Location.new(@X,@Y)) and regime.getLocation().isAdjacent(Location.new(@X,@Y))
                  @RegimeToMove.fight(regime)
                  attacked = true
                end
              end
              ## player 2 moving
              if(!attacked)
                if (@RegimeToMove.getLocation().isAdjacent(Location.new(@X,@Y)))
                  @RegimeToMove.move(Location.new(@X,@Y))

                end
              end

              @RegimeToMove = nil
            end
          end

        elsif @playerTurn == 1
          @playerOneRegimes.each do |regime|

            if regime.getLocation().eql?(Location.new(@X,@Y))

              @RegimeToMove = regime

            end
          end
        elsif @playerTurn == 2
          @playerTwoRegimes.each do |regime|
            if regime.getLocation().eql?(Location.new(@X,@Y))
              @RegimeToMove = regime
            end
          end
        end

        if  @playerOneCityPosition.eql?(Location.new(@X,@Y)) and @playerTurn == 1
          regimesInTheWay = 0
          @playerOneRegimes.each do |regime|
            if regime.getLocation().eql?(Location.new(@X+1,@Y))
              regimesInTheWay += 1
            end
          end
          if regimesInTheWay == 0
            @state = "recruit"

          end
        elsif  @playerTwoCityPosition.eql?(Location.new(@X,@Y)) and @playerTurn == 2
          regimesInTheWay = 0
          @playerTwoRegimes.each do |regime|
            if regime.getLocation().eql?(Location.new(@X-1,@Y))
              regimesInTheWay += 1
            end
          end
          @playerOneRegimes.each do |regime|
            if regime.getLocation().eql?(Location.new(@X-1,@Y))
              regimesInTheWay += 1
            end
          end
          if regimesInTheWay == 0
            @state = "recruit"
          end

        else
          @boxCoords << [@coordX,@coordY]
        end
      elsif @state == "recruit"
        @choice = ""
        if mouse_x < 100
          @choice = "Rock"
        elsif mouse_x < 200
          @choice = "Paper"
        elsif mouse_x < 300
          @choice = "Scissor"
        end

        if (@choice != nil)
          if @choice == "Rock"
            if @playerTurn == 1
              @world.getPlayerOne().addRegime(Rock.new,75,Location.new(@X+1,@Y))
              @world.getPlayerOne().getCity().damageCity(75)
            elsif @playerTurn == 2
              @world.getPlayerTwo().addRegime(Rock.new,75,Location.new(@X-1,@Y))
              @world.getPlayerTwo().getCity().damageCity(75)
            end
          elsif @choice == "Paper"
            if @playerTurn == 1

              @world.getPlayerOne().addRegime(Paper.new,75,Location.new(@X+1,@Y))
              @world.getPlayerOne().getCity().damageCity(75)
            elsif @playerTurn == 2

              @world.getPlayerTwo().addRegime(Paper.new,75,Location.new(@X-1,@Y))
              @world.getPlayerTwo().getCity().damageCity(75)
            end
          elsif @choice == "Scissor"
            if @playerTurn == 1
              @world.getPlayerOne().addRegime(Scissor.new,75,Location.new(@X+1,@Y))
              @world.getPlayerOne().getCity().damageCity(75)
            elsif @playerTurn == 2
              @world.getPlayerTwo().addRegime(Scissor.new,75,Location.new(@X-1,@Y))
              @world.getPlayerTwo().getCity().damageCity(75)
            end
          end
          @state = "normal"
        end

      end

    end
    @world.getPlayerOne().removeDeadRegimes()
    @world.getPlayerTwo().removeDeadRegimes()
   
  end
#end if someones base is destroyed
  def update
    if @world.getPlayerOne().getCity().isDead()
      @winner = "PLAYER TWO"
    elsif @world.getPlayerTwo().getCity().isDead()
      @winner = "PLAYER ONE"
    end
  end
end



window = GameWindow.new
window.show
