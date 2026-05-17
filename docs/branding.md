# Water Phoenix Branding System

This document describes the central branding system for Water Phoenix, which allows brand-specific values to be managed in one place while keeping the application source code clean and maintainable.

## Overview

The branding system separates branding concerns from the core application code:

- **Brand values** live in `branding/waterphoenix/brand.cmake`
- **Generated configuration** is created in the build directory
- **Application code** uses the stable `Branding` API
- **Upstream Otter references** are preserved where appropriate

## Brand Configuration

### Brand Values

All brand-specific values are defined in `branding/waterphoenix/brand.cmake`:

```cmake
# Brand identification
set(BRAND_ID "waterphoenix")

# User-visible names
set(BRAND_DISPLAY_NAME "Water Phoenix")
set(BRAND_ABOUT_NAME "Water Phoenix")

# Organization and developer
set(BRAND_ORGANIZATION_NAME "Developing 4 All")

# Application identifiers
set(BRAND_APPLICATION_ID "com.developing4all.waterphoenix")
set(BRAND_EXECUTABLE_NAME "waterphoenix")

# File and directory names
set(BRAND_PROFILE_DIR_NAME "WaterPhoenix")
set(BRAND_DESKTOP_FILE_NAME "waterphoenix.desktop")
set(BRAND_ICON_NAME "waterphoenix")
```

### Selecting Brand

To select a brand during configuration:

```bash
cmake -DAPP_BRAND=waterphoenix ..
```

The default brand is `waterphoenix`. Use `APP_BRAND=otter` for upstream Otter branding.

## Translation System

### Translation Files

Water Phoenix currently reuses the upstream Otter translation files:

- **Translation basename**: `BRAND_TRANSLATION_BASENAME "otter-browser"`
- **Translation files**: `resources/translations/otter-browser_*.ts` and `otter-browser_*.qm`
- **No file renaming**: Translation files keep their original names for compatibility

### Translation Loading

The application automatically uses the brand's translation basename when loading translations:

```cpp
const QString translationBaseName(Branding::translationBaseName());
m_applicationTranslator->load(
    translationBaseName + QLatin1Char('_') + locale,
    m_localePath
);
```

### Localized Product Strings

For user-facing strings that include the product name, use placeholder-based translations:

```cpp
// Good: Uses placeholder for product name
tr("About %1…").arg(Branding::displayFullName())
tr("New version of %1 is ready to install.").arg(Branding::displayFullName())
tr("You are viewing safe page from %1.").arg(Branding::displayFullName())

// Good: Direct branding API for tooltips
setToolTip(Branding::displayFullName())

// Avoid: Hardcoded product names in translations
tr("About Water Phoenix…")  // Don't do this
```

### Translation File Renaming (Future)

When Water Phoenix establishes its own translation workflow:

1. Set `BRAND_TRANSLATION_BASENAME "waterphoenix-browser"` in brand.cmake
2. Rename translation files to `waterphoenix-browser_*.ts` and `waterphoenix-browser_*.qm`
3. Update all translation sources with new product names
4. Regenerate `.qm` files from `.ts` files

The branding system will automatically handle the new translation basename without code changes.

## Generated Files

The build system generates these files in `${CMAKE_BINARY_DIR}/generated`:

- `BrandConfig.hpp` - C++ header with preprocessor defines
- `waterphoenix.desktop` - Generated desktop file

These files are **not committed** to version control.

## Branding API

### C++ API

The application uses the `Otter::Branding` class for brand values:

```cpp
#include "Branding.hpp"

// Get brand values
QString appName = Branding::applicationName();        // "Water Phoenix"
QString orgName = Branding::organizationName();       // "Developing 4 All"
QString appId = Branding::applicationId();            // "com.developing4all.waterphoenix"
QString execName = Branding::executableName();       // "waterphoenix"
QString profileDir = Branding::profileDirectoryName(); // "WaterPhoenix"
QString iconName = Branding::iconName();             // "waterphoenix"
QString aboutName = Branding::aboutName();           // "Water Phoenix"
QString version = Branding::versionString();         // "1.0.0"
QString website = Branding::websiteUrl();             // "https://developing4all.com"
QString support = Branding::supportUrl();             // "https://developing4all.com/support"
```

### CMake API

The `apply_branding()` function applies branding to a target:

```cmake
apply_branding(waterphoenix-browser)
```

This:
- Adds generated include directory
- Adds branding source files
- Sets up dependencies

## File Structure

```
branding/
  waterphoenix/
    brand.cmake                    # Brand values
    desktop/
      waterphoenix.desktop.in      # Desktop file template
    icons/                         # Brand-specific icons
cmake/
  ApplyBranding.cmake              # Branding system
  ConfigureFile.cmake              # File configuration helper
src/core/
  Branding.hpp                     # Branding API header
  Branding.cpp                     # Branding API implementation
  BrandConfig.hpp.in               # Generated header template
docs/
  branding.md                      # This documentation
```

## Desktop Files

Desktop files are generated from templates using brand variables:

```cmake
# Input: branding/waterphoenix/desktop/waterphoenix.desktop.in
# Output: build/generated/waterphoenix.desktop
# Install: share/applications/waterphoenix.desktop
```

## Wayland Desktop Identity

On Wayland, desktop identity comes from Qt's `desktopFileName`/app id rather than X11 WM class. The `StartupWMClass` field is mainly for X11 compatibility.

For proper Wayland integration, these values must stay consistent:
- `BRAND_DESKTOP_FILE_BASENAME` - Used for `setDesktopFileName()` (without .desktop extension)
- `BRAND_DESKTOP_FILE_NAME` - Full desktop filename for installation
- `BRAND_EXECUTABLE_NAME` - Executable name and `Exec=` field
- `BRAND_STARTUP_WM_CLASS` - Application name and X11 WM class
- `BRAND_DESKTOP_ICON_NAME` - Icon name and `Icon=` field

The FreeDesktopOrgPlatformIntegration also uses the branded desktop file name for:
- D-Bus notifications (`desktop-entry` property)
- Unity launcher integration (`application://` URLs)

## Icons

### Product Identity Icons

These icons represent the application identity:
- `waterphoenix-browser.png` (various sizes)
- `waterphoenix-browser.svg`
- `waterphoenix-browser.ico`

### Generic UI Icons

Generic browser UI icons remain in the normal resource system under `resources/icons/theme/`.

## Preserved Otter References

The following Otter references are intentionally preserved:

- **Copyright headers** - Legal attribution for original code
- **Technical namespaces** - `Otter::` namespace for internal code
- **Class names** - `OtterBrowser`, `OtterWidget`, etc.
- **Internal identifiers** - Settings keys, internal paths
- **Translation contexts** - `<name>Otter::ClassName</name>` in .ts files

## Migration Notes

### Profile/Config Paths

**TODO**: Profile directory migration needs consideration:
- Current: `~/.config/otter/`
- Target: `~/.config/WaterPhoenix/`

This change affects existing user data and requires migration logic.

### Settings Organization

**TODO**: QApplication organization name may need updating:
- Current: Not set
- Target: "Developing 4 All"

## Adding New Brands

To add a new brand:

1. Create `branding/newbrand/brand.cmake`
2. Add brand-specific assets in `branding/newbrand/`
3. Create desktop file template in `branding/newbrand/desktop/`
4. Configure with `-DWATERPHOENIX_BRAND=newbrand`

## Build Integration

The branding system is integrated into the main build:

1. Brand values are loaded from `branding/${WATERPHOENIX_BRAND}/brand.cmake`
2. `BrandConfig.hpp` is generated with preprocessor defines
3. Desktop files are generated from templates
4. Branding API is compiled into the application
5. Generated files are installed to appropriate locations

## Benefits

- **Centralized**: All brand values in one place
- **Maintainable**: Easy to update branding without code changes
- **Buildable**: Generated files, no manual editing
- **Clean**: Separation of branding and application logic
- **Flexible**: Support for multiple brands
- **Upstream-friendly**: Minimal changes to core Otter code
