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

#ifndef OTTER_BRANDING_H
#define OTTER_BRANDING_H

#include <QtCore/QString>

namespace Otter
{

/**
 * Branding class provides centralized access to brand-specific values.
 * This class wraps the generated BrandConfig.h values in a clean API.
 */
class Branding
{
public:
    /**
     * Returns the application display name
     */
    static QString displayName();

    /**
     * Returns the organization name
     */
    static QString organizationName();

    /**
     * Returns the application ID
     */
    static QString applicationId();

    /**
     * Returns the executable name
     */
    static QString executableName();

    /**
     * Returns the profile directory name
     */
    static QString profileDirectory();

    /**
     * Returns the icon name
     */
    static QString iconName();

    /**
     * Returns the about dialog name
     */
    static QString aboutName();

    /**
     * Returns the application name
     */
    static QString applicationName();

    /**
     * Returns the profile directory name
     */
    static QString profileDirectoryName();

    /**
     * Returns the full version string
     */
    static QString versionString();

    /**
     * Returns the website URL
     */
    static QString websiteUrl();

    /**
     * Returns the support URL
     */
    static QString supportUrl();

    /**
     * Returns the desktop file base name
     */
    static QString desktopFileBaseName();

    /**
     * Returns the desktop file name
     */
    static QString desktopFileName();

    /**
     * Returns the startup WM class
     */
    static QString startupWmClass();

    /**
     * Returns the desktop icon name
     */
    static QString desktopIconName();

    /**
     * Returns the full display name
     */
    static QString displayFullName();

    /**
     * Returns the package name
     */
    static QString packageName();

    /**
     * Returns the install data directory
     */
    static QString installDataDir();

    /**
     * Returns the translation basename
     */
    static QString translationBaseName();

    /**
     * Returns the appstream file name
     */
    static QString appstreamFileName();

    /**
     * Returns the manpage file name
     */
    static QString manpageFileName();

    /**
     * Returns the update URL
     */
    static QString updateUrl();
};

}

#endif // OTTER_BRANDING_H
