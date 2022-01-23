from psychopy import visual, core, event
import win32api
from win32api import GetSystemMetrics
import math

monitorXcm = 34.6 # Monitor X axis cm
BriOfWin = 255  # [Brightness] window
BriOfDots = 0  # [Brightness] dots


def printInfo(device):
    settings = win32api.EnumDisplaySettings(device.DeviceName, -1)
    return(getattr(settings, 'DisplayFrequency'), GetSystemMetrics(0), GetSystemMetrics(1))

def calculPix(distance, VisualAngle):
    pxcm_X = monitorXcm / monitorXpx  # The cm of pixels(X axis)
    stiSize = math.tan( math.radians(VisualAngle) ) * distance
    pxNum_X = math.ceil(stiSize / pxcm_X)
    return(pxNum_X)

def calculMoving():
    AmountOfMoving01 = StiTime/monitorIfi 
    AmountOfMoving02 = 2*DotsDia*math.pi/AmountOfMoving01
    AmountOfMoving = (AmountOfMoving02/DotsDia)
    return(AmountOfMoving)

def Dots(startPoint1, startPoint2):
    dotstim1.pos = [FromFix, FromFix]
    dotstim2.pos = [-FromFix, -FromFix]
    dotstim3.pos = [FromFix + math.cos(startPoint1)*Orbit, FromFix - math.sin(startPoint1)*Orbit]
    dotstim4.pos = [-FromFix + math.cos(startPoint2)*Orbit, -FromFix - math.sin(startPoint2)*Orbit]
    dotstim1.draw()
    dotstim2.draw()
    dotstim3.draw()
    dotstim4.draw()
    fixation1.draw()
    fixation2.draw()

def STI1():
    startPoint1 = 0
    startPoint2 = 1

    StopTime1 = 1
    clock1 = core.Clock()
    while 1 == 1: #clock1.getTime() < 1.001:  # Clock times are in seconds
        if StopTime1 < monitorHz*1:
            Dots(startPoint1, startPoint2)
            StopTime1 += 1
        elif monitorHz*1 <= StopTime1 and StopTime1 < monitorHz*3:
            Dots(startPoint1, startPoint2)
            startPoint1 += AmountOfMoving
            startPoint2 += AmountOfMoving
            StopTime1 += 1
        elif StopTime1 >= monitorHz*3:
            break
        elif clock1.getTime() > 5:
            break
        win.flip()


def control():
    text1.draw()
    win.flip()
    event.waitKeys()
    ShowSti()

def ShowSti():
    STI1()
    while 1==1:
        key = event.getKeys()
        if key == ['escape']:
            break
        elif key == ['space']:
            ShowSti()
        elif key == ['a']:
            control()


####################
# Monitor
device = win32api.EnumDisplayDevices()
monitorInfo = printInfo(device)
monitorHz = monitorInfo[0]
monitorIfi = 1/(monitorInfo[0])
monitorXpx = monitorInfo[1]
monitorYpx = monitorInfo[2]

####################
# Variable
DotsDia = calculPix(90, 0.25)   # [Size] Diameter of Dots
Orbit = calculPix(90, 1)        # [Distance] Between MOVING DOTS and STATIONARY DOTS
FromFix = calculPix(90, 2)      # [Distance] Between FIXATION and STATIONARY DOTS
StiTime = 0.5                   # [Time]

AmountOfMoving = calculMoving() # for calculating amount of moving

####################
# Experiment
win = visual.Window(fullscr = True, color = [BriOfWin, BriOfWin, BriOfWin], units="pix", colorSpace = 'rgb255')
dotstim1 = visual.Circle(win, fillColorSpace = 'rgb255', fillColor = [BriOfDots, BriOfDots, BriOfDots], size = (DotsDia, DotsDia))
dotstim2 = visual.Circle(win, fillColorSpace = 'rgb255', fillColor = [BriOfDots, BriOfDots, BriOfDots], size = (DotsDia, DotsDia))
dotstim3 = visual.Circle(win, fillColorSpace = 'rgb255', fillColor = [BriOfDots, BriOfDots, BriOfDots], size = (DotsDia, DotsDia))
dotstim4 = visual.Circle(win, fillColorSpace = 'rgb255', fillColor = [BriOfDots, BriOfDots, BriOfDots], size = (DotsDia, DotsDia))
fixation1 = visual.Line(win, lineColorSpace = 'rgb255', lineColor=[0, 0, 0], start = [-DotsDia/2, 0], end = [DotsDia/2, 0])
fixation2 = visual.Line(win, lineColorSpace = 'rgb255', lineColor=[0, 0, 0], start = [0, -DotsDia/2], end = [0, DotsDia/2])
text1 = visual.TextStim(win, text = "Control things", pos = [0, 0], color = [100, 100, 100], colorSpace = 'rgb255')

ShowSti()
