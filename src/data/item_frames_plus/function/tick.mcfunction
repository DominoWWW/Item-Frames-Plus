execute as @e[nbt={data:{iipInvisible:1b}}] at @s unless entity @n[type=marker,distance=..0.1,tag=iipInvisible] run function item_frames_plus:place
execute as @e[type=marker, tag=iipInvisible] at @s unless entity @n[nbt={data:{iipInvisible:1b}},distance=..0.1] run function item_frames_plus:destroy
execute as @e[nbt={data:{iipInvisible:1b}}] if data entity @s Item run data merge entity @s {Invisible:1b}
execute as @e[nbt={data:{iipInvisible:1b}}] unless data entity @s Item run data merge entity @s {Invisible:0b}