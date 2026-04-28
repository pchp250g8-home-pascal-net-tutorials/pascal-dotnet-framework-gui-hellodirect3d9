procedure InitializeComponent;
    begin
        self.SuspendLayout();
        // 
        // Form1
        // 
        self.ClientSize := new System.Drawing.Size(686, 504);
        self.Name := 'Form1';
        self.Text := 'Form1';
        self.FormClosing += Form1_FormClosing;
        self.Load += Form1_Load;
        self.Paint += Form1_Paint;
        self.ResumeLayout(false);
    end;
