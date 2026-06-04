game.StarterGui:SetCore("SendNotification", {
    Title = "OMAYHUB.asia",
    Text = "web free all script & executor latest 😈",
    Duration = 10,

    Button1 = "Copy",
    Button2 = "Close",

    Callback = function(button)
        if button == "Copy" then
            setclipboard("OMAYHUB.asia")
        elseif button == "Close" then
        end
    end
})
