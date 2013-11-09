#ifndef OTTER_APPLICATION_H
#define OTTER_APPLICATION_H

#include <QtCore/QPointer>
#include <QtWidgets/QApplication>
#include <QtNetwork/QLocalServer>

namespace Otter
{

class MainWindow;

class Application : public QApplication
{
	Q_OBJECT

public:
	explicit Application(int &argc, char **argv);
	~Application();

	MainWindow* newWindow();
	MainWindow* getWindow();
	bool isRunning() const;

protected:
	void cleanup();

protected slots:
	void newConnection();

private:
	QLocalServer *m_localServer;
	QList<QPointer<MainWindow> > m_windows;
};

}

#endif
