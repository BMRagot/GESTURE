/*****************************************************************************
*                                                                            *
*  GESTURE 1.x Beta													         *
*                                                                            *
*  Copyright (c) 2013 GESTURE										        *
*  All rights reserved.                                                      *
*                                                                            *
*  This file is part of GESTURE.                                    *
*                                                                            *
*****************************************************************************/

#include "GESTURE_Recognition.h"
#include <QPainter>


#define RED 0
#define GREEN 1
#define BLUE 2
#define SHOW_COLORS

GESTURE_Recognition::GESTURE_Recognition(QWidget *parent, Qt::WFlags flags)
	: QMainWindow(parent, flags), rgbImage(640, 480, QImage::Format::Format_RGB888), recognizedLetter(" ")
{
	int i;

	isHandShapeEventReceived=false;
	dbgColors=NULL;

	ui.setupUi(this);

#ifdef SHOW_COLORS
	useShapeColors=true;
	//*****DEFINING SHAPE COLORS FOR VISUALIZATION PURPOSES*****
	/*
	struct rdfLabelColor
	{
		unsigned char label;
		unsigned char pixel[3];
	};
	*/
	shapeColors[0].label=0;
	shapeColors[0].pixel[RED]=0;
	shapeColors[0].pixel[GREEN]=0;
	shapeColors[0].pixel[BLUE]=0;

	unsigned int __24BitMAX=0xFFFFFF;
	unsigned int step=__24BitMAX/LETTER_COUNT;
	unsigned int accumulate=0;

	for(i=1;i<LETTER_COUNT;i++)
	{
		accumulate=accumulate + step;
		shapeColors[i].label=(int)i;
		shapeColors[i].pixel[RED]  =(accumulate & 0xFF);
		shapeColors[i].pixel[GREEN]=(accumulate & 0xFF00)   >> 8;
		shapeColors[i].pixel[BLUE] =(accumulate & 0xFF0000) >> 16;
	}
	//*****DEFINING SHAPE COLORS FOR VISUALIZATION PURPOSES*****
#else
	useShapeColors=false;
#endif

	timer = new QTimer(this);
	connect( timer, SIGNAL(timeout()), this, SLOT(Run()) );
	timer->start(30);

	// Initialize SigmaNIL
	//nil.Init(KinectSDK);
	nil.Init(OpenNI2);
	nil.GetDriver()->SetUserFollowMode(SigmaNIL::NEAREST);


	// Initialize HandSegmentation Engine
	engineHandSegmentation.Init(&nil, SigmaNIL::RIGHT);
	engineHandSegmentation.Start();


	//VM_START_WITHLEVEL(20)
	//STR_ENCRYPT_START

	// Initialize HandShape Engine
	//std::string forestFileName("Data/ASL_T12_LH_SCR_98.9%_PPCR_86.8%.cforest");
	std::string forestFileName("Data/Test1Open2Close.cforest");

	if(useShapeColors){
		engineHandShape.Init( "Sigma", "A6E443852ED4FBB52D59D7B9146718D08E29F665", &nil, &engineHandSegmentation, forestFileName, SigmaNIL::RIGHT, 0.88, 0.25,false,true,shapeColors);
	}else{
		engineHandShape.Init( "Sigma", "A6E443852ED4FBB52D59D7B9146718D08E29F665", &nil, &engineHandSegmentation, forestFileName, SigmaNIL::RIGHT, 0.88, 0.25);
	}
	engineHandShape.Start();

	//engineHandShape.Init( "Enter Company Name Provided", "Enter Company Password", &nil, &engineHandSegmentation, forestFileName, SigmaNIL::RIGHT, 0.88, 0.25 );
	
	//STR_ENCRYPT_END
	//VM_END
	
	//engineHandShape.Start();

	// Bind event handlers
	nil.GetDriver()->AddEventListener( MEMBER_FUNC_PASS(GESTURE_Recognition::DriverEventHandler, *this) );
	engineHandShape.AddEventListener( MEMBER_FUNC_PASS(GESTURE_Recognition::HandShapeEventHandler, *this) );
	

	userActiveHand = UNDEFINED;

	//KSock = GESTURE_Server();
	//KSock.initServer();

	
}

GESTURE_Recognition::~GESTURE_Recognition()
{
	delete timer;
}

void GESTURE_Recognition::paintEvent( QPaintEvent* )
{
	int i;
	int j;

	QPainter p(this);
	QPen pen;
	QFont f("Courier", 40, QFont::Bold);
	
	p.setFont(f);
	pen.setColor(QColor(0,255,0,255));
	p.setPen(pen);

	//Draw label coloring; if it is enabled.
	if(useShapeColors)
	{
		int handWidth =handRect.dimensions.x;
		int handHeight=handRect.dimensions.y;
		int minX=handRect.lowerCorner.x;
		int minY=handRect.lowerCorner.y;

		for(i=0;i<handHeight;i++)
		{
			for(j=0;j<handWidth;j++)
			{
				int index=3*(i*handWidth + j);

				//Skip if this is a background pixel
				if(dbgColors[index + RED]==shapeColors[0].pixel[RED] && 
				   dbgColors[index + GREEN]==shapeColors[0].pixel[GREEN] &&
				   dbgColors[index + BLUE]==shapeColors[0].pixel[BLUE])
				{
					continue;
				}
			

				QColor pixelColor((int)dbgColors[index + RED],(int)dbgColors[index + GREEN],(int)dbgColors[index + BLUE]);

				rgbImage.setPixel(minX + j,minY + i,pixelColor.rgb());
			}
		}

		pen.setColor(QColor(255,0,0,255));
		p.setPen(pen);

	
	}
	p.drawImage(0,0,rgbImage);


	p.drawText(100,100,recognizedLetter);

	pen.setColor(QColor(255,0,0,255));
	pen.setWidth(5);
	p.setPen(pen);
	//p.drawRect(handPosition2D.x-15,handPosition2D.y-15,30,30);

	//Draw Hand
	if(userActiveHand == LEFT)
		pen.setColor(QColor(255,0,0,255));
	else if( userActiveHand == RIGHT )
		pen.setColor(QColor(0,255,0,255));
	else
		pen.setColor(QColor(0,0,255,255));

	pen.setWidth(5);
	p.setPen(pen);
	
	if( userActiveHand != UNDEFINED ){
		p.drawRect(handPosition2D.x-15,handPosition2D.y-15,30,30);
		
	}
}

void GESTURE_Recognition::DriverEventHandler( NIL_EVENT e )
{
	
	boost::shared_ptr<Driver::DriverEvent> driverEvent = boost::static_pointer_cast<Driver::DriverEvent>(e);

	// Get RGB Image from the camera
	//const unsigned char* rgbImg = nil.GetDriver()->GetRGBImage();
	const unsigned char* rgbImg = nil.GetDriver()->GetDepthHistogram();

	// Copy to buffer
	memcpy(rgbImage.bits(), rgbImg, 640*480*3*sizeof(unsigned char));

	if( driverEvent->activeUser != NULL )
		userActiveHand = driverEvent->activeUser->activeHand;
	
	vec3 handPosition3D = driverEvent->handPosition[RIGHT];
	handPosition2D = nil.GetDriver()->ConvertWorldToScreen(handPosition3D);
	handPosition2D.y = 480-handPosition2D.y;
	
	std::cout << "################################################"  << "\n" ;
	std::cout << "RIGHT==x: "<< handPosition2D.x << "/ y: "<< handPosition2D.y <<"/ z:" << handPosition2D.z <<"\n";
	update();
}

void GESTURE_Recognition::Run()
{
	isHandShapeEventReceived=false;
	if(dbgColors!=NULL && useShapeColors)
	{
		delete [] dbgColors;
		dbgColors=NULL;
	}
	
	nil.ManualUpdate();
}

void GESTURE_Recognition::HandShapeEventHandler( NIL_EVENT e )
{
	boost::shared_ptr<HandShapeEngine::HandShapeEvent> handShapeEvent = boost::static_pointer_cast<HandShapeEngine::HandShapeEvent>(e);

	if(useShapeColors)
	{
		handRect=handShapeEvent->GetSegmentationRect();
		dbgColors=new unsigned char[3*handRect.dimensions.x*handRect.dimensions.y];
		memcpy(dbgColors,handShapeEvent->GetDebugColors(),sizeof(unsigned char)*3*handRect.dimensions.x*handRect.dimensions.y);
	}
	
	char label = 64 + handShapeEvent->GetShapeLabel();
	if( label > 73 ) label++;
	recognizedLetter = (QString(label) + " %1").arg(QString::number(handShapeEvent->GetEntropy()));
	
	double a = handShapeEvent->GetEntropy();
	
	std::cout << "geste: "<<label << "/" << a <<"\n";

	std::ostringstream oss;
	oss<<label << "/"<< handPosition2D.x <<"/" << handPosition2D.y <<"/" << handPosition2D.z;
	const char* gesture= (const char*)&(oss.str());
	long dataSize = sizeof(gesture);
	

char buffer[120];
for (int a=0;a<=120;a++)
        {
            buffer[a]=oss.str()[a];
}


	//std::string s = oss.str();

	//char *un= s.c_str();
	//char gesture[32] ;
	//gesture=label.str() ;
	
	 //std::string gesture="/"+ handPosition2D.x.str() +"/" + handPosition2D.y +"/" + handPosition2D.z;
		 //gesture =s.toCharArray();
		// label<< "/"<< handPosition2D.x <<"/" << handPosition2D.y <<"/" << handPosition2D.z;
	bool isClientConnected1 = Sock.sendData(buffer,120);
	//bool isClientConnected2 = Sock.sendData("envoie dinfo",32);
	std::cout << oss.str()  << "\n" ;
	std::cout << buffer  << "\n" ;
	std::cout << gesture  << "\n" ;
	std::cout << "datasize" <<dataSize << "\n";
	std::cout << "Send?"<<  isClientConnected1 << "\n";
		//Sock.closeConnection();

	isHandShapeEventReceived=true;
}


	
