// testopenni.cpp : définit le point d'entrée pour l'application console.
//

#include "stdafx.h"
#include  <OpenNI.h>

int main(int argc, char** argv)
{

	openni::Status rc = openni::STATUS_OK;

	openni::Device device;
	openni::VideoStream depth, color;
	const char* deviceURI = openni::ANY_DEVICE;
	if (argc > 1)
	{
		deviceURI = argv[1];
	}

	rc = openni::OpenNI::initialize();

	printf("After initialization:\n%s\n", openni::OpenNI::getExtendedError());
	return 0;
}

