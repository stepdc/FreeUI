local F, C, L = unpack(select(2, ...))

tinsert(C.themes["FreeUI"], function()
	MovieFrame.CloseDialog:HookScript("OnShow", function(self)
		self:SetScale(UIParent:GetScale())
	end)

	F.CreateBD(MovieFrame.CloseDialog)
	F.CreateSD(MovieFrame.CloseDialog)
	F.Reskin(MovieFrame.CloseDialog.ConfirmButton)
	F.Reskin(MovieFrame.CloseDialog.ResumeButton)
end)