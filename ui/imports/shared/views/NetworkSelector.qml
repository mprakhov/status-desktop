﻿import QtQuick 2.13
import QtQuick.Layouts 1.13

import utils 1.0

import StatusQ.Controls 0.1
import StatusQ.Popups 0.1
import StatusQ.Components 0.1
import StatusQ.Core 0.1
import StatusQ.Core.Theme 0.1

import "../controls"

Item {
    id: root

    implicitHeight: visible ? tabBar.height + stackLayout.height + Style.current.xlPadding : 0

    property var store
    property var selectedAccount
    property var selectedAsset
    property double amountToSend: 0
    property double requiredGasInEth: 0
    property var bestRoutes
    property bool isLoading: false
    property bool advancedOrCustomMode: (tabBar.currentIndex === 1) || (tabBar.currentIndex === 2)
    property bool errorMode: advancedNetworkRoutingPage.errorMode
    property bool interactive: true
    property bool isBridgeTx: false
    property bool showUnpreferredNetworks: advancedNetworkRoutingPage.showUnpreferredNetworks
    property var toNetworksList: []

    signal reCalculateSuggestedRoute()

    QtObject {
        id: d
        readonly property int backgroundRectRadius: 13
        readonly property string backgroundRectColor: Theme.palette.indirectColor1
    }

    StatusSwitchTabBar {
        id: tabBar
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        StatusSwitchTabButton {
            text: qsTr("Simple")
        }
        StatusSwitchTabButton {
            text: qsTr("Advanced")
        }
        StatusSwitchTabButton {
            text: qsTr("Custom")
        }
    }

    StackLayout {
        id: stackLayout
        anchors.top: tabBar.bottom
        anchors.topMargin: Style.current.bigPadding
        height: currentIndex == 0 ? networksSimpleRoutingPage.height + networksSimpleRoutingPage.anchors.margins + Style.current.bigPadding:
                                   advancedNetworkRoutingPage.height + advancedNetworkRoutingPage.anchors.margins + Style.current.bigPadding
        width: parent.width
        currentIndex: tabBar.currentIndex === 0 ? 0 : 1

        Rectangle {
            id: simple
            radius: d.backgroundRectRadius
            color: d.backgroundRectColor
            NetworksSimpleRoutingView {
                id: networksSimpleRoutingPage
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.margins: Style.current.padding
                width: stackLayout.width  - Style.current.bigPadding
                bestRoutes: root.bestRoutes
                isBridgeTx: root.isBridgeTx
                amountToSend: root.amountToSend
                isLoading: root.isLoading
                store: root.store
                selectedAsset: root.selectedAsset
                selectedAccount: root.selectedAccount
                errorMode: root.errorMode
                toNetworksList: root.toNetworksList
                weiToEth: function(wei) {
                    return "%1 %2".arg(LocaleUtils.numberToLocaleString(parseFloat(store.getWei2Eth(wei, selectedAsset.decimals)))).arg(selectedAsset.symbol)
                }
                reCalculateSuggestedRoute: function() {
                    root.reCalculateSuggestedRoute()
                }
            }
        }

        Rectangle {
            id: advanced
            radius: d.backgroundRectRadius
            color: d.backgroundRectColor
            NetworksAdvancedCustomRoutingView {
                id: advancedNetworkRoutingPage
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.margins: Style.current.padding
                store: root.store
                customMode: tabBar.currentIndex === 2
                selectedAccount: root.selectedAccount
                amountToSend: root.amountToSend
                requiredGasInEth: root.requiredGasInEth
                selectedAsset: root.selectedAsset
                onReCalculateSuggestedRoute: root.reCalculateSuggestedRoute()
                bestRoutes: root.bestRoutes
                isLoading: root.isLoading
                interactive: root.interactive
                isBridgeTx: root.isBridgeTx
                weiToEth: function(wei) {
                    return parseFloat(store.getWei2Eth(wei, selectedAsset.decimals))
                }
            }
        }
    }
}
