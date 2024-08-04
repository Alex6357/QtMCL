/*
 * BSD 3-Clause License
 *
 * Copyright (c) 2024, Alex11
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice, this
 *    list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 *
 * 3. Neither the name of the copyright holder nor the names of its
 *    contributors may be used to endorse or promote products derived from
 *    this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/*
 * 下拉框组件
 */

import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic

ComboBox {
    id: control
    rightPadding: 30
    font.family: "Microsoft YaHei"

    property bool isDown: true
    required property int num

    delegate: ItemDelegate {
        id: controlDelegate

        required property var model
        required property int index

        width: control.width
        height: control.height
        contentItem: Rectangle {
            anchors.fill: parent
            color: "transparent"

            Text {
                text: controlDelegate.model[control.textRole]
                color: "#21be2b"
                font: control.font
                elide: Text.ElideRight
                verticalAlignment: Text.AlignVCenter
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 10
            }

            Rectangle {
                width: 28
                height: 28
                color: "transparent"
                radius: 5
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter

                MouseArea {
                    anchors.fill: parent
                }
            }
        }

        background: Rectangle {
            width: control.width - 4
            height: control.height
            // opacity: enabled ? 1 : 0.3
            // opacity: (control.currentIndex === index) ? 0 : 1
            color: if(control.currentIndex === index){
                       "#dddedf"
                    } else if(controlDelegate.hovered){
                       "#dddedf"
                    } else {
                       "white"
                    }
            radius: 5
            anchors.centerIn: parent

            Behavior on color {
                PropertyAnimation {
                    duration: 100
                }
            }
        }
    }

    indicator: Canvas {
        id: controlIndicator
        x: control.width - width - 9
        y: control.topPadding + (control.availableHeight - height) / 2
        width: 12
        height: 8
        contextType: "2d"

        Connections {
            target: controlPopup
            function onOpened(){
               controlIndicator.rotation = control.isDown ? 180 : -180
            }
        }

        Connections {
            target: controlPopup
            function onClosed(){
                controlIndicator.rotation = 0
            }
        }

        Behavior on rotation {
            NumberAnimation {
                duration: 150
            }
        }

        // onRotationChanged: requestPaint()

        onPaint: {
            context.reset();
            context.moveTo(0, control.isDown ? 0 : height);
            context.lineTo(width, control.isDown ? 0 : height);
            context.lineTo(width / 2, control.isDown ? height : 0);
            context.closePath();
            context.fillStyle = /*control.pressed ? "#17a81a" : */"#21be2b";
            context.fill();
        }
    }

    contentItem: TextField {
        enabled: control.editable
        leftPadding: 10
        rightPadding: /*parent.indicator.width + parent.spacing*/20
        // width: parent.width - 50
        text: control.displayText
        font: control.font
        color: /*control.pressed ? "#17a81a" : */"#21be2b"
        verticalAlignment: Text.AlignVCenter
        // elide: Text.ElideRight

        background: Rectangle {
            color: "transparent"
        }
    }

    background: Rectangle {
        implicitWidth: parent.width
        implicitHeight: parent.height
        color: control.hovered ? "#dddedf" : "white"
        border.color: /*control.pressed ? "#17a81a" : */"#21be2b"
        border.width: /*control.visualFocus ? 2 : */1
        radius: 5
        clip: true

        Behavior on color {
            PropertyAnimation {
                duration: 100
            }
        }
    }

    popup: Popup {
        id: controlPopup
        y: isDown ? control.height - 1 : -implicitHeight + 1
        // y: -243
        width: control.width
        implicitHeight: contentItem.implicitHeight > control.height * control.num ? control.height * control.num + 4 : contentItem.implicitHeight + 4
        padding: 0
        topPadding: 2
        bottomPadding: 2

        contentItem: ListView {
            clip: true
            implicitHeight: contentHeight
            model: control.popup.visible ? control.delegateModel : null
            currentIndex: control.highlightedIndex
            // spacing: -5

            ScrollIndicator.vertical: ScrollIndicator { }
        }

        background: Rectangle {
            border.color: "#21be2b"
            radius: 5
        }

        enter: Transition {
            NumberAnimation {
                property: "opacity"
                from: 0
                to: 1
                duration: 100
            }
        }
        exit: Transition {
            NumberAnimation {
                property: "opacity"
                from: 1
                to: 0
                duration: 100
            }
        }
    }
}

// ComboBox {
//     id: choosePlayer
//     width: 200
//     height: 30
//     rightPadding: 30
//     model: models/*ListModel {
//         id: model
//         ListElement { text: "1" }
//         //game.qmlGetGameList();
//     }*/
//     editable: true
//     font.family: "Microsoft YaHei"
//     anchors.horizontalCenter: parent.horizontalCenter
//     anchors.top: skinAvatar.bottom
//     anchors.topMargin: 40

//     property var models: Interface.getUserList()

//     onAccepted: {
//         var text = editText
//         if(find(text) === -1){
//             Interface.addToUserList(text)
//             models = Interface.getUserList()
//             console.debug(find(text))
//             currentIndex = find(text)
//         }
//     }

//     delegate: ItemDelegate {
//         id: choosePlayerDelegate

//         required property var model
//         required property int index

//         width: choosePlayer.width
//         height: choosePlayer.height
//         contentItem: Rectangle {
//             anchors.fill: parent
//             color: "transparent"

//             Text {
//                 text: choosePlayerDelegate.model[choosePlayer.textRole]
//                 color: "#21be2b"
//                 font: choosePlayer.font
//                 elide: Text.ElideRight
//                 verticalAlignment: Text.AlignVCenter
//                 anchors.verticalCenter: parent.verticalCenter
//                 anchors.left: parent.left
//                 anchors.leftMargin: 10
//             }

//             Rectangle {
//                 width: 28
//                 height: 28
//                 color: "transparent"
//                 radius: 5
//                 anchors.right: parent.right
//                 anchors.verticalCenter: parent.verticalCenter

//                 Canvas {

//                 }

//                 MouseArea {
//                     anchors.fill: parent
//                     onClicked: {

//                     }
//                 }
//             }
//         }

//         background: Rectangle {
//             width: choosePlayer.width - 4
//             height: choosePlayer.height
//             // opacity: enabled ? 1 : 0.3
//             // opacity: (choosePlayer.currentIndex === index) ? 0 : 1
//             color: if(choosePlayer.currentIndex === index){
//                        "#dddedf"
//                     } else if(choosePlayerDelegate.hovered){
//                        "#dddedf"
//                     } else {
//                        "white"
//                     }
//             radius: 5
//             anchors.centerIn: parent

//             Behavior on color {
//                 PropertyAnimation {
//                     duration: 100
//                 }
//             }
//         }
//     }

//     indicator: Canvas {
//         id: choosePlayerIndicator
//         x: choosePlayer.width - width - 9
//         y: choosePlayer.topPadding + (choosePlayer.availableHeight - height) / 2
//         width: 12
//         height: 8
//         contextType: "2d"

//         Connections {
//             target: choosePlayerPopup
//             function onOpened(){
//                choosePlayerIndicator.rotation = 180
//             }
//         }

//         Connections {
//             target: choosePlayerPopup
//             function onClosed(){
//                 choosePlayerIndicator.rotation = 0
//             }
//         }

//         Behavior on rotation {
//             NumberAnimation {
//                 duration: 150
//             }
//         }

//         // onRotationChanged: requestPaint()

//         onPaint: {
//             context.reset();
//             context.moveTo(0, 0);
//             context.lineTo(width, 0);
//             context.lineTo(width / 2, height);
//             context.closePath();
//             context.fillStyle = /*choosePlayer.pressed ? "#17a81a" : */"#21be2b";
//             context.fill();
//         }
//     }

//     contentItem: TextField {
//         leftPadding: 10
//         rightPadding: /*parent.indicator.width + parent.spacing*/20
//         // width: parent.width - 50
//         text: choosePlayer.displayText
//         font: choosePlayer.font
//         color: /*choosePlayer.pressed ? "#17a81a" : */"#21be2b"
//         verticalAlignment: Text.AlignVCenter
//         // elide: Text.ElideRight

//         background: Rectangle {
//             color: "transparent"
//         }
//     }

//     background: Rectangle {
//         implicitWidth: parent.width
//         implicitHeight: parent.height
//         color: choosePlayer.hovered ? "#dddedf" : "white"
//         border.color: /*choosePlayer.pressed ? "#17a81a" : */"#21be2b"
//         border.width: /*choosePlayer.visualFocus ? 2 : */1
//         radius: 5
//         clip: true

//         Behavior on color {
//             PropertyAnimation {
//                 duration: 100
//             }
//         }
//     }

//     popup: Popup {
//         id: choosePlayerPopup
//         y: choosePlayer.height - 1
//         // y: -243
//         width: choosePlayer.width
//         implicitHeight: contentItem.implicitHeight + 4 > 154 ? 154 : contentItem.implicitHeight + 4
//         padding: 0
//         topPadding: 2
//         bottomPadding: 2

//         contentItem: ListView {
//             clip: true
//             implicitHeight: contentHeight
//             model: choosePlayer.popup.visible ? choosePlayer.delegateModel : null
//             currentIndex: choosePlayer.highlightedIndex
//             // spacing: -5

//             ScrollIndicator.vertical: ScrollIndicator { }
//         }

//         background: Rectangle {
//             border.color: "#21be2b"
//             radius: 5
//         }

//         enter: Transition {
//             NumberAnimation {
//                 property: "opacity"
//                 from: 0
//                 to: 1
//                 duration: 100
//             }
//         }
//         exit: Transition {
//             NumberAnimation {
//                 property: "opacity"
//                 from: 1
//                 to: 0
//                 duration: 100
//             }
//         }
//     }
// }

// ComboBox {
//     id: chooseVersion
//     width: 130
//     height: 30
//     model: Interface.getGameList()
//     font.family: "Microsoft YaHei"
//     anchors.right: parent.right
//     anchors.bottom: parent.bottom
//     anchors.rightMargin: 30
//     anchors.bottomMargin: 60

//     delegate: ItemDelegate {
//         id: chooseVersionDelegate

//         required property var model
//         required property int index

//         width: chooseVersion.width
//         height: chooseVersion.height
//         contentItem: Text {
//             text: chooseVersionDelegate.model[chooseVersion.textRole]
//             color: "#21be2b"
//             font: chooseVersion.font
//             elide: Text.ElideRight
//             verticalAlignment: Text.AlignVCenter
//         }

//         background: Rectangle {
//             width: chooseVersion.width - 4
//             height: chooseVersion.height
//             // opacity: enabled ? 1 : 0.3
//             // opacity: (chooseVersion.currentIndex === index) ? 0 : 1
//             color: if(chooseVersion.currentIndex === index){
//                        "#dddedf"
//                     } else if(chooseVersionDelegate.hovered){
//                        "#dddedf"
//                     } else {
//                        "white"
//                     }
//             radius: 5
//             anchors.centerIn: parent

//             Behavior on color {
//                 PropertyAnimation {
//                     duration: 100
//                 }
//             }
//         }
//     }

//     indicator: Canvas {
//         id: chooseVersionIndicator
//         x: chooseVersion.width - width - 9
//         y: chooseVersion.topPadding + (chooseVersion.availableHeight - height) / 2
//         width: 12
//         height: 8
//         contextType: "2d"

//         Connections {
//             target: chooseVersionPopup
//             function onOpened(){
//                chooseVersionIndicator.rotation = -180
//             }
//         }

//         Connections {
//             target: chooseVersionPopup
//             function onClosed(){
//                 chooseVersionIndicator.rotation = 0
//             }
//         }

//         Behavior on rotation {
//             NumberAnimation {
//                 duration: 150
//             }
//         }

//         // onRotationChanged: requestPaint()

//         onPaint: {
//             context.reset();
//             context.moveTo(0, height);
//             context.lineTo(width, height);
//             context.lineTo(width / 2, 0);
//             context.closePath();
//             context.fillStyle = /*chooseVersion.pressed ? "#17a81a" : */"#21be2b";
//             context.fill();
//         }
//     }

//     contentItem: Text {
//         leftPadding: 10
//         text: chooseVersion.displayText
//         font: chooseVersion.font
//         color: /*chooseVersion.pressed ? "#17a81a" : */"#21be2b"
//         verticalAlignment: Text.AlignVCenter
//         elide: Text.ElideRight
//     }

//     background: Rectangle {
//         implicitWidth: parent.width
//         implicitHeight: parent.height
//         color: chooseVersion.hovered ? "#dddedf" : "white"
//         border.color: /*chooseVersion.pressed ? "#17a81a" : */"#21be2b"
//         border.width: /*chooseVersion.visualFocus ? 2 : */1
//         radius: 5
//         clip: true

//         Behavior on color {
//             PropertyAnimation {
//                 duration: 100
//             }
//         }
//     }

//     popup: Popup {
//         id: chooseVersionPopup
//         // y: chooseVersion.height - 1
//         y: -implicitHeight + 1
//         width: chooseVersion.width
//         implicitHeight: contentItem.implicitHeight + 4 > 244 ? 244 : contentItem.implicitHeight + 4
//         padding: 0
//         topPadding: 2
//         bottomPadding: 2

//         contentItem: ListView {
//             clip: true
//             implicitHeight: contentHeight
//             model: chooseVersion.popup.visible ? chooseVersion.delegateModel : null
//             currentIndex: chooseVersion.highlightedIndex
//             // spacing: -5

//             ScrollIndicator.vertical: ScrollIndicator { }
//         }

//         background: Rectangle {
//             border.color: "#21be2b"
//             radius: 5
//         }

//         enter: Transition {
//             NumberAnimation {
//                 property: "opacity"
//                 from: 0
//                 to: 1
//                 duration: 100
//             }
//         }
//         exit: Transition {
//             NumberAnimation {
//                 property: "opacity"
//                 from: 1
//                 to: 0
//                 duration: 100
//             }
//         }
//     }
// }
