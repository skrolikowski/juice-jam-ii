--[[
module = {
	x=emitterPositionX, y=emitterPositionY,
	[1] = {
		system=particleSystem1,
		kickStartSteps=steps1, kickStartDt=dt1, emitAtStart=count1,
		blendMode=blendMode1, shader=shader1,
		texturePreset=preset1, texturePath=path1,
		shaderPath=path1, shaderFilename=filename1,
		x=emitterOffsetX, y=emitterOffsetY
	},
	[2] = {
		system=particleSystem2,
		...
	},
	...
}
]]
local img = love.graphics.newImage("res/particles/Shield.png")
img:setFilter("linear", "linear")

local ps = love.graphics.newParticleSystem(img, 32)
-- ps:setColors(1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0.5, 1, 1, 1, 0)
ps:setDirection(-math.pi / 2)
ps:setEmissionArea("none", 0, 0, 0, false)
ps:setEmissionRate(16)
ps:setEmitterLifetime(2)
-- ps:setInsertMode("top")
-- ps:setLinearAcceleration(0, 0, 0, 0)
-- ps:setLinearDamping(-0.00020414621394593, 0)
ps:setOffset(-40, -40)
ps:setParticleLifetime(3, 5)
-- ps:setRadialAcceleration(0, 0)
-- ps:setRelativeRotation(false)
-- ps:setRotation(0, 0)
ps:setSizes(3)
-- ps:setSizeVariation(0.75)
ps:setSpeed(150, 200)
ps:setSpin(3, 0)
ps:setSpinVariation(5)
-- ps:setSpread(3)
-- ps:setTangentialAcceleration(0, 0)

return ps
