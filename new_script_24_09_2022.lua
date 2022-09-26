---------------------------FUNCTIONS & TABLES------------------------------------------

sound.Play( "ambient/explosions/exp1.wav", LocalPlayer())
render.Capture = function() chat.AddText( Color( 0, 0, 0, 125 ), "[HITSIS]", Color( 255, 255, 255 )," Someone tried to screengrab you dont worry your protected ;)" ) return end
render.CapturePixels = function() chat.AddText( Color( 0, 0, 0, 125 ), "[HITSIS]", Color( 255, 255, 255 )," Someone tried to screengrab you dont worry your protected ;)" )return end
render.CapturePixels = function() chat.AddText( Color( 0, 0, 0, 125 ), "[HITSIS]", Color( 255, 255, 255 )," Someone tried to screengrab you dont worry your protected ;)" )return end

local blur = Material("pp/blurscreen")
    local function DrawBlur(panel, amount) --Panel blur function
    local x, y = panel:LocalToScreen(0, 0)
    local scrW, scrH = ScrW(), ScrH()
        surface.SetDrawColor(255, 255, 255)
        surface.SetMaterial(blur)
    for i = 1, 6 do
        blur:SetFloat("$blur", (i / 3) * (amount or 6))
        blur:Recompute()
        render.UpdateScreenEffectTexture()
        surface.DrawTexturedRect(x * -1, y * -1, scrW, scrH)
    end
end

surface.CreateFont( "Titre", { font = "Lato Light", size = 30, weight = 250, antialias = true, strikeout = false, additive = true, } )
surface.CreateFont( "TexteCourant", { font = "Lato Light", size = 30, weight = 250, antialias = true, strikeout = false, additive = true, } )

local rpname = {
   "Jacques John","Krzysztof Burgess","Rosa Ingram",
   "Ralphy Feeney","Jagdeep Peacock","Damien Alston",
   "Ursula Robins","Kate Jaramillo","Saoirse Bannister",
   "Luella Burch","Katya Esquivel","Jadon Kirkland",
   "Akram Hood","Teegan Marsh","Ian Snider",
   "Zaydan Greer","Shea Col","Mr Propre"
};

local props = { --10
    "models/noesis/donut.mdl","models/props_combine/breenclock.mdl","models/noesis/donut.mdl","models/props_phx/misc/potato_launcher_explosive.mdl",
    "models/props_pipes/valvewheel001.mdl","models/props_trainstation/trainstation_clock001.mdl","models/props_phx/wheels/moped_tire.mdl",
    "models/Combine_Helicopter/helicopter_bomb01.mdl","models/props_junk/sawblade001a.mdl","models/maxofs2d/hover_rings.mdl"
}

local CCC = CreateClientConVar;
local PLY = LocalPlayer()

local ESP_PLY          = CCC("IT_ESP_PLY", "1", true,false)
local TRACER_PLY       = CCC("IT_TRACER_PLY", "1", true,false)
local PLY_BOX_PLY      = CCC("IT_PLY_BOX_PLY", "1", true,false)
local BUNNYHOP         = CCC("IT_BUNNYHOP", "1", true,false)
local ESP_OBJECT       = CCC("IT_ESP_OBJECT", "1", true,false)
local PLY_BOX_OBJECT   = CCC("IT_PLY_BOX_OBJECT", "1", true,false)
local CHATSPAM         = CCC("IT_CHATSPAM", "1", true,false)

local blue     = Color(9, 132, 227)
local red      = Color(255, 56, 56)
local purple   = Color(113, 88, 226)
local purple_1 = Color(108, 92, 231)
local black    = Color(0,0,0)
local white    = Color(255,255,255)
local tracer_3 = "cable/cable2"

local function bunny() do
   if not BUNNYHOP:GetBool() then return end
    if gui.IsGameUIVisible() || gui.IsConsoleVisible() || not PLY:Alive() || PLY:Team() == TEAM_SPECTATOR || PLY:GetMoveType() == 8 || PLY:IsTyping() then
        return
    end
    if PLY:IsOnGround() && input.IsKeyDown(KEY_SPACE) then
        RunConsoleCommand("+jump")
    else
        RunConsoleCommand("-jump")
    end
end
end
hook.Add("Think", "bunny", bunny)

local function tracer()
    if not TRACER_PLY:GetBool() then return end -- if the convar isn't egal 0 
    for _, v in pairs(player.GetAll()) do -- each players in this server
        if v ~= PLY and team.GetName(v:Team()) ~= TEAM_SPECTATOR then -- each player is different about same team
     
            cam.Start3D()
            cam.IgnoreZ(true)
            	local color = HSVToColor(CurTime() * 50, 1, 1)
            	--render.DrawLine(v:GetPos(), PLY:GetPos() + EyeAngles():Forward() * 20000, rainbow, v:GetVelocity():Length(), black)
            	render.SetMaterial(Material(tracer_3)) -- apply a material 
            	render.DrawBeam(v:GetPos(), PLY:GetPos() + EyeAngles():Forward() * 100, 3, 0, 0, color) -- a line on same position in each players + get a vector
            cam.End3D()
        end
    end
end
hook.Add("HUDPaint", "cunt", tracer)

local function PlayerBox()
        if not PLY_BOX_PLY:GetBool() then return end

        if PLY:IsValid() and PLY:Alive() then
            for _, v in pairs(player.GetAll()) do
                if v ~= PLY and v:Alive() and v:Team() ~= TEAM_SPECTATOR then
                	local color = HSVToColor(CurTime() * 30, 1, 1)
                    local ply = v
                    local plypos = ply:GetPos()
                    local plyobbmins = ply:OBBMins()
                    local plyobbmax = ply:OBBMaxs()
                    render.DrawWireframeBox(plypos, Angle(0, 0, 0), plyobbmins, Vector(plyobbmax.x, plyobbmax.y, plyobbmax.z), color, false)
				end
            end
        end
    end
hook.Add("PostDrawOpaqueRenderables", "PlayerBox", PlayerBox)

local function espply()
	if not ESP_PLY:GetBool() then return end

	if PLY:IsValid() && PLY:IsPlayer() && PLY:Alive() then
		for _, v in next, player.GetAll() do
			if v ~= PLY then
				local color = HSVToColor(CurTime() * 30, 1, 1)
				local pos = v:GetPos():ToScreen()
				local w,h = ScrW(), ScrH()
					draw.SimpleText(v:Nick(), "Trebuchet18", pos.x,pos.y,color, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
					draw.SimpleText(v:Health(), "Trebuchet18", pos.x,pos.y + 20,color, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
					draw.SimpleText(v:GetUserGroup(), "Trebuchet18", pos.x,pos.y + 30,color, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
					draw.SimpleText(math.abs(math.floor(PLY:GetPos():Distance(v:GetPos()) / 16)) .. "cm", "Trebuchet18", pos.x,pos.y + 50,color, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	        	end
			end
		end
	end
hook.Add("HUDPaint", "FaggotEsp",espply)
-------------------------------------------------------------------------------------------------------
local HITSIS = vgui.Create( "DFrame" )
HITSIS:SetSize( /*630, 450*/ ScrW()/2-184, ScrH()/2-155 )
HITSIS:SetVisible( true )
HITSIS:SetDraggable( false )
HITSIS:ShowCloseButton( true )
HITSIS:Center()
HITSIS:SetTitle("")
HITSIS:MakePopup()
HITSIS.Paint = function( self, w, h )
    DrawBlur(HITSIS, 2)
    draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 85))
    draw.RoundedBox(0, 2, 2, w - 4, h / 9, Color(0,0,0,125))
    draw.SimpleText( "W/Error Menu", "Titre", HITSIS:GetWide() / 2, 6, HSVToColor( CurTime() % 6 * 60, 1, 1 ), TEXT_ALIGN_CENTER )
end

local Avatar = vgui.Create( "AvatarImage", HITSIS )
Avatar:SetSize( 64, 64 )
Avatar:SetPos( 15, 60 )
Avatar:SetPlayer( LocalPlayer(), 64 )

local creator = vgui.Create( "DLabel", HITSIS )
creator:SetPos( 90, 60 )
creator:SetFont("ChatFont")
creator:SetColor(Color(46, 213, 115))
creator:SetText("I'm the creator of this script")
creator:SizeToContents()

local name = vgui.Create( "DLabel", HITSIS )
name:SetPos( 90, 80 )
name:SetFont("ChatFont")
name:SetColor(Color(46, 213, 115))
name:SetText("Name :" .. PLY:Nick())
name:SizeToContents()

local SEAMID = vgui.Create( "DLabel", HITSIS )
SEAMID:SetPos( 90, 100 )
SEAMID:SetFont("ChatFont")
SEAMID:SetColor(Color(46, 213, 115))
SEAMID:SetText("STEAMID :" .. PLY:SteamID())
SEAMID:SizeToContents()

local Texte = vgui.Create( "DLabel", HITSIS )
Texte:SetPos( 90, 120 )
Texte:SetFont("ChatFont")
Texte:SetColor(Color(46, 213, 115))
Texte:SetText("Country :" .. system.GetCountry())
Texte:SizeToContents()

local Texte = vgui.Create( "DLabel", HITSIS )
Texte:SetPos( 150, 170 )
Texte:SetFont("ChatFont")
Texte:SetColor(Color(255,255,255))
Texte:SetText("In this script you could find all the elements of a cheat like\n")
Texte:SizeToContents()

local saw = vgui.Create("DModelPanel", HITSIS)
saw:SetPos(90, 250)
saw:SetSize(100, 100)
saw:SetCamPos(Vector(0,0,50))
saw:SetFOV(50 - 0.5)
saw:SetModel(props[math.random(#props)])
saw:SetColor(HSVToColor(CurTime() * 200, 1, 1))
saw:SetAmbientLight(Color(255, 0, 0, 255))

local saw = vgui.Create("DModelPanel", HITSIS)
saw:SetPos(330, 250)
saw:SetSize(100, 100)
saw:SetCamPos(Vector(0,0,50))
saw:SetFOV(50 - 0.5)
saw:SetModel(props[math.random(#props)])
saw:SetColor(HSVToColor(CurTime() * 200, 1, 1))
saw:SetAmbientLight(Color(255, 0, 0, 255))

local saw = vgui.Create("DModelPanel", HITSIS)
saw:SetPos(570, 250)
saw:SetSize(100, 100)
saw:SetCamPos(Vector(0,0,50))
saw:SetFOV(50 - 0.5)
saw:SetModel(props[math.random(#props)])
saw:SetColor(HSVToColor(CurTime() * 200, 1, 1))
saw:SetAmbientLight(Color(255, 0, 0, 255))

-------------------------DCHECKBOX-----------------------------------

local BunnyHop = HITSIS:Add( "DCheckBoxLabel" )
BunnyHop:SetPos( 460, 60 )
BunnyHop:SetText("BunnyHop")
BunnyHop:SetConVar("IT_BUNNYHOP")
BunnyHop:SetValue( false )
BunnyHop:SizeToContents()

local ESP = HITSIS:Add( "DCheckBoxLabel" )
ESP:SetPos( 570, 60 )
ESP:SetText("ESP")
ESP:SetConVar("sbox_godmode")
ESP:SetValue( false )
ESP:SizeToContents()

local TRACERPLY = HITSIS:Add( "DCheckBoxLabel" )
TRACERPLY:SetPos( 680, 60 )
TRACERPLY:SetText("TRACER")
TRACERPLY:SetConVar("IT_TRACER_PLY")
TRACERPLY:SetValue( false )
TRACERPLY:SizeToContents()

local THIRDDBOXPLAY = HITSIS:Add( "DCheckBoxLabel" )
THIRDDBOXPLAY:SetPos( 460, 90 )
THIRDDBOXPLAY:SetText("3DBOXPLAY")
THIRDDBOXPLAY:SetConVar("IT_PLY_BOX_PLY")
THIRDDBOXPLAY:SetValue( false )
THIRDDBOXPLAY:SizeToContents()

local Derm = HITSIS:Add( "DCheckBoxLabel" )
Derm:SetPos( 570, 90 )
Derm:SetText("BunnyHop")
Derm:SetConVar("sbox_godmode")
Derm:SetValue( false )
Derm:SizeToContents()

local Checkbo = HITSIS:Add( "DCheckBoxLabel" )
Checkbo:SetPos( 680, 90 )
Checkbo:SetText("BunnyHop")
Checkbo:SetConVar("sbox_godmode")
Checkbo:SetValue( false )
Checkbo:SizeToContents()

local BunnyH = HITSIS:Add( "DCheckBoxLabel" )
BunnyH:SetPos( 460, 120 )
BunnyH:SetText("BunnyH")
BunnyH:SetConVar("sbox_godmode")
BunnyH:SetValue( false )
BunnyH:SizeToContents()

local Der = HITSIS:Add( "DCheckBoxLabel" )
Der:SetPos( 570, 120 )
Der:SetText("BunnyHop")
Der:SetConVar("sbox_godmode")
Der:SetValue( false )
Der:SizeToContents()

local Checkb = HITSIS:Add( "DCheckBoxLabel" )
Checkb:SetPos( 680, 120 )
Checkb:SetText("BunnyHop")
Checkb:SetConVar("sbox_godmode")
Checkb:SetValue( false )
Checkb:SizeToContents()

-----------------------------DCHECKBOX-------------------------------
