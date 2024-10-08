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
 * 这是QuickMCL的主窗口文件。主窗口由阴影背景、导航栏、功能栏、内容区组成。这里也包括拖放检测区。
 */

import QtQuick
import QtQuick.Effects

// 主窗口
Window {
    id: rootWindow
    // 窗口大小 800x450，预留 5 的阴影区
    width: 810
    height: 460
    minimumWidth: 810
    minimumHeight: 460
    visible: true
    color: "transparent"
    // 无边框窗口并启用任务栏最小化和恢复
    flags: Qt.Window | Qt.FramelessWindowHint | Qt.WindowSystemMenuHint | Qt.WindowMinMaxButtonsHint
    title: qsTr("QuickMCL")
    // 解决无边框窗口从最小化恢复时多出标题栏的 bug
    property bool isMinimized: false
    onVisibilityChanged: {
        if(rootWindow.visibility === Window.Minimized){
            rootWindow.isMinimized = true
            rootWindow.flags = Qt.Window
        } else if(rootWindow.isMinimized === true){
            rootWindow.flags = Qt.Window | Qt.FramelessWindowHint | Qt.WindowSystemMenuHint | Qt.WindowMinMaxButtonsHint
            rootWindow.isMinimized = false
        }
    }

    // 连接关闭按钮信号
    Connections {
        target: navBar.closeButton.mouseArea
        function onClicked(){
            rootWindow.close()
        }
    }

    // 连接最小化按钮信号
    Connections {
        target: navBar.minimizeButton.mouseArea
        function onClicked(){
            rootWindow.showMinimized()
        }
    }

    // 连接拖动区信号
    Connections {
        target: navBar.mouseArea
        function onPressed(){
            // 开始拖动
            rootWindow.startSystemMove()
        }
        function onReleased(){
            // 防止导航栏被拖到任务栏下或屏幕上方
            if(rootWindow.y < 0){
                rootWindow.y = 0
            }
            if(rootWindow.y > Screen.desktopAvailableHeight - navBar.height - 5){
                rootWindow.y = Screen.desktopAvailableHeight - navBar.height - 5
            }
        }
    }

    // 功能栏信号连接到导航栏
    Connections {
        target: funcBar
        function onFunctionTypeChanged(){
            navBar.buttonGroupLaunch.checkFunction(funcBar.functionType)
            navBar.buttonGroupDownload.checkFunction(funcBar.functionType)
            navBar.buttonGroupSettings.checkFunction(funcBar.functionType)
            // navBar.buttonGroupAbout.checkFunction(func)
            mainContentArea.switchFunction(funcBar.functionType, 0)
        }
    }

    Connections {
        target: navBar.buttonGroupLaunch
        function onLaunchFunctionChanged(){
            mainContentArea.switchFunction(funcBar.functionType, navBar.buttonGroupLaunch.launchFunction)
        }
    }
    Connections {
        target: navBar.buttonGroupDownload
        function onDownloadFunctionChanged(){
            mainContentArea.switchFunction(funcBar.functionType, navBar.buttonGroupDownload.downloadFunction)
        }
    }
    Connections {
        target: navBar.buttonGroupSettings
        function onSettingsFunctionChanged(){
            mainContentArea.switchFunction(funcBar.functionType, navBar.buttonGroupSettings.settingsFunction)
        }
    }
    // Connections {
    //     target: navBar.buttonGroupAbout
    //     function onAboutFunctionChanged(){
    //         mainContentArea.switchFunction(funcBar.functionType, navBar.buttonGroupAbout.aboutFunction)
    //     }
    // }

    // 包装 Item，方便对齐
    Item {
        id: rootItem
        // 边缘拖放检测大小
        property int dragAreaWidth: 10
        property int angleDragAreaWidth: 12
        anchors.fill: parent

        // 添加阴影效果
        MultiEffect {
            id: rootAreaShadow
            shadowEnabled: true
            source: rootArea
            anchors.fill: rootArea
            shadowBlur: 0.2
        }

        // 主区域
        Rectangle {
            id: rootArea
            width: parent.width - 10
            height: parent.height - 10
            anchors.centerIn: parent
            radius: 5

            // 导航栏
            NavBar {
                id: navBar
                width: parent.width
                height: 45
                anchors.left: parent.left
                anchors.top: parent.top
                topLeftRadius: 5
                topRightRadius: 5
            }

            // 功能栏
            FuncBar {
                id: funcBar
                width: 150
                height: parent.height - navBar.height
                anchors.left: navBar.left
                anchors.top: navBar.bottom
                anchors.leftMargin: 0
                anchors.topMargin: 0
                bottomLeftRadius: 5
            }

            // 功能栏在内容区的阴影，用渐变色长方形代替
            Rectangle {
                id: funcBarShadow
                width: 4
                height: funcBar.height
                anchors.left: funcBar.right
                anchors.top: navBar.bottom
                anchors.rightMargin: 0
                anchors.topMargin: 0
                color: "#e9faf0"

                Rectangle {
                    anchors.fill: parent
                    gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop {
                            position:0
                            color: "#14000000"
                        }
                        GradientStop {
                            position:1
                            color: "#00000000"
                        }
                    }
                }
            }

            // 内容区
            ContentArea {
                id: mainContentArea
                width: parent.width - funcBar.width - funcBarShadow.width + 1
                height: funcBar.height
                anchors.left: funcBarShadow.right
                anchors.top: navBar.bottom
                anchors.leftMargin: -1
                bottomRightRadius: 5
            }
        }// 主区域

        // 拖放检测区
        MouseArea {
            id: leftDragArea
            width: parent.dragAreaWidth
            height: parent.height - parent.angleDragAreaWidth * 2
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            cursorShape: Qt.SizeHorCursor
            onPressed: rootWindow.startSystemResize(Qt.LeftEdge)
        }
        MouseArea {
            id: rightDragArea
            width: parent.dragAreaWidth
            height: parent.height - parent.angleDragAreaWidth * 2
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            cursorShape: Qt.SizeHorCursor
            onPressed: rootWindow.startSystemResize(Qt.RightEdge)
        }
        MouseArea {
            id: topDragArea
            height: parent.dragAreaWidth
            width: parent.width - parent.angleDragAreaWidth * 2
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            cursorShape: Qt.SizeVerCursor
            onPressed: rootWindow.startSystemResize(Qt.TopEdge)
        }
        MouseArea {
            id: bottomDragArea
            height: parent.dragAreaWidth
            width: parent.width - parent.angleDragAreaWidth * 2
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            cursorShape: Qt.SizeVerCursor
            onPressed: rootWindow.startSystemResize(Qt.BottomEdge)
        }
        MouseArea {
            id: topLeftDragArea
            width: parent.angleDragAreaWidth
            height: parent.angleDragAreaWidth
            anchors.top: parent.top
            anchors.left: parent.left
            cursorShape: Qt.SizeFDiagCursor
            onPressed: rootWindow.startSystemResize(Qt.TopEdge | Qt.LeftEdge)
        }
        MouseArea {
            id: topRightDragArea
            width: parent.angleDragAreaWidth
            height: parent.angleDragAreaWidth
            anchors.top: parent.top
            anchors.right: parent.right
            cursorShape: Qt.SizeBDiagCursor
            onPressed: rootWindow.startSystemResize(Qt.TopEdge | Qt.RightEdge)
        }
        MouseArea {
            id: bottomLeftDragArea
            width: parent.angleDragAreaWidth
            height: parent.angleDragAreaWidth
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            cursorShape: Qt.SizeBDiagCursor
            onPressed: rootWindow.startSystemResize(Qt.BottomEdge | Qt.LeftEdge)
        }
        MouseArea {
            id: bottomRightDragArea
            width: parent.angleDragAreaWidth
            height: parent.angleDragAreaWidth
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            cursorShape: Qt.SizeFDiagCursor
            onPressed: rootWindow.startSystemResize(Qt.BottomEdge | Qt.RightEdge)
        }// 拖放检测区
    }// 包装 Item，方便对齐
}// 主窗口
