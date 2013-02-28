
    #include <winsock2.h>
    typedef int socklen_t;

  
#include <stdio.h>
#include <stdlib.h>
#define PORT 2000
  
  
  
int main(void)
{
  
        WSADATA WSAData;
        int erreur = WSAStartup(MAKEWORD(2,2), &WSAData);
    
  
    SOCKET sock;
    SOCKADDR_IN sin;
  
    if(!erreur)
    {
        /* Création de la socket */
        sock = socket(AF_INET, SOCK_STREAM, 0);
  
        /* Configuration de la connexion */
        sin.sin_addr.s_addr = inet_addr("127.0.0.1");
        sin.sin_family = AF_INET;
        sin.sin_port = htons(PORT);
  
        /* Si le client arrive à se connecter */
        if(connect(sock, (SOCKADDR*)&sin, sizeof(sin)) != SOCKET_ERROR)
            printf("Connexion à %s sur le port %d\n", inet_ntoa(sin.sin_addr), htons(sin.sin_port));
        else
            printf("Impossible de se connecter\n");
  
        /* On ferme la socket précédemment ouverte */
        closesocket(sock);
  
 
            WSACleanup();
 
    }
  
    return EXIT_SUCCESS;
}