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
 * 这是“启动游戏”中的“启动”页面。
 */

// **有时间尝试把组件写成模板

import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import QtQuick.Effects

// 启动页面
Rectangle {
    id: pageLaunch
    color: "transparent"
    bottomRightRadius: 5

    // 登录类型，离线或正版
    enum LoginType {
        Offline = 0,
        Online = 1
    }

    // 中间的内容区
    Rectangle {
        id: contentArea
        width: 646
        height: 405
        color: "transparent"
        anchors.centerIn: parent

        // 切换启动类型开关
        Rectangle {
            id: loginSwitch
            width: 160
            height: 35
            color: "white"
            radius: 5
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: 40
            anchors.topMargin: 35
            border.color: "#21be2b"
            border.width: 1

            property int loginType: PageLaunch.LoginType.Offline

            // 用一个 signal 通知所有
            // **其他部分应该这样修改？
            signal changeLoginTypeSignal(int loginType)

            // 每个部分都自己处理信号
            function changeLoginType(type: int){
                if(type === PageLaunch.LoginType.Offline){
                    loginType = PageLaunch.LoginType.Offline
                } else {
                    loginType = PageLaunch.LoginType.Online
                }
            }

            Component.onCompleted: changeLoginTypeSignal.connect(changeLoginType)

            // 颜色动画
            Behavior on color {
                PropertyAnimation {
                    duration: 100
                }
            }

            // 中间的移动矩形
            Rectangle {
                id: loginSwitchBackground
                x: loginSwitchOfflineText.x
                width: 70
                height: 25
                color: "#21be2b"
                radius: 5
                anchors.verticalCenter: parent.verticalCenter

                // 同样自己处理信号
                function changeX(type: int){
                    if (type === PageLaunch.LoginType.Offline){
                        x = loginSwitchOfflineText.x
                    } else {
                        x = loginSwitchOnlineText.x
                    }
                }

                Component.onCompleted: loginSwitch.changeLoginTypeSignal.connect(changeX)

                // 平移动画
                Behavior on x {
                    PropertyAnimation {
                        easing.type: Easing.InOutCubic
                    }
                }
            }// 中间的移动矩形

            // 离线启动文字
            Text {
                id: loginSwitchOfflineText
                width: 70
                height: 25
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 5
                text: qsTr("离线登录")
                color: "white"
                font.family: "Microsoft YaHei"
                font.pixelSize: 14
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                function changeColor(type: int){
                    if (type === PageLaunch.LoginType.Offline){
                        color = "white"
                    } else {
                        color = "#21be2b"
                    }
                }

                Component.onCompleted: loginSwitch.changeLoginTypeSignal.connect(changeColor)

                // 设置文字颜色渐变动画
                Behavior on color {
                    PropertyAnimation {

                    }
                }
            }// 离线启动文字

            // 正版登录文字
            Text {
                id: loginSwitchOnlineText
                width: 70
                height: 25
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: 5
                text: qsTr("正版登录")
                color: "#21be2b"
                font.family: "Microsoft YaHei"
                font.pixelSize: 14
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                function changeColor(type: int){
                    if (type === PageLaunch.LoginType.Offline){
                        color = "#21be2b"
                    } else {
                        color = "white"
                    }
                }

                Component.onCompleted: loginSwitch.changeLoginTypeSignal.connect(changeColor)

                // 设置文字颜色渐变动画
                Behavior on color {
                    PropertyAnimation {

                    }
                }
            }// 正版登录文字

            // 切换按钮鼠标区
            MouseArea {
                id: loginSwitchMouseArea
                anchors.fill: parent
                hoverEnabled: true
                onEntered: parent.color = "#dddedf"
                onExited: parent.color = "white"
                onClicked: {
                    // 让发信号的人判断应该发什么信号
                    if (parent.loginType === PageLaunch.LoginType.Offline){
                        parent.changeLoginTypeSignal(PageLaunch.LoginType.Online)
                    } else {
                        parent.changeLoginTypeSignal(PageLaunch.LoginType.Offline)
                    }
                }
            }
        }// 切换启动类型开关

        // 版本选择下拉框
        ComboBox {
            id: chooseVersion
            width: 130
            height: 30
            model: Interface.getGameList()
            font.family: "Microsoft YaHei"
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.rightMargin: 30
            anchors.bottomMargin: 60

            delegate: ItemDelegate {
                id: chooseVersionDelegate

                required property var model
                required property int index

                width: chooseVersion.width
                height: chooseVersion.height
                contentItem: Text {
                    text: chooseVersionDelegate.model[chooseVersion.textRole]
                    color: "#21be2b"
                    font: chooseVersion.font
                    elide: Text.ElideRight
                    verticalAlignment: Text.AlignVCenter
                }

                background: Rectangle {
                    width: chooseVersion.width - 4
                    height: chooseVersion.height
                    // opacity: enabled ? 1 : 0.3
                    // opacity: (chooseVersion.currentIndex === index) ? 0 : 1
                    color: if(chooseVersion.currentIndex === index){
                               "#dddedf"
                            } else if(chooseVersionDelegate.hovered){
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
                id: chooseVersionIndicator
                x: chooseVersion.width - width - 9
                y: chooseVersion.topPadding + (chooseVersion.availableHeight - height) / 2
                width: 12
                height: 8
                contextType: "2d"

                Connections {
                    target: chooseVersionPopup
                    function onOpened(){
                       chooseVersionIndicator.rotation = -180
                    }
                }

                Connections {
                    target: chooseVersionPopup
                    function onClosed(){
                        chooseVersionIndicator.rotation = 0
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
                    context.moveTo(0, height);
                    context.lineTo(width, height);
                    context.lineTo(width / 2, 0);
                    context.closePath();
                    context.fillStyle = /*chooseVersion.pressed ? "#17a81a" : */"#21be2b";
                    context.fill();
                }
            }

            contentItem: Text {
                leftPadding: 10
                text: chooseVersion.displayText
                font: chooseVersion.font
                color: /*chooseVersion.pressed ? "#17a81a" : */"#21be2b"
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }

            background: Rectangle {
                implicitWidth: parent.width
                implicitHeight: parent.height
                color: chooseVersion.hovered ? "#dddedf" : "white"
                border.color: /*chooseVersion.pressed ? "#17a81a" : */"#21be2b"
                border.width: /*chooseVersion.visualFocus ? 2 : */1
                radius: 5
                clip: true

                Behavior on color {
                    PropertyAnimation {
                        duration: 100
                    }
                }
            }

            popup: Popup {
                id: chooseVersionPopup
                // y: chooseVersion.height - 1
                y: -implicitHeight + 1
                width: chooseVersion.width
                implicitHeight: contentItem.implicitHeight + 4 > 244 ? 244 : contentItem.implicitHeight + 4
                padding: 0
                topPadding: 2
                bottomPadding: 2

                contentItem: ListView {
                    clip: true
                    implicitHeight: contentHeight
                    model: chooseVersion.popup.visible ? chooseVersion.delegateModel : null
                    currentIndex: chooseVersion.highlightedIndex
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

        // 头像阴影
        MultiEffect {
            id: skinAvatarShadow
            shadowEnabled: true
            source: skinAvatar
            anchors.fill: skinAvatar
            shadowBlur: 0.6
        }

        // 头像图片
        Image {
            id: skinAvatar
            width:80
            height: 80
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 100
            source: "qrc:/assests/steve.png"
            smooth: false
        }

        // 用户选择下拉框
        ComboBox {
            id: choosePlayer
            width: 200
            height: 30
            rightPadding: 30
            model: models/*ListModel {
                id: model
                ListElement { text: "1" }
                //game.qmlGetGameList();
            }*/
            editable: true
            font.family: "Microsoft YaHei"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: skinAvatar.bottom
            anchors.topMargin: 40

            property var models: Interface.getUserList()

            onAccepted: {
                var text = editText
                if(find(text) === -1){
                    Interface.addToUserList(text)
                    models = Interface.getUserList()
                    console.debug(find(text))
                    currentIndex = find(text)
                }
            }

            delegate: ItemDelegate {
                id: choosePlayerDelegate

                required property var model
                required property int index

                width: choosePlayer.width
                height: choosePlayer.height
                contentItem: Rectangle {
                    anchors.fill: parent
                    color: "transparent"

                    Text {
                        text: choosePlayerDelegate.model[choosePlayer.textRole]
                        color: "#21be2b"
                        font: choosePlayer.font
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

                        Canvas {

                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {

                            }
                        }
                    }
                }

                background: Rectangle {
                    width: choosePlayer.width - 4
                    height: choosePlayer.height
                    // opacity: enabled ? 1 : 0.3
                    // opacity: (choosePlayer.currentIndex === index) ? 0 : 1
                    color: if(choosePlayer.currentIndex === index){
                               "#dddedf"
                            } else if(choosePlayerDelegate.hovered){
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
                id: choosePlayerIndicator
                x: choosePlayer.width - width - 9
                y: choosePlayer.topPadding + (choosePlayer.availableHeight - height) / 2
                width: 12
                height: 8
                contextType: "2d"

                Connections {
                    target: choosePlayerPopup
                    function onOpened(){
                       choosePlayerIndicator.rotation = 180
                    }
                }

                Connections {
                    target: choosePlayerPopup
                    function onClosed(){
                        choosePlayerIndicator.rotation = 0
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
                    context.moveTo(0, 0);
                    context.lineTo(width, 0);
                    context.lineTo(width / 2, height);
                    context.closePath();
                    context.fillStyle = /*choosePlayer.pressed ? "#17a81a" : */"#21be2b";
                    context.fill();
                }
            }

            contentItem: TextField {
                leftPadding: 10
                rightPadding: /*parent.indicator.width + parent.spacing*/20
                // width: parent.width - 50
                text: choosePlayer.displayText
                font: choosePlayer.font
                color: /*choosePlayer.pressed ? "#17a81a" : */"#21be2b"
                verticalAlignment: Text.AlignVCenter
                // elide: Text.ElideRight

                background: Rectangle {
                    color: "transparent"
                }
            }

            background: Rectangle {
                implicitWidth: parent.width
                implicitHeight: parent.height
                color: choosePlayer.hovered ? "#dddedf" : "white"
                border.color: /*choosePlayer.pressed ? "#17a81a" : */"#21be2b"
                border.width: /*choosePlayer.visualFocus ? 2 : */1
                radius: 5
                clip: true

                Behavior on color {
                    PropertyAnimation {
                        duration: 100
                    }
                }
            }

            popup: Popup {
                id: choosePlayerPopup
                y: choosePlayer.height - 1
                // y: -243
                width: choosePlayer.width
                implicitHeight: contentItem.implicitHeight + 4 > 154 ? 154 : contentItem.implicitHeight + 4
                padding: 0
                topPadding: 2
                bottomPadding: 2

                contentItem: ListView {
                    clip: true
                    implicitHeight: contentHeight
                    model: choosePlayer.popup.visible ? choosePlayer.delegateModel : null
                    currentIndex: choosePlayer.highlightedIndex
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

        // 启动游戏按钮阴影
        MultiEffect {
            id: startButtonShadow
            shadowEnabled: false
            source: startButton
            anchors.fill: startButton
            shadowBlur: 0.6
        }

        // 启动游戏按钮
        Rectangle {
            id: startButton
            width: 200
            height: 65
            color: "white"
            radius: 5
            border.color: "#21be2b"
            border.width: 1
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: choosePlayer.bottom
            anchors.topMargin: 20

            // 颜色渐变动画
            Behavior on color {
                PropertyAnimation {
                    duration: 150
                }
            }

            // 启动游戏文字
            Text {
                id: startButtonText
                anchors.fill: parent
                text: qsTr("  启动游戏！")
                color: "#21be2b"
                font.family: "Microsoft YaHei"
                font.pixelSize: 24
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                // 颜色动画和大小动画
                Behavior on color {
                    PropertyAnimation {
                        duration: 150
                    }
                }

                Behavior on font.pixelSize {
                    PropertyAnimation {
                        duration: 30
                    }
                }
            }

            // 启动游戏按钮鼠标区
            MouseArea {
                id: startButtonMouseArea
                anchors.fill: parent
                hoverEnabled: true

                // 回到正常大小的计时器
                Timer {
                    id: startButtonTextTimer
                    interval: 80
                    onTriggered: startButtonText.font.pixelSize = 24
                }

                onEntered: {
                    startButtonShadow.shadowEnabled = true
                    startButtonText.color = "white"
                    parent.color = "#21be2b"
                }
                onExited: {
                    startButtonShadow.shadowEnabled = false
                    startButtonText.color = "#21be2b"
                    parent.color = "white"
                }
                onPressed: {
                    startButtonText.font.pixelSize = 20
                }
                onReleased: {
                    startButtonText.font.pixelSize = 28
                    startButtonTextTimer.start()
                }
                onClicked: {
                    // launcher.launch("")
                    // console.debug(game.qmlGetGameList());
                    // launcher.launch(chooseVersion.currentText)
                    console.debug(choosePlayer.currentText + " " + chooseVersion.currentText)
                    // launcher.launch(chooseVersion.currentText, choosePlayer.currentText/*, loginSwitch.loginType*/)
                    Interface.launchGame(chooseVersion.currentText, choosePlayer.currentText/*, loginSwitch.loginType*/)
                }
            }// 启动游戏按钮鼠标区
        }// 启动游戏按钮
    }// 中间的内容区
}// 启动页面
