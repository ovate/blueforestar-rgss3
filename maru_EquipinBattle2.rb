#★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
#
#Change equipment during battle 2
#
#Add "equipment" to individual command,
#Equipment can be changed during battle.
#
#★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★

#------------------------------------------------------------------------------
#Setting
module MARU_battleequip
  SWITCH = 1 #Switch to enable "equipment command"
  INDEX  = 3 #"Equip" command introduction position
  
             #INDEX placement
             # 0… before "attack" command
             # 1… between “attack” and “skill”
             # 2… between “skill” and “guard”
             # 3… between “guard” and “item”
             # 4… after “item”
#------------------------------------------------------------------------------
end

#==============================================================================
# ■ Window_ActorCommand
#------------------------------------------------------------------------------
# 　Window used to select actor actions on the battle screen.
#==============================================================================

class Window_ActorCommand < Window_Command
  #--------------------------------------------------------------------------
  # ● Create command list
  #--------------------------------------------------------------------------
  def make_command_list
    return unless @actor
    add_equip_command if $game_switches[MARU_battleequip::SWITCH] == true && MARU_battleequip::INDEX == 0
    add_attack_command
    add_equip_command if $game_switches[MARU_battleequip::SWITCH] == true && MARU_battleequip::INDEX == 1
    add_skill_commands
    add_equip_command if $game_switches[MARU_battleequip::SWITCH] == true && MARU_battleequip::INDEX == 2
    add_guard_command
    add_equip_command if $game_switches[MARU_battleequip::SWITCH] == true && MARU_battleequip::INDEX == 3
    add_item_command
    add_equip_command if $game_switches[MARU_battleequip::SWITCH] == true && MARU_battleequip::INDEX == 4
  end
  #--------------------------------------------------------------------------
  # ● Add item command to list
  #--------------------------------------------------------------------------
  def add_equip_command
    add_command("Equipment", :equip)
  end
end

#==============================================================================
# ■ Scene_Battle
#------------------------------------------------------------------------------
# 　Class for battle screen processing.
#==============================================================================

class Scene_Battle < Scene_Base
  #--------------------------------------------------------------------------
  # ● Create all windows
  #--------------------------------------------------------------------------
  alias ma0075_create_all_windows create_all_windows
  def create_all_windows
    ma0075_create_all_windows
    create_equip_window if $game_switches[MARU_battleequip::SWITCH] == true
  end
  #--------------------------------------------------------------------------
  # ● Creating actor command window
  #--------------------------------------------------------------------------
  alias ma0075_create_actor_command_window create_actor_command_window
  def create_actor_command_window
    ma0075_create_actor_command_window
    @actor_command_window.set_handler(:equip, method(:command_equip))
  end
  #--------------------------------------------------------------------------
  # ● Create equipment window
  #--------------------------------------------------------------------------
  def create_equip_window
    @status_equip_window = Window_EquipStatus.new(0, @help_window.height)
    @status_equip_window.visible = false
    @status_equip_window.viewport = @viewport
    wx = @status_equip_window.width
    wy = @help_window.height
    ww = Graphics.width - @status_equip_window.width
    @command_equip_window = Window_EquipCommand.new(wx, wy, ww)
    @command_equip_window.visible = false
    @command_equip_window.deactivate
    @command_equip_window.viewport = @viewport
    @command_equip_window.help_window = @help_window
    @command_equip_window.set_handler(:equip,    method(:command_equip_e))
    @command_equip_window.set_handler(:optimize, method(:command_optimize))
    @command_equip_window.set_handler(:clear,    method(:command_clear))
    @command_equip_window.set_handler(:cancel,   method(:on_command_cancel))
    wx = @status_equip_window.width
    wy = @command_equip_window.y + @command_equip_window.height
    ww = Graphics.width - @status_equip_window.width
    @slot_window = Window_EquipSlot.new(wx, wy, ww)
    @slot_window.visible = false
    @slot_window.viewport = @viewport
    @slot_window.help_window = @help_window
    @slot_window.status_window = @status_equip_window
    @slot_window.set_handler(:ok,       method(:on_slot_ok))
    @slot_window.set_handler(:cancel,   method(:on_slot_cancel))
    wx = 0
    wy = @slot_window.y + @slot_window.height
    ww = Graphics.width
    wh = Graphics.height - wy
    @item_equip_window = Window_EquipItem.new(wx, wy, ww, wh)
    @item_equip_window.visible = false
    @item_equip_window.viewport = @viewport
    @item_equip_window.help_window = @help_window
    @item_equip_window.status_window = @status_equip_window
    @item_equip_window.set_handler(:ok,     method(:on_item_equip_ok))
    @item_equip_window.set_handler(:cancel, method(:on_item_equip_cancel))
    @slot_window.item_window = @item_equip_window
  end
  #--------------------------------------------------------------------------
  # ● Command [equipment]
  #--------------------------------------------------------------------------
  def command_equip
    @help_window.show
    @actor = BattleManager.actor
    @status_equip_window.actor = @actor
    @slot_window.actor = @actor
    @item_equip_window.actor = @actor
    @status_equip_window.refresh
    @status_equip_window.show
    @command_equip_window.refresh
    @command_equip_window.show.activate
    @slot_window.refresh
    @slot_window.show
    @item_equip_window.refresh
    @item_equip_window.show
  end
  #--------------------------------------------------------------------------
  # ● Command [change equipment]
  #--------------------------------------------------------------------------
  def command_equip_e
    @slot_window.activate
    @slot_window.select(0)
  end
  #--------------------------------------------------------------------------
  # ● Command [optimize]
  #--------------------------------------------------------------------------
  def command_optimize
    Sound.play_equip
    @actor.optimize_equipments
    @status_equip_window.refresh
    @slot_window.refresh
    @command_equip_window.activate
  end
  #--------------------------------------------------------------------------
  # ● Command [remove all]
  #--------------------------------------------------------------------------
  def command_clear
    Sound.play_equip
    @actor.clear_equipments
    @status_equip_window.refresh
    @slot_window.refresh
    @command_equip_window.activate
  end
  #--------------------------------------------------------------------------
  # ● Command [cancel]
  #--------------------------------------------------------------------------
  def on_command_cancel
    @help_window.hide
    @status_equip_window.hide
    @command_equip_window.hide
    @slot_window.hide
    @item_equip_window.hide
    @actor_command_window.activate
    @actor_command_window.select(0)
  end
  #--------------------------------------------------------------------------
  # ● Slot [decision]
  #--------------------------------------------------------------------------
  def on_slot_ok
    @item_equip_window.activate
    @item_equip_window.select(0)
  end
  #--------------------------------------------------------------------------
  # ● Slot [cancel]
  #--------------------------------------------------------------------------
  def on_slot_cancel
    @slot_window.unselect
    @command_equip_window.activate
  end
  #--------------------------------------------------------------------------
  # ● Item [decision]
  #--------------------------------------------------------------------------
  def on_item_equip_ok
    Sound.play_equip
    @actor.change_equip(@slot_window.index, @item_equip_window.item)
    @slot_window.activate
    @slot_window.refresh
    @item_equip_window.unselect
    @item_equip_window.refresh
  end
  #--------------------------------------------------------------------------
  # ● Item [cancel]
  #--------------------------------------------------------------------------
  def on_item_equip_cancel
    @slot_window.activate
    @item_equip_window.unselect
  end
end