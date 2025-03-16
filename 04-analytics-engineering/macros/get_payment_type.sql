{#
    This macro return the description of payment
#}

{%- macro get_payment_type(payment_type) -%}

    CASE CAST({{payment_type}} as INTEGER)
        WHEN 1 THEN 'Credit Card'
        WHEN 2 THEN 'Cash'
        WHEN 3 THEN 'No Charge'
        WHEN 4 THEN 'Dispute'
        WHEN 5 THEN 'Unknown'
        WHEN 6 THEN 'Volded Trip'
        ELSE 'Empty'
    END
    
{%- endmacro -%}