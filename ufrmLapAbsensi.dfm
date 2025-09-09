inherited frmLapAbsensi: TfrmLapAbsensi
  Left = 318
  Top = 209
  Caption = 'Lap. Absensi'
  ClientWidth = 905
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited AdvPanel1: TAdvPanel
    Width = 905
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
    inherited cxButton8: TcxButton
      Left = 816
    end
  end
  inherited AdvPanel2: TAdvPanel
    Width = 905
    FullHeight = 0
    inherited btnRefresh: TcxButton
      Left = 816
    end
    inherited startdate: TDateTimePicker
      TabOrder = 2
    end
    inherited enddate: TDateTimePicker
      TabOrder = 3
    end
    object CheckBox1: TCheckBox
      Left = 448
      Top = 7
      Width = 169
      Height = 17
      Caption = 'Tampilkan keterangan'
      TabOrder = 4
    end
    object cxButton5: TcxButton
      Left = 729
      Top = 2
      Width = 87
      Height = 29
      Caption = '&Sync roti'
      TabOrder = 1
      OnClick = cxButton5Click
      Align = alRight
      LookAndFeel.Kind = lfStandard
      LookAndFeel.SkinName = 'LondonLiquidSky'
    end
    object cxButton9: TcxButton
      Left = 642
      Top = 2
      Width = 87
      Height = 29
      Caption = '&Sync pkrt'
      TabOrder = 5
      OnClick = cxButton9Click
      Align = alRight
      LookAndFeel.Kind = lfStandard
      LookAndFeel.SkinName = 'LondonLiquidSky'
    end
  end
  inherited AdvPanel3: TAdvPanel
    Width = 905
    FullHeight = 0
    inherited cxGrid: TcxGrid
      Width = 901
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
