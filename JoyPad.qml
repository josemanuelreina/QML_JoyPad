import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
    id: joyPad3

    function isInside(a,b,Distance) {
        if(hipo(a,b) < Distance) return true;
        else return false
    }
    function hipo(a,b) {
        return Math.sqrt(a*a+b*b)
    }

    function getRelativeX(a,b,dist) {
        var distance = hipo(a,b)
        var coseno = a/distance
        return parseInt(dist*coseno)
    }
    function getRelativeY(a,b,dist) {
        var distance = hipo(a,b)
        var seno = b/distance
        return parseInt(dist*seno)
    }

    function getValue(actual,max) {
        return (actual/max).toFixed(2)
    }


    property var innerDiameter
    property var innerRadius
    property var outterDiameter
    property var outterRadius
    property var originalInnerCircleX
    property var originalInnerCircleY

    property var movementAreaRadius
    property var movementAreaDiameter

    property var centerX
    property var centerY

    property bool moving

    property real initialMouseX
    property real initialMouseY

    property var moveX
    property var moveY

    property var nextMoveX
    property var nextMoveY

    property var outsideFactor

    property var offsetX
    property var offsetY

    property real incrementoX
    property real incrementoY
    property real newMouseX
    property real newMouseY
    property real lastMouseX
    property real lastMouseY

    property bool padReleased

    property var xValue
    property var yValue

    Component.onCompleted: {
        outsideFactor = 0.3
        innerRadius = parseInt(innerDiameter/2)
        outterRadius = parseInt(outterDiameter/2)
        movementAreaRadius = outterRadius+(outsideFactor*innerDiameter)
        movementAreaDiameter = movementAreaRadius*2
        originalInnerCircleX = (movementAreaDiameter-innerDiameter)/2
        originalInnerCircleY = (movementAreaDiameter-innerDiameter)/2
        innerCircle.x = originalInnerCircleX
        innerCircle.y = originalInnerCircleY
        moving = false
        centerX = movementAreaRadius
        centerY = movementAreaRadius
        initialMouseX = 0
        initialMouseY = 0
        offsetX = 0
        offsetY = 0

        xValue = 0
        yValue = 0
        padReleased = false
    }

    width: movementAreaDiameter
    height: width

    Rectangle {
        id: outterCircle
        width: outterDiameter
        height: width
        color: "transparent"
        border.width: 2
        border.color: "red"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        radius: width/2

        Rectangle {
            height: parent.height*0.95
            width: height
            radius: height/2
            color: "transparent"
            border.width: 2
            border.color: "red"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
        }
    }


    Rectangle {
        id: innerCircle
        width: innerDiameter
        height: width
        color: "grey"
        border.color: "black"
        radius: width/2

        Rectangle {
            height: parent.height*0.8
            width: parent.width*0.8
            radius: width/2
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            border.width: width*0.02
            border.color: "black"

            gradient: Gradient {
                GradientStop { position: 0.0; color: "#383838" }
                GradientStop { position: 0.5; color: "#C9C9C9" }
                GradientStop { position: 1.0; color: "#404040" }
            }

            states: State {
                name: "brighter"; when: moving
                PropertyChanges { target: innerCircle; color: "aqua" }
            }
            transitions: Transition {
                ColorAnimation {duration: 500}
            }
        }
    }

    MouseArea {
        id: mouseArea
        width: parent.width
        height: parent.height
        anchors.fill: parent
        onPressed: {
            padReleased = false
            innerCircle.x = originalInnerCircleX
            innerCircle.y = originalInnerCircleY
            if(isInside(mouseX-centerX,mouseY-centerY,innerRadius)) {
                initialMouseX = mouseX
                initialMouseY = mouseY
                moving = true

            }
            else{

            }
        }
        onReleased: {
            padReleased = true
            moving = false
            xValue = 0
            yValue = 0
        }
        onPositionChanged: {
            if(!moving) {
                if(isInside(mouseX-centerX,mouseY-centerY,innerRadius)) {
                    initialMouseX = mouseX
                    initialMouseY = mouseY
                    moving = true
                }
            }
            else {
                initialMouseX = initialMouseX
                initialMouseY = initialMouseY
                moveX = mouseX-initialMouseX
                moveY = mouseY-initialMouseY
                if(isInside(moveX,moveY,movementAreaRadius-innerRadius)) {
                    innerCircle.x = originalInnerCircleX+moveX
                    innerCircle.y = originalInnerCircleY+moveY
                    lastMouseX = mouseX
                    lastMouseY = mouseY

                    xValue = getValue(moveX,movementAreaRadius-innerRadius)
                    yValue = getValue(moveY,movementAreaRadius-innerRadius)
                }
                else {
                    innerCircle.x = originalInnerCircleX + getRelativeX(moveX,moveY,movementAreaRadius-innerRadius)
                    innerCircle.y = originalInnerCircleY + getRelativeY(moveX,moveY,movementAreaRadius-innerRadius)

                    if(isInside(mouseX-centerX,mouseY-centerY,movementAreaRadius)) {
                        newMouseX = mouseX
                        newMouseY = mouseY
                        incrementoX = newMouseX-lastMouseX
                        incrementoY = newMouseY-lastMouseY
                        initialMouseX = initialMouseX+incrementoX
                        initialMouseY = initialMouseY+incrementoY
                        lastMouseX = mouseX
                        lastMouseY = mouseY

                        xValue = getValue(getRelativeX(moveX,moveY,movementAreaRadius-innerRadius),movementAreaRadius-innerRadius)
                        yValue = getValue(getRelativeY(moveX,moveY,movementAreaRadius-innerRadius),movementAreaRadius-innerRadius)
                    }
                    else {
                        moving = false
                        padReleased = true
                        xValue = 0
                        yValue = 0
                    }
                }
            }
        }
    }
    states: State {
        name: "centered"; when: padReleased
        PropertyChanges { target: innerCircle; x: originalInnerCircleX; y: originalInnerCircleY; }
    }

    transitions: Transition {
            from: ""; to: "centered";
            NumberAnimation { properties: "x,y";duration: 250; easing.type: Easing.InOutQuad }
    }
}
