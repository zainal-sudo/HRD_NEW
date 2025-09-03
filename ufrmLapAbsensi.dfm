inherited frmLapAbsensi: TfrmLapAbsensi
  Left = 153
  Top = 149
  Caption = 'Lap. Absensi'
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited AdvPanel1: TAdvPanel
    FullHeight = 0
    inherited cxButton1: TcxButton
      Visible = False
    end
    inherited cxButton2: TcxButton
      Visible = False
    end
    inherited cxButton3: TcxButton
      Visible = False
    end
    inherited cxButton4: TcxButton
      Visible = False
    end
    inherited cxButton6: TcxButton
      Visible = False
    end
  end
  inherited AdvPanel2: TAdvPanel
    FullHeight = 0
    object CheckBox1: TCheckBox
      Left = 448
      Top = 7
      Width = 169
      Height = 17
      Caption = 'Tampilkan keterangan'
      TabOrder = 3
    end
  end
  inherited AdvPanel3: TAdvPanel
    FullHeight = 0
    inherited cxGrid: TcxGrid
      PopupMenu = PopupMenu1
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 144
    Top = 177
    object ransaksiIjin1: TMenuItem
      Caption = 'Transaksi Ijin'
    end
    object EditAbsensi1: TMenuItem
      Caption = 'Edit Absensi'
    end
  end
end
