/* Steam build 25633433. Only unused section-alignment padding is used. */
camera_resume = 0x1430d6cc7;
gui_resume = 0x1431d4d51;
gui_flag = 0x1445f64f1;
step_resume = 0x142f1e185;
viewwidth_id = 0x144249348;
view_width_id = 0x1442496e8;
getvar_write = 0x1400885d0;
global_object = 0x1442da630;
res_width_id = 0x1442c6898;
cam_scale_switch_id = 0x1442c6968;
res_height_id = 0x1442c6668;
getvar_read = 0x1400885c0;
real_value = 0x1400885a0;
window_height = 0x14405ed84;
window_width = 0x14405eb58;
gui_height = 0x14405afb4;
gui_scale_x = 0x14405afb8;
gui_scale_y = 0x14405afbc;
gui_offset_x = 0x14405afc4;
gui_offset_y = 0x14405afc8;
gui_maximise = 0x1445f64f0;
renderer_surface = 0x144059cf4;
transform_resume = 0x143168d3e;
draw_rectangle = 0x143052e40;
builtin_dispatch = 0x142fe6a60;
draw_sprite = 0x143026220;
surface_target = 0x143026510;
surface_width = 0x142fff5e0;
surface_resize = 0x142fff6e0;
set_projection = 0x1431717d0;
SECTIONS
{
  .text 0x1438fa2c0 : { *(.text) }
  .data 0x144669760 : { *(.data) }
  ASSERT(SIZEOF(.text) <= 1536, "Hooks exceed the three INI code blocks")
  ASSERT(SIZEOF(.data) <= 512, "State exceeds the INI state block")
  .CameraProjection 0x1430d6cc0 : { *(.CameraProjection) }
  .InitializeAspect 0x1431d4d4a : { *(.InitializeAspect) }
  .CenterGUI 0x143168d38 : { *(.CenterGUI) }
  .CameraStepWidth 0x142f1e180 : { *(.CameraStepWidth) }
  .ViewportWidth 0x142f1e7aa : { *(.ViewportWidth) }
  .CameraClampWidth 0x142f19a75 : { *(.CameraClampWidth) }
  .CameraViewWidth 0x142f1ec7d : { *(.CameraViewWidth) }
  .FullscreenOverlay1 0x14239a8bc : { *(.FullscreenOverlay1) }
  .FullscreenOverlay2 0x14239ae32 : { *(.FullscreenOverlay2) }
  .FullscreenOverlay3 0x14239e9fa : { *(.FullscreenOverlay3) }
  .NormalMaskTargetGUI 0x142d6d77b : { *(.NormalMaskTargetGUI) }
  .NormalMaskTargetWorld 0x142d6fce9 : { *(.NormalMaskTargetWorld) }
  .UnderwaterMaskTargetGUI 0x142d65477 : { *(.UnderwaterMaskTargetGUI) }
  .UnderwaterMaskTargetWorld 0x142d67ec7 : { *(.UnderwaterMaskTargetWorld) }
  .LightingSprite01 0x142d6ddf5 : { *(.LightingSprite01) }
  .LightingSprite02 0x142d6e4f5 : { *(.LightingSprite02) }
  .LightingSprite03 0x142d702af : { *(.LightingSprite03) }
  .LightingSprite04 0x142d65b2b : { *(.LightingSprite04) }
  .LightingSprite05 0x142d66030 : { *(.LightingSprite05) }
  .LightingSprite06 0x142d666e9 : { *(.LightingSprite06) }
  .LightingSprite07 0x142d685eb : { *(.LightingSprite07) }
  .LightingSprite08 0x142d68bb4 : { *(.LightingSprite08) }
  .LightingSprite09 0x142d691c5 : { *(.LightingSprite09) }
  .LightingSprite10 0x142d697d5 : { *(.LightingSprite10) }
  .LightingSprite11 0x142d69d06 : { *(.LightingSprite11) }
  .LightingComposite01 0x142d6e966 : { *(.LightingComposite01) }
  .LightingComposite02 0x142d70c71 : { *(.LightingComposite02) }
  .LightingComposite03 0x142d66b63 : { *(.LightingComposite03) }
  .LightingComposite04 0x142d6a735 : { *(.LightingComposite04) }
  .LowHealthOverlay 0x14239af6e : { *(.LowHealthOverlay) }
  .Preset3440Arguments 0x1402ed648 : { *(.Preset3440Arguments) }
  .PauseScreenshot 0x14239e94b : { *(.PauseScreenshot) }
  .LoadingFade 0x14256e8ed : { *(.LoadingFade) }
  .MenuFade 0x1426438e3 : { *(.MenuFade) }
  .RoomProjection 0x14316d801 : { *(.RoomProjection) }
}
