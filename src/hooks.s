.intel_syntax noprefix
.section .text
.global mask_target, mask_sprite, mask_surface, fullscreen_sprite
.global camera, gui, gui_transform, port, step, logical_width, rv3440
# All external references use RIP-relative addressing / relative branches for ASLR.
# Native camera_set_view_mat has resolved the active camera into RSI.
# Rebuild its orthographic projection at the selected aspect before installing
# the game's existing custom look-at matrix. Preserve XMM0 for the caller.
camera:
    sub rsp, 0x20
    movups [rsp], xmm0
    movsd xmm0, [rip + aspect]
    comisd xmm0, [rip + zero]
    jbe camera_done
    movss xmm0, [rsi + 0x194]
    cvtss2sd xmm0, xmm0
    mulsd xmm0, [rip + aspect]
    cvtsd2ss xmm0, xmm0
    movss [rsi + 0x190], xmm0
    mov BYTE PTR [rsi + 0x1e5], 1
camera_done:
    movups xmm0, [rsp]
    add rsp, 0x20
    cmp BYTE PTR [rsi + 0x1e5], 0
    jmp camera_resume

# display_set_gui_size runs on the saved-settings load path as well as explicit
# resolution changes. Derive the aspect from the current global RValues here.
gui:
    push rax
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    sub rsp, 0x48
    movups [rsp + 0x20], xmm0
    movups [rsp + 0x30], xmm1
    mov rcx, [rip + global_object]
    mov edx, [rip + res_width_id]
    call getvar_read
    mov rcx, rax
    call real_value
    movsd [rsp + 0x40], xmm0
    mov rcx, [rip + global_object]
    mov edx, [rip + res_height_id]
    call getvar_read
    mov rcx, rax
    call real_value
    movapd xmm1, xmm0
    movsd xmm0, [rsp + 0x40]
    divsd xmm0, xmm1
    comisd xmm0, [rip + normal_aspect]
    jbe gui_normal
    movsd [rip + aspect], xmm0
    mulsd xmm0, [rip + height]
    movsd [rip + logical_width], xmm0
    jmp gui_done
gui_normal:
    xorpd xmm0, xmm0
    movsd [rip + aspect], xmm0
    movsd xmm0, [rip + normal_width]
    movsd [rip + logical_width], xmm0
gui_done:
    # Ask the camera Step to refresh viewport ports after startup/room setup too.
    mov rcx, [rip + global_object]
    mov edx, [rip + cam_scale_switch_id]
    call getvar_write
    movsd xmm0, [rip + one]
    movsd [rax], xmm0
    mov QWORD PTR [rax + 8], 0
    # Retain the original 2560x1440 UI coordinate space; the transform hook
    # provides equal X/Y scaling and centers it, including inverse mouse mapping.
    movups xmm0, [rsp + 0x20]
    movups xmm1, [rsp + 0x30]
    add rsp, 0x48
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rax
    cmp BYTE PTR [rip + gui_flag], 0
    jmp gui_resume

# Native GUI matrix/inverse-matrix setup. Refresh scale and position using the
# current window size so fullscreen changes and resizing cannot leave stale offsets.
gui_transform:
    sub rsp, 0x30
    movups [rsp], xmm0
    movups [rsp + 0x10], xmm1
    movups [rsp + 0x20], xmm2
    movsd xmm0, [rip + aspect]
    comisd xmm0, [rip + zero]
    jbe transform_done
    cvtsi2ss xmm0, DWORD PTR [rip + window_height]
    cvtsi2ss xmm1, DWORD PTR [rip + gui_height]
    divss xmm0, xmm1
    movss [rip + gui_scale_x], xmm0
    movss [rip + gui_scale_y], xmm0
    mulss xmm0, [rip + ui_width_float]
    cvtsi2ss xmm1, DWORD PTR [rip + window_width]
    subss xmm1, xmm0
    mulss xmm1, [rip + half_float]
    movss [rip + gui_offset_x], xmm1
    mov DWORD PTR [rip + gui_offset_y], 0
    mov BYTE PTR [rip + gui_maximise], 1
transform_done:
    movups xmm0, [rsp]
    movups xmm1, [rsp + 0x10]
    movups xmm2, [rsp + 0x20]
    add rsp, 0x30
    mov ecx, [rip + renderer_surface]
    jmp transform_resume

# Leaf called instead of the fixed viewport-width immediate.
port:
    sub rsp, 0x18
    movups [rsp], xmm0
    movsd xmm0, [rip + logical_width]
    cvttsd2si edx, xmm0
    movups xmm0, [rsp]
    add rsp, 0x18
    ret

# Keep instance widths used for camera position and room clamps current.
# The hook runs before the camera Step prologue; preserve its input registers.
step:
    mov [rsp + 0x10], rdx
    push rcx
    push rdx
    push r8
    push r9
    sub rsp, 0x28
    mov rcx, [rsp + 0x40]
    mov edx, [rip + viewwidth_id]
    call getvar_write
    movsd xmm0, [rip + logical_width]
    movsd [rax], xmm0
    mov QWORD PTR [rax + 8], 0
    mov rcx, [rsp + 0x40]
    mov edx, [rip + view_width_id]
    call getvar_write
    movsd xmm0, [rip + logical_width]
    movsd [rax], xmm0
    mov QWORD PTR [rax + 8], 0
    add rsp, 0x28
    pop r9
    pop r8
    pop rdx
    pop rcx
    jmp step_resume

# Extend the fullscreen loading/menu/fade/hurt/pause rectangles into GUI margins.
# Tail-call preserves the original stack arguments and rendering state.
.global overlay_rectangle
overlay_rectangle:
    movsd xmm4, [rip + aspect]
    comisd xmm4, [rip + zero]
    jbe overlay_done
    movss xmm4, [rip + gui_scale_x]
    xorps xmm5, xmm5
    comiss xmm4, xmm5
    jbe overlay_done
    movss xmm5, [rip + gui_offset_x]
    divss xmm5, xmm4
    subss xmm0, xmm5
    addss xmm2, xmm5
overlay_done:
    jmp draw_rectangle

# Resize the normal and underwater lighting masks to ceil(logical_width/4).
# Their glow sprites keep their original scales; padding shifts both mask
# contents and final placement equally, preserving the light's world position.
mask_target:
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    sub rsp, 0x88
    movups [rsp + 0x20], xmm0
    movups [rsp + 0x30], xmm1
    movups [rsp + 0x40], xmm2
    movups [rsp + 0x50], xmm3
    movups [rsp + 0x60], xmm4
    movups [rsp + 0x70], xmm5
    movsd xmm0, [rip + logical_width]
    divsd xmm0, [rip + four]
    cvttsd2si eax, xmm0
    cvtsi2sd xmm1, eax
    comisd xmm1, xmm0
    jae mask_width_ready
    inc eax
mask_width_ready:
    mov [rsp + 0x80], eax
    cvtsi2sd xmm0, eax
    subsd xmm0, [rip + mask_normal_width]
    mulsd xmm0, [rip + half]
    movsd [rip + mask_padding], xmm0
    mov ecx, [rsp + 0xb0]
    call surface_width
    cmp eax, [rsp + 0x80]
    je mask_target_done
    mov ecx, [rsp + 0xb0]
    mov edx, [rsp + 0x80]
    mov r8d, 360
    call surface_resize
mask_target_done:
    movups xmm0, [rsp + 0x20]
    movups xmm1, [rsp + 0x30]
    movups xmm2, [rsp + 0x40]
    movups xmm3, [rsp + 0x50]
    movups xmm4, [rsp + 0x60]
    movups xmm5, [rsp + 0x70]
    add rsp, 0x88
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    jmp surface_target

mask_sprite:
    movsd xmm4, [rip + mask_padding]
    cvtsd2ss xmm4, xmm4
    addss xmm3, xmm4
    jmp draw_sprite

mask_surface:
    # Sixth builtin argument: [surface, x, y, xscale, yscale, ...].
    mov r10, [rsp + 0x30]
    mov r11, [r10 + 0x18]
    movsd xmm4, [r11]
    mulsd xmm4, [rip + mask_padding]
    mov r11, [r10 + 8]
    movsd xmm5, [r11]
    subsd xmm5, xmm4
    movsd [r11], xmm5
    jmp builtin_dispatch

# Fullscreen pause captures and low-health effects span the wider UI margins.
fullscreen_sprite:
    movsd xmm4, [rip + aspect]
    comisd xmm4, [rip + zero]
    jbe fullscreen_sprite_done
    movss xmm4, [rip + gui_offset_x]
    divss xmm4, [rip + gui_scale_x]
    subss xmm3, xmm4
    movsd xmm4, [rip + logical_width]
    divsd xmm4, [rip + normal_width]
    cvtsd2ss xmm4, xmm4
    mulss xmm4, [rsp + 0x30]
    movss [rsp + 0x30], xmm4
fullscreen_sprite_done:
    jmp draw_sprite

# Rooms without a gameplay camera (title/loading) use a fixed 2560x1440
# projection. Widen it symmetrically so their artwork and text stay proportional.
.global room_projection
room_projection:
    movsd xmm4, [rip + aspect]
    comisd xmm4, [rip + zero]
    jbe room_projection_done
    cvtss2sd xmm5, xmm3
    mulsd xmm5, xmm4
    cvtsd2ss xmm5, xmm5
    subss xmm2, xmm5
    mulss xmm2, [rip + half_float]
    addss xmm0, xmm2
    movaps xmm2, xmm5
room_projection_done:
    jmp set_projection

.section .data
.balign 16
mask_padding: .double 0
mask_normal_width: .double 640
four: .double 4
half: .double 0.5
.balign 16
aspect: .double 0
zero: .double 0
one: .double 1
normal_aspect: .double 1.7777777777777778
logical_width: .double 2560
normal_width: .double 2560
height: .double 1440
ui_width_float: .float 2560
half_float: .float 0.5
.balign 16
rv3440: .double 3440
    .long 0, 0
