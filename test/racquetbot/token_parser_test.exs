defmodule Racquetbot.TokenParserTest do
  use ExUnit.Case

  test "finds the token" do
    page = """
    <html>
    <head>
    <meta content="ZcesNkWyjeqqhJoQYOnx3TWRAHBTNu2v9FHr8JBIP5s=" name="csrf-token">
    </head>
    </html>
    """

    assert Racquetbot.TokenParser.find_token_in_page(page) == "ZcesNkWyjeqqhJoQYOnx3TWRAHBTNu2v9FHr8JBIP5s="
  end
end
