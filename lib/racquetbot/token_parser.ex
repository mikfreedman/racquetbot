defmodule Racquetbot.TokenParser do
  def find_token_in_page(page) do
    [el| rest] = Floki.find(page, "meta[name=csrf-token]")
    list2 = elem(el, 1)
    first = List.first(list2)
    elem(first, 1)
  end
end
