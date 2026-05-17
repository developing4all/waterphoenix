# ApplyBranding.cmake - Central branding system
# This module applies branding configuration to the build system

# Define cache variable for brand selection (generic)
set(APP_BRAND "waterphoenix" CACHE STRING "Brand configuration to use")

# Backward compatibility: map WATERPHOENIX_BRAND to APP_BRAND if set
if(DEFINED WATERPHOENIX_BRAND AND NOT WATERPHOENIX_BRAND STREQUAL "")
    set(APP_BRAND "${WATERPHOENIX_BRAND}")
    message(STATUS "WATERPHOENIX_BRAND is deprecated, use APP_BRAND instead")
endif()

# Validate brand selection
set(BRAND_FILE "${CMAKE_SOURCE_DIR}/branding/${APP_BRAND}/brand.cmake")
if(NOT EXISTS "${BRAND_FILE}")
    message(FATAL_ERROR "Brand configuration file not found: ${BRAND_FILE}")
endif()

# Include brand configuration
include("${BRAND_FILE}")

# Create generated directory
set(GENERATED_DIR "${CMAKE_BINARY_DIR}/generated")
file(MAKE_DIRECTORY "${GENERATED_DIR}")

# Generate BrandConfig.h from template
set(BRAND_CONFIG_INPUT "${CMAKE_SOURCE_DIR}/src/core/BrandConfig.h.in")
set(BRAND_CONFIG_OUTPUT "${GENERATED_DIR}/BrandConfig.h")

if(NOT EXISTS "${BRAND_CONFIG_INPUT}")
    message(FATAL_ERROR "BrandConfig template not found: ${BRAND_CONFIG_INPUT}")
endif()

# Generate BrandConfig.h at configure time
configure_file(
    "${BRAND_CONFIG_INPUT}"
    "${BRAND_CONFIG_OUTPUT}"
    @ONLY
)

# Function to apply branding to a target
function(apply_branding target_name)
    # Add generated include directory
    target_include_directories("${target_name}" PRIVATE "${GENERATED_DIR}")
    
    # Add branding source files
    target_sources("${target_name}" PRIVATE
        "${CMAKE_SOURCE_DIR}/src/core/Branding.cpp"
        "${CMAKE_SOURCE_DIR}/src/core/Branding.h"
    )
    
    # Add generated BrandConfig.h as a dependency
    set_source_files_properties("${BRAND_CONFIG_OUTPUT}" PROPERTIES 
        GENERATED TRUE
        HEADER_FILE_ONLY TRUE
    )
endfunction()

# Helper function to generate files with branding variables
function(generate_branding_file input output)
    configure_file("${input}" "${output}" @ONLY)
endfunction()

# Helper function to select brand file with fallback
function(select_brand_file output_variable brand_relative_path fallback_path)
    set(brand_file "${CMAKE_SOURCE_DIR}/branding/${APP_BRAND}/${brand_relative_path}")
    set(fallback_file "${CMAKE_SOURCE_DIR}/${fallback_path}")
    
    if(EXISTS "${brand_file}")
        set(${output_variable} "${brand_file}" PARENT_SCOPE)
    elseif(EXISTS "${fallback_file}")
        set(${output_variable} "${fallback_file}" PARENT_SCOPE)
    else()
        message(FATAL_ERROR "Neither brand file '${brand_file}' nor fallback file '${fallback_path}' exists")
    endif()
endfunction()

# Helper function to install branded icon
function(install_branded_icon size fallback_basename)
    select_brand_file(icon_file "icons/${BRAND_DESKTOP_ICON_NAME}-${size}.png" "resources/icons/${fallback_basename}-${size}.png")
    
    install(FILES "${icon_file}" 
            DESTINATION "${CMAKE_INSTALL_DATAROOTDIR}/icons/hicolor/${size}x${size}/apps"
            RENAME "${BRAND_DESKTOP_ICON_NAME}.png")
endfunction()

# Helper function to install branded SVG
function(install_branded_svg fallback_basename)
    select_brand_file(svg_file "icons/${BRAND_DESKTOP_ICON_NAME}.svg" "resources/icons/${fallback_basename}.svg")
    
    install(FILES "${svg_file}" 
            DESTINATION "${CMAKE_INSTALL_DATAROOTDIR}/icons/hicolor/scalable/apps"
            RENAME "${BRAND_DESKTOP_ICON_NAME}.svg")
endfunction()

# Helper function to install branded appdata/metainfo
function(install_branded_appdata)
    # Try .appdata.xml first, then .metainfo.xml
    select_brand_file(appdata_file "appstream/${BRAND_EXECUTABLE_NAME}.appdata.xml" "packaging/otter-browser.appdata.xml")
    if(NOT EXISTS "${appdata_file}")
        select_brand_file(appdata_file "appstream/${BRAND_EXECUTABLE_NAME}.metainfo.xml" "packaging/otter-browser.metainfo.xml")
    endif()
    
    install(FILES "${appdata_file}" 
            DESTINATION "${CMAKE_INSTALL_DATAROOTDIR}/metainfo"
            RENAME "${BRAND_EXECUTABLE_NAME}.appdata.xml")
endfunction()

# Helper function to install branded man page
function(install_branded_man_page)
    select_brand_file(man_file "man/${BRAND_EXECUTABLE_NAME}.1" "man/otter-browser.1")
    
    install(FILES "${man_file}" 
            DESTINATION "${CMAKE_INSTALL_MANDIR}/man1"
            RENAME "${BRAND_EXECUTABLE_NAME}.1")
endfunction()

# Generate desktop file with dynamic template selection
set(DESKTOP_INPUT_BASENAME "${CMAKE_SOURCE_DIR}/branding/${APP_BRAND}/desktop/${BRAND_DESKTOP_FILE_BASENAME}.desktop.in")
set(DESKTOP_INPUT_FILENAME "${CMAKE_SOURCE_DIR}/branding/${APP_BRAND}/desktop/${BRAND_DESKTOP_FILE_NAME}.in")
set(DESKTOP_INPUT_BRANDNAME "${CMAKE_SOURCE_DIR}/branding/${APP_BRAND}/desktop/${APP_BRAND}.desktop.in")
set(DESKTOP_OUTPUT "${GENERATED_DIR}/${BRAND_DESKTOP_FILE_NAME}")

# Try different desktop template names
if(EXISTS "${DESKTOP_INPUT_BASENAME}")
    generate_branding_file("${DESKTOP_INPUT_BASENAME}" "${DESKTOP_OUTPUT}")
elseif(EXISTS "${DESKTOP_INPUT_FILENAME}")
    generate_branding_file("${DESKTOP_INPUT_FILENAME}" "${DESKTOP_OUTPUT}")
elseif(EXISTS "${DESKTOP_INPUT_BRANDNAME}")
    generate_branding_file("${DESKTOP_INPUT_BRANDNAME}" "${DESKTOP_OUTPUT}")
else()
    # Fallback to upstream desktop file with warning
    set(UPSTREAM_DESKTOP "${CMAKE_SOURCE_DIR}/packaging/otter-browser.desktop")
    if(EXISTS "${UPSTREAM_DESKTOP}")
        message(WARNING "No desktop template found for brand '${APP_BRAND}', falling back to upstream desktop file")
        generate_branding_file("${UPSTREAM_DESKTOP}" "${DESKTOP_OUTPUT}")
    else()
        message(FATAL_ERROR "No desktop template found for brand '${APP_BRAND}' and no upstream fallback")
    endif()
endif()

# Install desktop file
install(FILES "${DESKTOP_OUTPUT}" 
        DESTINATION "${CMAKE_INSTALL_DATAROOTDIR}/applications"
        RENAME "${BRAND_DESKTOP_FILE_NAME}")

# Function to generate branded Qt resources
function(generate_branded_resources)
    set(BRAND_RESOURCES_OUTPUT "${GENERATED_DIR}/BrandResources.qrc")
    
    # Create the qrc file content
    set(QRC_CONTENT "<!DOCTYPE RCC>\n<RCC version=\"1.0\">\n<qresource prefix=\"/branding\">\n")
    
    # Icon sizes to process
    set(ICON_SIZES "16;32;48;64;128;256")
    
    foreach(size ${ICON_SIZES})
        # Try brand-specific icon first, then fallback
        set(BRAND_ICON "${CMAKE_SOURCE_DIR}/branding/${APP_BRAND}/icons/${BRAND_DESKTOP_ICON_NAME}-${size}.png")
        set(FALLBACK_ICON "${CMAKE_SOURCE_DIR}/resources/icons/otter-browser-${size}.png")
        
        if(EXISTS "${BRAND_ICON}")
            set(ICON_FILE "${BRAND_ICON}")
        elseif(EXISTS "${FALLBACK_ICON}")
            set(ICON_FILE "${FALLBACK_ICON}")
        else()
            continue()  # Skip if neither exists
        endif()
        
        string(APPEND QRC_CONTENT "    <file alias=\"app-icon-${size}.png\">${ICON_FILE}</file>\n")
    endforeach()
    
    # Add SVG icon
    set(BRAND_SVG "${CMAKE_SOURCE_DIR}/branding/${APP_BRAND}/icons/${BRAND_DESKTOP_ICON_NAME}.svg")
    set(FALLBACK_SVG "${CMAKE_SOURCE_DIR}/resources/icons/otter-browser.svg")
    
    if(EXISTS "${BRAND_SVG}")
        set(SVG_FILE "${BRAND_SVG}")
    elseif(EXISTS "${FALLBACK_SVG}")
        set(SVG_FILE "${FALLBACK_SVG}")
    else()
        set(SVG_FILE "")
    endif()
    
    if(SVG_FILE)
        string(APPEND QRC_CONTENT "    <file alias=\"app-icon.svg\">${SVG_FILE}</file>\n")
        string(APPEND QRC_CONTENT "    <file alias=\"app-icon.png\">${SVG_FILE}</file>\n")
    endif()
    
    # Add file type icons
    set(BRAND_FILE_ICON_PNG "${CMAKE_SOURCE_DIR}/branding/${APP_BRAND}/icons/${BRAND_DESKTOP_ICON_NAME}-file-type-256.png")
    set(FALLBACK_FILE_ICON_PNG "${CMAKE_SOURCE_DIR}/resources/icons/otter-browser-file-type-256.png")
    
    if(EXISTS "${BRAND_FILE_ICON_PNG}")
        set(FILE_ICON_PNG "${BRAND_FILE_ICON_PNG}")
    elseif(EXISTS "${FALLBACK_FILE_ICON_PNG}")
        set(FILE_ICON_PNG "${FALLBACK_FILE_ICON_PNG}")
    else()
        set(FILE_ICON_PNG "")
    endif()
    
    if(FILE_ICON_PNG)
        string(APPEND QRC_CONTENT "    <file alias=\"file-type-icon.png\">${FILE_ICON_PNG}</file>\n")
    endif()
    
    # Add ICO file for Windows
    set(BRAND_ICO "${CMAKE_SOURCE_DIR}/branding/${APP_BRAND}/icons/${BRAND_DESKTOP_ICON_NAME}.ico")
    set(FALLBACK_ICO "${CMAKE_SOURCE_DIR}/resources/icons/otter-browser.ico")
    
    if(EXISTS "${BRAND_ICO}")
        set(ICO_FILE "${BRAND_ICO}")
    elseif(EXISTS "${FALLBACK_ICO}")
        set(ICO_FILE "${FALLBACK_ICO}")
    else()
        set(ICO_FILE "")
    endif()
    
    if(ICO_FILE)
        string(APPEND QRC_CONTENT "    <file alias=\"app-icon.ico\">${ICO_FILE}</file>\n")
    endif()
    
    # Add file type ICO for Windows
    set(BRAND_FILE_ICO "${CMAKE_SOURCE_DIR}/branding/${APP_BRAND}/icons/${BRAND_DESKTOP_ICON_NAME}-file-type.ico")
    set(FALLBACK_FILE_ICO "${CMAKE_SOURCE_DIR}/resources/icons/otter-browser-file-type.ico")
    
    if(EXISTS "${BRAND_FILE_ICO}")
        set(FILE_ICO "${BRAND_FILE_ICO}")
    elseif(EXISTS "${FALLBACK_FILE_ICO}")
        set(FILE_ICO "${FALLBACK_FILE_ICO}")
    else()
        set(FILE_ICO "")
    endif()
    
    if(FILE_ICO)
        string(APPEND QRC_CONTENT "    <file alias=\"file-type-icon.ico\">${FILE_ICO}</file>\n")
    endif()
    
    string(APPEND QRC_CONTENT "</qresource>\n</RCC>\n")
    
    # Write the qrc file
    file(WRITE "${BRAND_RESOURCES_OUTPUT}" "${QRC_CONTENT}")
    
    # Set the output variable for parent scope
    set(BRAND_RESOURCES_FILE "${BRAND_RESOURCES_OUTPUT}" PARENT_SCOPE)
endfunction()

# Generate branded Windows resource file
function(generate_branded_windows_rc output_variable)
    # Set up template path
    set(RC_TEMPLATE "${CMAKE_SOURCE_DIR}/branding/${APP_BRAND}/windows/application.rc.in")
    
    # Fallback to otter brand template if brand template doesn't exist
    if(NOT EXISTS "${RC_TEMPLATE}")
        set(RC_TEMPLATE "${CMAKE_SOURCE_DIR}/branding/otter/windows/application.rc.in")
    endif()
    
    # Set up output path
    set(RC_OUTPUT "${CMAKE_BINARY_DIR}/generated/${BRAND_EXECUTABLE_NAME}.rc")
    
    # Configure the .rc file with brand variables
    configure_file(
        "${RC_TEMPLATE}"
        "${RC_OUTPUT}"
        @ONLY
    )
    
    # Set the output variable for parent scope
    set(${output_variable} "${RC_OUTPUT}" PARENT_SCOPE)
endfunction()

# Generate brand metadata JSON file
function(generate_brand_metadata output_variable)
    # Set up output path
    set(JSON_OUTPUT "${CMAKE_BINARY_DIR}/generated/brand.json")
    
    # Create JSON content
    set(JSON_CONTENT "{\n")
    string(APPEND JSON_CONTENT "  \"executable_name\": \"${BRAND_EXECUTABLE_NAME}\",\n")
    string(APPEND JSON_CONTENT "  \"package_name\": \"${BRAND_PACKAGE_NAME}\",\n")
    string(APPEND JSON_CONTENT "  \"desktop_file_name\": \"${BRAND_DESKTOP_FILE_NAME}\",\n")
    string(APPEND JSON_CONTENT "  \"desktop_file_basename\": \"${BRAND_DESKTOP_FILE_BASENAME}\",\n")
    string(APPEND JSON_CONTENT "  \"desktop_icon_name\": \"${BRAND_DESKTOP_ICON_NAME}\",\n")
    string(APPEND JSON_CONTENT "  \"install_data_dir\": \"${BRAND_INSTALL_DATA_DIR}\",\n")
    string(APPEND JSON_CONTENT "  \"appstream_file_name\": \"${BRAND_APPSTREAM_FILE_NAME}\",\n")
    string(APPEND JSON_CONTENT "  \"manpage_file_name\": \"${BRAND_MANPAGE_FILE_NAME}\",\n")
    string(APPEND JSON_CONTENT "  \"display_full_name\": \"${BRAND_DISPLAY_FULL_NAME}\"\n")
    string(APPEND JSON_CONTENT "}\n")
    
    # Write the JSON file
    file(WRITE "${JSON_OUTPUT}" "${JSON_CONTENT}")
    
    # Set the output variable for parent scope
    set(${output_variable} "${JSON_OUTPUT}" PARENT_SCOPE)
endfunction()

# Generate branded appstream file
function(generate_branded_appstream output_variable)
    # Set up template path
    set(APPSTREAM_TEMPLATE "${CMAKE_SOURCE_DIR}/branding/${APP_BRAND}/appstream/${BRAND_APPSTREAM_BASENAME}.xml.in")
    
    # Fallback to otter brand template if brand template doesn't exist
    if(NOT EXISTS "${APPSTREAM_TEMPLATE}")
        set(APPSTREAM_TEMPLATE "${CMAKE_SOURCE_DIR}/branding/otter/appstream/otter-browser.appdata.xml.in")
    endif()
    
    # Set up output path
    set(APPSTREAM_OUTPUT "${CMAKE_BINARY_DIR}/generated/${BRAND_APPSTREAM_FILE_NAME}")
    
    # Configure the appstream file with brand variables
    configure_file(
        "${APPSTREAM_TEMPLATE}"
        "${APPSTREAM_OUTPUT}"
        @ONLY
    )
    
    # Set the output variable for parent scope
    set(${output_variable} "${APPSTREAM_OUTPUT}" PARENT_SCOPE)
endfunction()

# Generate brand metadata
generate_brand_metadata(BRAND_METADATA_FILE)

# Generate branded appstream file
generate_branded_appstream(BRAND_APPSTREAM_FILE)

# Generate branded Windows .rc file if on Windows
if(WIN32)
    generate_branded_windows_rc(BRAND_WINDOWS_RC_FILE)
endif()

# Generate branded resources
generate_branded_resources()

# Print branding information
message(STATUS "Applying brand: ${APP_BRAND}")
message(STATUS "  Display Name: ${BRAND_DISPLAY_NAME}")
message(STATUS "  Application ID: ${BRAND_APPLICATION_ID}")
message(STATUS "  Executable: ${BRAND_EXECUTABLE_NAME}")
