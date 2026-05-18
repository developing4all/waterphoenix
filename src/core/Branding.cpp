/**************************************************************************
* Otter Browser: Web browser controlled by the user, not vice-versa.
* Copyright (C) 2013 - 2025 Michal Dutkiewicz aka Emdek <michal@emdek.pl>
* Copyright (C) 2014 - 2015 Piotr Wójcik <chocimier@tlen.pl>
* Copyright (C) 2015 Jan Bajer aka bajasoft <jbajer@gmail.com>
* Copyright (C) 2026 Haydar Alkaduhimi <haydar@developing4all.com>
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program. If not, see <http://www.gnu.org/licenses/>.
*
**************************************************************************/

#include "Branding.h"
#include "BrandConfig.h"

namespace Otter
{

QString Branding::applicationName()
{
    return QLatin1String(BRAND_DISPLAY_NAME);
}

QString Branding::organizationName()
{
    return QLatin1String(BRAND_ORGANIZATION_NAME);
}

QString Branding::applicationId()
{
    return QLatin1String(BRAND_APPLICATION_ID);
}

QString Branding::executableName()
{
    return QLatin1String(BRAND_EXECUTABLE_NAME);
}

QString Branding::profileDirectoryName()
{
    return QLatin1String(BRAND_PROFILE_DIR_NAME);
}

QString Branding::cacheDirectoryName()
{
    return QLatin1String(BRAND_CACHE_DIR_NAME);
}

QString Branding::iconName()
{
    return QLatin1String(BRAND_ICON_NAME);
}

QString Branding::aboutName()
{
    return QLatin1String(BRAND_ABOUT_NAME);
}

QString Branding::versionString()
{
    QString version = QLatin1String(BRAND_VERSION_MAJOR) + QLatin1Char('.') 
                    + QLatin1String(BRAND_VERSION_MINOR) + QLatin1Char('.') 
                    + QLatin1String(BRAND_VERSION_PATCH);
    
    const QLatin1String suffix(BRAND_VERSION_SUFFIX);
    if (!suffix.isEmpty())
    {
        version += suffix;
    }
    
    return version;
}

QString Branding::websiteUrl()
{
    return QLatin1String(BRAND_WEBSITE_URL);
}

QString Branding::supportUrl()
{
    return QLatin1String(BRAND_SUPPORT_URL);
}

QString Branding::desktopFileBaseName()
{
    return QLatin1String(BRAND_DESKTOP_FILE_BASENAME);
}

QString Branding::desktopFileName()
{
    return QLatin1String(BRAND_DESKTOP_FILE_NAME);
}

QString Branding::startupWmClass()
{
    return QLatin1String(BRAND_STARTUP_WM_CLASS);
}

QString Branding::desktopIconName()
{
    return QLatin1String(BRAND_DESKTOP_ICON_NAME);
}

QString Branding::displayFullName()
{
    return QLatin1String(BRAND_DISPLAY_FULL_NAME);
}

QString Branding::packageName()
{
    return QLatin1String(BRAND_PACKAGE_NAME);
}

QString Branding::installDataDir()
{
    return QLatin1String(BRAND_INSTALL_DATA_DIR);
}

QString Branding::translationBaseName()
{
    return QLatin1String(BRAND_TRANSLATION_BASENAME);
}

QString Branding::appstreamFileName()
{
    return QLatin1String(BRAND_APPSTREAM_FILE_NAME);
}

QString Branding::manpageFileName()
{
    return QLatin1String(BRAND_MANPAGE_FILE_NAME);
}

QString Branding::updateUrl()
{
    return QLatin1String(BRAND_UPDATE_URL);
}

}
