#include "Nil.h"
#include "HandSegmentationEngine.h"
#include "HandShapeEngine.h"

#include <iostream>
#include <string>

using namespace SigmaNIL; //Use SigmaNIL namespace to access library objects without the :: operator.

class GESTURE_Recognition 
{
public:
	GESTURE_Recognition();

private:
	void DriverEventHandler(NIL_EVENT e);
	void HandShapeEventHandler(NIL_EVENT e);

	NIL nil;
	HandSegmentationEngine engineHandSegmentation;
	HandShapeEngine engineHandShape;

	HAND_TYPE userActiveHand;
	bool isHandShapeEventReceived;
	vec3 handPosition2D;

	char recognizedLetter;
	//changer pour move ou control
};