#★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
#
#This script manages enemy strength with variables (ver1.10)
#
#★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
=begin
Update log
ver1.10  Modified to calculate the reinforcement value from the variable
=end

module MARU_degree

#-----------------------------------------------------------------------------
#Setting
  #Variable number used for difficulty change
  VARIABLES = 3
  
  #Ratio of enhancement to the value of the variable
  #(If default is 0.01, the variable of 1000 is factored of 0.01 times 10)
  DEGREE_RATE = 0.01
  
  #Parameter to change strength (0 = do not change, 1 = change)
  #[HP, MP, Attack, Defense, Magic, Magic Defense, Agility, Luck]
  PALAM = [1,0,1,0,1,0,0,0]
#End of setting
#-----------------------------------------------------------------------------
end

#==============================================================================
# ■ Game_Enemy
#------------------------------------------------------------------------------
# This class is used inside the Game_Troop ($game_troop).
#==============================================================================

class Game_Enemy < Game_Battler
  #--------------------------------------------------------------------------
  # ● Acquisition of normal ability value
  #--------------------------------------------------------------------------
  alias maru_param param
  def param(param_id)
    value = param_base(param_id) + param_plus(param_id)
    value *= param_rate(param_id) * param_buff_rate(param_id) * degree(param_id)
    [[value, param_max(param_id)].min, param_min(param_id)].max.to_i
  end
  #--------------------------------------------------------------------------
  # ● Rate of change by difficulty
  #--------------------------------------------------------------------------
  def degree(param_id)
    return 1.0 if $game_variables[MARU_degree::VARIABLES] == 0
    return MARU_degree::DEGREE_RATE * $game_variables[MARU_degree::VARIABLES] if MARU_degree::PALAM[param_id] == 1
    return 1.0
  end
end