{
    This file is part of Dev-C++
    Copyright (c) 2004 Bloodshed Software

    Dev-C++ is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    Dev-C++ is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Dev-C++; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}

unit AboutFrm;

interface

uses
  Windows, SysUtils, Classes, version, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls;

type
  TAboutForm = class(TForm)
    lblVersion: TLabel;
    btnOk: TBitBtn;
    lblCopyright: TLabel;
    grpLicense: TGroupBox;
    txtLicense: TMemo;
    grpLinks: TGroupBox;
    lblBlood: TLabel;
    lblBloodURL: TLabel;
    lblMinGWW64: TLabel;
    lblMinGWW64URL: TLabel;
    lblResources: TLabel;
    lblResourcesURL: TLabel;
    lblBlog: TLabel;
    lblBlogURL: TLabel;
    btnAuthors: TBitBtn;
    btnUpdateCheck: TBitBtn;
    timerFish: TTimer;
    pnlFish: TPanel;
    FishImage: TImage;
    imgBanner: TImage;
    bv2: TBevel;
    lblSubreddit: TLabel;
    lblSubredditURL: TLabel;
    lblRepository: TLabel;
    lblRepositoryURL: TLabel;
    lblPre511: TLabel;
    lblCompilers: TLabel;
    lblPre4992: TLabel;
    bv3: TBevel;
    bv1: TBevel;
    lblPost511: TLabel;
    lblGithub: TLabel;
    Label1: TLabel;
    procedure URLLabelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnAuthorsClick(Sender: TObject);
    procedure btnAuthorsDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure btnAuthorsDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure timerFishTimer(Sender: TObject);
    procedure FishImageClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    procedure LoadText;
  end;

implementation

uses
  ShellAPI, devcfg, utils, MultiLangSupport, main;

{$R *.dfm}

procedure TAboutForm.LoadText;
begin
  // Set interface font
  Font.Name := devData.InterfaceFont;
  Font.Size := devData.InterfaceFontSize;

  Caption := Lang[ID_AB_CAPTION];
  grpLicense.Caption := Lang[ID_AB_LICENSE];
  grpLinks.Caption := Lang[ID_AB_WEBCAP];
  lblPost511.Caption := Lang[ID_AB_POST511];
  lblGithub.Caption := Lang[ID_AB_GITHUB];
  lblMinGWW64.Caption := Lang[ID_AB_TDMGCC];
  lblPre511.Caption := Lang[ID_AB_PRE511];
  lblRepository.Caption := Lang[ID_AB_REPOSITORY];
  lblSubreddit.Caption := Lang[ID_AB_SUBREDDIT];
  lblBlog.Caption := Lang[ID_AB_BLOGNAME];
  lblCompilers.Caption := Lang[ID_AB_COMPILERS];
  lblPre4992.Caption := Lang[ID_AB_PRE4992];
  lblBlood.Caption := Lang[ID_AB_LBLBLOODSITE];
  lblResources.Caption := Lang[ID_AB_LBLEMAIL];
  btnOk.Caption := Lang[ID_BTN_OK];
  btnUpdateCheck.Caption := Lang[ID_AB_UPDATE];
  btnAuthors.Caption := Lang[ID_BTN_AUTHOR];
end;

procedure TAboutForm.URLLabelClick(Sender: TObject);
var
  S: AnsiString;
begin
  S := TLabel(Sender).Caption;
  ShellExecute(GetDesktopWindow(), 'open', PAnsiChar(s), nil, nil, SW_SHOWNORMAL);
end;

procedure TAboutForm.FormCreate(Sender: TObject);
var
  datestring: AnsiString;
begin
  LoadText;

  // Use modified time, not the PE headers
  datestring := GetBuildTime(ParamStr(0));
  lblVersion.Caption := lblVersion.Caption + DEVCPP_VERSION + #13#10 + 'Build time: ' + datestring;

  if FileExists(devData.Splash) then // TODO: check all folders?
    imgBanner.Picture.LoadFromFile(devData.Splash);
end;

procedure TAboutForm.btnAuthorsClick(Sender: TObject);
const
  MessageText =
    'Authors:'#13#10#13#10 +
    '- Post-5.1.1 development: Mingtian Yang'#13#10 +
    '- Pre-5.1.1 development: Johan Mes'#13#10 +
    '- Pre-4.9.9.2 development: Colin Laplace, Mike Berg, Hongli Lai, Yiannis Mandravellos'#13#10 +
    '- Contributors: Peter Schraut, Marek Januszewski, Anonymous'#13#10 +
    '- MinGW compiler system: Mumit Khan, J.J. van der Heijden, Colin Hendrix and GNU developers'#13#10 +
    '- Splash screen and association icons: Matthijs Crielaard'#13#10 +
    '- New Look theme: Gerard Caulfield'#13#10 +
    '- Gnome icons: Gnome designers'#13#10 +
    '- Blue theme: Thomas Thron';
begin
  MessageBeep($F);
  MessageDlg(MessageText, MtInformation, [MbOK], 0);
end;

procedure TAboutForm.btnAuthorsDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := True;
end;

procedure TAboutForm.btnAuthorsDragDrop(Sender, Source: TObject; X,
  Y: Integer);
begin
  pnlFish.Left := 0 - pnlFish.Width;
  pnlFish.Top := Random(Height - pnlFish.Height - (pnlFish.Height div 3));
  pnlFish.Tag := 0;
  timerFish.Enabled := True;
end;

procedure TAboutForm.timerFishTimer(Sender: TObject);
begin
  if ((pnlFish.Tag = 0) and (pnlFish.Left > Width + 10)) or
    ((pnlFish.Tag <> 1) and (pnlFish.Left < 0 - pnlFish.Width - 10)) then
    timerFish.Enabled := False;

  if pnlFish.Tag = 0 then
    pnlFish.Left := pnlFish.Left + 5
  else
    pnlFish.Left := pnlFish.Left - 5;
  pnlFish.Top := pnlFish.Top + 1;
end;

procedure TAboutForm.FishImageClick(Sender: TObject);
begin
  pnlFish.Tag := not pnlFish.Tag;
end;

procedure TAboutForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

end.

