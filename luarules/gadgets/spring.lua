
function gadget:GetInfo()
  return {
    name      = "Spring Engine",
    desc      = "Runs Spring",
    author    = "Robert Ole Ole Biscuit Weasel Paulson",
    date      = "1/4/2001",
    license   = "",
    layer     = -math.huge,
    enabled   = true  --  loaded by default?
  }
end

if (gadgetHandler:IsSyncedCode()) then return end 

local alpha = 0
local phase = 0
local fadeDuration = 30*3 -- sim frames
local holdDuration = 30*3 -- sim frames
local incr = 1/fadeDuration

local image = 'luaui/images/xmashorse.png'
local black = 'luaui/images/black.png'

local f
local aspectRatio

function gadget:DrawScreen()
    if alpha<0.01 then return end
        
	if not aspectRatio then
		local texInfo = gl.TextureInfo(image)
		aspectRatio = texInfo.xsize / texInfo.ysize
	end

	local vsx, vsy = Spring.GetViewGeometry()
	local screenAspectRatio = vsx / vsy

	local xDiv = 0
	local yDiv = 0
	local ratioComp = screenAspectRatio / aspectRatio

    if math.abs(ratioComp-1)>0.15 then 
        if (ratioComp > 1) then
            xDiv = vsx * (1 - (1 / ratioComp)) * 0.5;
        else
            yDiv = vsy * (1 - ratioComp) * 0.5;
        end
    end

    gl.Color(1,1,1,alpha)
	gl.Texture(black)
	gl.TexRect(0,0,vsx,vsy)
	gl.Texture(image)
	gl.TexRect(0+xDiv,0+yDiv,vsx-xDiv,vsy-yDiv)
	gl.Texture(false)
end

function gadget:GameFrame(n)
    if phase==0 then return end

    if phase==1 then
        alpha = alpha + incr
        if alpha>=1 then 
            phase = 2
            f = n
        end
    end
    if phase==2 and n>=f+holdDuration then
        phase = 3
        f = nil
    end
    if phase==3 then
        alpha = alpha - incr
        if alpha<=0 then
            phase = 0
        end
    end
    if alpha>1 then alpha=1 end
    if alpha<0 then alpha=0 end    
end

function gadget:UnitDestroyed(unitID, unitDefID, unitTeam, attackerID, attackerDefID, attackerTeam)
    if UnitDefs[unitDefID].customParams.iscommander and unitTeam==Spring.GetMyTeamID() and math.random()<0.1 then
        phase = 1                
    end
end