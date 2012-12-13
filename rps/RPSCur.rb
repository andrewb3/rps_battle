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
  def eql?(other)
    if @name == other.getName()
      return true
    else
      return false
    end
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
    puts "kkkkk"
    diffX = @posX - other.getX
    diffY = @posY - other.getY
    puts diffX
    puts diffY
    if diffX == 1 or diffX == -1
      if ((diffY == 1 or diffY == 0) or diffY == -1)
        puts "ll"
        return true
      else
        return false
      end
    elsif diffX == 0
      if diffY== 1 or diffY == -1
        puts "jjl"
        return true
      else
        return false
      end
    else
      puts "PPPP"

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

  def getName
    return @Type.getName
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
  
  def getPlayer(num)
    if num == 1
      return @playerOne
    else
      return @playerTwo
    end
  end
  
  def getPlayerOne()
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
    @stage = "recruit"
    @turn = 0
    @pl = 1
    @opp = 2
    @playOnce = true
    @RegimeToMove = nil
    @msg = "Welcome"
    @font = Gosu::Font.new(self, Gosu::default_font_name,20)
    @fontHuge = Gosu::Font.new(self, Gosu::default_font_name,50)
    @playerTurn = 1
    @boxCoords = []
    @clickQueue = []
    @rpsIntro = Gosu::Song.new(self, "rpsintro.ogg")
    @scissorsSound = Gosu::Sample.new(self, "scissors.ogg")
    @rockSound = Gosu::Sample.new(self, "rock.ogg")
    @paperSound = Gosu::Sample.new(self, "paper.ogg")
    @battleSound = Gosu::Sample.new(self, "battle.ogg")
    @player1wins = Gosu::Song.new(self, "p1wins.ogg")
    @player2wins = Gosu::Song.new(self, "p2wins.ogg")
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
            @font.draw("Health: " + @world.getPlayerOne().getCity().getHealth().to_s,j*100,i*100,0, factor_x=1,factor_y=1,color = 0xffff0f00, mode = :default)
            @font.draw(@world.getPlayerOne().getName(),j*100,i*110,0, factor_x=1,factor_y=1,color = 0xffff0f00, mode = :default)

          elsif @world.getPlayerTwo().getCity().getLocation().eql?(Location.new(j,i))
            @cityImage.draw(j*100,i*100,0)
            @font.draw("Health: " + @world.getPlayerTwo().getCity().getHealth().to_s,j*100,i*100,0, factor_x=1,factor_y=1,color = 0xffff0f00, mode = :default)
            @font.draw(@world.getPlayerTwo().getName(),j*100,i*110,0, factor_x=1,factor_y=1,color = 0xffff0f00, mode = :default)

          end

            #first player
          @world.getPlayerOne().getRegimes().each do |regime|
           
            if(regime.getType().getName() == "Scissor")
              @scissorImage.draw(regime.getLocation().getX*100,regime.getLocation().getY*100,0)
              @font.draw(regime.getSoldNum().to_s + " men",regime.getLocation().getX*100,regime.getLocation().getY*100 + 80 ,0, factor_x=1,factor_y=1,color = 0xffffffff, mode = :default)

            elsif(regime.getType().getName() == "Rock")
              @rockImage.draw(regime.getLocation().getX*100,regime.getLocation().getY*100,0)
              @font.draw(regime.getSoldNum().to_s + " men",regime.getLocation().getX*100,regime.getLocation().getY*100 + 80 ,0, factor_x=1,factor_y=1,color = 0xffffffff, mode = :default)

            elsif(regime.getType().getName() == "Paper")
              @paperImage.draw(regime.getLocation().getX*100,regime.getLocation().getY*100,0)
              @font.draw(regime.getSoldNum().to_s + " men",regime.getLocation().getX*100,regime.getLocation().getY*100 + 80 ,0, factor_x=1,factor_y=1,color = 0xffffffff, mode = :default)


            end

            @font.draw(@world.getPlayerOne.getName(), regime.getLocation.getX*100,regime.getLocation().getY*100,0, factor_x=1,factor_y=1,color = 0xffff0f00, mode = :default) 
          end
          #second player
          @world.getPlayerTwo().getRegimes().each do |regime|

            if(regime.getType().getName() == "Scissor")
              @scissorImage.draw(regime.getLocation().getX*100,regime.getLocation().getY*100,0)
              @font.draw(regime.getSoldNum().to_s + " men",regime.getLocation().getX*100,regime.getLocation().getY*100 + 80 ,0, factor_x=1,factor_y=1,color = 0xffffffff, mode = :default)
        
            elsif(regime.getType().getName() == "Rock")
              @rockImage.draw(regime.getLocation().getX*100,regime.getLocation().getY*100,0)
              @font.draw(regime.getSoldNum().to_s + " men",regime.getLocation().getX*100,regime.getLocation().getY*100 + 80 ,0, factor_x=1,factor_y=1,color = 0xffffffff, mode = :default)

            elsif(regime.getType().getName() == "Paper")
              @paperImage.draw(regime.getLocation().getX*100,regime.getLocation().getY*100,0)
              @font.draw(regime.getSoldNum().to_s + " men",regime.getLocation().getX*100,regime.getLocation().getY*100 + 80 ,0, factor_x=1,factor_y=1,color = 0xffffffff, mode = :default)

            end
            @font.draw(@world.getPlayerTwo.getName(),regime.getLocation().getX*100,regime.getLocation().getY*100,0, factor_x=1,factor_y=1,color = 0x0f0f0fff, mode = :default)
            if @stage == "move"
              @font.draw("Yes Master?", @tempLoc.getX*100,@tempLoc.getY*100 + 50 ,0, factor_x=1,factor_y=1,color = 0xffff0000, mode = :default)
            end
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
      if @msg == "Welcome"
        @rpsIntro.play
        @font.draw("Welcome to RPS: Ultimate Battles of all Time", 100,100,0, factor_x=1,factor_y=1,color=0xffff0000, mode = :default)
        @font.draw("Click City to Recruit Your Army", 100, 140, 0,  factor_x=1,factor_y=1,color = 0xffff0f00, mode = :default)
        @font.draw("DESTROY YOUR OPPONENT CITY", 100, 180, 0, factor_x=1, factor_y=1, color = 0xffff0000, mode = :default)
      else
        @font.draw(@msg,0,40,0, factor_x=1,factor_y=1,color = 0xffff0f00, mode = :default)
      end
      promptPlayer = ""
      if @stage == "recruit"
        promptPlayer = "Recruit by clicking city, or click one of your regiments to select them!"
      elsif @stage == "move"
        promptPlayer = "Click an adjacent square to selected regiment to move or ATTACK"
      elsif @stage == "placement"
        promptPlayer = "Place your new Regiment next to your city!"
      end
        @font.draw(promptPlayer,380,60,0, factor_x=1,factor_y=1,color = 0xffff0f00, mode = :default)
        if @stage == "placement"
         @font.draw("You Selected " + @choice , 480, 80, 0, factor_x=1, factor_y=1, color = 0xffff0000, mode = :default)
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
    @font.draw("Select Your Regiment You will get Regiment of 75 and lose 75 health", 100, 180, 0, factor_x=1, factor_y=1, color = 0xffff0000, mode = :default)
 
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
      puts @stage
      puts @pl

      @X =  (mouse_x / 100 ).to_i
      @Y =  (mouse_y / 100 ).to_i
      @coordX = @X * 100
      @coordY = @Y * 100
      puts @stage
      if @state == "normal"

        @tempLoc = Location.new(@X,@Y)
        @curPlayerCityPosition = @world.getPlayer(@pl).getCity().getLocation()
        @oppCityPosition = @world.getPlayer(@opp).getCity().getLocation()
        @curPlRegimes = @world.getPlayer(@pl).getRegimes()
        @oppRegimes = @world.getPlayer(@opp).getRegimes()
        @blocked = false
        @alreadyMoved = false
        @attacked = false
        @msg = ""
        
        if @stage == "recruit"
          @RegimeToMove = nil
          if (@tempLoc.eql?(@curPlayerCityPosition))
            @state = "recruit"
          else 
            @curPlRegimes.each do |regime|
              if regime.getLocation().eql?(Location.new(@X,@Y))
                @RegimeToMove = regime
              end
            end
            if (@RegimeToMove != nil)
              @stage = "move"
            end
          end
        elsif @stage == "move"
          if @RegimeToMove == nil
            @stage = "recruit"
          elsif !(@RegimeToMove.getLocation.isAdjacent(@tempLoc))
            @stage = "recruit"
            @msg = "invalid selection must move regiment to adjacent square"
          elsif @tempLoc.eql?(@oppCityPosition)
                 @world.getPlayer(@opp).getCity.damageCity(@RegimeToMove.getSoldNum)
                 @turn = @turn + 1  
                 @attacked = true
                 @battleSound.play
                 @RegimeToMove = nil
                 @msg = "The city is under ATTACK!"
                 whoseTurn()
          elsif (@tempLoc.eql?(@curPlayerCityPosition))
            @msg =  "You cant move there! We'll go back to recruit phase"
            @stage = "recruit"
            @blocked = true
            #@RegimeToMove = nil
          else
            @oppRegimes.each do |regime|
                   if regime.getLocation().eql?(Location.new(@X,@Y))
                     @RegimeToMove.fight(regime)
                     @attacked = true
                     #@RegimeToMove = nil
                     @turn = @turn + 1
                     @battleSound.play
                     @msg = "What a FIGHT!"
                     whoseTurn()
                   end
                 end
                 if @attacked == false
                   @curPlRegimes.each do |regime|
                     if regime.getLocation().eql?(Location.new(@X,@Y))
                       if ( @RegimeToMove and regime.getName == @RegimeToMove.getName)
                         regime.addSold(@RegimeToMove.getSoldNum)
                         @world.getPlayer(@pl).removeRegime(@RegimeToMove)
                         @turn = @turn + 1
                         whoseTurn()
                        # @RegimeToMove = nil
                         @alreadyMoved = true
                        break
                       else
                         @blocked = true  
                         @msg =  "You cant move there! We'll go back to recruit phase"
                         @stage = "recruit"
                         @RegimeToMove = nil
                     end  
                   end
                   if !(@blocked or (@alreadyMoved or @attacked))
                     @RegimeToMove.move(@tempLoc)
                     @RegimeToMove = nil
                     @turn = @turn + 1
                     @msg = "Oh what strategy and cunning!"
                     whoseTurn()
                   end
                 end 
               end
             end    
        elsif @stage == "placement"
          if @tempLoc.isAdjacent(@world.getPlayer(@pl).getCity.getLocation)
             @curPlRegimes.each do |regime|
               if regime.getLocation().eql?(@tempLoc)
                 if regime.getName == @choice
                      ##addSoldiers
                   @world.getPlayer(@pl).getCity().damageCity(75)                
                   puts "the lotion"
                      regime.addSold(75)
                      @turn = @turn + 1
                      whoseTurn()
                      @blocked = true
                 else
                   @blocked = true
                 end
               end
             end
             @oppRegimes.each do |regime|
               if regime.getLocation().eql?(@tempLoc)
                 @blocked = true
               end
             end 
            if !@blocked
              if @choice == "Rock"
                @world.getPlayer(@pl).addRegime(Rock.new,75,@tempLoc)
                @world.getPlayer(@pl).getCity().damageCity(75)
                @turn = @turn + 1
                @rockSound.play
                whoseTurn()
                @stage = "recruit"
                @state = "normal"
              elsif @choice == "Paper"
                @world.getPlayer(@pl).addRegime(Paper.new,75,@tempLoc)
                @world.getPlayer(@pl).getCity().damageCity(75)                
                @turn = @turn + 1  
                whoseTurn()
                @paperSound.play
                @stage = "recruit" 
                @state = "normal"
              elsif @choice == "Scissor"
                @world.getPlayer(@pl).addRegime(Scissor.new,75,@tempLoc)
                @world.getPlayer(@pl).getCity().damageCity(75) 
                @turn = @turn + 1
                @scissorsSound.play
                whoseTurn()
                @stage = "recruit"
                @state = "normal"
              end
            end
          else
            @stage = "recruit"
            @msg = "Looks like your having trouble placing regime, lets go back..."
          end
        end
      elsif @state == "recruit"
        
        puts "test"
        @choice = ""
        if mouse_x < 100
          @choice = "Rock"
          @state = "normal"
          @stage = "placement"
        elsif mouse_x < 200
          @choice = "Paper"
          @state = "normal"
          @stage = "placement"
        elsif mouse_x < 300
          @choice = "Scissor"
          @state = "normal"
          @stage = "placement"
        else
          @state = "normal"
        end
      end     
    end
    @world.getPlayerOne().removeDeadRegimes()
    @world.getPlayerTwo().removeDeadRegimes()
   
  end
#end if someones ba se is destroyed
  def update
    if @world.getPlayerOne().getCity().isDead()
      @winner = "PLAYER TWO"
      if @playOnce
        player2wins.play
        @playOnce = false
      end
      @stage = "end"
    elsif @world.getPlayerTwo().getCity().isDead()
      @winner = "PLAYER ONE"
      if @playOnce
        @playOnce = false
        @player1wins.play
      end
    end
  end
  def whoseTurn
    if @turn > 1
      @turn = 0
      @stage = "recruit"
      if @pl == 1
        @pl = 2
        @opp = 1
       
        @playerTurn = 2
      else
        @pl = 1
        @opp = 2
        @playerTurn = 1
      end
    end
  end
end



window = GameWindow.new
window.show
