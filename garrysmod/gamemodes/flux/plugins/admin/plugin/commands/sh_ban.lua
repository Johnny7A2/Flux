local COMMAND = Command.new("ban")
COMMAND.name = "Ban"
COMMAND.description = "#BanCMD_Description"
COMMAND.syntax = "#BanCMD_Syntax"
COMMAND.category = "administration"
COMMAND.arguments = 2
COMMAND.immunity = true
COMMAND.aliases = {"plyban"}

function COMMAND:OnRun(player, targets, duration, ...)
  local pieces = {...}
  local reason = "You have been banned."

  duration = fl.admin:InterpretBanTime(duration)

  if (!isnumber(duration)) then
    fl.player:Notify(player, "'"..tostring(duration).."' could not be interpreted as duration!")

    return
  end

  if (#pieces > 0) then
    reason = string.Implode(" ", pieces)
  end

  for k, v in ipairs(targets) do
    fl.admin:Ban(v, duration, reason)
  end

  for k, v in ipairs(_player.GetAll()) do
    local time = "#for "..fl.lang:NiceTimeFull(v:GetNetVar("language"), duration)

    if (duration <= 0) then time = L"permanently" end

    local phrase = L("BanMessage", (IsValid(player) and player:Name()) or "Console", util.PlayerListToString(targets)).." "..time..". ("..reason..")"

    v:Notify(phrase)
  end
end

COMMAND:register()
