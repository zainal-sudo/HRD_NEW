inherited frmBrowseLembur: TfrmBrowseLembur
  Left = 351
  Top = 238
  Caption = 'Browse Lembur'
  ClientWidth = 748
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited AdvPanel1: TAdvPanel
    Width = 748
    FullHeight = 0
    inherited cxButton1: TcxButton
      OnClick = cxButton1Click
    end
    inherited cxButton2: TcxButton
      OnClick = cxButton2Click
    end
    inherited cxButton3: TcxButton
      Visible = False
    end
    inherited cxButton4: TcxButton
      OnClick = cxButton4Click
    end
    inherited cxButton6: TcxButton
      Visible = False
    end
    inherited cxButton8: TcxButton
      Left = 659
    end
    object cxButton5: TcxButton
      Left = 538
      Top = 2
      Width = 87
      Height = 32
      Caption = '&Preview'
      TabOrder = 7
      OnClick = cxButton5Click
      Align = alLeft
      LookAndFeel.Kind = lfStandard
      LookAndFeel.SkinName = 'LondonLiquidSky'
    end
  end
  inherited AdvPanel2: TAdvPanel
    Width = 748
    FullHeight = 0
    inherited btnRefresh: TcxButton
      Left = 659
    end
  end
  inherited AdvPanel3: TAdvPanel
    Width = 748
    FullHeight = 0
    inherited cxGrid: TcxGrid
      Width = 744
      inherited cxGrdMaster: TcxGridDBTableView
        OnDblClick = cxButton1Click
        OptionsView.Footer = True
        Styles.OnGetContentStyle = cxGrdMasterStylesGetContentStyle
      end
    end
  end
  object cxStyleRepository1: TcxStyleRepository
    Left = 336
    Top = 161
    PixelsPerInch = 96
    object cxStyle1: TcxStyle
      AssignedValues = [svColor]
      Color = clYellow
    end
  end
end
