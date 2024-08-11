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
 * 这是“全局设置”中的“游戏设置”页面。
 */

import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import "../../QuickMCLComponents"

// 启动页面
Rectangle {
    id: pageGameSettings
    color: "transparent"
    bottomRightRadius: 5

    // 中间的内容区
    ScrollView {
        anchors.fill: parent
        clip: true
        leftPadding: 25
        topPadding: 25

        // 游戏基本设置
        Rectangle {
            width: pageGameSettings.width - 50
            height: 200
            color: "white"
            radius: 5
            border.color: "#21be2b"
            border.width: 1

            // 基本设置文字
            Text {
                id: basicConfigText
                height: 40
                width: 100
                text: qsTr("基本设置")
                font.pixelSize: 16
                font.family: "Microsoft YaHei"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.left: parent.left
                anchors.top: parent.top
            }

            // java 文字
            Text {
                id: javaText
                height: 30
                width: 120
                text: qsTr("游戏 Java")
                color: "#21be2b"
                font.pixelSize: 14
                font.family: "Microsoft YaHei"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.topMargin: 40
            }

            // java选择下拉框
            QuickMCLComboBox {
                width: parent.width - javaText.width - 25
                height: 30
                anchors.verticalCenter: javaText.verticalCenter
                anchors.left: javaText.right
                num: 9

                model: Interface.getJavaList()

                function setJava(){
                    Interface.setJava(model[currentIndex])
                }

                Component.onCompleted: {
                    currentIndex = Interface.getJavaIndex()
                    currentIndexChanged.connect(setJava)
                }
            }

            // 版本隔离文字
            Text {
                id: seperateText
                height: 30
                width: 120
                text: qsTr("版本隔离")
                color: "#21be2b"
                font.pixelSize: 14
                font.family: "Microsoft YaHei"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.left: parent.left
                anchors.top: javaText.bottom
                anchors.topMargin: 10
            }

            // 版本隔离下拉框
            QuickMCLComboBox {
                width: parent.width - seperateText.width - 25
                height: 30
                anchors.verticalCenter: seperateText.verticalCenter
                anchors.left: seperateText.right
                num: 9

                model: ["开启", "关闭"]

                function setSeperate(){
                    if (currentIndex === 0){
                        Interface.setSeperate(true)
                    } else {
                        Interface.setSeperate(false)
                    }
                }

                Component.onCompleted: {
                    if (Interface.getSeperate() === true){
                        currentIndex = 0
                    } else {
                        currentIndex = 1
                    }
                    currentIndexChanged.connect(setSeperate)
                }
            }

            // 游戏内存文字
            Text {
                id: memoryText
                height: 30
                width: 120
                text: qsTr("游戏内存")
                color: "#21be2b"
                font.pixelSize: 14
                font.family: "Microsoft YaHei"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.left: parent.left
                anchors.top: seperateText.bottom
                anchors.topMargin: 10
            }

            // 游戏内存滑动条
            // **需要的话做成模板
            Slider {
                id: memorySlider
                width: parent.width - memoryText.width - memorySize.width - 25
                height: 30
                anchors.verticalCenter: memoryText.verticalCenter
                anchors.left: memoryText.right
                from: 256
                to: Interface.getTotalMemoryMiB()
                value: Interface.getMemory()
                stepSize: 1

                // 滑动条本身，分左右两个矩形
                background: Rectangle {
                    x: memorySlider.leftPadding
                    y: memorySlider.topPadding + memorySlider.availableHeight / 2 - height / 2
                    implicitWidth: 200
                    implicitHeight: 4
                    width: memorySlider.availableWidth
                    height: implicitHeight
                    radius: 2
                    color: "#bdbebf"

                    Rectangle {
                        width: memorySlider.visualPosition * parent.width
                        height: parent.height
                        color: "#21be2b"
                        radius: 2
                    }
                }

                // 把手，滑动条的球
                handle: Rectangle {
                    x: memorySlider.leftPadding + memorySlider.visualPosition * (memorySlider.availableWidth - width)
                    y: memorySlider.topPadding + memorySlider.availableHeight / 2 - height / 2
                    implicitWidth: 18
                    implicitHeight: 18
                    radius: 9
                    color: memorySlider.pressed ? "#f0f0f0" : "#f6f6f6"
                    border.color: "#bdbebf"
                }

                // 跟文字同步变化
                onMoved: {
                    memorySizeText.text = value.toString()
                }

                // onValueChanged: {
                //     if (!pressed){
                //         console.debug(value)
                //     }
                // }

                // 松手之后再设置
                onPressedChanged: {
                    if (!pressed){
                        Interface.setMemory(value)
                    }
                }
            }// 游戏内存滑动条

            // 内存数值
            Rectangle {
                id: memorySize
                height: 30
                width: 100
                anchors.right: parent.right
                anchors.rightMargin: 25
                anchors.verticalCenter: memoryText.verticalCenter
                radius: 5
                border.color: "#21be2b"
                border.width: 1

                // 内存数值的数字
                TextField {
                    id: memorySizeText
                    height: 28
                    width: 60
                    leftInset: 0
                    rightInset: 0
                    leftPadding: 0
                    rightPadding: 0
                    // 设置背景防止有边框
                    background: Rectangle {
                        color: "transparent"
                    }

                    // 暂时限制为 256 到最大物理内存
                    validator: IntValidator {
                        bottom: 256
                        top: Interface.getTotalMemoryMiB()
                    }

                    text: Interface.getMemory().toString()
                    color: "black"
                    font.pixelSize: 14
                    font.family: "Microsoft YaHei"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: memorySizeTextMib.left

                    onAccepted: {
                        memorySlider.value = Number(text)
                        Interface.setMemory(memorySlider.value)
                        focus = false
                    }

                    // onTextChanged: {
                    //     if (Number(text) > Interface.getTotalMemoryMiB()){
                    //         text = Interface.getTotalMemoryMiB().toString()
                    //     }
                    //     memorySlider.value = Number(text)
                    // }

                    // onFocusChanged: {
                    //     if (Number(text) < 256){
                    //         text = "256"
                    //     }
                    // }
                }

                // 内存数值单位
                Text {
                    id: memorySizeTextMib
                    text: "MiB"
                    color: "#21be2b"
                    font.pixelSize: 14
                    font.family: "Microsoft YaHei"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                }
            }// 内存数值
        }// 游戏基本设置
    }// 中间的内容区
}// 启动页面
