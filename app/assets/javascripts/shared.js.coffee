sort_by_value = ( hash )->
  sortable = []
  sortable.push [v,k] for k, v of hash
  sortable.sort (a, b) ->  b[0]- a[0]

