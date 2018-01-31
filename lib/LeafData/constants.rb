module LeafData
  module Constants
    module ResponsePage
      SAMPLE_ATTR            = { 'c' => 'date', 'd' => 'product', 'e' => 'quantity' }
      BUTTON_RECEIVE         = 'input[value="Receive Sample"]'
      BUTTON_RESULTS         = 'input[value="Add Results"]'
      BUTTON_ACTION_IDX      = 'input#button-IDX'
      UI_ELEMENTS            = ('b'..'e')
      LOT_BATCH_COLUMN_COUNT = 3
      UI_ELEMENT_IDX         = '.ui-block-IDX'
      DATA_ELEMENT           = '.ui-bar-e'
      SAMPLE_ID_OFFSET       = 0
      LOT_ID_OFFSET          = 2
      DATA_OFFSET            = 2
      SHIPPED_QUANTITY       = 'table:nth-child(1) > tr:nth-child(1) > td:nth-child(2)'
    end

    module API
      HOME_PAGE       = '/labtesting.asp'.freeze
      LOGIN_PAGE      = '/qlogin.asp'.freeze
      LICENSEE_SEARCH = '/qasearch.asp?style=full&maxRows=10&name_startsWith='.freeze
      LICENSE_SEARCH  = '/qasearchreturn.asp?l='.freeze
      SAMPLE_SEARCH   = '/qasearchreturn_lot.asp?l='.freeze
      SAMPLE_RECEIVE  = '/labtestreceive.asp?id='.freeze
      CREATE_RESULTS  = '/labtestresult.asp?id='.freeze
      UPDATE_RESULTS  = '/labtestresult_modify.asp?id='.freeze
      RECEIVE_PAGE    = '/labtestreceive.asp?id='.freeze
    end

    # ANALITES = {
    #   b_moisture: 'page1_moisture',
    #   c_thc: 'page2_THC',
    #   c_thca: 'page2_CBDA',
    #   c_cbd: 'page2_CBD',
    #   c_cbda: 'page2_CBDA',
    #   v_stems: 'page3_Stems',
    #   v_other: 'page3_Other',
    #   m_aerobic_count: 'page4_aerobic_bacteria',
    #   m_yeast_mold: 'page4_yeast_and_mold',
    #   m_total_coliform: 'page4_coliforms',
    #   m_btgn_bacteria: 'page4_bile_tolerant',
    #   m_ecoli: 'page4_e_coli_and_salmonella',
    #   mycotoxins_pass: 'page6_total_mycotoxins',
    #   pesticide_pass: 'page7_pesticide_screening',
    #   heavy_metal_pass: 'page8_heavy_metal',
    #   amount_destroyed_pct: 'sample_amount_destroyed',
    #   amount_other_pct: 'sample_amount_other'
    # }

  end
end
