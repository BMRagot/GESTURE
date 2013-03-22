
//#include <sstream>

#include <winsock2.h>

typedef int socklen_t;

#include <stdio.h>
#include <stdlib.h>

class GESTURE_Server
{
public:	
	//GESTURE_Server();
	int initServer();
	bool waitForConnection();
	void closeConnection();
	bool sendData(const char* mixedData, int dataSize);

	SOCKET GetListenSocket(){return ListenSock;};
	SOCKET GetClientSocket(){return ClientSock;};

	WSADATA WSAData;
	SOCKADDR_IN sin;
    SOCKET ListenSock;
    socklen_t recsize;

	SOCKADDR_IN csin;
	SOCKET ClientSock;
    socklen_t crecsize;
	

	int iResult;
	int iSendResult;
	int sock_err;
};
