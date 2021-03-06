INCLUDE "constants.asm"


SECTION "Code 1", ROMX

INCLUDE "engine/gfx/load_push_oam.asm"
INCLUDE "engine/overworld/init_map.asm"
INCLUDE "engine/overworld/map_objects.asm"
INCLUDE "engine/intro_menu.asm"
INCLUDE "engine/init_options.asm"
INCLUDE "engine/pokemon/learn.asm"
INCLUDE "engine/math/math.asm"
INCLUDE "engine/overworld/npc_movement.asm"
INCLUDE "engine/events/happiness_egg.asm"
INCLUDE "engine/events/specials_2.asm"
INCLUDE "data/items/attributes.asm"


SECTION "Code 2", ROMX

INCLUDE "engine/overworld/player_object.asm"
INCLUDE "engine/math/sine.asm"
INCLUDE "data/predef_pointers.asm"
INCLUDE "engine/gfx/color.asm"
INCLUDE "engine/trainer_scripts.asm"

SECTION "Poke Ball Code", ROMX

INCLUDE "engine/poke_balls.asm"

SECTION "Code 3", ROMX

INCLUDE "engine/events/specials.asm"
INCLUDE "engine/math/print_num.asm"
INCLUDE "engine/pokemon/health.asm"
INCLUDE "engine/events/overworld.asm"
INCLUDE "engine/items.asm"
INCLUDE "engine/anim_hp_bar.asm"
INCLUDE "engine/pokemon/move_mon.asm"
INCLUDE "engine/pokemon/bills_pc_top.asm"
INCLUDE "engine/item_effects.asm"
INCLUDE "engine/events/checktime.asm"
INCLUDE "engine/pokemon/breedmon_level_growth.asm"

BugContest_SetCaughtContestMon: ; e6ce
	ld a, [wContestMon]
	and a
	jr z, .firstcatch
	ld [wd265], a
	call DisplayAlreadyCaughtText
	call DisplayCaughtContestMonStats
	call YesNoBox
	ret c

.firstcatch
	call .generatestats
	ld a, [wTempEnemyMonSpecies]
	ld [wd265], a
	call GetPokemonName
	ld hl, .caughttext
	jp PrintText

.generatestats ; e6fd
	ld a, [wTempEnemyMonSpecies]
	ld [wCurSpecies], a
	ld [wCurPartySpecies], a
	call GetBaseData
	xor a
	ld bc, PARTYMON_STRUCT_LENGTH
	ld hl, wContestMon
	call ByteFill
	xor a
	ld [wMonType], a
	ld hl, wOTPartyMon1
	ld de, wContestMon
	ld bc, PARTYMON_STRUCT_LENGTH
	rst CopyBytes
	ret

.caughttext ; 0xe71d
	; Caught @ !
	text_jump UnknownText_0x1c10c0
	db "@"

DisplayAlreadyCaughtText: ; cc0c7
	call GetPokemonName
	ld hl, .AlreadyCaughtText
	jp PrintText

.AlreadyCaughtText: ; 0xcc0d0
	; You already caught a @ .
	text_jump UnknownText_0x1c10dd
	db "@"

DisplayCaughtContestMonStats: ; cc000
	call ClearBGPalettes
	call ClearTileMap
	call ClearSprites
	call LoadFontsBattleExtra

	ld hl, wOptions1
	ld a, [hl]
	push af
	set NO_TEXT_SCROLL, [hl]

	hlcoord 0, 0
	lb bc, 4, 13
	call TextBox

	hlcoord 0, 6
	lb bc, 4, 13
	call TextBox

	hlcoord 2, 0
	ld de, .Stock
	call PlaceString

	hlcoord 2, 6
	ld de, .This
	call PlaceString

	hlcoord 5, 4
	ld de, .Health
	call PlaceString

	hlcoord 5, 10
	ld de, .Health
	call PlaceString

	ld a, [wContestMon]
	ld [wd265], a
	call GetPokemonName
	ld de, wStringBuffer1
	hlcoord 1, 2
	call PlaceString

	ld h, b
	ld l, c
	ld a, [wContestMonLevel]
	ld [wTempMonLevel], a
	call PrintLevel

	ld de, wEnemyMonNick
	hlcoord 1, 8
	call PlaceString

	ld h, b
	ld l, c
	ld a, [wEnemyMonLevel]
	ld [wTempMonLevel], a
	call PrintLevel

	hlcoord 11, 4
	ld de, wContestMonMaxHP
	lb bc, 2, 3
	call PrintNum

	hlcoord 11, 10
	ld de, wEnemyMonMaxHP
	call PrintNum

	ld hl, SwitchMonText
	call PrintText

	pop af
	ld [wOptions1], a

	call ApplyTilemapInVBlank
	ld b, CGB_DIPLOMA
	call GetCGBLayout
	jp SetPalettes

.Health:
	db "Health@"
.Stock:
	db " Stock <PK><MN> @"
.This:
	db " This <PK><MN>  @"

SwitchMonText: ; cc0c2
	; Switch #MON?
	text_jump UnknownText_0x1c10cf
	db "@"


SECTION "Code 4", ROMX

INCLUDE "engine/pack.asm"
INCLUDE "engine/overworld/time.asm"
INCLUDE "engine/tmhm.asm"
INCLUDE "engine/naming_screen.asm"
INCLUDE "engine/events/itemball.asm"
INCLUDE "engine/events/heal_machine_anim.asm"
INCLUDE "engine/events/whiteout.asm"
INCLUDE "engine/events/forced_movement.asm"
INCLUDE "engine/events/itemfinder.asm"
INCLUDE "engine/startmenu.asm"
INCLUDE "engine/pokemon/mon_menu.asm"
INCLUDE "engine/overworld/select_menu.asm"
INCLUDE "engine/events/elevator.asm"
INCLUDE "engine/events/bug_contest.asm"
INCLUDE "engine/events/safari_game.asm"
INCLUDE "engine/events/std_tiles.asm"


SECTION "Roofs", ROMX

INCLUDE "engine/mapgroup_roofs.asm"


SECTION "Code 5", ROMX

INCLUDE "engine/rtc.asm"
INCLUDE "engine/overworld/overworld.asm"
INCLUDE "engine/overworld/tile_events.asm"
INCLUDE "engine/save.asm"
INCLUDE "engine/overworld/spawn_points.asm"
INCLUDE "engine/overworld/map_setup.asm"
INCLUDE "engine/pokecenter_pc.asm"
INCLUDE "engine/mart.asm"
INCLUDE "engine/money.asm"
INCLUDE "data/items/marts.asm"
INCLUDE "engine/events/mom.asm"
INCLUDE "engine/events/daycare.asm"
INCLUDE "engine/pokemon/breeding.asm"


SECTION "Code 6", ROMX

INCLUDE "engine/clock_reset.asm"


SECTION "Effect Command Pointers", ROMX

INCLUDE "data/battle/effect_command_pointers.asm"


SECTION "Code 7", ROMX

INCLUDE "engine/events/pokepic.asm"
INCLUDE "engine/scrolling_menu.asm"
INCLUDE "engine/switch_items.asm"
INCLUDE "engine/menu.asm"
INCLUDE "engine/pokemon/mon_submenu.asm"
INCLUDE "engine/battle/menu.asm"
INCLUDE "engine/buy_sell_toss.asm"
INCLUDE "engine/trainer_card.asm"
INCLUDE "engine/events/prof_oaks_pc.asm"
INCLUDE "engine/overworld/decorations.asm"
INCLUDE "data/trainers/dvs.asm"

UpdateItemDescriptionAndBagQuantity:
	hlcoord 1, 1
	lb bc, 1, 8
	call ClearBox
	ld a, [wMenuSelection]
	cp -1
	jr z, UpdateItemDescription
	hlcoord 1, 1
	ld de, BagXString
	call PlaceString
	ld a, [wMenuSelection]
	call GetQuantityInBag
	hlcoord 6, 1
	ld de, wBuffer1
	lb bc, 2, 3
	call PrintNum
UpdateItemDescription: ; 0x244c3
	ld a, [wMenuSelection]
	ld [wCurSpecies], a
	hlcoord 0, 12
	lb bc, 4, SCREEN_WIDTH - 2
	call TextBox
	ld a, [wMenuSelection]
	cp -1
	ret z
	decoord 1, 14
	farjp PrintItemDescription

BagXString:
	db "Bag ×@"

UpdateTMHMDescriptionAndOwnership:
	hlcoord 1, 1
	lb bc, 1, 8
	call ClearBox
	ld a, [wMenuSelection]
	cp -1
	jr z, UpdateTMHMDescription
	ld a, [wCurTMHM]
	call CheckTMHM
	ld de, OwnedTMString
	jr c, .GotString
	ld de, UnownedTMString
.GotString
	hlcoord 1, 1
	call PlaceString
UpdateTMHMDescription:
	ld a, [wMenuSelection]
	ld [wCurSpecies], a
	hlcoord 0, 12
	lb bc, 4, SCREEN_WIDTH - 2
	call TextBox
	ld a, [wMenuSelection]
	cp -1
	ret z
	decoord 1, 14
	farjp PrintTMHMDescription

OwnedTMString:
	db "Owned@"
UnownedTMString:
	db "Unowned@"

UpdateKeyItemDescription:
	hlcoord 0, 12
	lb bc, 4, SCREEN_WIDTH - 2
	call TextBox
	; ld a, [wMenuSelection]
	; cp -1
	; ret z
	decoord 1, 14
	farjp PrintKeyItemDescription

GetQuantityInBag:
	ld a, [wCurItem]
	push af
	ld a, [wMenuSelection]
	ld [wCurItem], a
	call CountItem
	pop af
	ret

PlaceMenuItemName:
; places a star near the name if registered
	push hl
	push de
	dec de
	dec de
	ld a, " "
	ld [de], a
	ld a, [wMenuSelection]
	pop de
	pop hl
PlaceMartItemName:
	push de
	ld a, [wMenuSelection]
	cp a, -1 ; special case for Cancel in Key Items pocket
	ld de, ScrollingMenu_CancelString ; found in scrolling_menu.asm
	ld [wNamedObjectIndexBuffer], a
	call nz, GetItemName
	pop hl
	jp PlaceString

PlaceMenuTMHMName:
	push de
	ld a, [wMenuSelection]
	ld [wNamedObjectIndexBuffer], a
	call GetTMHMName
	pop hl
	jp PlaceString

PlaceMenuApricornQuantity:
	ld a, [wMenuSelection]
	ld [wCurItem], a
	and a
	ret nz
	ld l, e
	ld h, d
	jr _PlaceMenuQuantity

PlaceMenuItemQuantity: ; 0x24ac3
	ld a, [wMenuSelection]
	ld [wCurItem], a
	push de
	pop hl
_PlaceMenuQuantity:
	ld de, $15
	add hl, de
	ld [hl], "×"
	inc hl
	ld de, wMenuSelectionQuantity
	lb bc, 1, 2
	jp PrintNum

PlaceMoneyTopRight: ; 24ae8
	ld hl, MenuDataHeader_0x24b15
	call CopyMenuDataHeader
	jr PlaceMoneyDataHeader

PlaceMoneyBottomLeft: ; 24af0
	ld hl, MenuDataHeader_0x24b1d
	call CopyMenuDataHeader
	jr PlaceMoneyDataHeader

PlaceMoneyAtTopLeftOfTextbox: ; 24af8
	ld hl, MenuDataHeader_0x24b15
	lb de, 0, 11
	call OffsetMenuDataHeader

PlaceMoneyDataHeader: ; 24b01
	call MenuBox
	call MenuBoxCoord2Tile
	ld de, SCREEN_WIDTH + 1
	add hl, de
	ld de, wMoney
	lb bc, PRINTNUM_MONEY | 3, 7
	jp PrintNum

MenuDataHeader_0x24b15: ; 0x24b15
	db $40 ; flags
	db 00, 10 ; start coords
	db 02, 19 ; end coords
	dw NULL
	db 1 ; default option

MenuDataHeader_0x24b1d: ; 0x24b1d
	db $40 ; flags
	db 11, 00 ; start coords
	db 13, 09 ; end coords
	dw NULL
	db 1 ; default option

PlaceBlueCardPointsTopRight:
	hlcoord 11, 0
	lb bc, 1, 7
	call TextBox
	hlcoord 12, 1
	ld de, wBlueCardBalance
	lb bc, 1, 3
	call PrintNum
	ld de, .PointsString
	jp PlaceString

.PointsString:
	db " Pts@"

PlaceBattlePointsTopRight:
	hlcoord 12, 0
	lb bc, 1, 6
	call TextBox
	hlcoord 13, 1
	ld de, wBattlePoints
	lb bc, 1, 3
	call PrintNum
	ld de, .BPString
	jp PlaceString

.BPString:
	db " BP@"

Special_DisplayCoinCaseBalance: ; 24b25
	; Place a text box of size 1x7 at 11, 0.
	hlcoord 11, 0
	lb bc, 1, 7
	call TextBox
	hlcoord 12, 0
	ld de, CoinString
	call PlaceString
	ld de, wCoins
	lb bc, 2, 5
	hlcoord 13, 1
	jp PrintNum

Special_DisplayMoneyAndCoinBalance: ; 24b4e
	hlcoord 5, 0
	lb bc, 3, 13
	call TextBox
	hlcoord 6, 1
	ld de, MoneyString
	call PlaceString
	hlcoord 11, 1
	ld de, wMoney
	lb bc, PRINTNUM_MONEY | 3, 7
	call PrintNum
	hlcoord 6, 3
	ld de, CoinString
	call PlaceString
	hlcoord 14, 3
	ld de, wCoins
	lb bc, 2, 5
	jp PrintNum

MoneyString: ; 24b83
	db "Money@"
CoinString: ; 24b89
	db "Coin@"

StartMenu_DrawBugContestStatusBox: ; 24bdc
	hlcoord 0, 0
	lb bc, 5, 17
	jp TextBox

StartMenu_PrintBugContestStatus: ; 24be7
	ld hl, wOptions1
	ld a, [hl]
	push af
	set NO_TEXT_SCROLL, [hl]
	call StartMenu_DrawBugContestStatusBox
	hlcoord 1, 5
	ld de, .Balls
	call PlaceString
	hlcoord 8, 5
	ld de, wParkBallsRemaining
	lb bc, PRINTNUM_LEFTALIGN | 1, 2
	call PrintNum
	hlcoord 1, 1
	ld de, .Caught
	call PlaceString
	ld a, [wContestMon]
	and a
	ld de, .None
	jr z, .no_contest_mon
	ld [wd265], a
	call GetPokemonName

.no_contest_mon
	hlcoord 8, 1
	call PlaceString
	ld a, [wContestMon]
	and a
	jr z, .skip_level
	hlcoord 1, 3
	ld de, .Level
	call PlaceString
	ld a, [wContestMonLevel]
	ld h, b
	ld l, c
	inc hl
	ld c, 3
	call Print8BitNumRightAlign

.skip_level
	pop af
	ld [wOptions1], a
	ret

.Caught: ; 24c4b
	db "Caught@"
.Balls: ; 24c52
	db "Balls:@"
.None: ; 24c59
	db "None@"
.Level: ; 24c5e
	db "Level@"

PadCoords_de: ; 27092
	ld a, d
	add 4
	ld d, a
	ld a, e
	add 4
	ld e, a
	jp GetBlockLocation

INCLUDE "engine/pokemon/level_up_happiness.asm"

_ReturnToBattle_UseBall: ; 2715c
	call ClearBGPalettes
	call ClearTileMap
	ld a, [wBattleType]
	cp BATTLETYPE_TUTORIAL
	jr z, .gettutorialbackpic
	farcall GetMonBackpic
	jr .continue

.gettutorialbackpic
	farcall GetTrainerBackpic
.continue
	farcall GetMonFrontpic
	farcall _LoadBattleFontsHPBar
	call GetMemCGBLayout
	call CloseWindow
	call LoadStandardMenuDataHeader
	call ApplyTilemapInVBlank
	call SetPalettes
	farcall LoadPlayerStatusIcon
	farcall LoadEnemyStatusIcon
	farjp FinishBattleAnim

INCLUDE "data/moves/effects_pointers.asm"

INCLUDE "data/moves/effects.asm"


SECTION "Code 8", ROMX

INCLUDE "engine/link.asm"


SECTION "Code 9", ROMX

INCLUDE "data/battle/music.asm"
INCLUDE "engine/battle/trainer_huds.asm"
INCLUDE "engine/battle/ai/redundant.asm"
INCLUDE "engine/events/move_deleter.asm"
INCLUDE "engine/key_items.asm"
INCLUDE "engine/tmhm2.asm"
INCLUDE "engine/events/pokerus.asm"
INCLUDE "data/trainers/class_names.asm"
INCLUDE "data/moves/descriptions.asm"

ShowLinkBattleParticipants: ; 2ee18
; If we're not in a communications room,
; we don't need to be here.
	ld a, [wLinkMode]
	and a
	ret z

	farcall _ShowLinkBattleParticipants
	ld c, 150
	call DelayFrames
	call ClearTileMap
	jp ClearSprites

FindFirstAliveMonAndStartBattle: ; 2ee2f
	xor a
	ld [hMapAnims], a
	call DelayFrame
	ld b, 6
	ld hl, wPartyMon1HP
	ld de, PARTYMON_STRUCT_LENGTH - 1

.loop
	ld a, [hli]
	or [hl]
	jr nz, .okay
	add hl, de
	dec b
	jr nz, .loop

.okay
	ld de, MON_LEVEL - MON_HP
	add hl, de
	ld a, [hl]
	ld [wBattleMonLevel], a
	predef Predef_StartBattle
	farcall _LoadBattleFontsHPBar
	ld a, 1
	ld [hBGMapMode], a
	call ClearSprites
	call ClearTileMap
	xor a
	ld [hBGMapMode], a
	ld [hWY], a
	ld [rWY], a
	ld [hMapAnims], a
	ret

ClearBattleRAM: ; 2ef18
	xor a
	ld [wBattlePlayerAction], a
	ld [wBattleResult], a

	ld hl, wPartyMenuCursor
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a

	ld [wMenuScrollPosition], a
	ld [wCriticalHit], a
	ld [wBattleMonSpecies], a
	ld [wCurBattleMon], a
	ld [wTimeOfDayPal], a
	ld [wPlayerTurnsTaken], a
	ld [wEnemyTurnsTaken], a
	ld [wEvolvableFlags], a

	ld hl, wPlayerHPPal
	ld [hli], a
	ld [hl], a

	ld hl, wBattleMonDVs
	ld [hli], a
	ld [hli], a
	ld [hl], a

	ld hl, wBattleMonPersonality
	ld [hli], a
	ld [hl], a

	ld hl, wEnemyMonDVs
	ld [hli], a
	ld [hli], a
	ld [hl], a

	ld hl, wEnemyMonPersonality
	ld [hli], a
	ld [hl], a

	; Clear the entire BattleMons area
	ld hl, wBattle
	ld bc, wBattleEnd - wBattle
	xor a
	call ByteFill

	; Clear UsedItems
	ld hl, wPartyUsedItems
	ld bc, 6
	xor a
	call ByteFill
	ld hl, wOTPartyUsedItems
	ld bc, 6
	xor a
	call ByteFill

	call ClearWindowData

	ld hl, hBGMapAddress
	xor a
	ld [hli], a
	ld [hl], vBGMap0 / $100
	ret

INCLUDE "engine/gfx/place_graphic.asm"


SECTION "Code 10", ROMX

INCLUDE "engine/pokemon/mail.asm"
INCLUDE "engine/events/fruit_trees.asm"
INCLUDE "engine/events/hidden_grottoes.asm"
INCLUDE "engine/battle/ai/move.asm"

AnimateDexSearchSlowpoke: ; 441cf
	ld hl, .FrameIDs
	ld b, 25
.loop
	ld a, [hli]

	; Wrap around
	cp $fe
	jr nz, .ok
	ld hl, .FrameIDs
	ld a, [hli]
.ok

	ld [wDexSearchSlowpokeFrame], a
	ld a, [hli]
	ld c, a
	push bc
	push hl
	call DoDexSearchSlowpokeFrame
	pop hl
	pop bc
	call DelayFrames
	dec b
	jr nz, .loop
	xor a
	ld [wDexSearchSlowpokeFrame], a
	call DoDexSearchSlowpokeFrame
	ld c, 32
	jp DelayFrames

.FrameIDs: ; 441fc
	; frame ID, duration
	db 0, 7
	db 1, 7
	db 2, 7
	db 3, 7
	db 4, 7
	db -2

DoDexSearchSlowpokeFrame: ; 44207
	ld a, [wDexSearchSlowpokeFrame]
	ld hl, .SpriteData
	ld de, wSprites
.loop
	ld a, [hli]
	cp -1
	ret z
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [wDexSearchSlowpokeFrame]
	ld b, a
	add a
	add b
	add [hl]
	inc hl
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	jr .loop

.SpriteData: ; 44228
	dsprite 11, 0,  9, 0, $00, $0
	dsprite 11, 0, 10, 0, $01, $0
	dsprite 11, 0, 11, 0, $02, $0
	dsprite 12, 0,  9, 0, $10, $0
	dsprite 12, 0, 10, 0, $11, $0
	dsprite 12, 0, 11, 0, $12, $0
	dsprite 13, 0,  9, 0, $20, $0
	dsprite 13, 0, 10, 0, $21, $0
	dsprite 13, 0, 11, 0, $22, $0
	db -1

DisplayDexEntry: ; 4424d
	call GetPokemonName
	hlcoord 9, 3
	call PlaceString ; mon species
	ld a, [wd265]
	ld b, a
	call GetDexEntryPointer
	ld a, b
	push af
	hlcoord 9, 5
	call FarString ; dex species
	ld h, b
	ld l, c
	push de
; Print dex number
	hlcoord 2, 8
	ld a, "№"
	ld [hli], a
	ld a, "."
	ld [hli], a
	ld de, wd265
	lb bc, PRINTNUM_LEADINGZEROS | 1, 3
	call PrintNum
; Check to see if we caught it.  Get out of here if we haven't.
	ld a, [wd265]
	dec a
	call CheckCaughtMon
	pop hl
	pop bc
	ret z
; Get the height of the Pokemon.
	ld a, [wCurPartySpecies]
	ld [wCurSpecies], a
	inc hl
	ld a, b
	push af
	push hl
	call GetFarHalfword
	ld d, l
	ld e, h
	pop hl
	inc hl
	inc hl
	ld a, d
	or e
	jr z, .skip_height
	ld a, [wOptions2]
	bit POKEDEX_UNITS, a
	jr z, .imperial_height

	push hl
	ld l, d
	ld h, e
	ld bc, -100
	ld e, 0
.inchloop
	ld a, h
	and a
	jr nz, .inchloop2
	ld a, l
	cp 100
	jr c, .inchdone
.inchloop2
	add hl, bc
	inc e
	jr .inchloop
.inchdone
	ld a, e
	ld e, l
	ld d, 0
	ld hl, 0
	ld bc, 12
	rst AddNTimes
	add hl, de
	ld b, h
	ld c, l
	ld de, 16646 ; 0.254 << 16
	call Mul16
	ld de, hTmpd
	hlcoord 11, 7
	ln bc, 0, 2, 4, 5
	call PrintNum
	pop hl
	jr .skip_height

.imperial_height
	push hl
	push de
	ld hl, sp+$0
	ld d, h
	ld e, l
	hlcoord 12, 7
	ln bc, 0, 2, 2, 4
	call PrintNum
	hlcoord 14, 7
	ld a, "′"
	ld [hli], a
	ld a, [hl]
	cp "0"
	jr nz, .imheight_ok
	ld [hl], " "
.imheight_ok
	pop af
	pop hl

.skip_height
	pop af
	push af
	inc hl
	push hl
	dec hl
	call GetFarHalfword
	ld d, l
	ld e, h
	ld a, e
	or d
	jr z, .skip_weight
	ld a, [wOptions2]
	bit POKEDEX_UNITS, a
	jr z, .imperial_weight

	ld c, d
	ld b, e
	ld de, 29726 ; 0.45359237 << 16
	call Mul16
	ld de, hTmpd
	hlcoord 11, 9
	ln bc, 0, 2, 4, 5
	call PrintNum
	jr .skip_weight

.imperial_weight
	push de
	ld hl, sp+$0
	ld d, h
	ld e, l
	hlcoord 11, 9
	ln bc, 0, 2, 4, 5
	call PrintNum
	pop de

.skip_weight
; Page 1
	lb bc, 5, SCREEN_WIDTH - 2
	hlcoord 2, 11
	call ClearBox
	hlcoord 1, 10
	ld bc, SCREEN_WIDTH - 1
	ld a, $5f ; horizontal divider
	call ByteFill
	; page number
	hlcoord 1, 9
	ld [hl], $55
	inc hl
	ld [hl], $55
	hlcoord 1, 10
	ld [hl], $56 ; P.
	inc hl
	ld [hl], $57 ; 1
	pop de
	inc de
	pop af
	hlcoord 2, 11
	push af
	call FarString
	pop bc
	ld a, [wPokedexStatus]
	or a
	ret z

; Page 2
	push bc
	push de
	lb bc, 5, SCREEN_WIDTH - 2
	hlcoord 2, 11
	call ClearBox
	hlcoord 1, 10
	ld bc, SCREEN_WIDTH - 1
	ld a, $5f ; horizontal divider
	call ByteFill
	; page number
	hlcoord 1, 9
	ld [hl], $55
	inc hl
	ld [hl], $55
	hlcoord 1, 10
	ld [hl], $56 ; P.
	inc hl
	ld [hl], $58 ; 2
	pop de
	inc de
	pop af
	hlcoord 2, 11
	jp FarString

; Metric conversion code by TPP Anniversary Crystal 251
; https://github.com/TwitchPlaysPokemon/tppcrystal251pub/blob/public/main.asm
Mul16:
	;[hTmpd][hTmpe]hl = bc * de
	xor a
	ld [hTmpd], a
	ld [hTmpe], a
	ld hl, 0
	ld a, 16
	ld [hProduct], a
.loop
	sla l
	rl h
	ld a, [hTmpe]
	rla
	ld [hTmpe], a
	ld a, [hTmpd]
	rla
	ld [hTmpd], a
	sla e
	rl d
	jr nc, .noadd
	add hl, bc
	ld a, [hTmpe]
	adc 0
	ld [hTmpe], a
	ld a, [hTmpd]
	adc 0
	ld [hTmpd], a
.noadd
	ld a, [hProduct]
	dec a
	ld [hProduct], a
	jr nz, .loop
	ret

GetDexEntryPointer: ; 44333
; return dex entry pointer b:de
	push hl
	ld hl, PokedexDataPointerTable
	ld a, b
	dec a
	ld d, 0
	ld e, a
	add hl, de
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	push de
	rlca
	rlca
	and $3
	ld hl, .PokedexEntryBanks
	ld d, 0
	ld e, a
	add hl, de
	ld b, [hl]
	pop de
	pop hl
	ret

.PokedexEntryBanks: ; 44351

GLOBAL PokedexEntries1
GLOBAL PokedexEntries2
GLOBAL PokedexEntries3
GLOBAL PokedexEntries4

	db BANK(PokedexEntries1)
	db BANK(PokedexEntries2)
	db BANK(PokedexEntries3)
	db BANK(PokedexEntries4)

	call GetDexEntryPointer ; b:de
	push hl
	ld h, d
	ld l, e
; skip species name
.loop1
	ld a, b
	call GetFarByte
	inc hl
	cp "@"
	jr nz, .loop1
; skip height and weight
rept 4
	inc hl
endr
; if c != 1: skip entry
	dec c
	jr z, .done
; skip entry
.loop2
	ld a, b
	call GetFarByte
	inc hl
	cp "@"
	jr nz, .loop2

.done
	ld d, h
	ld e, l
	pop hl
	ret

PokedexDataPointerTable: ; 0x44378
INCLUDE "data/pokemon/dex_entry_pointers.asm"


SECTION "Code 11", ROMX

INCLUDE "engine/main_menu.asm"
INCLUDE "engine/pokemon/search.asm"
INCLUDE "engine/events/celebi.asm"
INCLUDE "engine/tileset_palettes.asm"

Special_MoveTutor: ; 4925b
	call FadeToMenu
	call ClearBGPalettes
	call ClearScreen
	call DelayFrame
	ld b, CGB_PACKPALS
	call GetCGBLayout
	xor a
	ld [wItemAttributeParamBuffer], a
	ld a, [hScriptVar]
	and a
	ld [wPutativeTMHMMove], a
	jr z, .relearner
	ld [wNamedObjectIndexBuffer], a
	call GetMoveName
	call CopyName1
.relearner
	farcall ChooseMonToLearnTMHM
	jr c, .cancel
	jr .enter_loop

.loop
	farcall ChooseMonToLearnTMHM_NoRefresh
	jr c, .cancel
.enter_loop
	call CheckCanLearnMoveTutorMove
	jr nc, .loop
	xor a
	jr .quit

.cancel
	ld a, -1
.quit
	ld [hScriptVar], a
	jp CloseSubmenu

CheckCanLearnMoveTutorMove: ; 492b9
	ld hl, .MenuDataHeader
	call LoadMenuDataHeader

	predef CanLearnTMHMMove

	push bc
	ld a, [wCurPartyMon]
	ld hl, wPartyMonNicknames
	call GetNick
	pop bc

	ld a, c
	and a
	jr nz, .can_learn
	push de
	ld de, SFX_WRONG
	call PlaySFX
	pop de
	ld a, BANK(Text_TMHMNotCompatible)
	ld hl, Text_TMHMNotCompatible
	call FarPrintText
	jr .didnt_learn

.can_learn
	ld a, [wPutativeTMHMMove]
	and a
	jr z, .reminder
	farcall KnowsMove
	jr c, .didnt_learn

	predef LearnMove
.perform_move_learn
	ld a, b
	and a
	jr z, .didnt_learn

	ld c, HAPPINESS_LEARNMOVE
	farcall ChangeHappiness
	jr .learned

.reminder
	farcall ChooseMoveToRelearn
	jr nc, .can_remind
	push de
	ld de, SFX_WRONG
	call PlaySFX
	pop de
	ld a, BANK(MoveReminderNoMovesText)
	ld hl, MoveReminderNoMovesText
	call FarPrintText
	jr .didnt_learn

.can_remind
	jr z, .didnt_learn
	ld a, [wMoveScreenSelectedMove]
	ld [wPutativeTMHMMove], a
	ld [wNamedObjectIndexBuffer], a
	call GetMoveName
	call CopyName1
	predef LearnMove
	xor a
	ld [wPutativeTMHMMove], a
	jr .perform_move_learn

.didnt_learn
	call ExitMenu
	and a
	ret

.learned
	call ExitMenu
	scf
	ret

.MenuDataHeader: ; 0x4930a
	db $40 ; flags
	db 12, 00 ; start coords
	db 17, 19 ; end coords

AskRememberPassword: ; 4ae12
	call .DoMenu
	ld a, 0 ; not xor a; preserve carry flag
	jr c, .okay
	ld a, $1

.okay
	ld [hScriptVar], a
	ret

.DoMenu: ; 4ae1f
	lb bc, 14, 7
	push bc
	ld hl, YesNoMenuDataHeader
	call CopyMenuDataHeader
	pop bc
	ld a, b
	ld [wMenuBorderLeftCoord], a
	add $5
	ld [wMenuBorderRightCoord], a
	ld a, c
	ld [wMenuBorderTopCoord], a
	add $4
	ld [wMenuBorderBottomCoord], a
	call PushWindow
	call VerticalMenu
	push af
	ld c, 15
	call DelayFrames
	call Buena_ExitMenu
	pop af
	jr c, .refused
	ld a, [wMenuCursorY]
	cp $2
	jr z, .refused
	and a
	ret

.refused
	ld a, $2
	ld [wMenuCursorY], a
	scf
	ret

Buena_ExitMenu: ; 4ae5e
	ld a, [hOAMUpdate]
	push af
	call ExitMenu
	call UpdateSprites
	xor a
	ld [hOAMUpdate], a
	call DelayFrame
	ld a, $1
	ld [hOAMUpdate], a
	call ApplyTilemap
	pop af
	ld [hOAMUpdate], a
	ret

PackGFX:
INCBIN "gfx/pack/pack.w40.2bpp"
PackFGFX: ; 48e9b
INCBIN "gfx/pack/pack_f.w40.2bpp"


SECTION "Code 12", ROMX

EmptyAllSRAMBanks: ; 4cf1f
	xor a
	call .EmptyBank
	ld a, $1
	call .EmptyBank
	ld a, $2
	call .EmptyBank
	ld a, $3
	; fallthrough

.EmptyBank: ; 4cf34
	call GetSRAMBank
	ld hl, SRAM_Begin
	ld bc, SRAM_End - SRAM_Begin
	xor a
	call ByteFill
	jp CloseSRAM

CheckSave:: ; 4cffe
	ld a, BANK(sCheckValue1)
	call GetSRAMBank
	ld a, [sCheckValue1]
	ld b, a
	ld a, [sCheckValue2]
	ld c, a
	call CloseSRAM
	ld a, b
	cp SAVE_CHECK_VALUE_1
	jr nz, .ok
	ld a, c
	cp SAVE_CHECK_VALUE_2
	jr nz, .ok
	ld c, $1
	ret

.ok
	ld c, $0
	ret

INCLUDE "data/maps/scenes.asm"

Shrink1Pic: ; 4d249
INCBIN "gfx/new_game/shrink1.2bpp.lz"

Shrink2Pic: ; 4d2d9
INCBIN "gfx/new_game/shrink2.2bpp.lz"

_ResetClock: ; 4d3b1
	farcall BlankScreen
	ld b, CGB_DIPLOMA
	call GetCGBLayout
	call LoadStandardFont
	call LoadFontsExtra
	ld de, MUSIC_MAIN_MENU
	call PlayMusic
	ld hl, .text_askreset
	call PrintText
	ld hl, .NoYes_MenuDataHeader
	call CopyMenuDataHeader
	call VerticalMenu
	ret c
	ld a, [wMenuCursorY]
	cp $1
	ret z
	ld a, BANK(sRTCStatusFlags)
	call GetSRAMBank
	ld a, $80
	ld [sRTCStatusFlags], a
	call CloseSRAM
	ld hl, .text_okay
	jp PrintText

.text_okay ; 0x4d3fe
	; Select CONTINUE & reset settings.
	text_jump UnknownText_0x1c55db
	db "@"

.text_askreset ; 0x4d408
	; Reset the clock?
	text_jump UnknownText_0x1c561c
	db "@"

.NoYes_MenuDataHeader: ; 0x4d40d
	db $00 ; flags
	db 07, 14 ; start coords
	db 11, 19 ; end coords
	dw .NoYes_MenuData2
	db 1 ; default option

.NoYes_MenuData2: ; 0x4d415
	db $c0 ; flags
	db 2 ; items
	db "No@"
	db "Yes@"

_DeleteSaveData: ; 4d54c
	farcall BlankScreen
	ld b, CGB_DIPLOMA
	call GetCGBLayout
	call LoadStandardFont
	call LoadFontsExtra
	ld de, MUSIC_MAIN_MENU
	call PlayMusic
	ld hl, .Text_ClearAllSaveData
	call PrintText
	ld hl, TitleScreenNoYesMenuDataHeader
	call CopyMenuDataHeader
	call VerticalMenu
	ret c
	ld a, [wMenuCursorY]
	cp $1
	ret z
	farjp EmptyAllSRAMBanks

.Text_ClearAllSaveData: ; 0x4d580
	; Clear all save data?
	text_jump UnknownText_0x1c564a
	db "@"

_ResetInitialOptions:
	farcall BlankScreen
	ld b, CGB_DIPLOMA
	call GetCGBLayout
	call LoadStandardFont
	call LoadFontsExtra
	ld de, MUSIC_MAIN_MENU
	call PlayMusic
	ld hl, .Text_ResetInitialOptions
	call PrintText
	ld hl, TitleScreenNoYesMenuDataHeader
	call CopyMenuDataHeader
	call VerticalMenu
	ret c
	ld a, [wMenuCursorY]
	cp $1
	ret z
	ld a, [wInitialOptions]
	set RESET_INIT_OPTS, a
	ld [wInitialOptions], a
	ld a, BANK(sOptions)
	call GetSRAMBank
	ld a, [wInitialOptions]
	ld [sOptions + 6], a ; sInitialOptions
	jp CloseSRAM

.Text_ResetInitialOptions: ; 0x4d580
	; Reset the initial game options?
	text_jump ResetInitialOptionsText
	db "@"

TitleScreenNoYesMenuDataHeader: ; 0x4d585
	db $00 ; flags
	db 07, 14 ; start coords
	db 11, 19 ; end coords
	dw .MenuData2
	db 1 ; default option

.MenuData2: ; 0x4d58d
	db $c0 ; flags
	db 2 ; items
	db "No@"
	db "Yes@"

FlagPredef: ; 4d7c1
; Perform action b on flag c in flag array hl.
; If checking a flag, check flag array d:hl unless d is 0.

; For longer flag arrays, see FlagAction.

	push hl
	push bc

; Divide by 8 to get the byte we want.
	push bc
	srl c
	srl c
	srl c
	ld b, 0
	add hl, bc
	pop bc

; Which bit we want from the byte
	ld a, c
	and 7
	ld c, a

; Shift left until we can mask the bit
	ld a, 1
	jr z, .shifted
.shift
	add a
	dec c
	jr nz, .shift
.shifted
	ld c, a

; What are we doing to this flag?
	dec b
	jr z, .set ; 1
	dec b
	jr z, .check ; 2

.reset
	ld a, c
	cpl
	and [hl]
	ld [hl], a
	jr .done

.set
	ld a, [hl]
	or c
	ld [hl], a
	jr .done

.check
	ld a, d
	cp 0
	jr nz, .farcheck

	ld a, [hl]
	and c
	jr .done

.farcheck
	call GetFarByte
	and c

.done
	pop bc
	pop hl
	ld c, a
	ret

INCLUDE "engine/gfx/trademon_frontpic.asm"

CheckPokerus: ; 4d860
; Return carry if a monster in your party has Pokerus

; Get number of monsters to iterate over
	ld a, [wPartyCount]
	and a
	jr z, .NoPokerus
	ld b, a
; Check each monster in the party for Pokerus
	ld hl, wPartyMon1PokerusStatus
	ld de, PARTYMON_STRUCT_LENGTH
.Check:
	ld a, [hl]
	and $0f ; only the bottom nybble is used
	jr nz, .HasPokerus
; Next PartyMon
	add hl, de
	dec b
	jr nz, .Check
.NoPokerus:
	and a
	ret
.HasPokerus:
	scf
	ret

Special_CheckForLuckyNumberWinners: ; 4d87a
	xor a
	ld [hScriptVar], a
	ld [wFoundMatchingIDInParty], a
	ld a, [wPartyCount]
	and a
	ret z
	ld d, a
	ld hl, wPartyMon1ID
	ld bc, wPartySpecies
.PartyLoop:
	push hl
	ld bc, wPartyMon1IsEgg - wPartyMon1ID
	add hl, bc
	bit MON_IS_EGG_F, [hl]
	pop hl
	call z, .CompareLuckyNumberToMonID
	ld bc, PARTYMON_STRUCT_LENGTH
	add hl, bc
	dec d
	jr nz, .PartyLoop
	ld a, BANK(sBox)
	call GetSRAMBank
	ld a, [sBoxCount]
	and a
	jr z, .SkipOpenBox
	ld d, a
	ld hl, sBoxMon1ID
	ld bc, sBoxSpecies
.OpenBoxLoop:
	push hl
	ld bc, wPartyMon1IsEgg - wPartyMon1ID
	add hl, bc
	bit MON_IS_EGG_F, [hl]
	pop hl
	jr nz, .SkipOpenBoxMon
	call .CompareLuckyNumberToMonID
	jr nc, .SkipOpenBoxMon
	ld a, 1
	ld [wFoundMatchingIDInParty], a

.SkipOpenBoxMon:
	ld bc, BOXMON_STRUCT_LENGTH
	add hl, bc
	dec d
	jr nz, .OpenBoxLoop

.SkipOpenBox:
	call CloseSRAM
	ld c, $0
.BoxesLoop:
	ld a, [wCurBox]
	and $f
	cp c
	jr z, .SkipBox
	ld hl, .BoxBankAddresses
	ld b, 0
	add hl, bc
	add hl, bc
	add hl, bc
	ld a, [hli]
	call GetSRAMBank
	ld a, [hli]
	ld h, [hl]
	ld l, a ; hl now contains the address of the loaded box in SRAM
	ld a, [hl]
	and a
	jr z, .SkipBox ; no mons in this box
	push bc
	ld b, h
	ld c, l
	inc bc
	ld de, sBoxMon1ID - sBox
	add hl, de
	ld d, a
.BoxNLoop:
	push hl
	ld bc, wPartyMon1IsEgg - wPartyMon1ID
	add hl, bc
	bit MON_IS_EGG_F, [hl]
	pop hl
	jr nz, .SkipBoxMon

	call .CompareLuckyNumberToMonID ; sets hScriptVar and wCurPartySpecies appropriately
	jr nc, .SkipBoxMon
	ld a, 1
	ld [wFoundMatchingIDInParty], a

.SkipBoxMon:
	ld bc, BOXMON_STRUCT_LENGTH
	add hl, bc
	dec d
	jr nz, .BoxNLoop
	pop bc

.SkipBox:
	inc c
	ld a, c
	cp NUM_BOXES
	jr c, .BoxesLoop

	call CloseSRAM
	ld a, [hScriptVar]
	and a
	ret z ; found nothing
	ld a, [wFoundMatchingIDInParty]
	and a
	push af
	ld a, [wCurPartySpecies]
	ld [wNamedObjectIndexBuffer], a
	call GetPokemonName
	ld hl, .FoundPartymonText
	pop af
	jr z, .print
	ld hl, .FoundBoxmonText

.print
	jp PrintText

.CompareLuckyNumberToMonID: ; 4d939
	push bc
	push de
	push hl
	ld d, h
	ld e, l
	ld hl, wBuffer1
	lb bc, PRINTNUM_LEADINGZEROS | 2, 5
	call PrintNum
	ld hl, wLuckyNumberDigitsBuffer
	ld de, wLuckyIDNumber
	lb bc, PRINTNUM_LEADINGZEROS | 2, 5
	call PrintNum
	lb bc, 5, 0
	ld hl, wLuckyNumberDigitsBuffer + 4
	ld de, wBuffer1 + 4
.loop
	ld a, [de]
	cp [hl]
	jr nz, .done
	dec de
	dec hl
	inc c
	dec b
	jr nz, .loop

.done
	pop hl
	push hl
	ld de, -6
	add hl, de
	ld a, [hl]
	pop hl
	pop de
	push af
	ld a, c
	ld b, 1
	cp 5
	jr z, .okay
	ld b, 2
	cp 4
	jr z, .okay
	ld b, 3
	cp 3
	jr nc, .okay
	ld b, 4
	cp 2
	jr nz, .nomatch

.okay
	inc b
	ld a, [hScriptVar]
	and a
	jr z, .bettermatch
	cp b
	jr c, .nomatch

.bettermatch
	dec b
	ld a, b
	ld [hScriptVar], a
	pop bc
	ld a, b
	ld [wCurPartySpecies], a
	pop bc
	scf
	ret

.nomatch
	pop bc
	pop bc
	and a
	ret

.BoxBankAddresses: ; 4d99f
	dba sBox1
	dba sBox2
	dba sBox3
	dba sBox4
	dba sBox5
	dba sBox6
	dba sBox7
	dba sBox8
	dba sBox9
	dba sBox10
	dba sBox11
	dba sBox12
	dba sBox13
	dba sBox14

.FoundPartymonText: ; 0x4d9c9
	; Congratulations! We have a match with the ID number of @  in your party.
	text_jump UnknownText_0x1c1261
	db "@"

.FoundBoxmonText: ; 0x4d9ce
	; Congratulations! We have a match with the ID number of @  in your PC BOX.
	text_jump UnknownText_0x1c12ae
	db "@"

Special_PrintTodaysLuckyNumber: ; 4d9d3
	ld hl, wStringBuffer3
	ld de, wLuckyIDNumber
	lb bc, PRINTNUM_LEADINGZEROS | 2, 5
	call PrintNum
	ld a, "@"
	ld [wStringBuffer3 + 5], a
	ret

INCLUDE "engine/pokemon/caught_data.asm"

_FindThatSpecies: ; 4dbe0
	ld hl, wPartyMon1Species
	jp FindThatSpecies

_FindThatSpeciesYourTrainerID: ; 4dbe6
	ld hl, wPartyMon1Species
	call FindThatSpecies
	ret z
	ld a, c
	ld hl, wPartyMon1ID
	ld bc, PARTYMON_STRUCT_LENGTH
	rst AddNTimes
	ld a, [wPlayerID]
	cp [hl]
	jr nz, .nope
	inc hl
	ld a, [wPlayerID + 1]
	cp [hl]
	jr nz, .nope
	ld a, $1
	and a
	ret

.nope
	xor a
	ret

FindThatSpecies: ; 4dc56
; Find species b in your party.
; If you have no Pokemon, returns c = -1 and z.
; If that species is in your party, returns its location in c, and nz.
; Otherwise, returns z.
	ld c, -1
	ld hl, wPartySpecies
.loop
	ld a, [hli]
	cp -1
	ret z
	inc c
	cp b
	jr nz, .loop
	ld a, $1
	and a
	ret

INCLUDE "engine/pokemon/stats_screen.asm"

CatchTutorial:: ; 4e554
	ld a, [wBattleType]
	dec a
	ld c, a
	ld hl, .dw
	ld b, 0
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

.dw ; 4e564 (13:6564)
	dw .DudeTutorial
	dw .DudeTutorial
	dw .DudeTutorial

.DudeTutorial: ; 4e56a (13:656a)
; Back up your name
	ld hl, wPlayerName
	ld de, wBackupName
	ld bc, NAME_LENGTH
	rst CopyBytes
; Copy Dude's name to your name
	ld hl, .Dude
	ld de, wPlayerName
	ld bc, NAME_LENGTH
	rst CopyBytes

	call .LoadDudeData

	xor a
	ld [hJoyDown], a
	ld [hJoyPressed], a

	ld hl, .AutoInput
	ld a, BANK(.AutoInput)
	call StartAutoInput
	farcall StartBattle
	call StopAutoInput

	ld hl, wBackupName
	ld de, wPlayerName
	ld bc, NAME_LENGTH
	rst CopyBytes
	ret

.LoadDudeData: ; 4e5b7 (13:65b7)
	ld hl, wDudeNumItems
	ld de, .DudeItems
	call .CopyDudeData
	ld hl, wDudeNumMedicine
	ld de, .DudeMedicine
	call .CopyDudeData
	ld hl, wDudeNumBalls
	ld de, .DudeBalls
.CopyDudeData:
	ld a, [de]
	inc de
	ld [hli], a
	cp -1
	jr nz, .CopyDudeData
	ret

.Dude: ; 4e5da
	db "Lyra@"
.DudeItems:
	db 2, REPEL, 1, GOLD_LEAF, 1, -1
.DudeMedicine:
	db 3, POTION, 2, ANTIDOTE, 1, FRESH_WATER, 1, -1
.DudeBalls:
	db 2, POKE_BALL, 10, PREMIER_BALL, 1, -1

.AutoInput: ; 4e5df
	db NO_INPUT, $ff ; end

INCLUDE "engine/evolution_animation.asm"

InitDisplayForHallOfFame: ; 4e881
	call ClearBGPalettes
	call ClearTileMap
	call ClearSprites
	call DisableLCD
	call LoadStandardFont
	call LoadFontsBattleExtra
	hlbgcoord 0, 0
	ld bc, vBGMap1 - vBGMap0
	ld a, " "
	call ByteFill
	hlcoord 0, 0, wAttrMap
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	xor a
	call ByteFill
	xor a
	ld [hSCY], a
	ld [hSCX], a
	call EnableLCD
	ld hl, .SavingRecordDontTurnOff
	call PrintText
	call ApplyAttrAndTilemapInVBlank
	jp SetPalettes

.SavingRecordDontTurnOff: ; 0x4e8bd
	; SAVING RECORD… DON'T TURN OFF!
	text_jump UnknownText_0x1bd39e
	db "@"

InitDisplayForLeafCredits: ; 4e8c2
	call ClearBGPalettes
	call ClearTileMap
	call ClearSprites
	call DisableLCD
	call LoadStandardFont
	call LoadFontsBattleExtra
	hlbgcoord 0, 0
	ld bc, vBGMap1 - vBGMap0
	ld a, " "
	call ByteFill
	hlcoord 0, 0, wAttrMap
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	xor a
	call ByteFill
	ld hl, wUnknBGPals
	ld c, 4 tiles
.load_white_palettes
if !DEF(MONOCHROME)
	ld a, (palred 31 + palgreen 31 + palblue 31) % $100
	ld [hli], a
	ld a, (palred 31 + palgreen 31 + palblue 31) / $100
	ld [hli], a
else
	ld a, PAL_MONOCHROME_WHITE % $100
	ld [hli], a
	ld a, PAL_MONOCHROME_WHITE / $100
	ld [hli], a
endc
	dec c
	jr nz, .load_white_palettes
	xor a
	ld [hSCY], a
	ld [hSCX], a
	call EnableLCD
	call ApplyAttrAndTilemapInVBlank
	jp SetPalettes

ResetDisplayBetweenHallOfFameMons: ; 4e906
	ld a, [rSVBK]
	push af
	ld a, $6
	ld [rSVBK], a
	ld hl, wScratchTileMap
	ld bc, BG_MAP_WIDTH * BG_MAP_HEIGHT
	ld a, " "
	call ByteFill
	hlbgcoord 0, 0
	ld de, wScratchTileMap
	lb bc, $0, $40
	call Request2bpp
	pop af
	ld [rSVBK], a
	ret

INCLUDE "engine/battle/sliding_intro.asm"

CheckBattleEffects: ; 4ea44
; Return carry if battle scene is turned off.
	ld a, [wOptions1]
	bit BATTLE_EFFECTS, a
	jr z, .off
	and a
	ret
.off
	scf
	ret

INCLUDE "engine/bsod.asm"

INCLUDE "engine/events/stats_judge.asm"

INCLUDE "engine/events/poisonstep.asm"
INCLUDE "engine/events/squirtbottle.asm"
INCLUDE "engine/events/card_key.asm"
INCLUDE "engine/events/basement_key.asm"
INCLUDE "engine/events/sacred_ash.asm"


SECTION "Code 13", ROMX

INCLUDE "engine/pokemon/party_menu.asm"
INCLUDE "engine/pokemon/tempmon.asm"
INCLUDE "engine/pokemon/types.asm"

PrintNature:
; Print nature b at hl.
	push hl
	ld hl, NatureNames
	jr _PrintNatureProperty

PrintNatureIndicators:
; Print indicators for nature b at hl.
	push hl
	ld hl, NatureIndicators
_PrintNatureProperty:
	ld a, b
	add a
	ld e, a
	ld d, 0
	add hl, de
	ld a, [hli]
	ld e, a
	ld d, [hl]
	pop hl
	jp PlaceString

INCLUDE "data/natures.asm"
INCLUDE "engine/pokemon/mon_stats.asm"
INCLUDE "engine/pokemon/experience.asm"
INCLUDE "engine/pokemon/switchpartymons.asm"
INCLUDE "engine/gfx/load_pics.asm"
INCLUDE "engine/pokemon/move_mon_wo_mail.asm"
INCLUDE "data/pokemon/base_stats.asm"
INCLUDE "data/pokemon/names.asm"


SECTION "Code 14", ROMX

INCLUDE "engine/battle/abilities.asm"
INCLUDE "data/trainers/final_text.asm"
INCLUDE "engine/overworld/player_movement.asm"
INCLUDE "engine/engine_flags.asm"
INCLUDE "engine/overworld/variables.asm"
INCLUDE "data/text/battle.asm"


SECTION "Code 15", ROMX

INCLUDE "gfx/battle_anims.asm"
INCLUDE "engine/events/halloffame.asm"
INCLUDE "engine/copy_tilemap_at_once.asm"

PrintAbility:
; Print ability b at hl.
	ld l, b
	ld h, 0
	ld bc, AbilityNames
	add hl, hl
	add hl, bc
	ld a, [hli]
	ld d, [hl]
	ld e, a
	hlcoord 3, 13
	jp PlaceString

BufferAbility:
; Buffer name for b into wStringBuffer1
	ld l, b
	ld h, 0
	ld bc, AbilityNames
	add hl, hl
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, wStringBuffer1
.loop
	ld a, [hli]
	ld [de], a
	inc de
	cp "@"
	ret z
	jr .loop

PrintAbilityDescription:
; Print ability description for b
; we can't use PlaceString, because it would linebreak with an empty line inbetween
	ld l, b
	ld h, 0
	ld bc, AbilityDescriptions
	add hl, hl
	add hl, bc
	ld a, [hli]
	ld d, [hl]
	ld e, a
	hlcoord 1, 15
	jp PlaceString

INCLUDE "data/abilities.asm"


SECTION "Code 16", ROMX

INCLUDE "engine/gfx/player_gfx.asm"
INCLUDE "engine/events/kurt.asm"
INCLUDE "engine/events/unown.asm"
INCLUDE "engine/events/buena.asm"
INCLUDE "engine/events/movesets.asm"
INCLUDE "engine/events/battle_tower/battle_tower.asm"
INCLUDE "engine/events/battle_tower/trainer_text.asm"
INCLUDE "engine/events/item_maniacs.asm"


SECTION "Code 17", ROMX

INCLUDE "engine/timeofdaypals.asm"
INCLUDE "engine/battle_start.asm"
INCLUDE "engine/gfx/sprites.asm"
INCLUDE "engine/gfx/mon_icons.asm"
INCLUDE "engine/events/field_moves.asm"
INCLUDE "engine/events/magnet_train.asm"
INCLUDE "data/pokemon/menu_icon_pointers.asm"
INCLUDE "data/pokemon/menu_icons.asm"


SECTION "Code 18", ROMX

INCLUDE "engine/phone.asm"
INCLUDE "engine/timeset.asm"
INCLUDE "engine/pokegear.asm"
INCLUDE "engine/events/fish.asm"
INCLUDE "engine/slot_machine.asm"


SECTION "Code 19", ROMX

INCLUDE "engine/events_2.asm"
INCLUDE "engine/radio.asm"
INCLUDE "engine/pokemon/mail_2.asm"


SECTION "Code 20", ROMX

INCLUDE "engine/events/std_scripts.asm"
INCLUDE "engine/phone_scripts.asm"


SECTION "Code 21", ROMX

INCLUDE "engine/battle_anims/bg_effects.asm"


SECTION "Battle Animation data", ROMX

INCLUDE "data/moves/animations.asm"


SECTION "Code 22", ROMX

INCLUDE "engine/card_flip.asm"
INCLUDE "engine/unown_puzzle.asm"
;INCLUDE "engine/dummy_game.asm"
INCLUDE "engine/pokemon/bills_pc.asm"
INCLUDE "engine/fade.asm"


SECTION "Code 23", ROMX

INCLUDE "engine/battle/hidden_power.asm"
INCLUDE "engine/battle/misc.asm"
INCLUDE "engine/unowndex.asm"
INCLUDE "engine/events/magikarp.asm"
INCLUDE "engine/events/name_rater.asm"
INCLUDE "audio/distorted_cries.asm"


SECTION "Code 24", ROMX

INCLUDE "engine/tileset_anims.asm"
INCLUDE "engine/events/npc_trade.asm"
INCLUDE "engine/events/wonder_trade.asm"
INCLUDE "engine/events/mom_phone.asm"


SECTION "Code 25", ROMX

INCLUDE "engine/gfx/dma_transfer.asm"
INCLUDE "gfx/emotes.asm"
INCLUDE "engine/overworld/warp_connection.asm"
INCLUDE "engine/battle/used_move_text.asm"
INCLUDE "gfx/items.asm"

SECTION "Load Map Part", ROMX
; linked, do not separate
INCLUDE "engine/overworld/player_step.asm"
INCLUDE "engine/overworld/load_map_part.asm"
; end linked section


SECTION "Introduction", ROMX

INCLUDE "engine/options_menu.asm"
INCLUDE "engine/crystal_intro.asm"

CopyrightGFX:: ; e4000
INCBIN "gfx/splash/copyright.2bpp"


SECTION "Title Screen", ROMX

INCLUDE "engine/title.asm"


SECTION "Diploma", ROMX

INCLUDE "engine/diploma.asm"


SECTION "Collision Permissions", ROMX

INCLUDE "data/collision_permissions.asm"


SECTION "Typefaces", ROMX

INCLUDE "engine/gfx/load_font.asm"


SECTION "Battle Core", ROMX

INCLUDE "engine/battle/core.asm"


SECTION "Battle Endturn", ROMX

INCLUDE "engine/battle/endturn.asm"


SECTION "Unique Wild Moves", ROMX

INCLUDE "engine/battle/unique_wild_moves.asm"


SECTION "Effect Commands", ROMX

INCLUDE "engine/battle/effect_commands.asm"


SECTION "Battle Stat Changes", ROMX

INCLUDE "engine/battle/stats.asm"


SECTION "Battle Animations", ROMX

INCLUDE "engine/battle_anims/anim_commands.asm"
INCLUDE "engine/battle_anims/core.asm"
INCLUDE "data/battle_anims/objects.asm"
INCLUDE "engine/battle_anims/functions.asm"
INCLUDE "engine/battle_anims/helpers.asm"
INCLUDE "data/battle_anims/framesets.asm"
INCLUDE "data/battle_anims/oam.asm"
INCLUDE "data/battle_anims/object_gfx.asm"


SECTION "Battle Graphics", ROMX

SubstituteFrontpic: INCBIN "gfx/battle/substitute-front.2bpp.lz"
SubstituteBackpic:  INCBIN "gfx/battle/substitute-back.2bpp.lz"

GhostFrontpic:      INCBIN "gfx/battle/ghost.2bpp.lz"


SECTION "Moves", ROMX

INCLUDE "data/moves/moves.asm"


SECTION "Enemy Trainers", ROMX

INCLUDE "engine/battle/ai/items.asm"

AIScoring: ; 38591
INCLUDE "engine/battle/ai/scoring.asm"

GetTrainerClassName: ; 3952d
	ld a, c
	ld [wCurSpecies], a
	ld a, TRAINER_NAME
	ld [wNamedObjectTypeBuffer], a
	call GetName
	ld de, wStringBuffer1
	ret

GetOTName: ; 39550
	ld hl, wOTPlayerName
	ld a, [wLinkMode]
	and a
	jr nz, .ok

	ld a, c
	ld [wCurSpecies], a
	ld a, TRAINER_NAME
	ld [wNamedObjectTypeBuffer], a
	call GetName
	ld hl, wStringBuffer1

.ok
	ld bc, TRAINER_CLASS_NAME_LENGTH
	ld de, wOTClassName
	push de
	rst CopyBytes
	pop de
	ret

GetTrainerAttributes: ; 3957b
	ld a, [wTrainerClass]
	ld c, a
	call GetOTName
	ld a, [wTrainerClass]
	dec a
	ld hl, TrainerClassAttributes + TRNATTR_ITEM1
	ld bc, NUM_TRAINER_ATTRIBUTES
	rst AddNTimes
	ld de, wEnemyTrainerItem1
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	ld a, [hl]
	ld [wEnemyTrainerBaseReward], a
	ret

ComputeTrainerReward: ; 3991b (e:591b)
	ld hl, hProduct
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld a, [wEnemyTrainerBaseReward]
	ld [hli], a
	ld a, [wCurPartyLevel]
	ld [hl], a
	call Multiply
	ld hl, wBattleReward
	xor a
	ld [hli], a
	ld a, [hProduct + 2]
	ld [hli], a
	ld a, [hProduct + 3]
	ld [hl], a
	ret

INCLUDE "data/trainers/attributes.asm"


SECTION "Enemy Trainer Pointers", ROMX

INCLUDE "engine/read_party.asm"
INCLUDE "data/trainers/party_pointers.asm"
INCLUDE "data/trainers/parties.asm"


SECTION "Wild Data", ROMX

INCLUDE "engine/overworld/wildmons.asm"


SECTION "Pokedex", ROMX

INCLUDE "engine/pokedex.asm"


SECTION "Evolution", ROMX

INCLUDE "engine/pokemon/evolve.asm"


SECTION "Pic Animations", ROMX

INCLUDE "engine/gfx/pic_animation.asm"

; Pic animations are assembled in 3 parts:

; Top-level animations:
; 	frame #, duration: Frame 0 is the original pic (no change)
;	setrepeat #:       Sets the number of times to repeat
; 	dorepeat #:        Repeats from command # (starting from 0)
; 	end

; Bitmasks:
;	Layered over the pic to designate affected tiles

; Frame definitions:
;	first byte is the bitmask used for this frame
;	following bytes are tile ids mapped to each bit in the mask

; Main animations (played everywhere)
INCLUDE "gfx/pokemon/anim_pointers.asm"
INCLUDE "gfx/pokemon/anims.asm"

; Extra animations, appended to the main animation
; Used in the status screen (blinking, tail wags etc.)
INCLUDE "gfx/pokemon/extra_pointers.asm"
INCLUDE "gfx/pokemon/extras.asm"

; Variants have their own animation data despite having entries in the main tables
INCLUDE "gfx/pokemon/variant_anim_pointers.asm"
INCLUDE "gfx/pokemon/variant_anims.asm"
INCLUDE "gfx/pokemon/variant_extra_pointers.asm"
INCLUDE "gfx/pokemon/variant_extras.asm"


SECTION "Pic Animations Frames 1", ROMX

INCLUDE "gfx/pokemon/frame_pointers.asm"
INCLUDE "gfx/pokemon/kanto_frames.asm"


SECTION "Pic Animations Frames 2", ROMX

INCLUDE "gfx/pokemon/johto_frames.asm"
INCLUDE "gfx/pokemon/variant_frame_pointers.asm"
INCLUDE "gfx/pokemon/variant_frames.asm"


SECTION "Pic Animations Bitmasks", ROMX

; Bitmasks
INCLUDE "gfx/pokemon/bitmask_pointers.asm"
INCLUDE "gfx/pokemon/bitmasks.asm"
INCLUDE "gfx/pokemon/variant_bitmask_pointers.asm"
INCLUDE "gfx/pokemon/variant_bitmasks.asm"


SECTION "Standard Text", ROMX

INCLUDE "data/text/std_text.asm"


SECTION "Phone Scripts", ROMX

INCLUDE "engine/more_phone_scripts.asm"
INCLUDE "engine/buena_phone_scripts.asm"


SECTION "Phone Text 1", ROMX

INCLUDE "data/phone/text/anthony_overworld.asm"
INCLUDE "data/phone/text/todd_overworld.asm"
INCLUDE "data/phone/text/gina_overworld.asm"
INCLUDE "data/phone/text/irwin_overworld.asm"
INCLUDE "data/phone/text/arnie_overworld.asm"
INCLUDE "data/phone/text/alan_overworld.asm"
INCLUDE "data/phone/text/dana_overworld.asm"
INCLUDE "data/phone/text/chad_overworld.asm"
INCLUDE "data/phone/text/derek_overworld.asm"
INCLUDE "data/phone/text/tully_overworld.asm"
INCLUDE "data/phone/text/brent_overworld.asm"
INCLUDE "data/phone/text/tiffany_overworld.asm"
INCLUDE "data/phone/text/vance_overworld.asm"
INCLUDE "data/phone/text/wilton_overworld.asm"
INCLUDE "data/phone/text/kenji_overworld.asm"
INCLUDE "data/phone/text/parry_overworld.asm"
INCLUDE "data/phone/text/erin_overworld.asm"


SECTION "Phone Text 2", ROMX

INCLUDE "data/phone/text/jack_overworld.asm"
INCLUDE "data/phone/text/beverly_overworld.asm"
INCLUDE "data/phone/text/huey_overworld.asm"
INCLUDE "data/phone/text/gaven_overworld.asm"
INCLUDE "data/phone/text/beth_overworld.asm"
INCLUDE "data/phone/text/jose_overworld.asm"
INCLUDE "data/phone/text/reena_overworld.asm"
INCLUDE "data/phone/text/joey_overworld.asm"
INCLUDE "data/phone/text/wade_overworld.asm"
INCLUDE "data/phone/text/ralph_overworld.asm"


SECTION "Phone Text 3", ROMX

INCLUDE "data/phone/text/mom.asm"
INCLUDE "data/phone/text/bill.asm"
INCLUDE "data/phone/text/elm.asm"
INCLUDE "data/phone/text/trainers1.asm"
INCLUDE "data/phone/text/liz_overworld.asm"


SECTION "Phone Text 4", ROMX

INCLUDE "data/phone/text/extra.asm"
INCLUDE "data/phone/text/lyra.asm"


SECTION "Phone Text 5", ROMX

INCLUDE "data/phone/text/extra2.asm"


SECTION "Item Text", ROMX

INCLUDE "data/items/names.asm"

PrintKeyItemDescription:
	ld hl, KeyItemDescriptions
	ld a, [wCurKeyItem]
	jr PrintDescription

PrintItemDescription: ; 0x1c8955
; Print the description for item [wCurSpecies] at de.
	ld hl, ItemDescriptions
	ld a, [wCurSpecies]
PrintDescription:
	dec a
	ld c, a
	ld b, 0
	add hl, bc
	add hl, bc
	push de
	ld e, [hl]
	inc hl
	ld d, [hl]
	pop hl
	jp PlaceString
; 0x1c8987

PrintTMHMDescription:
; Print the description for TM/HM [wCurSpecies] at de.

	ld a, [wCurSpecies]
	inc a
	ld [wCurTMHM], a
	ld [wCurTMHMBuffer], a
	push de
	predef GetTMHMMove
	pop hl
	ld a, [wd265]
	ld [wCurSpecies], a
	predef PrintMoveDesc
	ret

INCLUDE "data/items/descriptions.asm"
INCLUDE "data/items/apricorn_names.asm"


SECTION "Move and Landmark Text", ROMX

INCLUDE "data/moves/names.asm"

INCLUDE "engine/overworld/landmarks.asm"


SECTION "Battle Tower Text", ROMX

INCLUDE "data/battle_tower/trainer_text.asm"


SECTION "Crystal Data", ROMX

INCLUDE "engine/events/battle_tower/load_trainer.asm"
INCLUDE "data/events/odd_eggs.asm"
