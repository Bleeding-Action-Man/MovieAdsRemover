// Modified class of LobbyMenu to show custon Textures
// as IMGs or GIFs

Class CustomLobbyMenu extends LobbyMenu DependsOn(MovieAdsRemover);

var	texture CustomTex;
var string TexName;
var MovieAdsRemover MutRef;

function InitComponent(GUIController MyC, GUIComponent MyO)
{
  local int i;

  Super.InitComponent(MyC, MyO);

  for ( i = 0; i < 6; i++ )
  {
    PlayerPerk[i].WinWidth = PlayerPerk[i].ActualHeight();
    PlayerPerk[i].WinLeft += ((PlayerBox[i].ActualHeight() - PlayerPerk[i].ActualHeight()) / 2) / MyC.ResX;
  }

  i_Portrait.WinTop = PlayerPortraitBG.ActualTop() + 30;
  i_Portrait.WinHeight = PlayerPortraitBG.ActualHeight() - 36;

  t_ChatBox.FocusInstead = PerkClickLabel;
}

event Opened(GUIComponent Sender)
{
  bShouldUpdateVeterancy = true;
  SetTimer(1,true);
}

function DrawPerk(Canvas Canvas)
{
  local float X, Y, Width, Height;
  local int CurIndex, LevelIndex;
  local float TempX, TempY;
  local float TempWidth, TempHeight;
  local float IconSize, ProgressBarWidth, PerkProgress;
  local string PerkName, PerkLevelString;
  local bool focused;

  DrawPortrait();

  focused = Controller.ActivePage == self;

  MutRef = class'MovieAdsRemover'.default.Mut;

  if (focused)
  {
    Canvas.SetPos(0.066797 * Canvas.ClipX + 5, 0.325208 * Canvas.ClipY + 30);
    X = Canvas.ClipX / 1024; // X & Y scale

    if(!MutRef.bCompletelyDisable || MutRef.bReplaceWithTexture)
    {
      AdBackground.WinWidth = 320 * X + 10;
      AdBackground.WinHeight = 240 * X + 37;

      // Show Canvas + Custom Texture
      TexName = MutRef.sTextureName;
      CustomTex = texture(DynamicLoadObject(TexName, class'texture', true));

      // If 0, then FPS of animation will be same as Player's FPS
      // Always recommended to 60
      // If you are using an image instead of GIF, you can set this to 0
      if(MutRef.fMaxFPS != 0) CustomTex.MaxFrameRate = MutRef.fMaxFPS;

      // Draw Texture
      Canvas.DrawTile(CustomTex, 320 * X, 240 * X, 0, 0, CustomTex.USize, CustomTex.VSize);
    }
    else
    {
      AdBackground.WinTop=0;
      AdBackground.WinLeft=0;
      AdBackground.WinWidth=0;
      AdBackground.WinHeight=0;
      AdBackground.RenderWeight=0;
    }


  }

  if ( KFPlayerController(PlayerOwner()) == none || KFPlayerController(PlayerOwner()).SelectedVeterancy == none ||
     KFSteamStatsAndAchievements(PlayerOwner().SteamStatsAndAchievements) == none )
  {
    return;
  }
  else

  CurIndex = KFPlayerController(PlayerOwner()).SelectedVeterancy.default.PerkIndex;
  LevelIndex = KFSteamStatsAndAchievements(PlayerOwner().SteamStatsAndAchievements).PerkHighestLevelAvailable(CurIndex);
  PerkName =  KFPlayerController(PlayerOwner()).SelectedVeterancy.default.VeterancyName;
  PerkLevelString = LvAbbrString @ LevelIndex;
  PerkProgress = KFSteamStatsAndAchievements(PlayerOwner().SteamStatsAndAchievements).GetPerkProgress(CurIndex);

  //Get the position size etc in pixels
  X = i_BGPerk.ActualLeft() + 5;
  Y = i_BGPerk.ActualTop() + 30;

  Width = i_BGPerk.ActualWidth() - 10;
  Height = i_BGPerk.ActualHeight() - 37;

  // Offset for the Background
  TempX = X;
  TempY = Y + ItemSpacing / 2.0;

  // Initialize the Canvas
  Canvas.Style = 1;
  Canvas.Font = class'ROHUD'.Static.GetSmallMenuFont(Canvas);
  Canvas.SetDrawColor(255, 255, 255, 255);

  // Draw Item Background
  Canvas.SetPos(TempX, TempY);
  //Canvas.DrawTileStretched(ItemBackground, Width, Height);

  IconSize = Height - ItemSpacing;

  // Draw Item Background
  Canvas.DrawTileStretched(PerkBackground, IconSize, IconSize);
  Canvas.SetPos(TempX + IconSize - 1.0, Y + 7.0);
  Canvas.DrawTileStretched(InfoBackground, Width - IconSize, Height - ItemSpacing - 14);

  IconSize -= IconBorder * 2.0 * Height;

  // Draw Icon
  Canvas.SetPos(TempX + IconBorder * Height, TempY + IconBorder * Height);
  Canvas.DrawTile(class'KFGameType'.default.LoadedSkills[CurIndex].default.OnHUDIcon, IconSize, IconSize, 0, 0, 256, 256);

  TempX += IconSize + (IconToInfoSpacing * Width);
  TempY += TextTopOffset * Height + ItemBorder * Height;

  ProgressBarWidth = Width - (TempX - X) - (IconToInfoSpacing * Width);

  // Select Text Color
  Canvas.SetDrawColor(0, 0, 0, 255);

  // Draw the Perk's Level name
  Canvas.StrLen(PerkName, TempWidth, TempHeight);
  Canvas.SetPos(TempX, TempY);
  Canvas.DrawText(PerkName);

  // Draw the Perk's Level
  if ( PerkLevelString != "" )
  {
    Canvas.StrLen(PerkLevelString, TempWidth, TempHeight);
    Canvas.SetPos(TempX + ProgressBarWidth - TempWidth, TempY);
    Canvas.DrawText(PerkLevelString);
  }

  TempY += TempHeight + (0.04 * Height);

  // Draw Progress Bar
  Canvas.SetDrawColor(255, 255, 255, 255);
  Canvas.SetPos(TempX, TempY);
  Canvas.DrawTileStretched(ProgressBarBackground, ProgressBarWidth, ProgressBarHeight * Height);
  Canvas.SetPos(TempX + 3.0, TempY + 3.0);
  Canvas.DrawTileStretched(ProgressBarForeground, (ProgressBarWidth - 6.0) * PerkProgress, (ProgressBarHeight * Height) - 6.0);

  if ( PlayerOwner().SteamStatsAndAchievements.bUsedCheats )
  {
    if ( CurrentVeterancyLevel != 255 )
    {
      lb_PerkEffects.SetContent(PerksDisabledString);
      CurrentVeterancyLevel = 255;
    }
  }
  else if ( CurrentVeterancy != KFPlayerController(PlayerOwner()).SelectedVeterancy || CurrentVeterancyLevel != LevelIndex )
  {
    lb_PerkEffects.SetContent(KFPlayerController(PlayerOwner()).SelectedVeterancy.default.LevelEffects[LevelIndex]);
    CurrentVeterancy = KFPlayerController(PlayerOwner()).SelectedVeterancy;
    CurrentVeterancyLevel = LevelIndex;
  }
}

defaultproperties
{
  Begin Object class=GUISectionBackground Name=ADBG
    WinTop=0.325208
    WinLeft=0.066797
    WinWidth=0.322595
    WinHeight=0.374505
    RenderWeight=0.3
  End Object
  ADBackground=ADBG
}