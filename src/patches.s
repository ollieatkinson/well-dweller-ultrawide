.intel_syntax noprefix
.section .CameraProjection,"a"
jmp camera
.fill 2, 1, 0x90

.section .InitializeAspect,"a"
jmp gui
.fill 2, 1, 0x90

.section .CenterGUI,"a"
jmp gui_transform
.fill 1, 1, 0x90

.section .CameraStepWidth,"a"
jmp step

.section .ViewportWidth,"a"
call port

.section .CameraClampWidth,"a"
.byte 0xf2, 0x0f, 0x10, 0x05
.long logical_width - . - 4

.section .CameraViewWidth,"a"
.byte 0xf2, 0x0f, 0x10, 0x15
.long logical_width - . - 4

.section .FullscreenOverlay1,"a"
call overlay_rectangle

.section .FullscreenOverlay2,"a"
call overlay_rectangle

.section .FullscreenOverlay3,"a"
call overlay_rectangle

.section .NormalMaskTargetGUI,"a"
call mask_target

.section .NormalMaskTargetWorld,"a"
call mask_target

.section .UnderwaterMaskTargetGUI,"a"
call mask_target

.section .UnderwaterMaskTargetWorld,"a"
call mask_target

.section .LightingSprite01,"a"
call mask_sprite

.section .LightingSprite02,"a"
call mask_sprite

.section .LightingSprite03,"a"
call mask_sprite

.section .LightingSprite04,"a"
call mask_sprite

.section .LightingSprite05,"a"
call mask_sprite

.section .LightingSprite06,"a"
call mask_sprite

.section .LightingSprite07,"a"
call mask_sprite

.section .LightingSprite08,"a"
call mask_sprite

.section .LightingSprite09,"a"
call mask_sprite

.section .LightingSprite10,"a"
call mask_sprite

.section .LightingSprite11,"a"
call mask_sprite

.section .LightingComposite01,"a"
call mask_surface

.section .LightingComposite02,"a"
call mask_surface

.section .LightingComposite03,"a"
call mask_surface

.section .LightingComposite04,"a"
call mask_surface

.section .LowHealthOverlay,"a"
call fullscreen_sprite

.section .Preset3440Arguments,"a"
.byte 0x0f, 0x10, 0x05
.long rv3440 - . - 4

.section .PauseScreenshot,"a"
call fullscreen_sprite

.section .LoadingFade,"a"
call overlay_rectangle

.section .MenuFade,"a"
call overlay_rectangle

.section .RoomProjection,"a"
call room_projection
