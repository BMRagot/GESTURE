
#include <winsock2.h>
typedef int socklen_t;
#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#define PORT 2000


  
  
int main(void)
{
    WSADATA WSAData;
    int erreur = WSAStartup(MAKEWORD(2,2), &WSAData);
   
     
    /* Socket et contexte d'adressage du serveur */
    SOCKADDR_IN sin;
    SOCKET sock;
    socklen_t recsize = sizeof(sin);
     
    /* Socket et contexte d'adressage du client */
    SOCKADDR_IN csin;
    SOCKET csock;
    socklen_t crecsize = sizeof(csin);
     
    int sock_err;
    char buffer[32] = "Bonjour !";
     
    if(!erreur)
    {
        /* Création d'une socket */
        sock = socket(AF_INET, SOCK_STREAM, 0);
         
        /* Si la socket est valide */
        if(sock != INVALID_SOCKET)
        {
            printf("La socket %d est maintenant ouverte en mode TCP/IP\n", sock);
             
            /* Configuration */
            sin.sin_addr.s_addr = htonl(INADDR_ANY);  /* Adresse IP automatique */
            sin.sin_family = AF_INET;                 /* Protocole familial (IP) */
            sin.sin_port = htons(PORT);               /* Listage du port */
            sock_err = bind(sock, (SOCKADDR*)&sin, recsize);
             
            /* Si la socket fonctionne */
            if(sock_err != SOCKET_ERROR)
            {
                /* Démarrage du listage (mode server) */
                sock_err = listen(sock, 5);
                printf("Listage du port %d...\n", PORT);
                 
                /* Si la socket fonctionne */
                if(sock_err != SOCKET_ERROR)
                {
                    /* Attente pendant laquelle le client se connecte */
                    printf("Patientez pendant que le client se connecte sur le port %d...\n", PORT);
                    csock = accept(sock, (SOCKADDR*)&csin, &crecsize);
                    printf("Un client se connecte avec la socket %d de %s:%d\n", csock, inet_ntoa(csin.sin_addr), htons(csin.sin_port));
					
					sock_err = send(csock, buffer, 32, 0);
  
                    if(sock_err != SOCKET_ERROR)
                        printf("Chaine envoyée : %s\n", buffer);
                    else
                        printf("Erreur de transmission\n");
  
                    /* Il ne faut pas oublier de fermer la connexion (fermée dans les deux sens) */
                    shutdown(csock, 2);
				}
                else
                    perror("listen");
            }
            else
                perror("bind");
             
            /* Fermeture de la socket client et de la socket serveur */
            printf("Fermeture de la socket client\n");
            closesocket(csock);
            printf("Fermeture de la socket serveur\n");
            closesocket(sock);
            printf("Fermeture du serveur terminée\n");
			std::cout << "Fermeture du serveur terminée\n" << std::endl;
        }
        else
           perror("socket");

           WSACleanup();
  
    }
     
    return EXIT_SUCCESS;
}