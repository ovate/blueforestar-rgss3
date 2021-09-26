#★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
#
#Change character description
#
#★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★

module DescriptionChange
  CHANGE = [
  #★Setting
  #1st Array
  [
  1, # Used to change character description
  3, # Switch used to change character description
  
  #When using a control character ↓, add two \ as shown in the example.
  #First line of character description after change
  "You can change the \\C[2]description like this\\c[0]. \\n[1]",
  #Changed character description 2nd line
  "If it's too long, description will be cut off."
  ],
  #Second array (If you want to change more, copy and use the array)
  [
  1,
  3,
  "If there are multiple arrays, the array above takes priority.",
  "In the sample project, the message ↑ should flow."
  ]
  #★End of setting
  ]
end

#==============================================================================
# ■ Game_Actor
#------------------------------------------------------------------------------
# Class for Game_Actors ($game_actors)
# Referenced by the Game_Party ($game_party)
#==============================================================================
class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # ● Get description
  #--------------------------------------------------------------------------
  alias description_change description
  def description
    DescriptionChange::CHANGE.each do |des|
      return des[2] + "\n" + des[3] if actor.id == des[0] && $game_switches[des[1]]
    end
    description_change
  end
end