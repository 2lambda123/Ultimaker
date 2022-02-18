// Copyright (c) 2022 Ultimaker B.V.
// Uranium is released under the terms of the LGPLv3 or higher.

import QtQuick 2.1
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.1

import UM 1.5 as UM

PreferencesPage
{
    id: base

    property alias model: objectList.model
    property alias section: objectList.section
    property alias delegate: objectList.delegate
    property string nameRole: "name"
    property string sectionRole: "group"
    property bool detailsVisible: true

    property variant objectList: objectList
    property variant currentItem: null
    property string scrollviewCaption: ""

    default property alias details: detailsPane.children

    signal itemActivated()

    property alias buttons: buttonRow.children

    resetEnabled: false

    property string activeId: ""
    property int activeIndex: -1

    Row
    {
        id: buttonRow

        anchors
        {
            left: parent.left
            right: parent.right
            top: parent.top
        }

        height: childrenRect.height
    }

    Item
    {
        anchors
        {
            top: buttonRow.bottom
            topMargin: UM.Theme.getSize("default_margin").height
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        UM.Label
        {
            id: captionLabel
            anchors
            {
                top: parent.top
                left: parent.left
            }
            visible: scrollviewCaption != ""
            text: scrollviewCaption
            width: objectList.width
            elide: Text.ElideRight
        }

        ListView
        {
            id: objectList
            anchors
            {
                top: captionLabel.visible ? captionLabel.bottom : parent.top
                topMargin: captionLabel.visible ? UM.Theme.getSize("default_margin").height : 0
                bottom: parent.bottom
                left: parent.left
            }
            width: base.detailsVisible ? Math.round(parent.width * 0.4) | 0 : parent.width

            clip: true
            ScrollBar.vertical: UM.ScrollBar {}

            currentIndex: activeIndex
            onCurrentIndexChanged:
            {
                // Explicitly trigger onCurrentItemChanged
                base.currentItem = null;
                base.currentItem = (currentIndex != null) ? model.getItem(currentIndex) : null;
            }

            section.property: base.sectionRole
            section.criteria: ViewSection.FullString
            section.delegate: Rectangle
            {
                width: objectList.width - objectList.ScrollBar.vertical.width
                height: childrenRect.height
                color: palette.light

                UM.Label
                {
                    anchors.left: parent.left
                    anchors.leftMargin: UM.Theme.getSize("default_lining").width
                    text: section
                    font.bold: true
                    color: palette.text
                }
            }

            delegate: Rectangle
            {
                width: objectList.width - objectList.ScrollBar.vertical.width
                height: childrenRect.height
                color: ListView.isCurrentItem ? UM.Theme.getColor("text_selection") : UM.Theme.getColor("main_background")
                UM.Label
                {
                    anchors.left: parent.left
                    anchors.leftMargin: UM.Theme.getSize("default_margin").width
                    anchors.right: parent.right
                    text: model.name
                    elide: Text.ElideRight
                    font.italic: model.id == activeId
                }

                MouseArea
                {
                    anchors.fill: parent
                    onClicked:
                    {
                        if(!parent.ListView.isCurrentItem)
                        {
                            parent.ListView.view.currentIndex = index;
                            base.itemActivated();
                        }
                    }
                }
            }
        }

        Item
        {
            id: detailsPane

            anchors
            {
                left: objectList.right
                leftMargin: UM.Theme.getSize("default_margin").width
                top: parent.top
                bottom: parent.bottom
                right: parent.right
            }

            visible: base.detailsVisible
        }

        UM.I18nCatalog { id: catalog; name: "uranium"; }
        SystemPalette { id: palette }

        Connections
        {
            target: objectList.model

            function onItemsChanged()
            {
                var itemIndex = -1;
                if (base.currentItem === null)
                {
                    return;
                }
                for (var i = 0; i < objectList.model.count; ++i)
                {
                    if (objectList.model.getItem(i).id == base.currentItem.id)
                    {
                        itemIndex = i;
                        break;
                    }
                }

                objectList.currentIndex = itemIndex;
                base.currentItem = itemIndex >= 0 ? objectList.model.getItem(itemIndex) : null;
            }
        }
    }
}
