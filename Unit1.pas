Unit Unit1;

interface

uses System, System.Drawing, System.Windows.Forms,
     SlimDX, SlimDx.Direct3D9;
type
  Form1 = class(Form)
    procedure Form1_Load(sender: Object; e: EventArgs);
    procedure Form1_Paint(sender: Object; e: PaintEventArgs);
    procedure Form1_FormClosing(sender: Object; e: FormClosingEventArgs);
  {$region FormDesigner}
  internal
    {$resource Unit1.Form1.resources}
    {$include Unit1.Form1.inc}
  {$endregion FormDesigner}
  public
    constructor;
    begin
      InitializeComponent;
    end;
  private
    m_oD3D: Direct3D;
    m_oD3D_Device: Device;
    m_d3dpp: PresentParameters;
    nRedColor: byte;
    function InitializeDirect3D():boolean;
    procedure DestroyDirect3D();
    procedure RenderScene();
    procedure Application_Idle(sender: Object; e: EventArgs);
  end;

implementation

procedure Form1.Form1_Load(sender: Object; e: EventArgs);
begin
  nRedColor := 0;
  if(not InitializeDirect3D()) then
  begin          
    MessageBox.Show('Failed Loading DirectX', 'Error');
    Application.Exit();
    exit;
  end;          
  SetStyle(ControlStyles.Opaque, true);
  SetStyle(ControlStyles.ResizeRedraw, true);
  Application.Idle += Application_Idle;
end;

procedure Form1.Form1_Paint(sender: Object; e: PaintEventArgs);
begin
  RenderScene(); 
end;

procedure Form1.Form1_FormClosing(sender: Object; e: FormClosingEventArgs);
begin
  
end;

procedure Form1.Application_Idle(sender: Object; e: EventArgs);
begin
  Invalidate();
  Inc(nRedColor);  
end;

function Form1.InitializeDirect3D():boolean;
var
  bResult:boolean;
begin
  bResult := false;
  m_d3dpp := new PresentParameters();
  m_d3dpp.SwapEffect := SwapEffect.Discard;
  m_d3dpp.Windowed := true;
  m_d3dpp.EnableAutoDepthStencil := false;
  try
    m_oD3D := new Direct3D();
    var nAdapter := m_oD3D.Adapters.DefaultAdapter.Adapter;
    var d3ddm := m_oD3D.GetAdapterDisplayMode(nAdapter);
    m_d3dpp.BackBufferFormat := d3ddm.Format;
    m_oD3D_Device := new Device
    (
      m_oD3D, nAdapter,
      DeviceType.Hardware, 
      Handle,
      CreateFlags.SoftwareVertexProcessing,
      m_d3dpp
    );
    bResult := m_oD3D_Device <> nil;
  except
    bResult := false;
  end;
  Result := bResult;
end;

procedure Form1.DestroyDirect3D();
begin
  if ( m_oD3D_Device <> nil ) then
    m_oD3D_Device.Dispose();
  if ( m_oD3D <> nil ) then
    m_oD3D.Dispose();
end;

procedure Form1.RenderScene();
begin
  if ( m_oD3D = nil ) then exit;
  if ( m_oD3D_Device = nil ) then exit;
  var gdipColor := Color.FromArgb(nRedColor, 0, 0);
  var d3dColor := new Color4(gdipColor);
  m_oD3D_Device.Clear(ClearFlags.Target, d3dColor, 0.0, 0);
  m_oD3D_Device.BeginScene();
  m_oD3D_Device.EndScene();
  m_oD3D_Device.Present();
end;

end.
