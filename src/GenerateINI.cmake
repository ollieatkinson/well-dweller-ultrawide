# Assemble readable source into the byte values consumed by unmodified SUWSF.
function(extract_section section output)
    execute_process(COMMAND "${OBJCOPY}" -O binary -j "${section}"
        "${BINARY_DIR}/hooks.elf" "${BINARY_DIR}/${output}.bin"
        COMMAND_ERROR_IS_FATAL ANY)
endfunction()

function(read_bytes path offset limit output)
    file(READ "${path}" bytes OFFSET ${offset} LIMIT ${limit} HEX)
    string(REGEX REPLACE "(..)" "\\1 " bytes "${bytes}")
    string(STRIP "${bytes}" bytes)
    string(TOUPPER "${bytes}" bytes)
    set(${output} "${bytes}" PARENT_SCOPE)
endfunction()

extract_section(.text Hooks)
extract_section(.data State)
read_bytes("${BINARY_DIR}/State.bin" 0 512 State0)
foreach(index RANGE 0 2)
    math(EXPR offset "${index} * 512")
    read_bytes("${BINARY_DIR}/Hooks.bin" ${offset} 512 Hooks${index})
endforeach()

# Each named output section corresponds to one game's call/instruction patch.
file(STRINGS "${SOURCE_DIR}/src/layout.ld" sections REGEX "^  \\.[A-Z][A-Za-z0-9]+ 0x")
foreach(section IN LISTS sections)
    string(REGEX MATCH "[A-Z][A-Za-z0-9]+" name "${section}")
    extract_section(.${name} ${name})
    read_bytes("${BINARY_DIR}/${name}.bin" 0 32 ${name})
endforeach()

file(READ "${SOURCE_DIR}/src/SUWSF.ini.in" template)
string(CONFIGURE "${template}" configuration @ONLY)
file(WRITE "${BINARY_DIR}/SUWSF.ini" "${configuration}")
