# [DAX] Festive Promo Analysis for Strategic Planning

#### total_revenue(before_promotion)
        = DIVIDE(
            SUMX(fact_events, 
            [base_price]*[quantity_sold(before_promo)]),
          1000000)

#### total_revenue(after_promotion)
        = DIVIDE(
            SUMX(fact_events, 
            [base_price]*[quantity_sold(after_promo)]), 
          1000000)

#### IR%
        =DIVIDE( 
          [total_revenue(after_promotion)] - [total_revenue(before_promotion)], 
          [total_revenue(before_promotion)]) 
          * 100

#### ISU%
        =ROUND(
          DIVIDE(
            SUM(fact_events[quantity_sold(after_promo)]) - SUM(fact_events[quantity_sold(before_promo)]),
            SUM(fact_events[quantity_sold(before_promo)])
          ) * 100,
        2)
