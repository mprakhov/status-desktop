
statusDesktop_mainWindow = {"name": "mainWindow", "type": "StatusWindow", "visible": True}
statusDesktop_mainWindow_overlay = {"container": statusDesktop_mainWindow, "type": "Overlay", "unnamed": 1, "visible": True}
mainWindow_navBarListView_ListView = {"container": statusDesktop_mainWindow, "objectName": "statusMainNavBarListView", "type": "ListView", "visible": True}
chatView_log = {"container": statusDesktop_mainWindow, "objectName": "chatLogView", "type": "StatusListView", "visible": True}
secureSeedPhrase_Banner = {"container": statusDesktop_mainWindow, "objectName": "secureYourSeedPhraseBanner", "type": "ModuleWarning"}
connectionInfo_Banner = {"container": statusDesktop_mainWindow, "objectName": "connectionInfoBanner", "type": "ModuleWarning"}
appVersionUpdate_Banner = {"container": statusDesktop_mainWindow, "objectName": "appVersionUpdateBanner", "type": "ModuleWarning"}
testnetInfo_Banner = {"container": statusDesktop_mainWindow, "objectName": "testnetBanner", "type": "ModuleWarning"}
statusDesktop_mainWindow_AppMain_EmojiPopup_SearchTextInput = {"container": statusDesktop_mainWindow_overlay, "objectName": "StatusEmojiPopup_searchBox", "type": "TextEdit", "visible": True}
mainWindow_ScrollView = {"container": statusDesktop_mainWindow, "type": "StatusScrollView", "unnamed": 1, "visible": True}
mainWindow_ScrollView_2 = {"container": statusDesktop_mainWindow, "occurrence": 2, "type": "StatusScrollView", "unnamed": 1, "visible": True}
mainWindow_ProfileNavBarButton = {"container": statusDesktop_mainWindow, "objectName": "statusProfileNavBarTabButton", "type": "StatusNavBarTabButton", "visible": True}
mainWindow_ProfileSettingsView = {"container": statusDesktop_mainWindow, "objectName": "myProfileSettingsView", "type": "MyProfileSettingsView", "visible": True}
settings_navbar_settings_icon_StatusIcon = {"container": mainWindow_navBarListView_ListView, "objectName": "settings-icon", "type": "StatusIcon", "visible": True}
splashScreen = {"container": statusDesktop_mainWindow, "objectName": "splashScreen", "type": "SplashScreen"}
mainWindow_StatusToolBar = {"container": statusDesktop_mainWindow, "objectName": "statusToolBar", "type": "StatusToolBar", "visible": True}
main_toolBar_back_button = {"container": mainWindow_StatusToolBar, "objectName": "toolBarBackButton", "type": "StatusFlatButton", "visible": True}
mainWindow_emptyChatPanelImage = {"container": statusDesktop_mainWindow, "objectName": "emptyChatPanelImage", "type": "Image", "visible": True}


# main right panel
mainWindow_RighPanel= {"container": statusDesktop_mainWindow, "type": "ColumnLayout", "objectName": "mainRightView", "visible": True}

# User Status Profile Menu
userContextmenu_AlwaysActiveButton= {"container": statusDesktop_mainWindow_overlay, "objectName": "userStatusMenuAlwaysOnlineAction", "type": "StatusMenuItem", "visible": True}
userContextmenu_InActiveButton= {"container": statusDesktop_mainWindow_overlay, "objectName": "userStatusMenuInactiveAction", "type": "StatusMenuItem", "visible": True}
userContextmenu_AutomaticButton= {"container": statusDesktop_mainWindow_overlay, "objectName": "userStatusMenuAutomaticAction", "type": "StatusMenuItem", "visible": True}
userContextMenu_ViewMyProfileAction = {"container": statusDesktop_mainWindow_overlay, "objectName": "userStatusViewMyProfileAction", "type": "StatusMenuItem", "visible": True}

# popups
modal_Close_Button = {"container": statusDesktop_mainWindow_overlay, "objectName": "modalCloseButtonRectangle", "type": "Rectangle", "visible": True}
delete_Channel_ConfirmationDialog_DeleteButton = {"container": statusDesktop_mainWindow_overlay, "objectName": "deleteChatConfirmationDialogDeleteButton", "type": "StatusButton"}
closeButton_StatusHeaderAction = {"container": statusDesktop_mainWindow_overlay, "objectName": "headerActionsCloseButton", "type": "StatusFlatRoundButton", "visible": True}

# Main Window - chat related:
mainWindow_statusChatNavBarListView_ListView = {"container": statusDesktop_mainWindow, "objectName": "statusChatNavBarListView", "type": "ListView", "visible": True}
navBarListView_Chat_navbar_StatusNavBarTabButton = {"checkable": True, "container": mainWindow_statusChatNavBarListView_ListView, "objectName": "Messages-navbar", "type": "StatusNavBarTabButton", "visible": True}
mainWindow_public_chat_icon_StatusIcon = {"container": statusDesktop_mainWindow, "objectName": "public-chat-icon", "source": "qrc:/StatusQ/src/assets/img/icons/public-chat.svg", "type": "StatusIcon", "visible": True}
chatList_Repeater = {"container": statusDesktop_mainWindow, "objectName": "chatListItems", "type": "Repeater"}
chatList = {"container": statusDesktop_mainWindow, "objectName": "ContactsColumnView_chatList", "type": "StatusChatList"}
mainWindow_startChat = {"checkable": True, "container": statusDesktop_mainWindow, "objectName": "startChatButton", "type": "StatusIconTabButton"}
join_public_chat_StatusMenuItem = {"checkable": False, "container": statusDesktop_mainWindow_overlay, "enabled": True, "text": "Join public chat", "type": "StatusMenuItem", "unnamed": 1, "visible": True}
chatView_messageInput = {"container": statusDesktop_mainWindow, "objectName": "messageInputField", "type": "TextArea", "visible": True}
chatView_StatusChatInfoButton = {"container": statusDesktop_mainWindow, "objectName": "chatInfoBtnInHeader", "type": "StatusChatInfoButton", "visible": True}
chatInfoButton_Pin_Text = {"container": chatView_StatusChatInfoButton, "objectName": "StatusChatInfo_pinText", "type": "StatusBaseText", "visible": True}
joinPublicChat_input = {"container": statusDesktop_mainWindow_overlay, "objectName": "joinPublicChannelInput", "type": "TextEdit", "visible": True}
startChat_Btn = {"container": statusDesktop_mainWindow_overlay, "objectName": "startChatButton", "type": "StatusButton"}

# My Profile Popup
ProfileHeader_userImage = {"container": statusDesktop_mainWindow_overlay, "objectName": "ProfileHeader_userImage", "type": "UserImage", "visible": True}
ProfilePopup_displayName = {"container": statusDesktop_mainWindow_overlay, "objectName": "ProfileDialog_displayName", "type": "StatusBaseText", "visible": True}
ProfilePopup_editButton = {"container": statusDesktop_mainWindow_overlay, "objectName": "editProfileButton", "type": "StatusButton", "visible": True}