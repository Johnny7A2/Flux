function flChatbox:OnThemeLoaded(activeTheme)
  local scrW, scrH = ScrW(), ScrH()

  font.Create("flChatFont", {
    font = "Arial",
    size = 16,
    weight = 1000
  })

  activeTheme:SetFont("Chatbox_Normal", "flChatFont", font.Scale(20))
  activeTheme:SetFont("Chatbox_Bold", "flRobotoCondensedBold", font.Scale(20))
  activeTheme:SetFont("Chatbox_Italic", "flRobotoCondensedItalic", font.Scale(20))
  activeTheme:SetFont("Chatbox_ItalicBold", "flRobotoCondensedItalicBold", font.Scale(20))
  activeTheme:SetFont("Chatbox_Syntax", "flRobotoCondensed", font.Scale(24))

  activeTheme:SetOption("Chatbox_Width", scrW / 3)
  activeTheme:SetOption("Chatbox_Height", scrH / 3)
  activeTheme:SetOption("Chatbox_X", 8)
  activeTheme:SetOption("Chatbox_Y", scrH - activeTheme:GetOption("Chatbox_Height") - 32)
end

function flChatbox:OnResolutionChanged(newW, newH)
  theme.SetOption("Chatbox_Width", newW / 3)
  theme.SetOption("Chatbox_Height", newH / 3)
  theme.SetOption("Chatbox_X", 8)
  theme.SetOption("Chatbox_Y", newH - theme.GetOption("Chatbox_Height") - 32)

  if (chatbox.panel) then
    chatbox.panel:Remove()
    chatbox.panel = nil
  end
end

function flChatbox:PlayerBindPress(player, bind, bPress)
  if (fl.client:HasInitialized() and (string.find(bind, "messagemode") or string.find(bind, "messagemode2")) and bPress) then
    if (string.find(bind, "messagemode2")) then
      fl.client.isTypingTeamChat = true
    else
      fl.client.isTypingTeamChat = false
    end

    chatbox.Show()

    return true
  end
end

function flChatbox:GUIMousePressed(mouseCode, aimVector)
  if (IsValid(chatbox.panel)) then
    chatbox.Hide()
  end
end

function flChatbox:HUDShouldDraw(element)
  if (element == "CHudChat") then
    return false
  end
end

function flChatbox:ChatboxTextEntered(text)
  if (text and text != "") then
    netstream.Start("Chatbox::PlayerSay", text)
  end

  chatbox.Hide()
end

function flChatbox:ChatboxPaintOver(w, h, panel)
  
end

netstream.Hook("Chatbox::AddMessage", function(messageData)
  if (IsValid(chatbox.panel)) then
    chatbox.panel:AddMessage(messageData)
  end
end)
