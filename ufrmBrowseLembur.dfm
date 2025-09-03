inherited frmBrowseLembur: TfrmBrowseLembur
  Left = 304
  Top = 157
  Caption = 'Browse Lembur'
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited AdvPanel1: TAdvPanel
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
  end
  inherited AdvPanel2: TAdvPanel
    FullHeight = 0
  end
  inherited AdvPanel3: TAdvPanel
    FullHeight = 0
    inherited cxGrid: TcxGrid
      inherited cxGrdMaster: TcxGridDBTableView
        OnDblClick = cxButton1Click
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
