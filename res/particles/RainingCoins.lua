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
local particles = { x = 32, y = -32 }
local img = Config.image.icon.gold
img:setFilter("linear", "linear")

local ps = love.graphics.newParticleSystem(img, 50)
-- ps:setColors(1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1)
ps:setDirection(1.5707963705063)
ps:setEmissionArea("uniform", Config.width * 0.5, Config.height * 0.5, 0, false)
ps:setEmissionRate(35)
ps:setEmitterLifetime(-1)
ps:setInsertMode("top")
ps:setLinearAcceleration(0, 0, 0, 0)
ps:setLinearDamping(-0.00020414621394593, 0)
ps:setOffset(0, 0)
ps:setParticleLifetime(15, 25)
ps:setRadialAcceleration(0, 0)
ps:setRelativeRotation(false)
ps:setRotation(0, 0)
ps:setSizes(2)
ps:setSizeVariation(0.75)
ps:setSpeed(100, 200)
ps:setSpin(0, 0)
ps:setSpinVariation(0)
ps:setSpread(0.7779181599617)
ps:setTangentialAcceleration(0, 0)
table.insert(particles,
	{ system = ps, kickStartSteps = 0, kickStartDt = 0, emitAtStart = 0, blendMode = "add", shader = nil,
		texturePath = "res/image/icon/Coin.png", texturePreset = "", shaderPath = "", shaderFilename = "", x = 0, y = 0 })

return particles
