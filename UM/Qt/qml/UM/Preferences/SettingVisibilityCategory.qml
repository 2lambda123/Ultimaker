// Copyright (c) 2022 Ultimaker B.V.
// Uranium is released under the terms of the LGPLv3 or higher.

import QtQuick 2.2
import QtQuick.Controls 2.1

import UM 1.1 as UM

import ".."

Button {
    id: base;

    background: Item { }

    contentItem: Row
    {
        spacing: UM.Theme.getSize("default_lining").width

        UM.RecolorImage
        {
            anchors.verticalCenter: parent.verticalCenter
            height: (label.height / 2) | 0
            width: height
            source: base.checked ? UM.Theme.getIcon("ChevronSingleDown") : UM.Theme.getIcon("ChevronSingleRight");
            color: base.hovered ? palette.highlight : palette.buttonText
        }
        UM.RecolorImage
        {
            anchors.verticalCenter: parent.verticalCenter
            height: label.height
            width: height
            source: definition ? UM.Theme.getIcon(definition.icon) : ""
            color: base.hovered ? palette.highlight : palette.buttonText
        }
        Label
        {
            id: label
            anchors.verticalCenter: parent.verticalCenter
            text: base.text
            color: base.hovered ? palette.highlight : palette.buttonText
            font.bold: true
        }

        SystemPalette { id: palette }
    }

    signal showTooltip(string text);
    signal hideTooltip();
    signal contextMenuRequested()

    text: definition ? definition.label : ""

    checkable: true
    checked: definition? definition.expanded : ""

    onClicked: definition.expanded ? settingDefinitionsModel.collapseRecursive(definition.key) : settingDefinitionsModel.expandRecursive(definition.key)
}
