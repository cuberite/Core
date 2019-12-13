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

local function RelativeCommandCoord(a_Split, a_Relative)
	if string.sub(a_Split, 1, 1) == "~" then
		local rel = tonumber(string.sub(a_Split, 2, -1))
		if rel then
			return a_Relative + rel
		end
		return a_Relative
	end
	return tonumber(a_Split)
end

local function SpawnEntity(EntityName, World, X, Y, Z)
	if EntityName == "boat" or EntityName == "Boat" then
		local Material = cBoat.bmOak

		World:SpawnBoat(Vector3d(X, Y, Z), Material)
	elseif EntityName == "falling_block" or EntityName == "FallingSand" then
		local BlockType = E_BLOCK_SAND
		local BlockMeta = 0

		World:SpawnFallingBlock(Vector3i(X, Y, Z), BlockType, BlockMeta)
	elseif EntityName == "lightning_bolt" or EntityName == "LightningBolt" then
		World:CastThunderbolt(Vector3i(X, Y, Z))
	elseif Minecarts[EntityName] then
		World:SpawnMinecart(Vector3d(X, Y, Z), Minecarts[EntityName])
	elseif Mobs[EntityName] then
		World:SpawnMob(X, Y, Z, Mobs[EntityName])
	elseif Projectiles[EntityName] then
		World:CreateProjectile(Vector3d(X, Y, Z), Projectiles[EntityName], Player, Player:GetEquippedItem(), Player:GetLookVector() * 20)
	elseif EntityName == "tnt" or EntityName == "PrimedTnt" then
		World:SpawnPrimedTNT(Vector3d(X, Y, Z))
	elseif EntityName == "xp_orb" or EntityName == "XPOrb" then
		local Reward = 1

		World:SpawnExperienceOrb(Vector3d(X, Y, Z), Reward)
	else
		return false
	end
	return true
end

function HandleSummonCommand(Split, Player)
	if Split[2] == nil then
		Player:SendMessageInfo("Usage: " .. Split[1] .. " <entityname> [x] [y] [z]")
	else
		local X = Player:GetPosX()
		local Y = Player:GetPosY()
		local Z = Player:GetPosZ()
		local World = Player:GetWorld()

		if Split[3] ~= nil then
			X = RelativeCommandCoord(Split[3], X)
		end

		if Split[4] ~= nil then
			Y = RelativeCommandCoord(Split[4], Y)
		end

		if Split[5] ~= nil then
			Z = RelativeCommandCoord(Split[5], Z)
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

		if SpawnEntity(Split[2], World, X, Y, Z) then
			Player:SendMessageSuccess("Successfully summoned entity at [X:" .. math.floor(X) .. " Y:" .. math.floor(Y) .. " Z:" .. math.floor(Z) .. "]")
		else
			Player:SendMessageFailure("Unknown entity '" .. Split[2] .. "'")
		end
	end
	return true
end
