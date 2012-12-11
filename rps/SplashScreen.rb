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