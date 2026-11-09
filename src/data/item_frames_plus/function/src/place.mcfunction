execute as @e[nbt={data:{ifp_invisible:1b}}] at @s unless entity @n[type=marker,distance=..0.1,tag=ifp_invisible]:
    summon marker ~ ~ ~ {Tags:["ifp_invisible"]}
scoreboard players set @s ifp.place_item_frame 0
scoreboard players set @s ifp.place_glow_item_frame 0