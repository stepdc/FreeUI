local F, C, L = unpack(select(2, ...))

tinsert(C.themes["FreeUI"], function()
	F.CreateBD(RaidInfoFrame)
	F.CreateSD(RaidInfoFrame)
	F.ReskinCheck(RaidFrameAllAssistCheckButton)

	RaidInfoFrame:SetPoint("TOPLEFT", RaidFrame, "TOPRIGHT", 1, -28)
	RaidInfoDetailFooter:Hide()
	RaidInfoDetailHeader:Hide()
	RaidInfoDetailCorner:Hide()
	RaidInfoFrameHeader:Hide()

	F.Reskin(RaidFrameRaidInfoButton)
	F.Reskin(RaidFrameConvertToRaidButton)
	F.Reskin(RaidInfoExtendButton)
	F.Reskin(RaidInfoCancelButton)
	F.ReskinClose(RaidInfoCloseButton)
	F.ReskinScroll(RaidInfoScrollFrameScrollBar)
	F.ReskinClose(RaidParentFrameCloseButton)

	F.SetBD(RaidParentFrame)
	RaidInfoInstanceLabel:DisableDrawLayer("BACKGROUND")
	RaidInfoIDLabel:DisableDrawLayer("BACKGROUND")
	RaidParentFrame:DisableDrawLayer("BACKGROUND")
	RaidParentFrame:DisableDrawLayer("BORDER")
	RaidParentFrameInset:DisableDrawLayer("BORDER")
	RaidParentFrameInsetBg:Hide()
	RaidParentFramePortraitFrame:Hide()
	RaidParentFramePortrait:Hide()
	RaidParentFrameTopBorder:Hide()
	RaidParentFrameTopRightCorner:Hide()
end)