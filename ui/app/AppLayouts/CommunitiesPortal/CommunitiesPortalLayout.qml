import QtQuick 2.13
import QtQuick.Layouts 1.13

import StatusQ.Core 0.1
import StatusQ.Core.Theme 0.1
import StatusQ.Controls 0.1
import StatusQ.Components 0.1
import StatusQ.Popups 0.1
import StatusQ.Popups.Dialog 0.1
import StatusQ.Layout 0.1

import utils 1.0
import shared.controls 1.0
import shared.popups 1.0
import shared.panels 1.0

import SortFilterProxyModel 0.2

import AppLayouts.CommunitiesPortal.stores 1.0

import "controls"
import "popups"
import "views"

StatusSectionLayout {
    id: root
    objectName: "communitiesPortalLayout"

    property CommunitiesStore communitiesStore: CommunitiesStore {}
    property var importCommunitiesPopup: importCommunitiesPopupComponent
    property var createCommunitiesPopup: createCommunitiesPopupComponent
    property var discordImportProgressPopup: discordImportProgressDialog

    notificationCount: activityCenterStore.unreadNotificationsCount
    onNotificationButtonClicked: Global.openActivityCenterPopup()

    onVisibleChanged: {
        if(visible)
            searcher.input.edit.forceActiveFocus()
    }

    QtObject {
        id: d

        // values from the design
        readonly property int layoutTopMargin: 10
        readonly property int layoutBottomMargin: 249
        readonly property int layoutHMargin: 64
        readonly property int layoutWidth: 1037
        readonly property int titlePixelSize: 28
        readonly property int preventShadowClipMargin: 40

        readonly property bool searchMode: searcher.text.length > 0
    }

    SortFilterProxyModel {
        id: filteredCommunitiesModel

        function selectedTagsPredicate(selectedTagsNames, tagsJSON) {
            const tags = JSON.parse(tagsJSON)
            for (const i in tags) {
                selectedTagsNames = selectedTagsNames.filter(name => name !== tags[i].name)
            }
            return selectedTagsNames.length === 0
        }

        sourceModel: root.communitiesStore.curatedCommunitiesModel

        filters: [
            ExpressionFilter {
                enabled: d.searchMode
                expression: {
                    searcher.text
                    return name.toLowerCase().includes(searcher.text.toLowerCase())
                }
            },
            ExpressionFilter {
                expression: {
                    return filteredCommunitiesModel.selectedTagsPredicate(communityTags.selectedTagsNames, model.tags)
                }
            }
        ]
    }

    centerPanel: Item {
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        width: d.layoutWidth

        anchors.topMargin: d.layoutTopMargin
        anchors.leftMargin: d.layoutHMargin

        ColumnLayout {
            id: column

            anchors.fill: parent
            spacing: 18

            StatusBaseText {
                text: qsTr("Discover Communities")
                font.weight: Font.Bold
                font.pixelSize: d.titlePixelSize
                color: Theme.palette.directColor1
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 38
                spacing: Style.current.bigPadding

                SearchBox {
                    id: searcher
                    implicitWidth: 327
                    Layout.alignment: Qt.AlignVCenter
                    topPadding: 0
                    bottomPadding: 0
                    minimumHeight: 36
                    maximumHeight: 36
                }

                // Just a row filler to fit design
                Item { Layout.fillWidth: true }

                StatusButton {
                    id: importBtn
                    Layout.preferredHeight: 38
                    text: qsTr("Import using key")
                    verticalPadding: 0
                    onClicked: Global.openPopup(importCommunitiesPopupComponent)
                }

                StatusButton {
                    id: createBtn
                    objectName: "createCommunityButton"
                    Layout.preferredHeight: 38
                    verticalPadding: 0
                    text: qsTr("Create New Community")
                    onClicked: {
                        if (localAccountSensitiveSettings.isDiscordImportToolEnabled) {
                            Global.openPopup(chooseCommunityCreationTypePopupComponent)
                        } else {
                            Global.openPopup(createCommunitiesPopupComponent)
                        }
                    }
                }
            }

            CommunityTagsRow {
                id: communityTags
                Layout.fillWidth: true

                tags: root.communitiesStore.communityTags
            }

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.leftMargin: -d.preventShadowClipMargin
                Layout.rightMargin: -d.preventShadowClipMargin

                clip: true

                CommunitiesGridView {
                    id: communitiesGrid
                    anchors.fill: parent
                    anchors.rightMargin: d.preventShadowClipMargin
                    anchors.leftMargin: d.preventShadowClipMargin

                    padding: 0
                    bottomPadding: d.layoutBottomMargin

                    locale: communitiesStore.locale
                    model: filteredCommunitiesModel
                    searchLayout: d.searchMode

                    onCardClicked: root.communitiesStore.navigateToCommunity(communityId)
                }

                StatusBaseText {
                    anchors.top: parent.top
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.topMargin: parent.height / 3.1
                    visible: (d.searchMode && filteredCommunitiesModel.count === 0) || communitiesGrid.isEmpty
                    text: qsTr("No communities found")
                    color: Theme.palette.baseColor1
                    font.pixelSize: 15
                }
            }
        }
    }

    Component {
        id: importCommunitiesPopupComponent
        ImportCommunityPopup {
            anchors.centerIn: parent
            store: root.communitiesStore
            onClosed: {
                destroy()
            }
        }
    }

    Component {
        id: createCommunitiesPopupComponent
        CreateCommunityPopup {
            anchors.centerIn: parent
            store: root.communitiesStore
            onClosed: {
                destroy()
            }
        }
    }

    Component {
        id: chooseCommunityCreationTypePopupComponent
        StatusDialog {
            id: chooseCommunityCreationTypePopup
            title: qsTr("Create new community")
            horizontalPadding: 40
            verticalPadding: 60
            footer: null
            onClosed: destroy()

            contentItem: RowLayout {
                spacing: 20
                CommunityBanner {
                    text: qsTr("Create a new Status community")
                    buttonText: qsTr("Create new")
                    icon.name: "favourite"
                    onButtonClicked: {
                        chooseCommunityCreationTypePopup.close()
                        Global.openPopup(createCommunitiesPopupComponent)
                    }
                }
                CommunityBanner {
                    readonly property bool importInProgress: root.communitiesStore.discordImportInProgress && !root.communitiesStore.discordImportCancelled
                    text: importInProgress ?
                        qsTr("'%1' import in progress...").arg(root.communitiesStore.discordImportCommunityName) :
                        qsTr("Import existing Discord community into Status")
                    buttonText: qsTr("Import existing")
                    icon.name: "download"
                    buttonTooltipText: qsTr("Your current import must be finished or cancelled before a new import can be started.")
                    buttonLoading: importInProgress
                    onButtonClicked: {
                        chooseCommunityCreationTypePopup.close()
                        Global.openPopup(createCommunitiesPopupComponent, {isDiscordImport: true})
                    }
                }
            }
        }
    }

    Component {
        id: discordImportProgressDialog
        DiscordImportProgressDialog {
            store: root.communitiesStore
        }
    }
}
