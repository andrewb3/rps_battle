class Game
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