#★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
#
#Use the switch to determine the item's availability.
#
#How to use
#Put <ITEM_USE_SWITCH_n> (n is the switch number) in the item Note box.
#When that switch is ON, the item cannot be used.
#
#★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★

#--------------------------------------------------------------------------
# ★ Switch number to enable
#--------------------------------------------------------------------------
class RPG::BaseItem
  def item_use_switch
    /<ITEM_USE_SWITCH_(\d+)>/ =~ note ? $1.to_i : 0
  end
end


#==============================================================================
# ■ Game_BattlerBase
#------------------------------------------------------------------------------
# Class for handling battlers. Includes ability value and calculation methods.
# This class is used as a superclass of the Game_BattlerBase.
#==============================================================================
class Game_BattlerBase
  #--------------------------------------------------------------------------
  # ● Skill / item availability check
  #--------------------------------------------------------------------------
  def usable?(item)
    if item != nil
      if item.item_use_switch != 0
        return false if $game_switches[item.item_use_switch] == true
      end
    end
    return skill_conditions_met?(item) if item.is_a?(RPG::Skill)
    return item_conditions_met?(item)  if item.is_a?(RPG::Item)
    return false
  end
end