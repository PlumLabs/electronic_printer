# README

* Ruby version 2.5.1

* Rails version 5.2.1

API destinada a facilitar la facturacion electronica en los distintos sitemas de :PLUM

# README

* Ruby version 2.5.1

* Rails version 5.2.1

API destinada a facilitar la facturacion electronica en los distintos sitemas de :PLUM

Interface

`/api/v1/billings/bill`

```rb
params: {
  invoice: {
    invoice_paramas
  },
  company: {
    unformat_cuit, company_iva_condition
  },
  point_sale: {
    pos_number, concept
  },
  items: {
    items_params
  }
}
```

`/api/v1/billings/state`

```rb
params: {
  slug
}
```

`/api/v1/billings/send_data`
