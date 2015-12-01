defmodule Racquetbot.Worker do
  use Slack

  def init(initial_state, slack) do
    IO.puts "Connected as #{slack.me.name}"
    {:ok, initial_state}
  end

  def handle_message(message = %{type: "message", text: text}, slack, state) do

    unless sent_from_me?(message, slack) do
      parsed = parse_message(text)
      handle_parsed_message(parsed, message, slack, state)
    end

    {:ok, [message.text | state]}
  end

  def handle_parsed_message({:game_finished, winner, loser}, message, slack, state) do
    message_to_send = post_result(winner, loser)
    send_message(message_to_send, message.channel, slack)
  end

  def post_result(winner, loser) do
    data = """
      utf8=%E2%9C%93&authenticity_token=#{get_token}
      &commit=
      &match%5Bloser%5D=%40#{loser}
      &match%5Bwinner%5D=%40#{winner}
      &match%5Bclub_id%5D=#{get_club_id}
    """

    {:ok, %HTTPoison.Response{status_code: status_code, body: body}} = HTTPoison.post("http://racquet.io/matches", data, [{"Content-Type", "application/x-www-form-urlencoded"}])
    IO.inspect(body)
    inspect(status_code)
  end

  def get_club_id do
    System.get_env("RACQUET_CLUB_ID")
  end

  def get_token do
    {:ok, %HTTPoison.Response{body: body}} = HTTPoison.get("http://racquet.io/pivotal-sydney")
    Racquetbot.TokenParser.find_token_in_page(body)
  end

  def handle_parsed_message(_, _, _, _) do
  end

  def get_number_of_received_messages(state) do
    length(state) + 1
  end

  def parse_message(message) do
    # 'racquetbot mik beat andrew'
    result = Regex.named_captures(~r/^@?racquetbot:? +(?<winner>\w+) +beat +(?<loser>\w+)/, message) 
    if result do
      { :game_finished, result["winner"], result["loser"] }
    end
  end

  def sent_from_me?(%{user: sender_id}, %{me: %{id: my_id}}) do
    sender_id == my_id
  end

  def handle_message(_message, _slack, state) do
    {:ok, state}
  end
end
