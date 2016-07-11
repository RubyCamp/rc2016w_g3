class Background < Sprite
  attr_accessor :vx

  def initialize(x, y,vx, filename , do_loop=false)
    image = Image.load(filename)
    image.set_color_key([0, 0, 0])
    @image = image
    super(x, y, image)
    self.z = 0
    @do_loop = do_loop
    @vx = vx
  end

  def update
    vanish if 0 >= (@image.width + self.x) && !@do_loop
    if @do_loop && self.x <= -(@image.width - Window.width)
      self.x = -((@image.width / 2) - Window.width)
    elsif vx >= 0
      self.x = self.x - @vx
    end
  end
end
