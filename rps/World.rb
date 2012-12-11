
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