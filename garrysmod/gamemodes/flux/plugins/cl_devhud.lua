PLUGIN:set_name("Flux Dev HUD")
PLUGIN:set_author("Mr. Meow")
PLUGIN:set_description("Adds developer HUD.")

function PLUGIN:HUDPaint()
  if (fl.development) then
    if (hook.Run("HUDPaintDeveloper") == nil) then
      draw.SimpleText("Flux version "..(GAMEMODE.Version or "UNKNOWN")..", developer mode on.", "default", 8, ScrH() - 18, Color(200, 200, 200, 200))
    end
  end
end
