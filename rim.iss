; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "rim -- The R Installation Manager"
#define MyAppVersion "0.2.1"
#define MyAppPublisher "Gabor Csardi"
#define MyAppURL "https://github.com/gaborcsardi/rim"
#define MyAppExeName "rim.exe"

[Setup]
; NOTE: The value of AppId uniquely identifies this application. Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{A6B1E72E-CEB0-4E4B-A444-6DD0DC0DF0C0}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={autopf}\rim
DefaultGroupName={#MyAppName}
DisableProgramGroupPage=yes
; Uncomment the following line to run in non administrative install mode (install for current user only.)
;PrivilegesRequired=lowest
OutputBaseFilename=mysetup
Compression=lzma
SolidCompression=yes
WizardStyle=modern
ArchitecturesInstallIn64BitMode=x64
ArchitecturesAllowed=x64
ChangesEnvironment=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Files]
Source: "target\release\{#MyAppExeName}"; DestDir: "{app}"; Flags: ignoreversion
Source: "gsudo.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "_rim.ps1"; DestDir: "{app}"; Flags: ignoreversion
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"

[Registry]
Root: HKLM; Subkey: "SYSTEM\CurrentControlSet\Control\Session Manager\Environment"; \
    ValueType: expandsz; ValueName: "Path"; ValueData: "{olddata};{autopf}\rim;{autopf}\R\bin"; \
    Check: NeedsAddPath('{autopf}\rim')

[Code]

function NeedsAddPath(Param: string): boolean;
var
  OrigPath: string;
begin
  Param := ExpandConstant(Param);
  if not RegQueryStringValue(HKEY_LOCAL_MACHINE,
    'SYSTEM\CurrentControlSet\Control\Session Manager\Environment',
    'Path', OrigPath)
  then begin
    Result := True;
    exit;
  end;
  { look for the path with leading and trailing semicolon }
  { Pos() returns 0 if not found }
  Result := Pos(';' + Param + ';', ';' + OrigPath + ';') = 0;
end;

function GHPath(): boolean;
var
  fileName : string;
  lines : TArrayOfString;
begin
  Result := true;
  fileName := GetEnv('GITHUB_PATH');
  if fileName <> '' then
    begin
      SetArrayLength(lines, 2);
       lines[0] := ExpandConstant('{autopf}\rim');
       lines[1] := ExpandConstant('{autopf}\R\bin');
       Result := SaveStringsToFile(fileName, lines, true);
    end;
  exit;
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  if CurStep=ssDone then
    begin
         GHPath();
    end
end;
