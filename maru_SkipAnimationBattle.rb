#★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
#
#Animation skip (battle)
#
#While pressing the set button,
#Animation aren't shown.
#
#★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★

module MARU_SKIP_ANIME
#---------------------------------------------------------------------------
#Setting
  BOTTAN = :A #Button for use for skipping animation
#End of setting
#---------------------------------------------------------------------------
end




#==============================================================================
# ■ Scene_Battle
#------------------------------------------------------------------------------
# 　Class performs battle screen processing.
#==============================================================================
class Scene_Battle < Scene_Base
  #--------------------------------------------------------------------------
  # ● Animation display
  #     targets      : Target array
  #     animation_id : Animation ID (-1: Same as normal attack)
  #--------------------------------------------------------------------------  
   alias maru_show_animation show_animation
   def show_animation(targets, animation_id)
    if Input.press?(MARU_SKIP_ANIME::BOTTAN)
     return
    end
    maru_show_animation(targets, animation_id)
  end
  #--------------------------------------------------------------------------
  # ● Fast forward
  #--------------------------------------------------------------------------
  alias maru_show_fast? show_fast?
  def show_fast?
    Input.press?(:A) || Input.press?(:C) || Input.press?(MARU_SKIP_ANIME::BOTTAN)
  end
end