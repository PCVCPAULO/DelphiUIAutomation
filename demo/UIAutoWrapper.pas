unit UIAutoWrapper;

interface

type
  // TODO: Better names for these types please
  TSimpleFunc = procedure; stdcall;
  TLaunchFunc = procedure (const val1, val2: String);
  TStringFunc = function (const value: String): Pointer;
  TPointerFunc = procedure (handle: Pointer);
  TSelectTabFunc = procedure (handle: Pointer; text: String);
  TGetTabFunc = function (handle: Pointer; value: Integer): Pointer;
  TGetEditBoxByNameFunc = function (handle: Pointer; text: String): Pointer;
  TGetTextFunc = function (handle: Pointer): String;
  TToggleFunc = procedure (handle: Pointer);
  TGetStatusBarFunc = function (handle: Pointer): Pointer;
  TSetTextFunc = procedure (handle: Pointer; text: String);

  TUIAutoWrapper = class
  private
    dllHandle : THandle;

    simpleFunc: TSimpleFunc;
    launchOrAttachFunc: TLaunchFunc;
    killFunc: TSimpleFunc;
    initializeFunc: TSimpleFunc;
    finalizeFunc: TSimpleFunc;
    waitWhileBusyFunc: TSimpleFunc;
    getDesktopWindowFunc: TStringFunc;
    maximizeFunc: TPointerFunc;
    selectTabFunc: TSelectTabFunc;
    getTabFunc: TGetTabFunc;
    getCheckBoxFunc: TGetTabFunc;

    getEditBoxFunc: TGetTabFunc;
    getTextBoxFunc: TGetTabFunc;
    getEditBoxByNameFunc: TGetEditBoxByNameFunc;

    getTextFunc: TGetTextFunc;
    getTextFromTextFunc: TGetTextFunc;
    toggleFunc: TToggleFunc;
    getStatusbarFunc: TGetStatusBarFunc;

    getComboBoxByNameFunc: TGetEditBoxByNameFunc;
    getComboBoxFunc: TGetTabFunc;

    setTextFunc: TSetTextFunc;

  public
    constructor Create;
    destructor Destroy;

    procedure Launch(const val1, val2: String);
    procedure Kill;

    procedure Initialize;
    procedure Finalize;

    procedure WaitWhileBusy;

    function GetDesktopWindow(const name: String) : Pointer;

    procedure Maximize(handle: Pointer);
    procedure Focus(handle: Pointer);

    procedure SelectTab(handle: Pointer; text: String);
    function GetTab(handle: Pointer; item: integer): Pointer;

    function GetEditBox(handle: Pointer; item: Integer): pointer; overload;
    function GetEditBox(handle: Pointer; name: String): pointer; overload;

    function GetTextBox(handle: Pointer; item: Integer): pointer;

    function GetText(handle: Pointer): String;
    function GetTextFromText(handle: Pointer): String;

    function GetCheckBox(handle: Pointer; index: Integer): Pointer;
    procedure Toggle(handle: Pointer);

    function GetStatusbar(handle: Pointer): Pointer;

    function GetComboBox(handle: Pointer; item: Integer): Pointer; overload;
    function GetComboBox(handle: Pointer; name: String): Pointer; overload;

    procedure SetText(handle: Pointer; text: String);
  end;

implementation

uses
  dialogs,
  windows;

{ TUIAutoWrapper }

constructor TUIAutoWrapper.Create;
begin
  WriteLn('Loading DLL');
  dllHandle := LoadLibrary('C:\Users\humphreysm.JHCLLP\Documents\GitHub\DelphiUIAutomation\library\Win32\Debug\UIAutomation.dll') ;
  WriteLn('Loaded DLL');
  if dllHandle <> 0 then
  begin
    @launchOrAttachFunc := getProcAddress(dllHandle, 'LaunchOrAttach');
    if not Assigned (launchOrAttachFunc) then
      WriteLn('"LaunchOrAttach" function not found') ;

    @killFunc := getProcAddress(dllHandle, 'Kill');
    if not Assigned (killFunc) then
      WriteLn('"Kill" function not found') ;

    @initializeFunc := getProcAddress(dllHandle, 'Initialize');
    if not Assigned (initializeFunc) then
      WriteLn('"Initialise" function not found') ;

    @finalizeFunc := getProcAddress(dllHandle, 'Finalize');
    if not Assigned (finalizeFunc) then
      WriteLn('"Finalize" function not found') ;

    @waitWhileBusyFunc := getProcAddress(dllHandle, 'WaitWhileBusy');
    if not Assigned (waitWhileBusyFunc) then
      WriteLn('"WaitWhileBusy" function not found');

    @getDesktopWindowFunc := getProcAddress(dllHandle, 'GetDesktopWindow');
    if not Assigned (getDesktopWindowFunc) then
      WriteLn('"GetDesktopWindow" function not found');

    @selectTabFunc := getProcAddress(dllHandle, 'SelectTab');
    if not Assigned (selectTabFunc) then
      WriteLn('"SelectTab" function not found');

    @getTabFunc := getProcAddress(dllHandle, 'GetTab');
    if not Assigned (getTabFunc) then
      WriteLn('"GetTab" function not found');

    @maximizeFunc := getProcAddress(dllHandle, 'Maximize');
    if not Assigned (maximizeFunc) then
      WriteLn('"Maximize" function not found');

    @getEditBoxByNameFunc := getProcAddress(dllHandle, 'GetEditBoxByName');
    if not Assigned (getEditBoxByNameFunc) then
      WriteLn('"GetEditBoxByName" function not found');

    @getEditBoxFunc := getProcAddress(dllHandle, 'GetEditBox');
    if not Assigned (getEditBoxFunc) then
      WriteLn('"GetEditBox" function not found');

    @getTextFunc := getProcAddress(dllHandle, 'GetText');
    if not Assigned (getTextFunc) then
      WriteLn('"GetText" function not found');

    @getCheckBoxFunc := getProcAddress(dllHandle, 'GetCheckBox');
    if not Assigned (getCheckBoxFunc) then
      WriteLn('"GetCheckBox" function not found');

    @toggleFunc := getProcAddress(dllHandle, 'Toggle');
    if not Assigned (toggleFunc) then
      WriteLn('"Toggle" function not found');

    @getStatusbarFunc := getProcAddress(dllHandle, 'GetStatusBar');
    if not Assigned (getStatusbarFunc) then
      WriteLn('"GetStatusbar" function not found');

    @getTextBoxFunc := getProcAddress(dllHandle, 'GetTextBox');
    if not Assigned (getTextBoxFunc) then
      WriteLn('"GetTextBox" function not found');

    @getTextFromTextFunc := getProcAddress(dllHandle, 'GetTextFromText');
    if not Assigned (getTextFromTextFunc) then
      WriteLn('"GetTextFromText" function not found');

    @getComboBoxByNameFunc := getProcAddress(dllHandle, 'GetComboBoxByName');
    if not Assigned (getComboBoxByNameFunc) then
      WriteLn('"GetComboBoxByName" function not found');

    @getComboBoxFunc := getProcAddress(dllHandle, 'GetComboBox');
    if not Assigned (getComboBoxFunc) then
      WriteLn('"GetComboBox" function not found');

    @setTextFunc := getProcAddress(dllHandle, 'SetText');
    if not Assigned (setTextFunc) then
      WriteLn('"SetText" function not found');

  end
  else
  begin
    WriteLn('Dll not found') ;
    Exit;
  end;
end;

destructor TUIAutoWrapper.Destroy;
begin
  FreeLibrary(dllHandle) ;
end;

procedure TUIAutoWrapper.Finalize;
begin
  self.FinalizeFunc;
end;

procedure TUIAutoWrapper.Initialize;
begin
  self.InitializeFunc;
end;

procedure TUIAutoWrapper.WaitWhileBusy;
begin
  self.waitWhileBusyFunc;
end;

function TUIAutoWrapper.GetDesktopWindow(const name: String) : Pointer;
begin
  result := self.getDesktopWindowFunc(name);
end;

procedure TUIAutoWrapper.Focus (handle: Pointer);
begin
  // Nothing yet.
end;

procedure TUIAutoWrapper.Kill;
begin
  self.KillFunc;
end;

procedure TUIautoWrapper.maximize(handle: Pointer);
begin
  self.maximizeFunc (handle);
end;

function TUIAutoWrapper.getTab(handle: Pointer; item: Integer): Pointer;
begin
  result := self.GetTabFunc(handle, item);
end;

function TUIAutoWrapper.GetEditBox(handle: Pointer; item: Integer): pointer;
begin
  result := self.getEditBoxFunc(handle, item);
end;

function TUIAutoWrapper.GetTextBox(handle: Pointer; item: Integer): pointer;
begin
  result := self.getTextBoxFunc(handle, item);
end;

function TUIAutoWrapper.GetTextFromText(handle: Pointer): String;
begin
  result := self.getTextFromTextFunc(handle);
end;

function TUIAutoWrapper.GetText(handle: Pointer): String;
begin
  result := self.getTextFunc(handle);
end;

function TUIAutoWrapper.GetCheckBox(handle: Pointer; index: Integer): Pointer;
begin
  result := self.getCheckBoxFunc(handle, index);
end;

function TUIAutoWrapper.GetComboBox(handle: Pointer; name: String): Pointer;
begin
  result := self.getComboBoxByNameFunc(handle, name);
end;

function TUIAutoWrapper.GetComboBox(handle: Pointer; item: Integer): Pointer;
begin
  result := self.getComboBoxFunc(handle, item);
end;

function TUIAutoWrapper.GetStatusbar(handle: Pointer): Pointer;
begin
  result := self.getStatusbarFunc(handle);
end;

function TUIAutoWrapper.GetEditBox(handle: Pointer; name: String): pointer;
begin
  result := self.getEditBoxByNameFunc(handle, name);
end;

procedure TUIAutoWrapper.SelectTab(handle: Pointer; text: String);
begin
  self.SelectTabFunc(handle, text);
end;

procedure TUIAutoWrapper.SetText(handle: Pointer; text: String);
begin
  self.setTextFunc(handle, text);
end;

procedure TUIAutoWrapper.Toggle(handle: Pointer);
begin
  self.ToggleFunc(handle);
end;

procedure TUIAutoWrapper.Launch(const val1, val2: String);
begin
  self.launchOrAttachFunc(val1, val2);
end;

end.

