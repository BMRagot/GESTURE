#include "GESTURE_Server.h"
#define PORT 2000

//GESTURE_Server::GESTURE_Server()
//{

//}

int GESTURE_Server::initServer()
{
	// Initialize Winsock
	iResult = WSAStartup(MAKEWORD(2,2), &WSAData);
	if (iResult != 0) {
		printf("WSAStartup failed with error: %d\n", iResult);
		return 1;
	}

	printf(":: create socket server...\n");

	ListenSock = socket(AF_INET, SOCK_STREAM, 0);
         
    /* Si la socket est valide */
    if(ListenSock != INVALID_SOCKET)
    {
		printf("La socket %d est maintenant ouverte en mode TCP/IP\n", ListenSock);
             
        /* Configuration */
		recsize = sizeof(sin);
        sin.sin_addr.s_addr = htonl(INADDR_ANY);  /* Adresse IP automatique */
        sin.sin_family = AF_INET;                 /* Protocole familial (IP) */
        sin.sin_port = htons(PORT);               /* Listage du port */
        sock_err = bind(ListenSock, (SOCKADDR*)&sin, recsize);
             
        /* Si la socket fonctionne */
        if(sock_err != SOCKET_ERROR)
        {
            /* Démarrage du listage (mode server) */
            sock_err = listen(ListenSock, 5);
                
            /* Si la socket fonctionne */
            if(sock_err == SOCKET_ERROR)
            {
				printf("listen failed with error: %d\n", WSAGetLastError());
				closesocket(ListenSock);
				WSACleanup();
				return 1;
			}
            else
                perror("listen");
        }
        else
            perror("bind");
	}
	
	printf(": socket server created...\n\n");
	
	return 0;
	
}

bool GESTURE_Server::waitForConnection()
{
	printf (":: wait for connection...\n");

	socklen_t crecsize = sizeof(csin);
	ClientSock = accept(ListenSock,(SOCKADDR*)&csin, &crecsize);
	if (ClientSock == INVALID_SOCKET) {
		printf("accept failed with error: %d\n", WSAGetLastError());
		closesocket(ClientSock);
		WSACleanup();
		return false;
	}
	printf(": client connected...\n\n");

	return true;
}

void GESTURE_Server::closeConnection(){
	// shutdown the connection since we're done
	iResult = shutdown(ClientSock, SD_SEND);
	if (iResult == SOCKET_ERROR) {
		printf("shutdown failed with error: %d\n", WSAGetLastError());
		closesocket(ClientSock);
		WSACleanup();
	//	return 1;
	}

	// cleanup
	closesocket(ClientSock);
	WSACleanup();
}

bool GESTURE_Server::sendData( const char* mixedData, int dataSize){
	iSendResult = send( ClientSock,(const char*) mixedData, dataSize, 0 );
	if (iSendResult == SOCKET_ERROR) {
		printf("send failed with error: %d\n", WSAGetLastError());
		closesocket(ClientSock);
		WSACleanup();
		return false;
	}
	return true;
}