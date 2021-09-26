#★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
#
#  ★ Animate State for RGSS3 Ver1.00
#      Display state icons based on order.
#  Source: neomemo URL http://neomemo.web.fc2.com/top.html
#
#  【Notice】
#  If the script doesn't work, don't contact the author.
#
#★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★

module StateAnime
  # Icon number: represent by horizontal (0 to 16) + vertical (after 0) x 16
  # ▼ Setting
  NOR = 0             # Icon number when the state is normal
  SPE = 50            # Animation speed (1 sec = 60)
end

#==============================================================================
# ■ StateIcons
#==============================================================================

class StateIcons
  #--------------------------------------------------------------------------
  # ● Instance variables
  #--------------------------------------------------------------------------
  attr_reader   :x                        # X coordinate
  attr_reader   :y                        # Y coordinate
  attr_reader   :bitmap                   # Bitmap (back of icon)
  #--------------------------------------------------------------------------
  # ● Object initialization
  #--------------------------------------------------------------------------
  def initialize(icons, x, y, bitmap)
    @icons  = icons
    @x , @y = x , y
    @bitmap = bitmap
  end
  #--------------------------------------------------------------------------
  # ● Icon
  #     index : Number of display
  #--------------------------------------------------------------------------
  def icon(index)
    return @icons[index % @icons.size]
  end
  #--------------------------------------------------------------------------
  # ● Dispose
  #--------------------------------------------------------------------------
  def dispose
    @bitmap.dispose
  end
end

#==============================================================================
# ■ Window_Base
#==============================================================================

class Window_Base
  #--------------------------------------------------------------------------
  # ● Object initialization
  #--------------------------------------------------------------------------
  alias :stateanime_initialize :initialize
  def initialize(x, y, width, height)
    stateanime_initialize(x, y, width, height)
    @stateanime_new   = true
    @stateanime_set   = []
    @stateanime_count = 0
  end
  #--------------------------------------------------------------------------
  # ● State animation remove
  #--------------------------------------------------------------------------
  alias :stateanime_dispose :dispose
  def dispose
    stateanime_dispose
    for state in @stateanime_set do state.dispose end
  end
  #--------------------------------------------------------------------------
  # ● Clear state animation
  #--------------------------------------------------------------------------
  def clear_stateanime
    for state in @stateanime_set do state.dispose end
    @stateanime_new   = false
    @stateanime_set   = []
  end
  #--------------------------------------------------------------------------
  # ● State animation drawing
  #     obj: State icon class to draw
  #--------------------------------------------------------------------------
  def draw_stateanime(obj)
    self.contents.clear_rect(obj.x, obj.y, 24, 24)
    self.contents.blt(obj.x, obj.y, obj.bitmap, Rect.new(0, 0, 24, 24))
    draw_icon(obj.icon(@stateanime_count / StateAnime::SPE), obj.x, obj.y)
  end
  #--------------------------------------------------------------------------
  # ● Update frame
  #--------------------------------------------------------------------------
  alias :stateanime_update :update
  def update
    stateanime_update
    unless @stateanime_set.empty?
      @stateanime_count += 1
      if @stateanime_count % StateAnime::SPE == 0
        @stateanime_new = true unless @stateanime_new
        for obj in @stateanime_set do draw_stateanime(obj) end
      end
    end
  end
  #--------------------------------------------------------------------------
  # ☆ Draw state
  #--------------------------------------------------------------------------
  def draw_actor_icons(actor, x, y, dummy_width = 24)
    clear_stateanime if @stateanime_new
    icons = []
    icons += actor.state_icons
    icons += actor.buff_icons
    icons.push(StateAnime::NOR) if icons.empty?
    icons.uniq!
    src_rect = Rect.new(x, y, 24, 24)
    bitmap   = Bitmap.new(24, 24)
    bitmap.blt(0, 0, self.contents, src_rect)
    obj = StateIcons.new(icons, x, y, bitmap)
    @stateanime_set.push(obj)
    draw_stateanime(obj)
  end
end