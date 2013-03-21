/*****************************************************************************
*														                   *
*  GESTURE 1.x Beta														     *
*                                                                            *
*  Copyright (c) 2013 GESTURE										         *
*  All rights reserved.                                                      *
*                                                                            *
*  This file is part of GESTURE.                                    *
*                                                                            *
*****************************************************************************/
//#include "GESTURE_Server.h"
#include "GESTURE_Recognition.h"

#include <QtGui/QApplication>
//#include <iostream>




int main(int argc, char *argv[])
{
	std::cout<< "démarrage du programme" << "\n";
	
	bool isClientConnected;
	GESTURE_Server KSock;
	KSock = GESTURE_Server();
	KSock.initServer();

		isClientConnected = KSock.waitForConnection();

		 if(isClientConnected) {
			// std::ostringstream oss;
			// oss<<label << "/"<< handPosition2D.x <<"/" << handPosition2D.y <<"/" << handPosition2D.z;
			// const unsigned char* gesture= (unsigned char*)(&oss.str());
			// long dataSize = sizeof(gesture);
			//isClientConnected = KSock.sendData(gesture,dataSize);
			//std::cout << dataSize << "\n";
			 std::cout <<"youpi"<< "\n";
		}
		
	//}

	//KSock.closeConnection();

	QApplication a(argc, argv);
	GESTURE_Recognition w;
	w.SetSock(KSock);
	w.show();
	return a.exec();

}
