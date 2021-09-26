#★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
#
#How to use
#
#In the Note box for the item you want to limit
#<ITEM_LIMIT_n>          (n is the maximum number)
#
#★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★

#--------------------------------------------------------------------------
# ★ Number of possession
#--------------------------------------------------------------------------
  class RPG::BaseItem
    def item_limitation
      /<ITEM_LIMIT_(\d+)>/ =~ note ? $1.to_i : 99 
    end
  end

#==============================================================================
# ■ Game_Party
#------------------------------------------------------------------------------
# This class handles parties. Includes information such as money and items.
# Instance of this class are referenced in $game_party.
#==============================================================================
class Game_Party < Game_Unit
  #--------------------------------------------------------------------------
  # ● Maximum number of items
  #--------------------------------------------------------------------------
  alias maru0075_max_item_number max_item_number
  def max_item_number(item)
   item.item_limitation
  end
end