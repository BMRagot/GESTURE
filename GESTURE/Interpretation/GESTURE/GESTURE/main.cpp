
#include <QtCore/QCoreApplication>
#include "GESTURE_Recognition.h"
#include <iostream>
#include <string>
#include <QtGui/QApplication>
int main(int argc, char *argv[])
{

	std::cout << "Demarrage du programme \n";
	QApplication a(argc, argv);
	GESTURE_Recognition w;
	w.show();
	return a.exec();

	//QCoreApplication a(argc, argv);

	//return a.exec();
}
