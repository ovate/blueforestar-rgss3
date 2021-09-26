#★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
#
#Creates a normal attack button.
#
#★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★

module MARU__attack_command
  
  #Setting
  
  ATTACK_BOTTAN = :X                      #Normal attack button
  WINDOW_OPEN  = true                     #Whether to show a help window
  WINDOW_TEXT  = "X(A key) Normal Attack" #Text content
  
  #End of setting
  
end  

#==============================================================================
# ■ Window_PartyCommand
#------------------------------------------------------------------------------
# 　This window is for selecting whether to fight or escape on the battle screen.
#==============================================================================
class Window_PartyCommand < Window_Command
  #--------------------------------------------------------------------------
  # ● Handling process such as decision and cancellation
  #--------------------------------------------------------------------------
  alias ma__process_handling process_handling
  def process_handling
    return unless open? && active
    ma__process_handling
    return process_a if handle?(:X) && Input.trigger?(MARU__attack_command::ATTACK_BOTTAN)
  end
  #--------------------------------------------------------------------------
  # ● A key is pressed
  #--------------------------------------------------------------------------
  def process_a
    Sound.play_ok
    Input.update
    deactivate
    call_handler(:X)
  end
end

#==============================================================================
# ■ Scene_Battle
#------------------------------------------------------------------------------
# 　Class for battle screen processing.
#==============================================================================

class Scene_Battle < Scene_Base
  #--------------------------------------------------------------------------
  # ● Create party command window
  #--------------------------------------------------------------------------
  alias ma__create_party_command_window create_party_command_window
  def create_party_command_window
    ma__create_party_command_window
    @party_command_window.set_handler(:X,      method(:command_attack_all))
    if MARU__attack_command::WINDOW_OPEN
    @help_bot_window = Window_Selectable.new(0,Graphics.height-@party_command_window.height-48,250,48)
    @help_bot_window.draw_text(0,0,232,24,MARU__attack_command::WINDOW_TEXT,1)
    @help_bot_window.hide
    end
  end
  #--------------------------------------------------------------------------
  # ● Start actor command
  #--------------------------------------------------------------------------
  alias ma__start_actor_command_selection start_actor_command_selection
  def start_actor_command_selection
    @help_bot_window.hide if MARU__attack_command::WINDOW_OPEN
    ma__start_actor_command_selection
  end
  #--------------------------------------------------------------------------
  # ● Start party command
  #--------------------------------------------------------------------------
  alias ma_start_party_command_selection start_party_command_selection
  def start_party_command_selection
    @help_bot_window.show if MARU__attack_command::WINDOW_OPEN
    ma_start_party_command_selection
  end
  #--------------------------------------------------------------------------
  # ● Command for run away
  #--------------------------------------------------------------------------
  alias ma__command_escape command_escape
  def command_escape
    @help_bot_window.hide if MARU__attack_command::WINDOW_OPEN
    ma__command_escape
  end
  #--------------------------------------------------------------------------
  # ● Command for attack all
  #--------------------------------------------------------------------------
  def command_attack_all
    @help_bot_window.hide if MARU__attack_command::WINDOW_OPEN
    x = $game_party.battle_members.size
    x.times{|i|$game_party.members[i].input.set_attack if $game_party.members[i].attack_usable?}
    turn_start
  end
end