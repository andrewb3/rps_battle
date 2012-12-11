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