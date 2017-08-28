# QML_JoyPad
A simple qml Joystick Component.
This creates a virtual joystick on the screen.

It's behaviour is like a real pad, I've Tried to do it the better I could

To use it, only copy the file into your project

and call it like follows:

    JoyPad {
        id: joyPad
        innerDiameter: 30
        outterDiameter: 50
        anchors.right: parent.right
        anchors.bottom: parent.bottom
    }
    
This will display the pad on the bottom corner of your App, to acces to the values use joyPad.xValue and joyPad.yValue, both go from -1 to 1. Where 0,0 is center.
