#include "Nil.h"
#include <iostream>
#include <string>
#define _SECURE_SCL 0 //-D_SCL_SECURE_NO_WARNINGS

using namespace SigmaNIL; //Use SigmaNIL namespace to access library objects without the :: operator.


int main(int argc, char *argv[])
{

	SigmaNIL::NIL nil;

	 nil.Init(OpenNI2);//

	
	std::cout << nil.GetLastErrorString();
	return 0;
}