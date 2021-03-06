local F, C = unpack(select(2, ...))



--local mainFont

--if C.appearance.fontUseAlternativeFont then
--	mainFont = C.font.normal
--else
--	mainFont = C.font.pixel
--end

--F.AddOptionsCallback("appearance", "fontUseAlternativeFont", function()
--	if C.appearance.fontUseAlternativeFont then
--		mainFont = C.font.normal
--	else
--		mainFont = C.font.pixel
--	end
--end)

local _, class = UnitClass("player")

if C.appearance.colourScheme == 2 then
	C.class = {C.appearance.customColour.r, C.appearance.customColour.g, C.appearance.customColour.b}
else
	C.class = {C.classcolours[class].r, C.classcolours[class].g, C.classcolours[class].b}
end

C.r, C.g, C.b = unpack(C.class)
C.texCoord = {.08, .92, .08, .92}



r, g, b = C.r, C.g, C.b

C.myColor = format("|cff%02x%02x%02x", r*255, g*255, b*255)
C.infoColor = "|cff70c0f5"


C.reactioncolours = {
	[1] = {1, .12, .24},
	[2] = {1, .12, .24},
	[3] = {1, .12, .24},
	[4] = {1, 1, 0.3},
	[5] = {0.26, 1, 0.22},
	[6] = {0.26, 1, 0.22},
	[7] = {0.26, 1, 0.22},
	[8] = {0.26, 1, 0.22},
}

C.myClass = class
C.myName = UnitName("player")
C.myRealm = GetRealmName()

C.client = GetLocale()



-- [[ Functions ]]


function F:Dummy()
	return
end

-- compatibility with Aurora plugins that are compatible with Aurora's custom style system
F.AddPlugin = function(func)
	func()
end

F.CreateFS = function(parent, fontSize, justify)
	local f = parent:CreateFontString(nil, "OVERLAY")
	F.SetFS(f, fontSize)

	if justify then f:SetJustifyH(justify) end

	return f
end

F.SetFS = function(fontObject, fontSize)
	local size

	if(not fontSize or fontSize == C.FONT_SIZE_NORMAL) then
		size = C.appearance.fontSizeNormal
	elseif fontSize == C.FONT_SIZE_LARGE then
		size = C.appearance.fontSizeLarge
	elseif fontSize > 4 then -- actual size
		size = fontSize
	end

	local outline = nil
	if C.appearance.fontOutline then
		outline = C.appearance.fontOutlineStyle == 2 and "OUTLINEMONOCHROME" or "OUTLINE"
	end

	fontObject:SetFont(C.font.pixel, size, outline)

	if C.appearance.fontShadow then
		fontObject:SetShadowColor(0, 0, 0)
		fontObject:SetShadowOffset(1, -1)
	else
		fontObject:SetShadowOffset(0, 0)
	end
end

--[[F.SetFS = function(fontObject, fontSize)
	--local size

	--if(not fontSize or fontSize == C.FONT_SIZE_NORMAL) then
	--	size = C.appearance.fontSizeNormal
	--elseif fontSize == C.FONT_SIZE_LARGE then
	--	size = C.appearance.fontSizeLarge
	--elseif fontSize > 4 then -- actual size
	--	size = fontSize
	--end

	--local outline = nil
	--if C.appearance.fontOutline then
	--	outline = C.appearance.fontOutlineStyle == 2 and "OUTLINEMONOCHROME" or "OUTLINE"
	--end



	fontObject:SetFont(C.font.pixel, 8, "OUTLINEMONOCHROME")

	--if C.appearance.fontShadow then
	--	fontObject:SetShadowColor(0, 0, 0)
	--	fontObject:SetShadowOffset(1, -1)
	--else
	--	fontObject:SetShadowOffset(0, 0)
	--end

	fontObject:SetShadowColor(0, 0, 0)
	fontObject:SetShadowOffset(1, -1)
end]]


function F:CreatePFS(text, classcolor, anchor, x, y)
	local fs = self:CreateFontString(nil, "OVERLAY")
	fs:SetFont(C.font.pixel, 8, "OUTLINEMONOCHROME")
	fs:SetText(text)
	fs:SetWordWrap(false)
	--if classcolor then fs:SetTextColor(cr, cg, cb) end
	fs:SetTextColor(1, 1, 1)
	if anchor and x and y then
		fs:SetPoint(anchor, x, y)
	else
		fs:SetPoint("CENTER", 1, 0)
	end

	return fs
end

function F:CreateTex()
	if self.Tex then return end

	local frame = self
	if self:GetObjectType() == "Texture" then frame = self:GetParent() end

	self.Tex = frame:CreateTexture(nil, "BACKGROUND", nil, 1)
	self.Tex:SetAllPoints(self)
	self.Tex:SetTexture(C.media.bgtex, true, true)
	self.Tex:SetHorizTile(true)
	self.Tex:SetVertTile(true)
	self.Tex:SetBlendMode("ADD")
end


local function CreateTex(f)
	if f.Tex then return end
	f.Tex = f:CreateTexture(nil, "BACKGROUND", nil, 1)
	f.Tex:SetAllPoints()
	f.Tex:SetTexture(C.media.bgtex, true, true)
	f.Tex:SetHorizTile(true)
	f.Tex:SetVertTile(true)
	f.Tex:SetBlendMode("ADD")
end

function F:CreateSD(a)
	if not C.themeconfig.shadow then return end
	if self.Shadow then return end
	self.Shadow = CreateFrame("Frame", nil, self)
	self.Shadow:SetPoint("TOPLEFT", -3, 3)
	self.Shadow:SetPoint("BOTTOMRIGHT", 3, -3)
	self.Shadow:SetBackdrop({edgeFile = C.media.glowtex, edgeSize = 4})
	self.Shadow:SetBackdropBorderColor(0, 0, 0, a or .6)
	CreateTex(self)
	return self.Shadow
end



function F:CreateBD(a, s)
	self:SetBackdrop({
		bgFile = C.media.backdrop,
		edgeFile = C.media.backdrop,
		edgeSize = s or 1,
	})
	self:SetBackdropColor(0, 0, 0, a or C.themeconfig.alpha)
	self:SetBackdropBorderColor(0, 0, 0)
	--if not a then tinsert(C.themeframes, self) end
end

function F:CreateBG()
	local f = self
	if self:GetObjectType() == "Texture" then f = self:GetParent() end

	local bg = f:CreateTexture(nil, "BACKGROUND")
	bg:SetPoint("TOPLEFT", self, -1, 1)
	bg:SetPoint("BOTTOMRIGHT", self, 1, -1)
	bg:SetTexture(C.media.backdrop)
	bg:SetVertexColor(0, 0, 0)

	return bg
end



-- we assign these after loading variables for caching
-- otherwise we call an extra unpack() every time
local buttonR, buttonG, buttonB, buttonA

useButtonGradientColour = C.themeconfig.useButtonGradientColour

if useButtonGradientColour then
	buttonR, buttonG, buttonB, buttonA = unpack(C.themeconfig.buttonGradientColour)
else
	buttonR, buttonG, buttonB, buttonA = unpack(C.themeconfig.buttonSolidColour)
end





function F:CreateGradient()
	local tex = self:CreateTexture(nil, "BORDER")
	tex:SetPoint("TOPLEFT", 1, -1)
	tex:SetPoint("BOTTOMRIGHT", -1, 1)
	tex:SetTexture(useButtonGradientColour and C.media.gradient or C.media.backdrop)
	tex:SetVertexColor(buttonR, buttonG, buttonB, buttonA)

	return tex
end

local function colourButton(self)
	if not self:IsEnabled() then return end

	if useButtonGradientColour then
		self:SetBackdropColor(r, g, b, .3)
	else
		self.bgTex:SetVertexColor(r / 4, g / 4, b / 4)
	end

	self:SetBackdropBorderColor(r, g, b)
end

local function clearButton(self)
	if useButtonGradientColour then
		self:SetBackdropColor(0, 0, 0, 0)
	else
		self.bgTex:SetVertexColor(buttonR, buttonG, buttonB, buttonA)
	end

	self:SetBackdropBorderColor(0, 0, 0)
end

F.CreatePulse = function(frame) -- pulse function originally by nightcracker
	local speed = .05
	local mult = 1
	local alpha = 1
	local last = 0
	frame:SetScript("OnUpdate", function(self, elapsed)
		last = last + elapsed
		if last > speed then
			last = 0
			self:SetAlpha(alpha)
		end
		alpha = alpha - elapsed*mult
		if alpha < 0 and mult > 0 then
			mult = mult*-1
			alpha = 0
		elseif alpha > 1 and mult < 0 then
			mult = mult*-1
		end
	end)
end

local function StartGlow(f)
	if not f:IsEnabled() then return end
	--f:SetBackdropColor(.2, .2, .2, .7)

	f:SetBackdropBorderColor(r, g, b)
	f.glow:SetAlpha(1)
	F.CreatePulse(f.glow)
end

local function StopGlow(f)
	--f:SetBackdropColor(.2, .2, .2, .7)
	f:SetBackdropBorderColor(0, 0, 0)

	f.glow:SetScript("OnUpdate", nil)
	f.glow:SetAlpha(0)
end

F.Reskin = function(f, noGlow)
	f:SetNormalTexture("")
	f:SetHighlightTexture("")
	f:SetPushedTexture("")
	f:SetDisabledTexture("")

	if f.Left then f.Left:SetAlpha(0) end
	if f.Middle then f.Middle:SetAlpha(0) end
	if f.Right then f.Right:SetAlpha(0) end
	if f.LeftSeparator then f.LeftSeparator:Hide() end
	if f.RightSeparator then f.RightSeparator:Hide() end

	--f:SetBackdropColor(.2, .2, .2, .7)

	F.CreateBD(f, .0)

	f.bgTex = F.CreateGradient(f)
	

	if not noGlow then
		f.glow = CreateFrame("Frame", nil, f)
		f.glow:SetBackdrop({
			edgeFile = C.media.glowtex,
			edgeSize = 5,
		})
		f.glow:SetPoint("TOPLEFT", -6, 6)
		f.glow:SetPoint("BOTTOMRIGHT", 6, -6)
		f.glow:SetBackdropBorderColor(r, g, b)
		f.glow:SetAlpha(0)

		f:HookScript("OnEnter", StartGlow)
		f:HookScript("OnLeave", StopGlow)
	end
end

function F:ReskinTab()
	self:DisableDrawLayer("BACKGROUND")

	local bg = CreateFrame("Frame", nil, self)
	bg:SetPoint("TOPLEFT", 8, -3)
	bg:SetPoint("BOTTOMRIGHT", -8, 0)
	bg:SetFrameLevel(self:GetFrameLevel()-1)
	F.CreateBD(bg)

	self:SetHighlightTexture(C.media.backdrop)
	local hl = self:GetHighlightTexture()
	hl:SetPoint("TOPLEFT", 9, -4)
	hl:SetPoint("BOTTOMRIGHT", -9, 1)
	hl:SetVertexColor(r, g, b, .25)
end

local function textureOnEnter(self)
	if self:IsEnabled() then
		if self.pixels then
			for _, pixel in pairs(self.pixels) do
				pixel:SetVertexColor(r, g, b)
			end
		else
			self.bgTex:SetVertexColor(r, g, b)
		end
	end
end
F.colourArrow = textureOnEnter

local function textureOnLeave(self)
	if self.pixels then
		for _, pixel in pairs(self.pixels) do
			pixel:SetVertexColor(1, 1, 1)
		end
	else
		self.bgTex:SetVertexColor(1, 1, 1)
	end
end
F.clearArrow = textureOnLeave

function F:ReskinScroll()
	local frame = self:GetName()

	local track = (self.trackBG or self.Background or self.Track) or (_G[frame.."Track"] or _G[frame.."BG"])
	if track then track:Hide() end
	local top = (self.ScrollBarTop or self.Top or self.ScrollUpBorder) or _G[frame.."Top"]
	if top then top:Hide() end
	local middle = (self.ScrollBarMiddle or self.Middle or self.Border) or _G[frame.."Middle"]
	if middle then middle:Hide() end
	local bottom = (self.ScrollBarBottom or self.Bottom or self.ScrollDownBorder) or _G[frame.."Bottom"]
	if bottom then bottom:Hide() end

	local bu = (self.ThumbTexture or self.thumbTexture) or _G[frame.."ThumbTexture"]
	bu:SetAlpha(0)
	bu:SetWidth(17)

	bu.bg = CreateFrame("Frame", nil, self)
	bu.bg:SetPoint("TOPLEFT", bu, 0, -2)
	bu.bg:SetPoint("BOTTOMRIGHT", bu, 0, 4)
	F.CreateBD(bu.bg, 0)

	local tex = F.CreateGradient(self)
	tex:SetPoint("TOPLEFT", bu.bg, 1, -1)
	tex:SetPoint("BOTTOMRIGHT", bu.bg, -1, 1)

	local up, down = self:GetChildren()
	up:SetWidth(17)
	down:SetWidth(17)

	F.Reskin(up, true)
	F.Reskin(down, true)

	up:SetDisabledTexture(C.media.backdrop)
	local dis1 = up:GetDisabledTexture()
	dis1:SetVertexColor(0, 0, 0, .4)
	dis1:SetDrawLayer("OVERLAY")

	down:SetDisabledTexture(C.media.backdrop)
	local dis2 = down:GetDisabledTexture()
	dis2:SetVertexColor(0, 0, 0, .4)
	dis2:SetDrawLayer("OVERLAY")

	local uptex = up:CreateTexture(nil, "ARTWORK")
	uptex:SetTexture(C.media.arrowUp)
	uptex:SetSize(8, 8)
	uptex:SetPoint("CENTER")
	uptex:SetVertexColor(1, 1, 1)
	up.bgTex = uptex

	local downtex = down:CreateTexture(nil, "ARTWORK")
	downtex:SetTexture(C.media.arrowDown)
	downtex:SetSize(8, 8)
	downtex:SetPoint("CENTER")
	downtex:SetVertexColor(1, 1, 1)
	down.bgTex = downtex

	up:HookScript("OnEnter", textureOnEnter)
	up:HookScript("OnLeave", textureOnLeave)
	down:HookScript("OnEnter", textureOnEnter)
	down:HookScript("OnLeave", textureOnLeave)
end

function F:ReskinDropDown()
	local frame = self:GetName()

	local left = self.Left or _G[frame.."Left"]
	local middle = self.Middle or _G[frame.."Middle"]
	local right = self.Right or _G[frame.."Right"]

	if left then left:SetAlpha(0) end
	if middle then middle:SetAlpha(0) end
	if right then right:SetAlpha(0) end

	local down = self.Button or _G[frame.."Button"]

	down:SetSize(20, 20)
	down:ClearAllPoints()
	down:SetPoint("RIGHT", -18, 2)

	F.Reskin(down, true)

	down:SetDisabledTexture(C.media.backdrop)
	local dis = down:GetDisabledTexture()
	dis:SetVertexColor(0, 0, 0, .4)
	dis:SetDrawLayer("OVERLAY")
	dis:SetAllPoints()

	local tex = down:CreateTexture(nil, "ARTWORK")
	tex:SetTexture(C.media.arrowDown)
	tex:SetSize(8, 8)
	tex:SetPoint("CENTER")
	tex:SetVertexColor(1, 1, 1)
	down.bgTex = tex

	down:HookScript("OnEnter", textureOnEnter)
	down:HookScript("OnLeave", textureOnLeave)

	local bg = CreateFrame("Frame", nil, self)
	bg:SetPoint("TOPLEFT", 16, -4)
	bg:SetPoint("BOTTOMRIGHT", -18, 8)
	bg:SetFrameLevel(self:GetFrameLevel() - 1)
	F.CreateBD(bg, 0)

	local gradient = F.CreateGradient(self)
	gradient:SetPoint("TOPLEFT", bg, 1, -1)
	gradient:SetPoint("BOTTOMRIGHT", bg, -1, 1)
end

function F:ReskinClose(a1, p, a2, x, y)
	self:SetSize(17, 17)

	if not a1 then
		self:SetPoint("TOPRIGHT", -6, -6)
	else
		self:ClearAllPoints()
		self:SetPoint(a1, p, a2, x, y)
	end

	self:SetNormalTexture("")
	self:SetHighlightTexture("")
	self:SetPushedTexture("")
	self:SetDisabledTexture("")
	F.CreateBD(self, 0)
	F.CreateGradient(self)

	self:SetDisabledTexture(C.media.backdrop)
	local dis = self:GetDisabledTexture()
	dis:SetVertexColor(0, 0, 0, .4)
	dis:SetDrawLayer("OVERLAY")
	dis:SetAllPoints()

	self.pixels = {}
	for i = 1, 2 do
		local tex = self:CreateTexture()
		tex:SetColorTexture(1, 1, 1)
		tex:SetSize(11, 2)
		tex:SetPoint("CENTER")
		tex:SetRotation(math.rad((i-1/2)*90))
		tinsert(self.pixels, tex)
	end

	self:HookScript("OnEnter", textureOnEnter)
 	self:HookScript("OnLeave", textureOnLeave)
end

function F:ReskinInput(height, width)
	local frame = self:GetName()

	local left = self.Left or _G[frame.."Left"]
	local middle = self.Middle or _G[frame.."Middle"] or _G[frame.."Mid"]
	local right = self.Right or _G[frame.."Right"]

	left:Hide()
	middle:Hide()
	right:Hide()

	local bd = CreateFrame("Frame", nil, self)
	bd:SetPoint("TOPLEFT", -2, 0)
	bd:SetPoint("BOTTOMRIGHT")
	bd:SetFrameLevel(self:GetFrameLevel() - 1)
	F.CreateBD(bd, 0)

	local gradient = F.CreateGradient(self)
	gradient:SetPoint("TOPLEFT", bd, 1, -1)
	gradient:SetPoint("BOTTOMRIGHT", bd, -1, 1)

	if height then self:SetHeight(height) end
	if width then self:SetWidth(width) end
end

function F:ReskinArrow(direction)
	self:SetSize(18, 18)
	F.Reskin(self, true)

	self:SetDisabledTexture(C.media.backdrop)
	local dis = self:GetDisabledTexture()
	dis:SetVertexColor(0, 0, 0, .3)
	dis:SetDrawLayer("OVERLAY")

	local tex = self:CreateTexture(nil, "ARTWORK")
	local themeMediaPath = "Interface\\AddOns\\FreeUI\\assets\\"
	tex:SetTexture(themeMediaPath.."arrow-"..direction.."-active")
	tex:SetSize(8, 8)
	tex:SetPoint("CENTER")
	self.bgTex = tex

	self:HookScript("OnEnter", textureOnEnter)
	self:HookScript("OnLeave", textureOnLeave)
end

function F:ReskinCheck()
	self:SetNormalTexture("")
	self:SetPushedTexture("")
	self:SetHighlightTexture(C.media.backdrop)
	local hl = self:GetHighlightTexture()
	hl:SetPoint("TOPLEFT", 5, -5)
	hl:SetPoint("BOTTOMRIGHT", -5, 5)
	hl:SetVertexColor(r, g, b, .2)

	local bd = CreateFrame("Frame", nil, self)
	bd:SetPoint("TOPLEFT", 4, -4)
	bd:SetPoint("BOTTOMRIGHT", -4, 4)
	bd:SetFrameLevel(self:GetFrameLevel() - 1)
	F.CreateBD(bd, 0)

	local tex = F.CreateGradient(self)
	tex:SetPoint("TOPLEFT", 5, -5)
	tex:SetPoint("BOTTOMRIGHT", -5, 5)

	local ch = self:GetCheckedTexture()
	ch:SetDesaturated(true)
	ch:SetVertexColor(r, g, b)
end

local function colourRadio(self)
	self.bd:SetBackdropBorderColor(r, g, b)
end

local function clearRadio(self)
	self.bd:SetBackdropBorderColor(0, 0, 0)
end

function F:ReskinRadio()
	self:SetNormalTexture("")
	self:SetHighlightTexture("")
	self:SetCheckedTexture(C.media.backdrop)

	local ch = self:GetCheckedTexture()
	ch:SetPoint("TOPLEFT", 4, -4)
	ch:SetPoint("BOTTOMRIGHT", -4, 4)
	ch:SetVertexColor(r, g, b, .6)

	local bd = CreateFrame("Frame", nil, self)
	bd:SetPoint("TOPLEFT", 3, -3)
	bd:SetPoint("BOTTOMRIGHT", -3, 3)
	bd:SetFrameLevel(self:GetFrameLevel() - 1)
	F.CreateBD(bd, 0)
	self.bd = bd

	local tex = F.CreateGradient(self)
	tex:SetPoint("TOPLEFT", 4, -4)
	tex:SetPoint("BOTTOMRIGHT", -4, 4)

	self:HookScript("OnEnter", colourRadio)
	self:HookScript("OnLeave", clearRadio)
end

function F:ReskinSlider(verticle)
	self:SetBackdrop(nil)
	self.SetBackdrop = F.dummy

	local bd = CreateFrame("Frame", nil, self)
	bd:SetPoint("TOPLEFT", 14, -2)
	bd:SetPoint("BOTTOMRIGHT", -15, 3)
	bd:SetFrameStrata("BACKGROUND")
	bd:SetFrameLevel(self:GetFrameLevel() - 1)
	F.CreateBD(bd, 0)

	F.CreateGradient(bd)

	for i = 1, self:GetNumRegions() do
		local region = select(i, self:GetRegions())
		if region:GetObjectType() == "Texture" then
			region:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
			region:SetBlendMode("ADD")

			if verticle then region:SetRotation(math.rad(90)) end
			return
		end
	end
end

local function expandOnEnter(self)
	if self:IsEnabled() then
		self.bg:SetBackdropColor(r, g, b, .3)
	end
end

local function expandOnLeave(self)
	self.bg:SetBackdropColor(0, 0, 0, .3)
end

local function SetupTexture(self, texture)
	if self.settingTexture then return end
	self.settingTexture = true
	self:SetNormalTexture("")

	if texture and texture ~= "" then
		if texture:find("Plus") then
			self.expTex:SetTexCoord(0, 0.4375, 0, 0.4375)
		elseif texture:find("Minus") then
			self.expTex:SetTexCoord(0.5625, 1, 0, 0.4375)
		end
		self.bg:Show()
	else
		self.bg:Hide()
	end
	self.settingTexture = nil
end

function F:ReskinExpandOrCollapse()
	self:SetHighlightTexture("")
	self:SetPushedTexture("")

	local bg = F.CreateBDFrame(self, .3)
	bg:ClearAllPoints()
	bg:SetSize(13, 13)
	bg:SetPoint("TOPLEFT", self:GetNormalTexture())
	F.CreateGradient(bg)
	self.bg = bg

	self.expTex = bg:CreateTexture(nil, "OVERLAY")
	self.expTex:SetSize(7, 7)
	self.expTex:SetPoint("CENTER")
	self.expTex:SetTexture("Interface\\Buttons\\UI-PlusMinus-Buttons")

	self:HookScript("OnEnter", expandOnEnter)
	self:HookScript("OnLeave", expandOnLeave)
	hooksecurefunc(self, "SetNormalTexture", SetupTexture)
end

function F:SetBD(x, y, x2, y2)
	local bg = CreateFrame("Frame", nil, self)
	if not x then
		bg:SetPoint("TOPLEFT")
		bg:SetPoint("BOTTOMRIGHT")
	else
		bg:SetPoint("TOPLEFT", x, y)
		bg:SetPoint("BOTTOMRIGHT", x2, y2)
	end
	bg:SetFrameLevel(self:GetFrameLevel() - 1)
	F.CreateBD(bg)
	F.CreateSD(bg)
end

function F:StripTextures()
	for i = 1, self:GetNumRegions() do
		local region = select(i, self:GetRegions())
		if region and region:GetObjectType() == "Texture" then
			region:SetTexture("")
		end
	end
end

function F:ReskinPortraitFrame(isButtonFrame)
	local name = self:GetName()

	_G[name.."Bg"]:Hide()
	_G[name.."TitleBg"]:Hide()
	_G[name.."Portrait"]:Hide()
	_G[name.."PortraitFrame"]:Hide()
	_G[name.."TopRightCorner"]:Hide()
	_G[name.."TopLeftCorner"]:Hide()
	_G[name.."TopBorder"]:Hide()
	_G[name.."TopTileStreaks"]:SetTexture("")
	_G[name.."BotLeftCorner"]:Hide()
	_G[name.."BotRightCorner"]:Hide()
	_G[name.."BottomBorder"]:Hide()
	_G[name.."LeftBorder"]:Hide()
	_G[name.."RightBorder"]:Hide()

	if isButtonFrame then
		_G[name.."BtnCornerLeft"]:SetTexture("")
		_G[name.."BtnCornerRight"]:SetTexture("")
		_G[name.."ButtonBottomBorder"]:SetTexture("")

		self.Inset.Bg:Hide()
		self.Inset:DisableDrawLayer("BORDER")
	end

	F.CreateBD(self)
	F.CreateSD(self)
	F.ReskinClose(_G[name.."CloseButton"])
end

function F:CreateBDFrame(a)
	local frame = self
	if self:GetObjectType() == "Texture" then frame = self:GetParent() end
	local lvl = frame:GetFrameLevel()

	local bg = CreateFrame("Frame", nil, frame)
	bg:SetPoint("TOPLEFT", self, -1, 1)
	bg:SetPoint("BOTTOMRIGHT", self, 1, -1)
	bg:SetFrameLevel(lvl == 0 and 1 or lvl - 1)
	F.CreateBD(bg, a or .5)

	return bg
end

function F:ReskinColourSwatch()
	local name = self:GetName()

	self:SetNormalTexture(C.media.backdrop)
	local nt = self:GetNormalTexture()
	nt:SetPoint("TOPLEFT", 3, -3)
	nt:SetPoint("BOTTOMRIGHT", -3, 3)

	local bg = _G[name.."SwatchBg"]
	bg:SetColorTexture(0, 0, 0)
	bg:SetPoint("TOPLEFT", 2, -2)
	bg:SetPoint("BOTTOMRIGHT", -2, 2)
end

function F:ReskinFilterButton()
	self.TopLeft:Hide()
	self.TopRight:Hide()
	self.BottomLeft:Hide()
	self.BottomRight:Hide()
	self.TopMiddle:Hide()
	self.MiddleLeft:Hide()
	self.MiddleRight:Hide()
	self.BottomMiddle:Hide()
	self.MiddleMiddle:Hide()

	F.Reskin(self)
	self.Text:SetPoint("CENTER")
	self.Icon:SetTexture(C.media.arrowRight)
	self.Icon:SetPoint("RIGHT", self, "RIGHT", -5, 0)
	self.Icon:SetSize(8, 8)
end

function F:ReskinNavBar()
	if self.navBarStyled then return end

	local homeButton = self.homeButton
	local overflowButton = self.overflowButton

	self:GetRegions():Hide()
	self:DisableDrawLayer("BORDER")
	self.overlay:Hide()
	homeButton:GetRegions():Hide()
	F.Reskin(homeButton)
	F.Reskin(overflowButton, true)

	local tex = overflowButton:CreateTexture(nil, "ARTWORK")
	tex:SetTexture(C.media.arrowLeft)
	tex:SetSize(8, 8)
	tex:SetPoint("CENTER")
	overflowButton.bgTex = tex

	overflowButton:HookScript("OnEnter", textureOnEnter)
	overflowButton:HookScript("OnLeave", textureOnLeave)

	self.navBarStyled = true
end

function F:ReskinGarrisonPortrait()
	self.Portrait:ClearAllPoints()
	self.Portrait:SetPoint("TOPLEFT", 4, -4)
	self.PortraitRing:Hide()
	self.PortraitRingQuality:SetTexture("")
	if self.Highlight then self.Highlight:Hide() end

	self.LevelBorder:SetScale(.0001)
	self.Level:ClearAllPoints()
	self.Level:SetPoint("BOTTOM", self, 0, 12)

	self.squareBG = F.CreateBDFrame(self, 1)
	self.squareBG:SetFrameLevel(self:GetFrameLevel())
	self.squareBG:SetPoint("TOPLEFT", 3, -3)
	self.squareBG:SetPoint("BOTTOMRIGHT", -3, 11)
	
	if self.PortraitRingCover then
		self.PortraitRingCover:SetColorTexture(0, 0, 0)
		self.PortraitRingCover:SetAllPoints(self.squareBG)
	end

	if self.Empty then
		self.Empty:SetColorTexture(0, 0, 0)
		self.Empty:SetAllPoints(self.Portrait)
	end
end

function F:ReskinIcon()
	self:SetTexCoord(.08, .92, .08, .92)
	return F.CreateBG(self)
end

function F:ReskinMinMax()
	for _, name in next, {"MaximizeButton", "MinimizeButton"} do
		local button = self[name]
		if button then
			button:SetSize(17, 17)
			button:ClearAllPoints()
			button:SetPoint("CENTER", -3, 0)
			F.Reskin(button)

			button.pixels = {}

			local tex = button:CreateTexture()
			tex:SetColorTexture(1, 1, 1)
			tex:SetSize(11, 2)
			tex:SetPoint("CENTER")
			tex:SetRotation(math.rad(45))
			tinsert(button.pixels, tex)

			local hline = button:CreateTexture()
			hline:SetColorTexture(1, 1, 1)
			hline:SetSize(7, 2)
			tinsert(button.pixels, hline)
			local vline = button:CreateTexture()
			vline:SetColorTexture(1, 1, 1)
			vline:SetSize(2, 7)
			tinsert(button.pixels, vline)

			if name == "MaximizeButton" then
				hline:SetPoint("TOPRIGHT", -4, -4)
				vline:SetPoint("TOPRIGHT", -4, -4)
			else
				hline:SetPoint("BOTTOMLEFT", 4, 4)
				vline:SetPoint("BOTTOMLEFT", 4, 4)
			end

			button:SetScript("OnEnter", textureOnEnter)
			button:SetScript("OnLeave", textureOnLeave)
		end
	end
end




-------------------

-- Button Color
function F:CreateBC(a)
	self:SetNormalTexture("")
	self:SetHighlightTexture("")
	self:SetPushedTexture("")
	self:SetDisabledTexture("")

	if self.Left then self.Left:SetAlpha(0) end
	if self.Middle then self.Middle:SetAlpha(0) end
	if self.Right then self.Right:SetAlpha(0) end
	if self.LeftSeparator then self.LeftSeparator:Hide() end
	if self.RightSeparator then self.RightSeparator:Hide() end

	self:SetScript("OnEnter", function()
		self:SetBackdropBorderColor(cr, cg, cb, 1)
	end)
	self:SetScript("OnLeave", function()
		self:SetBackdropBorderColor(0, 0, 0, 1)
	end)
	self:SetScript("OnMouseDown", function()
		self:SetBackdropColor(cr, cg, cb, a or .3)
	end)
	self:SetScript("OnMouseUp", function()
		self:SetBackdropColor(0, 0, 0, a or .3)
	end)
end

-- Checkbox
function F:CreateCB(a)
	self:SetNormalTexture("")
	self:SetPushedTexture("")
	self:SetHighlightTexture(C.media.backdrop)
	local hl = self:GetHighlightTexture()
	hl:SetPoint("TOPLEFT", 6, -6)
	hl:SetPoint("BOTTOMRIGHT", -6, 6)
	hl:SetVertexColor(cr, cg, cb, .25)

	local bd = F.CreateBG(self, -4)
	F.CreateBDFrame(bd)

	local ch = self:GetCheckedTexture()
	ch:SetDesaturated(true)
	ch:SetVertexColor(r, g, b)
end

-- Icon Style
function F:CreateIF(mouse, cd)
	F.CreateSD(self, 3, 3)
	self.Icon = self:CreateTexture(nil, "ARTWORK")
	self.Icon:SetAllPoints()
	self.Icon:SetTexCoord(unpack(C.texCoord))
	if mouse then
		self:EnableMouse(true)
		self.HL = self:CreateTexture(nil, "HIGHLIGHT")
		self.HL:SetColorTexture(1, 1, 1, .3)
		self.HL:SetAllPoints(self.Icon)
	end
	if cd then
		self.CD = CreateFrame("Cooldown", nil, self, "CooldownFrameTemplate")
		self.CD:SetAllPoints()
		self.CD:SetReverse(true)
	end
end


-- GameTooltip
function F:AddTooltip(anchor, text, color)
	self:SetScript("OnEnter", function()
		GameTooltip:SetOwner(self, anchor)
		GameTooltip:ClearLines()
		if tonumber(text) then
			GameTooltip:SetSpellByID(text)
		else
			local r, g, b = 1, 1, 1
			if color == "class" then
				r, g, b = cr, cg, cb
			elseif color == "system" then
				r, g, b = 1, .8, 0
			end
			GameTooltip:AddLine(text, r, g, b)
		end
		GameTooltip:Show()
	end)
	self:SetScript("OnLeave", GameTooltip_Hide)
end

-- Movable Frame
function F:CreateMF(parent)
	local frame = parent or self
	frame:SetMovable(true)
	frame:SetUserPlaced(true)
	frame:SetClampedToScreen(true)

	self:EnableMouse(true)
	self:RegisterForDrag("LeftButton")
	self:SetScript("OnDragStart", function() frame:StartMoving() end)
	self:SetScript("OnDragStop", function() frame:StopMovingOrSizing() end)
end


-- Statusbar
function F:CreateSB(spark, r, g, b)
	self:SetStatusBarTexture(C.media.texture)
	if r and g and b then
		self:SetStatusBarColor(r, g, b)
	else
		self:SetStatusBarColor(cr, cg, cb)
	end
	F.CreateSD(self, 3, 3)
	self.BG = self:CreateTexture(nil, "BACKGROUND")
	self.BG:SetAllPoints()
	self.BG:SetTexture(C.media.backdrop)
	self.BG:SetVertexColor(0, 0, 0, .5)
	F.CreateTex(self.BG)
	if spark then
		self.Spark = self:CreateTexture(nil, "OVERLAY")
		self.Spark:SetTexture(C.media.sparktex)
		self.Spark:SetBlendMode("ADD")
		self.Spark:SetAlpha(.8)
		self.Spark:SetPoint("TOPLEFT", self:GetStatusBarTexture(), "TOPRIGHT", -10, 10)
		self.Spark:SetPoint("BOTTOMRIGHT", self:GetStatusBarTexture(), "BOTTOMRIGHT", 10, -10)
	end
end



-- Numberize
function F.Numb(n)
	if n >= 1e12 then
		return ("%.2ft"):format(n / 1e12)
	elseif n >= 1e9 then
		return ("%.2fb"):format(n / 1e9)
	elseif n >= 1e6 then
		return ("%.2fm"):format(n / 1e6)
	elseif n >= 1e3 then
		return ("%.1fk"):format(n / 1e3)
	else
		return ("%.0f"):format(n)
	end
end


-- Color code
function F.HexRGB(r, g, b)
	if r then
		if type(r) == "table" then
			if r.r then r, g, b = r.r, r.g, r.b else r, g, b = unpack(r) end
		end
		return ("|cff%02x%02x%02x"):format(r*255, g*255, b*255)
	end
end

function F.ClassColor(class)
	local color = C.classcolours[class]
	if not color then return 1, 1, 1 end
	return color.r, color.g, color.b
end

function F.UnitColor(unit)
	local r, g, b = 1, 1, 1
	if UnitIsPlayer(unit) then
		local _, class = UnitClass(unit)
		if class then
			r, g, b = F.ClassColor(class)
		end
	elseif UnitIsTapDenied(unit) then
		r, g, b = .6, .6, .6
	else
		local reaction = UnitReaction(unit, "player")
		if reaction then
			local color = FACTION_BAR_COLORS[reaction]
			r, g, b = color.r, color.g, color.b
		end
	end
	return r, g, b
end

-- Disable function
F.HiddenFrame = CreateFrame("Frame")
F.HiddenFrame:Hide()

function F:HideObject()
	if self.UnregisterAllEvents then
		self:UnregisterAllEvents()
		self:SetParent(F.HiddenFrame)
	else
		self.Show = self.Hide
	end
	self:Hide()
end

function F:StripTextures()
	for i = 1, self:GetNumRegions() do
		local region = select(i, self:GetRegions())
		if region and region:GetObjectType() == "Texture" then
			region:SetTexture("")
		end
	end
end

function F:HideOption()
	self:SetAlpha(0)
	self:SetScale(.0001)
end


-- Smoothy
local smoothing = {}
local f = CreateFrame("Frame")
f:SetScript("OnUpdate", function()
	local limit = 30/GetFramerate()
	for bar, value in pairs(smoothing) do
		local cur = bar:GetValue()
		local new = cur + math.min((value-cur)/8, math.max(value-cur, limit))
		if new ~= new then
			new = value
		end
		bar:SetValue_(new)
		if cur == value or math.abs(new - value) < 1 then
			smoothing[bar] = nil
			bar:SetValue_(value)
		end
	end
end)

function F:SmoothBar()
	if not self.SetValue_ then
		self.SetValue_ = self.SetValue
		self.SetValue = function(_, value)
			if value ~= self:GetValue() or value == 0 then
				smoothing[self] = value
			else
				smoothing[self] = nil
				self:SetValue_(value)
			end
		end
	end
end

-- Guild Check
function F.UnitInGuild(unitName)
	for i = 1, GetNumGuildMembers() do
		local name = GetGuildRosterInfo(i)
		if name and name == unitName then
			return true
		end
	end
	return false
end



-- Table Backup
function F.CopyTable(source, target)
	for key, value in pairs(source) do
		if type(value) == "table" then
			if not target[key] then target[key] = {} end
			for k in pairs(value) do
				target[key][k] = value[k]
			end
		else
			target[key] = value
		end
	end
end



-------------------

-- GUI APIs
function F:CreateButton(width, height, text, fontSize)
	local bu = CreateFrame("Button", nil, self)
	bu:SetSize(width, height)
	F.CreateBD(bu, .3)
	F.CreateBC(bu)
	bu.text = F.CreatePFS(bu, text, true)

	return bu
end

function F:CreateCheckBox()
	local cb = CreateFrame("CheckButton", nil, self, "InterfaceOptionsCheckButtonTemplate")
	F.CreateCB(cb)

	cb.Type = "CheckBox"
	return cb
end

function F:CreateEditBox(width, height)
	local eb = CreateFrame("EditBox", nil, self)
	eb:SetSize(width, height)
	eb:SetAutoFocus(false)
	eb:SetTextInsets(10, 10, 0, 0)
	eb:SetFontObject(GameFontHighlight)
	F.CreateBD(eb, .3)
	eb:SetScript("OnEscapePressed", function()
		eb:ClearFocus()
	end)
	eb:SetScript("OnEnterPressed", function()
		eb:ClearFocus()
	end)

	eb.Type = "EditBox"
	return eb
end

function F:CreateDropDown(width, height, data)
	local dd = CreateFrame("Frame", nil, self)
	dd:SetSize(width, height)
	F.CreateBD(dd, .3)
	dd.Text = F.CreateFS(dd, 14, "")
	dd.options = {}

	local bu = CreateFrame("Button", nil, dd)
	bu:SetPoint("LEFT", dd, "RIGHT", -2, 0)
	bu:SetSize(22, 22)
	bu.Icon = bu:CreateTexture(nil, "ARTWORK")
	bu.Icon:SetAllPoints()
	bu.Icon:SetTexture(C.media.geartex)
	bu.Icon:SetTexCoord(0, .5, 0, .5)
	bu:SetHighlightTexture(C.media.geartex)
	bu:GetHighlightTexture():SetTexCoord(0, .5, 0, .5)
	local list = CreateFrame("Frame", nil, dd)
	list:SetPoint("TOP", dd, "BOTTOM")
	F.CreateBD(list, .7)
	bu:SetScript("OnShow", function() list:Hide() end)
	bu:SetScript("OnClick", function()
		PlaySound(SOUNDKIT.GS_TITLE_OPTION_OK)
		ToggleFrame(list)
	end)
	dd.button = bu

	local opt, index = {}, 0
	local function optOnClick(self)
		PlaySound(SOUNDKIT.GS_TITLE_OPTION_OK)
		for i = 1, #opt do
			if self == opt[i] then
				opt[i]:SetBackdropColor(1, .8, 0, .3)
				opt[i].selected = true
			else
				opt[i]:SetBackdropColor(0, 0, 0, .3)
				opt[i].selected = false
			end
		end
		dd.Text:SetText(self.text)
		list:Hide()
	end
	local function optOnEnter(self)
		if self.selected then return end
		self:SetBackdropColor(1, 1, 1, .3)
	end
	local function optOnLeave(self)
		if self.selected then return end
		self:SetBackdropColor(0, 0, 0, .3)
	end

	for i, j in pairs(data) do
		opt[i] = CreateFrame("Button", nil, list)
		opt[i]:SetPoint("TOPLEFT", 5, -5 - (i-1)*height)
		opt[i]:SetSize(width - 10, height)
		F.CreateBD(opt[i], .3)
		F.CreateFS(opt[i], 14, j, false, "LEFT", 5, 0)
		opt[i].text = j
		opt[i]:SetScript("OnClick", optOnClick)
		opt[i]:SetScript("OnEnter", optOnEnter)
		opt[i]:SetScript("OnLeave", optOnLeave)

		dd.options[i] = opt[i]
		index = index + 1
	end
	list:SetSize(width, index*height + 10)

	dd.Type = "DropDown"
	return dd
end











DEFAULT_CHAT_FRAME:AddMessage("FreeUI <Continued> |cffffffff"..GetAddOnMetadata("FreeUI", "Version"), unpack(C.class))
--DEFAULT_CHAT_FRAME:AddMessage("Type |cffffffff/FreeUI|r for more information.", unpack(C.class))
