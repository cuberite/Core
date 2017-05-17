local Minecarts =
{
	["minecart"] = E_ITEM_MINECART,
	["chest_minecart"] = E_ITEM_CHEST_MINECART,
	["furnace_minecart"] = E_ITEM_FURNACE_MINECART,
	["hopper_minecart"] = E_ITEM_MINECART_WITH_HOPPER,
	["tnt_minecart"] = E_ITEM_MINECART_WITH_TNT,

	-- 1.10 and below
	["MinecartChest"] = E_ITEM_CHEST_MINECART,
	["MinecartFurnace"] = E_ITEM_FURNACE_MINECART,
	["MinecartHopper"] = E_ITEM_MINECART_WITH_HOPPER,
	["MinecartRideable"] = E_ITEM_MINECART,
	["MinecartTNT"] = E_ITEM_MINECART_WITH_TNT
}

local Mobs = 
{
	["bat"] = mtBat,
	["blaze"] = mtBlaze,
	["cave_spider"] = mtCaveSpider,
	["chicken"] = mtChicken,
	["cow"] = mtCow,
	["creeper"] = mtCreeper,
	["ender_dragon"] = mtEnderDragon,
	["enderman"] = mtEnderman,
	["ghast"] = mtGhast,
	["giant"] = mtGiant,
	["guardian"] = mtGuardian,
	["horse"] = mtHorse,
	["iron_golem"] = mtIronGolem,
	["magma_cube"] = mtMagmaCube,
	["mooshroom"] = mtMooshroom,
	["ocelot"] = mtOcelot,
	["pig"] = mtPig,
	["rabbit"] = mtRabbit,
	["sheep"] = mtSheep,
	["silverfish"] = mtSilverfish,
	["skeleton"] = mtSkeleton,
	["slime"] = mtSlime,
	["snowman"] = mtSnowGolem,
	["spider"] = mtSpider,
	["squid"] = mtSquid,
	["villager"] = mtVillager,
	["witch"] = mtWitch,
	["wither"] = mtWither,
	["wolf"] = mtWolf,
	["zombie"] = mtZombie,
	["zombie_pigman"] = mtZombiePigman,

	-- 1.10 and below
	["Bat"] = mtBat,
	["Blaze"] = mtBlaze,
	["CaveSpider"] = mtCaveSpider,
	["Chicken"] = mtChicken,
	["Cow"] = mtCow,
	["Creeper"] = mtCreeper,
	["EnderDragon"] = mtEnderDragon,
	["Enderman"] = mtEnderman,
	["Ghast"] = mtGhast,
	["Giant"] = mtGiant,
	["Guardian"] = mtGuardian,
	["Horse"] = mtHorse,
	["LavaSlime"] = mtMagmaCube,
	["MushroomCow"] = mtMooshroom,
	["Ozelot"] = mtOcelot,
	["Pig"] = mtPig,
	["Rabbit"] = mtRabbit,
	["Sheep"] = mtSheep,
	["Silverfish"] = mtSilverfish,
	["Skeleton"] = mtSkeleton,
	["Slime"] = mtSlime,
	["SnowMan"] = mtSnowGolem,
	["Spider"] = mtSpider,
	["Squid"] = mtSquid,
	["Villager"] = mtVillager,
	["VillagerGolem"] = mtIronGolem,
	["Witch"] = mtWitch,
	["Wither"] = mtWither,
	["Wolf"] = mtWolf,
	["Zombie"] = mtZombie,
	["PigZombie"] = mtZombiePigman
}

local Projectiles =
{
	["arrow"] = cProjectileEntity.pkArrow,
	["egg"] = cProjectileEntity.pkEgg,
	["ender_pearl"] = cProjectileEntity.pkEnderPearl,
	["fireworks_rocket"] = cProjectileEntity.pkFirework,
	["fishing_float"] = cProjectileEntity.pkFishingFloat,
	["fireball"] = cProjectileEntity.pkGhastFireball,
	["potion"] = cProjectileEntity.pkSplashPotion,
	["small_fireball"] = cProjectileEntity.pkFireCharge,
	["snowball"] = cProjectileEntity.pkSnowball,
	["wither_skull"] = cProjectileEntity.pkWitherSkull,
	["xp_bottle"] = cProjectileEntity.pkExpBottle,

	-- 1.10 and below
	["Arrow"] = cProjectileEntity.pkArrow,
	["Fireball"] = cProjectileEntity.pkGhastFireball,
	["FireworksRocketEntity"] = cProjectileEntity.pkFirework,
	["FishingFloat"] = cProjectileEntity.pkFishingFloat,
	["SmallFireball"] = cProjectileEntity.pkFireCharge,
	["Snowball"] = cProjectileEntity.pkSnowball,
	["ThrownEgg"] = cProjectileEntity.pkEgg,
	["ThrownEnderpearl"] = cProjectileEntity.pkEnderPearl,
	["ThrownExpBottle"] = cProjectileEntity.pkExpBottle,
	["ThrownPotion"] = cProjectileEntity.pkSplashPotion,
	["WitherSkull"] = cProjectileEntity.pkWitherSkull
}

function HandleSummonCommand(Split, Player)
	if Split[2] == nil then
		Player:SendMessageInfo("Usage: " .. Split[1] .. " <entityname> [x] [y] [z]")
	else
		local X = Player:GetPosX()
		local Y = Player:GetPosY()
		local Z = Player:GetPosZ()
		local World = Player:GetWorld()

		if Split[3] ~= nil then
			X = tonumber(Split[3])
			local RelativeX = loadstring(Split[3]:gsub("~", "return " .. Player:GetPosX() .. "+0"))
			if RelativeX then
				X = select(2, pcall(setfenv(RelativeX, {})))
			end
		end

		if Split[4] ~= nil then
			Y = tonumber(Split[4])
			local RelativeY = loadstring(Split[4]:gsub("~", "return " .. Player:GetPosY() .. "+0"))
			if RelativeY then
				Y = select(2, pcall(setfenv(RelativeY, {})))
			end
		end

		if Split[5] ~= nil then
			Z = tonumber(Split[5])
			local RelativeZ = loadstring(Split[5]:gsub("~", "return " .. Player:GetPosZ() .. "+0"))
			if RelativeZ then
				Z = select(2, pcall(setfenv(RelativeZ, {})))
			end
		end

		if X == nil then
			Player:SendMessageFailure("'" .. Split[3] .. "' is not a valid number")
			return true
		end

		if Y == nil then
			Player:SendMessageFailure("'" .. Split[4] .. "' is not a valid number")
			return true
		end

		if Z == nil then
			Player:SendMessageFailure("'" .. Split[5] .. "' is not a valid number")
			return true
		end

		local function Success()
			Player:SendMessageSuccess("Successfully summoned entity at [X:" .. math.floor(X) .. " Y:" .. math.floor(Y) .. " Z:" .. math.floor(Z) .. "]")
		end

		if Split[2] == "boat" or Split[2] == "Boat" then
			World:SpawnBoat(X, Y, Z)
			Success()
		elseif Split[2] == "falling_block" or Split[2] == "FallingSand" then
			World:SpawnFallingBlock(X, Y, Z, 12, 0)
			Success()
		elseif Split[2] == "lightning_bolt" or Split[2] == "LightningBolt" then
			World:CastThunderbolt(X, Y, Z)
			Success()
		elseif Minecarts[Split[2]] then
			World:SpawnMinecart(X, Y, Z, Minecarts[Split[2]])
			Success()
		elseif Mobs[Split[2]] then
			World:SpawnMob(X, Y, Z, Mobs[Split[2]])
			Success()
		elseif Projectiles[Split[2]] then
			World:CreateProjectile(X, Y, Z, Projectiles[Split[2]], Player, Player:GetEquippedItem(), Player:GetLookVector() * 20)
			Success()
		elseif Split[2] == "tnt" or Split[2] == "PrimedTnt" then
			World:SpawnPrimedTNT(X, Y, Z)
			Success()
		elseif Split[2] == "xp_orb" or Split[2] == "XPOrb" then
			World:SpawnExperienceOrb(X, Y, Z, 1)
			Success()
		else
			Player:SendMessageFailure("Unknown entity '" .. Split[2] .. "'")
		end
	end
	return true
end

