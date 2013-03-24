/*****************************************************************************
*                                                                            *
*  GESTURE 1.x Beta															 *
*                                                                            *
*  Copyright (c) 2013														 *
*  All rights reserved.                                                      *
*                                                                            *
*  This file is part of GESTURE.											 *
*                                                                            *
*****************************************************************************/

#ifndef SIGMANIL_HANDSHAPERECOGNITION_H
#define SIGMANIL_HANDSHAPERECOGNITION_H
//
//#ifdef _WIN32
//	#ifdef _DEBUG
//		#pragma comment (lib, "../lib/SigmaNIL_200d_x86.lib")
//		#pragma comment (lib, "../lib/Engines/HandSegmentationEngine_nil200_100d_x86.lib")
//		#pragma comment (lib, "../lib/Engines/HandShapeEngine_nil200_100d_x86.lib")
//	#else
//		#pragma comment (lib, "../lib/SigmaNIL_200_x86.lib")
//		#pragma comment (lib, "../lib/Engines/HandSegmentationEngine_nil200_100_x86.lib")
//		#pragma comment (lib, "../lib/Engines/HandShapeEngine_nil200_100_x86.lib")
//	#endif
//#else
//	#ifdef _DEBUG
//		#pragma comment (lib, "../lib/SigmaNIL_200d_x64.lib")
//		#pragma comment (lib, "../lib/Engines/HandSegmentationEngine_nil200_100d_x64.lib")
//		#pragma comment (lib, "../lib/Engines/HandShapeEngine_nil200_100d_x64.lib")
//	#else
//		#pragma comment (lib, "../lib/SigmaNIL_200_x64.lib")
//		#pragma comment (lib, "../lib/Engines/HandSegmentationEngine_nil200_100_x64.lib")
//		#pragma comment (lib, "../lib/Engines/HandShapeEngine_nil200_100_x64.lib")
//	#endif
//#endif
#include "GESTURE_Server.h"
#include <QtGui/QMainWindow>
#include "ui_GESTURE_Recognition.h"
#include "Nil.h"
#include "HandSegmentationEngine.h"
#include "HandShapeEngine.h"

#include <QTimer>

#define LETTER_COUNT 27

using namespace SigmaNIL;

class GESTURE_Recognition : public QMainWindow
{
	Q_OBJECT

public:
	GESTURE_Recognition(QWidget *parent = 0, Qt::WFlags flags = 0);
	~GESTURE_Recognition();

	GESTURE_Server Sock;//const;
	//GESTURE_Server GetSock(){return Sock;};
	void SetSock( GESTURE_Server newSock){Sock=newSock;};
	void closeEvent( QCloseEvent * event );

public slots:
	void Run();

protected:
	void paintEvent(QPaintEvent*);

private:
	void DriverEventHandler(NIL_EVENT e);

	void HandShapeEventHandler(NIL_EVENT e);

	Ui::SigmaNIL_HandShapeRecognitionClass ui;

	NIL nil;

	HandSegmentationEngine engineHandSegmentation;

	HandShapeEngine engineHandShape;


	QImage rgbImage;
	QTimer *timer;

	QString recognizedLetter;
	vec3 handPosition2D;
	vec3 handPosition2Dmem;

	Box2D handRect;

	bool isHandShapeEventReceived;
	unsigned char* dbgColors;
	HAND_TYPE userActiveHand;
	bool useShapeColors;
	rdfLabelColor shapeColors[LETTER_COUNT];

	//bool isClientConnected;
	//GESTURE_Server KSock;

};

#endif // SIGMANIL_HANDSHAPERECOGNITION_H