defmodule Racquetbot.WorkerTest do
  use ExUnit.Case
  doctest Racquetbot

  test "the count is not out by 1" do
    assert Racquetbot.Worker.get_number_of_received_messages([]) == 1
    assert Racquetbot.Worker.get_number_of_received_messages(["hello world"]) == 2
  end

  test 'ignores my messages' do
    slack = %{ me: %{ id: 'testy' } }
    message = %{ user: 'testy' }
    assert Racquetbot.Worker.sent_from_me?(message, slack) == true

    slack = %{ me: %{ id: 'balls' } }
    message = %{ user: 'testy' }
    assert Racquetbot.Worker.sent_from_me?(message, slack) == false
  end

  test "it parses a racquetbot message" do
    assert Racquetbot.Worker.parse_message("racquetbot mik beat andrew") == {:game_finished, "mik", "andrew"}
    assert Racquetbot.Worker.parse_message("@racquetbot  mik beat andrew") == {:game_finished, "mik", "andrew"}
    assert Racquetbot.Worker.parse_message("@racquetbot: mik beat  andrew") == {:game_finished, "mik", "andrew"}
    assert Racquetbot.Worker.parse_message("foo mik beat  andrew") == nil
  end
end
