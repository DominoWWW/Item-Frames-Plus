if data storage item_frames_plus:data {enabled:1b}:
    # Place Item Frame
    as @a[scores={ifp.place_item_frame=1..}] at @s run function item_frames_plus:src/place
    as @a[scores={ifp.place_glow_item_frame=1..}] at @s run function item_frames_plus:src/place
    
    # Destroy Item Frame
    execute as @e[type=marker, tag=ifp_invisible] at @s unless entity @n[nbt={data:{ifp_invisible:1b}},distance=..0.1] run function item_frames_plus:src/destroy

    # Add Item
    as @a at @s if entity @e[nbt={data:{ifp_invisible:1b}}, distance=..5]:
        execute as @e[nbt={data:{ifp_invisible:1b}}] if data entity @s Item run data merge entity @s {Invisible:1b}
    
    # Remove Item
    execute as @e[nbt={data:{ifp_invisible:1b}}] unless data entity @s Item run data merge entity @s {Invisible:0b}

    # Summon Lock Item Frame interaction
    execute as @a[nbt={SelectedItem:{id:"minecraft:glass_pane"}},scores={ifp.sneak_time=1..}] at @s:
        execute as @e[type=item_frame, distance=..5] at @s run function ~/lock_interaction
        execute as @e[type=glow_item_frame, distance=..5] at @s run function ~/lock_interaction

        # Click Lock Item Frame interaction
        execute as @e[tag=ifp_lock_interaction] at @s on target as @n[tag=ifp_lock_interaction, distance=..1] at @s run function ~/lock_click

    # Remove Lock Item Frame interaction
    execute as @e[type=interaction, tag=ifp_lock_interaction] at @s unless entity @p[distance=..5, nbt={SelectedItem:{id:"minecraft:glass_pane"}},scores={ifp.sneak_time=1..}] run kill @s

    # Reset Sneak Time (I would rather use predicates for checking if the player is sneaking, however it's not supported by carpet players)
    scoreboard players reset @a ifp.sneak_time

function ~/lock_click:
    positioned ~ ~0.5 ~ run as @n[type=item_frame ,distance=..1] at @s run function ~/lock
    positioned ~ ~0.5 ~ run as @n[type=glow_item_frame, distance=..1] at @s run function ~/lock
    kill @s
    function ~/lock:
        execute as @s if entity @s[nbt={Fixed:0b}]:
            execute as @e[tag=ifp_lock_interaction] at @s on target run clear @s[gamemode=!creative] minecraft:glass_pane 1
            playsound minecraft:ui.loom.take_result master @p ~ ~ ~ 1 1
            particle minecraft:happy_villager ~ ~ ~ .2 .2 .2 .025 10 force
            data merge entity @s {Fixed:1b}
            tag @s add ifp_lock_toggle
        execute as @s if entity @s[nbt={Fixed:1b}, tag=!ifp_lock_toggle]:
            playsound minecraft:item.ominous_bottle.dispose master @p ~ ~ ~ 1 1
            particle minecraft:firework ~ ~ ~ 0 0 0 .05 10 force
            data merge entity @s {Fixed:0b}
        tag @s remove ifp_lock_toggle

function ~/lock_interaction:
    align xyz positioned ~0.5 ~ ~0.5 positioned ^ ^ ^-0.9 unless entity @e[type=interaction, distance=..0.1, tag=ifp_lock_interaction] run summon interaction ~ ~ ~ {Tags:["ifp_lock_interaction"]}
    