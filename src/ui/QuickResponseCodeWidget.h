/**************************************************************************
* Otter Browser: Web browser controlled by the user, not vice-versa.
* Copyright (C) 2022 Michal Dutkiewicz aka Emdek <michal@emdek.pl>
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

#ifndef OTTER_QUICKRESPONSECODEWIDGET_H
#define OTTER_QUICKRESPONSECODEWIDGET_H

#include "../../3rdparty/qrcodegen/qrcodegen.h"

#include <QtWidgets/QWidget>

namespace Otter
{

class QuickResponseCodeWidget final : public QWidget
{
	Q_OBJECT

public:
	explicit QuickResponseCodeWidget(QWidget *parent = nullptr);

	void render(QPainter *painter) const;
	QPixmap getPixmap() const;
	QSize minimumSizeHint() const override;
	QSize sizeHint() const override;
	int getSize() const;
	int heightForWidth(int width) const override;
	bool hasHeightForWidth() const override;

public slots:
	void setText(const QString &text);
	void setUrl(const QUrl &url);

protected:
	void paintEvent(QPaintEvent *event) override;
	int getSegmentSize() const;

private:
	QString m_text;
	qrcodegen::QrCode m_code;
};

}

#endif
