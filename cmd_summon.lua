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
	["wither_skeleton"] = mtWitherSkeleton,
	["wolf"] = mtWolf,
	["zombie"] = mtZombie,
	["zombie_pigman"] = mtZombiePigman,
	["zombie_villager"] = mtZombieVillager,

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
	["WitherSkeleton"] = mtWitherSkeleton,
	["Wolf"] = mtWolf,
	["Zombie"] = mtZombie,
	["PigZombie"] = mtZombiePigman,
	["ZombieVillager"] = mtZombieVillager
}

local Projectiles =
{
	["arrow"] = cProjectileEntity.pkArrow,
	["egg"] = cProjectileEntity.pkEgg,
	["ender_pearl"] = cProjectileEntity.pkEnderPearl,
	["fireworks_rocket"] = cProjectileEntity.pkFirework,
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
	["SmallFireball"] = cProjectileEntity.pkFireCharge,
	["Snowball"] = cProjectileEntity.pkSnowball,
	["ThrownEgg"] = cProjectileEntity.pkEgg,
	["ThrownEnderpearl"] = cProjectileEntity.pkEnderPearl,
	["ThrownExpBottle"] = cProjectileEntity.pkExpBottle,
	["ThrownPotion"] = cProjectileEntity.pkSplashPotion,
	["WitherSkull"] = cProjectileEntity.pkWitherSkull
}

local function SpawnEntity(EntityName, World, X, Y, Z, Player)
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
	elseif EntityName == "ender_crystal" or EntityName == "EnderCrystal" then
		World:SpawnEnderCrystal(Vector3d(X, Y, Z), false)
	else
		return false
	end
	return true
end

function HandleSummonCommand(Split, Player)
	local Response

	if not Split[2] or (not Player and not Split[5]) then
		Response = SendMessage(Player, "Usage: " .. Split[1] .. " <entityname> [x] [y] [z]")
	else
		local X
		local Y
		local Z
		local World = cRoot:Get():GetDefaultWorld()
		
		if Player then
			X = Player:GetPosX()
			Y = Player:GetPosY()
			Z = Player:GetPosZ()
			World = Player:GetWorld()
		end

		if Split[5] then
			X = RelativeCommandCoord(Split[3], X)
			Y = RelativeCommandCoord(Split[4], Y)
			Z = RelativeCommandCoord(Split[5], Z)

			if not X then
				return true, SendMessageFailure(Player, "'" .. Split[3] .. "' is not a valid number")
			elseif not Y then
				return true, SendMessageFailure(Player, "'" .. Split[4] .. "' is not a valid number")
			elseif not Z then
				return true, SendMessageFailure(Player, "'" .. Split[5] .. "' is not a valid number")
			end
		end

		if SpawnEntity(Split[2], World, X, Y, Z, Player) then
			Response = SendMessageSuccess(Player, "Successfully summoned entity at [X:" .. math.floor(X) .. " Y:" .. math.floor(Y) .. " Z:" .. math.floor(Z) .. "]")
		else
			Response = SendMessageFailure(Player, "Unknown entity '" .. Split[2] .. "'")
		end
	end
	return true, Response
end

function HandleConsoleSummon(Split)
	return HandleSummonCommand(Split)
end
