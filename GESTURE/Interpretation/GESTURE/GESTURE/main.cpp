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


char buffer[32] = "";

int main(int argc, char *argv[])
{
	std::cout<< "démarrage du programme" << "\n";
	
	std::cout<< "démarrage TCP Server" << "\n";
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
			 std::cout <<"Client connected"<< "\n";

			//if(recv(KSock.GetListenSocket(), buffer, 32, 0) != SOCKET_ERROR)
				//		printf("Recu : %s\n", buffer);

			int e=send(KSock.GetClientSocket(),"hello",32,0);
			std::cout <<e<< "\n";
		}
		
	//}

	//KSock.closeConnection();
	std::cout<< "démarrage GESTURE recognition" << "\n";
	QApplication a(argc, argv);
	GESTURE_Recognition w;
	w.SetSock(KSock);
	w.show();
	return a.exec();

}
