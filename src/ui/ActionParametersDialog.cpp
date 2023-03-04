/**************************************************************************
* Otter Browser: Web browser controlled by the user, not vice-versa.
* Copyright (C) 2021 Michal Dutkiewicz aka Emdek <michal@emdek.pl>
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

#include "ActionParametersDialog.h"
#include "../core/ActionsManager.h"

#include <QtWidgets/QMenu>

#include "ui_ActionParametersDialog.h"

namespace Otter
{

ActionParametersDialog::ActionParametersDialog(int action, const QVariantMap &parameters, QWidget *parent) : Dialog(parent),
	m_model(new QStandardItemModel(this)),
	m_ui(new Ui::ActionParametersDialog)
{
	const ActionsManager::ActionDefinition definition(ActionsManager::getActionDefinition(action));
	QVariantMap::const_iterator iterator;

	for (iterator = parameters.begin(); iterator != parameters.end(); ++iterator)
	{
		addItem(iterator.key(), iterator.value());
	}

	m_model->setHorizontalHeaderLabels({tr("Key"), tr("Type"), tr("Value")});

	m_ui->setupUi(this);
	m_ui->actionIconLabel->setPixmap(definition.getDefaultState().icon.pixmap(32, 32));
	m_ui->actionTextLabel->setText(definition.getText());
	m_ui->parametersViewWidget->setModel(m_model);
	m_ui->parametersViewWidget->setFilterRoles({Qt::DisplayRole});
	m_ui->parametersViewWidget->setViewMode(ItemViewWidget::TreeView);
	m_ui->parametersViewWidget->expandAll();

	QMenu *menu(new QMenu(m_ui->addButton));
	menu->addAction(tr("String"))->setData(QVariant::String);
	menu->addAction(tr("Map"))->setData(QVariant::Map);
	menu->addAction(tr("List"))->setData(QVariant::List);

	m_ui->addButton->setMenu(menu);

	connect(m_ui->filterLineEditWidget, &QLineEdit::textChanged, m_ui->parametersViewWidget, &ItemViewWidget::setFilterString);
	connect(m_ui->parametersViewWidget, &ItemViewWidget::needsActionsUpdate, this, [&]()
	{
		m_ui->removeButton->setEnabled(m_ui->parametersViewWidget->getCurrentIndex().isValid());
	});
	connect(m_ui->removeButton, &QPushButton::clicked, m_ui->parametersViewWidget, &ItemViewWidget::removeRow);
}

ActionParametersDialog::~ActionParametersDialog()
{
	delete m_ui;
}

void ActionParametersDialog::changeEvent(QEvent *event)
{
	QWidget::changeEvent(event);

	if (event->type() == QEvent::LanguageChange)
	{
		m_ui->retranslateUi(this);

		m_model->setHorizontalHeaderLabels({tr("Key"), tr("Type"), tr("Value")});
	}
}

QStandardItem* ActionParametersDialog::addItem(const QString &key, const QVariant &value, QStandardItem *parent)
{
	QList<QStandardItem*> items({new QStandardItem(key), new QStandardItem(), new QStandardItem()});
	items[1]->setFlags(Qt::ItemIsSelectable | Qt::ItemIsEnabled);

	switch (value.type())
	{
		case QVariant::List:
		case QVariant::StringList:
			{
				const QStringList list(value.toStringList());

				items[0]->setFlags(Qt::ItemIsSelectable | Qt::ItemIsEnabled | Qt::ItemNeverHasChildren);
				items[1]->setText(tr("List"));
				items[2]->setText(list.join(QLatin1String(", ")));
				items[2]->setData(list, Qt::UserRole);
				items[2]->setFlags(items[2]->flags() | Qt::ItemNeverHasChildren);
			}

			break;
		case QVariant::Map:
			{
				const QVariantMap map(value.toMap());
				QVariantMap::const_iterator iterator;

				for (iterator = map.begin(); iterator != map.end(); ++iterator)
				{
					addItem(iterator.key(), iterator.value(), items[0]);
				}

				items[0]->setFlags(Qt::ItemIsSelectable | Qt::ItemIsEnabled);
				items[1]->setText(tr("Map"));
				items[2]->setFlags(Qt::ItemIsSelectable | Qt::ItemIsEnabled);
			}

			break;
		default:
			items[0]->setFlags(Qt::ItemIsSelectable | Qt::ItemIsEnabled | Qt::ItemNeverHasChildren);
			items[1]->setText(tr("String"));
			items[2]->setText(value.toString());
			items[2]->setFlags(items[2]->flags() | Qt::ItemNeverHasChildren);

			break;
	}

	if (parent)
	{
		parent->appendRow(items);
	}
	else
	{
		m_model->appendRow(items);
	}

	return items[0];
}

QVariantMap ActionParametersDialog::getParameters() const
{
	QVariantMap parameters;

///TODO

	return parameters;
}

bool ActionParametersDialog::isModified() const
{
	return m_ui->parametersViewWidget->isModified();
}

}
