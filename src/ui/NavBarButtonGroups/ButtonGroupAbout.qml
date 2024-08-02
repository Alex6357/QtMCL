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

import QtQuick
import QtQuick.Layouts

Rectangle {
    id: navBarButtonGroup
    width: 500
    height: parent.height
    color: "transparent"
    anchors.centerIn: parent
    Component.onCompleted: {
        funcBar.functionTypeChanged.connect(checkFunction)
    }

    property alias layout: navBarButtonLayout
    property alias buttons: navBarButtonLayout.children

    signal changed(number: int)

    Item {
        id: navBarButtonItem
        anchors.centerIn: parent

        property int buttonWidth: 80
        property int buttonHeight: 30
        property int buttonRadius: 5

        Rectangle {
            id: navBarGroupBackGroundRectangle
            x: navBarButtonLayout.x + navBarButtonLayout.children[0].x
            width: navBarButtonItem.buttonWidth
            height: navBarButtonItem.buttonHeight
            radius: navBarButtonItem.buttonRadius
            color: "white"
            anchors.verticalCenter: parent.verticalCenter
            Component.onCompleted: navBarButtonGroup.changed.connect(checkActivate)
            function checkActivate(number: int){
                x = navBarButtonLayout.x + navBarButtonLayout.children[number - 1].x
            }
        }

        RowLayout {
            id: navBarButtonLayout
            spacing: 10
            anchors.centerIn: parent
        }
    }
}
