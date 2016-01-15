# DEPRECATED #

We have moved our work to <https://github.com/mikfreedman/slacker-racquetio>

# Racquetbot

> slackbot that posts to racquet.io
 
## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add racquetbot to your list of dependencies in `mix.exs`:

        def deps do
          [{:racquetbot, "~> 0.0.1"}]
        end

  2. Ensure racquetbot is started before your application:

        def application do
          [applications: [:racquetbot]]
        end

## Running

```bash
 SLACK_API_TOKEN=api-token RACQUET_CLUB_ID=666 mix run --no-halt
```
