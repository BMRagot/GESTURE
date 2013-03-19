#include "GESTURE_Recognition.h"


GESTURE_Recognition::GESTURE_Recognition(QWidget *parent, Qt::WFlags flags)
{
	isHandShapeEventReceived=false;

	timer = new QTimer(this);
	connect( timer, SIGNAL(timeout()), this, SLOT(Run()) );
	timer->start(30);


	std::cout << "1"<< "\n";
	//Initialisation
	nil.Init(OpenNI2);//
	std::cout << "2"<< "\n";
	nil.ManualUpdate();

	std::cout << nil.GetLastErrorString() << "\n";
	
	nil.GetDriver()->SetUserFollowMode(SigmaNIL::NEAREST);
	std::cout << "Initialize HandSegmentation Engine" << "\n";
	// Initialize HandSegmentation Engine
	engineHandSegmentation.Init(&nil, SigmaNIL::RIGHT);
	engineHandSegmentation.Start();
	std::cout << "Initialize HandShape Engine" << "\n";
	// Initialize HandShape Engine
	std::string forestFileName("Data/ASL_T12_LH_SCR_98.9%_PPCR_86.8%.cforest");
	engineHandShape.Init( "Sigma", "A6E443852ED4FBB52D59D7B9146718D08E29F665", &nil, &engineHandSegmentation, forestFileName, SigmaNIL::RIGHT, 0.88, 0.25);
	engineHandShape.Start();
	std::cout << "HandShape Engine started" << "\n";
	// Bind event handlers
	nil.GetDriver()->AddEventListener( MEMBER_FUNC_PASS(GESTURE_Recognition::DriverEventHandler, *this) );
	std::cout << "getdriver" << "\n";
	engineHandShape.AddEventListener( MEMBER_FUNC_PASS(GESTURE_Recognition::HandShapeEventHandler, *this) );
	std::cout << "listenerevnt" << "\n";
	userActiveHand = UNDEFINED;
}


GESTURE_Recognition::~GESTURE_Recognition()
{
	delete timer;
}


void GESTURE_Recognition::Run()
{
	isHandShapeEventReceived=false;
	
	nil.ManualUpdate();
}


void GESTURE_Recognition::DriverEventHandler( NIL_EVENT e )
{
	boost::shared_ptr<Driver::DriverEvent> driverEvent = boost::static_pointer_cast<Driver::DriverEvent>(e);

	// Get RGB Image from the camera
	//const unsigned char* rgbImg = nil.GetDriver()->GetRGBImage();
	const unsigned char* rgbImg = nil.GetDriver()->GetDepthHistogram();

	// Copy to buffer
	//memcpy(rgbImage.bits(), rgbImg, 640*480*3*sizeof(unsigned char));

	if( driverEvent->activeUser != NULL )
		userActiveHand = driverEvent->activeUser->activeHand;
	
vec3 handPosition3D	= driverEvent->handPosition[RIGHT];
	handPosition2D = nil.GetDriver()->ConvertWorldToScreen(handPosition3D);
	handPosition2D.y = 480-handPosition2D.y;

	update();
}



void GESTURE_Recognition::HandShapeEventHandler( NIL_EVENT e )
{
	std::cout << "test";
	boost::shared_ptr<HandShapeEngine::HandShapeEvent> handShapeEvent = boost::static_pointer_cast<HandShapeEngine::HandShapeEvent>(e);

	char label = 64 + handShapeEvent->GetShapeLabel();
	if( label > 73 ) label++;
	recognizedLetter = label ;
	double a = handShapeEvent->GetEntropy();
	std::cout << "55";
	std::cout << recognizedLetter << "/" << a <<"\n";

	isHandShapeEventReceived=true;
}
