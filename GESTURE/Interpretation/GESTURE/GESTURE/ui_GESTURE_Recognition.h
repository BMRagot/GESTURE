/*****************************************************************************
*														                   *
*  GESTURE 1.x Beta														     *
*                                                                            *
*  Copyright (c) 2013 GESTURE										         *
*  All rights reserved.                                                      *
*                                                                            *
*  This file is part of GESTURE.                                    *
*                                                                            *
*****************************************************************************/

#ifndef T_H
#define T_H

#include <QtCore/QVariant>
#include <QtGui/QAction>
#include <QtGui/QApplication>
#include <QtGui/QButtonGroup>
#include <QtGui/QHeaderView>
#include <QtGui/QMainWindow>
#include <QtGui/QStatusBar>
#include <QtGui/QWidget>

QT_BEGIN_NAMESPACE

class Ui_SigmaNIL_HandShapeRecognitionClass
{
public:
    QWidget *centralWidget;
    QStatusBar *statusBar;

    void setupUi(QMainWindow *SigmaNIL_HandShapeRecognitionClass)
    {
        if (SigmaNIL_HandShapeRecognitionClass->objectName().isEmpty())
            SigmaNIL_HandShapeRecognitionClass->setObjectName(QString::fromUtf8("SigmaNIL_HandShapeRecognitionClass"));
        SigmaNIL_HandShapeRecognitionClass->resize(600, 400);
        centralWidget = new QWidget(SigmaNIL_HandShapeRecognitionClass);
        centralWidget->setObjectName(QString::fromUtf8("centralWidget"));
        QSizePolicy sizePolicy(QSizePolicy::Fixed, QSizePolicy::Fixed);
        sizePolicy.setHorizontalStretch(0);
        sizePolicy.setVerticalStretch(0);
        sizePolicy.setHeightForWidth(centralWidget->sizePolicy().hasHeightForWidth());
        centralWidget->setSizePolicy(sizePolicy);
        centralWidget->setMinimumSize(QSize(640, 480));
        centralWidget->setMaximumSize(QSize(640, 480));
        SigmaNIL_HandShapeRecognitionClass->setCentralWidget(centralWidget);
        statusBar = new QStatusBar(SigmaNIL_HandShapeRecognitionClass);
        statusBar->setObjectName(QString::fromUtf8("statusBar"));
        SigmaNIL_HandShapeRecognitionClass->setStatusBar(statusBar);

        retranslateUi(SigmaNIL_HandShapeRecognitionClass);

        QMetaObject::connectSlotsByName(SigmaNIL_HandShapeRecognitionClass);
    } // setupUi

    void retranslateUi(QMainWindow *SigmaNIL_HandShapeRecognitionClass)
    {
        SigmaNIL_HandShapeRecognitionClass->setWindowTitle(QApplication::translate("SigmaNIL_HandShapeRecognitionClass", "SigmaNIL_HandShapeRecognition", 0, QApplication::UnicodeUTF8));
    } // retranslateUi

};

namespace Ui {
    class SigmaNIL_HandShapeRecognitionClass: public Ui_SigmaNIL_HandShapeRecognitionClass {};
} // namespace Ui

QT_END_NAMESPACE

#endif // T_H
