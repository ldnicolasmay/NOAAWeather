defmodule NOAAWeather.CLI do 

  # import OptionParser, only: [parse: 2]
  # import NOAAWeather.NOAAWeather, only: [fetch: 1]

  # @default_icao_code "KFLG"
  @default_icao_code "KARB"
  @default_measures_list [
    "location",
    "station_id",
    "observation_time",
    "weather",
    "temperature_string",
    "pressure_string",
    "wind_string",
  ]

  @moduledoc """
  Handle the command line parsing and the dispatch of various functions that end up generating a
  a table of the most current hourly weather data at a given airport, indicated by ICAO code.
  """

  # mix run -e 'NOAAWeather.CLI.run(["--help"])'
  # mix run -e 'NOAAWeather.CLI.run(["--icao-code", "KDTO", "temp_f", "temp_c", "wind_dir"])'
  # mix run -e 'NOAAWeather.CLI.run(["temp_f", "temp_c", "wind_dir"])'
  # def run(argv) do 
  def main(argv) do 
    argv
    |> parse_args()
    |> process()
  end

  def parse_args(argv) do 
    argv
    |> OptionParser.parse(
      switches: [help: :boolean, icao_code: :string],
      aliases: [h: :help, i: :icao_code]
    )
    # {[icao_code: "KFLG"], ["f_temp", "c_temp", "humidity"], []}
    |> args_to_internal_representation()
  end

  def args_to_internal_representation({[], [], _}) do 
    {@default_icao_code, @default_measures_list}
  end

  def args_to_internal_representation({[icao_code: code], [], _}) do 
    {code, @default_measures_list}
  end

  def args_to_internal_representation({[], measures_list, _}) do
    {@default_icao_code, measures_list}
  end

  def args_to_internal_representation({[icao_code: code], measures_list, _}) do 
    {code, measures_list}
  end

  def args_to_internal_representation(_), do: :help
  
  def process({icao_code, measures_list}) do 
    NOAAWeather.fetch(icao_code)
    # |> IO.inspect()
    |> decode_response()
    # |> IO.inspect()
    |> get_measures(measures_list)
    # |> IO.inspect()
    |> TableFormatter.print_table()
  end
    
  def process(:help) do
    IO.puts("""
    usage: noaa_weather [<icao_code> | #{@default_icao_code}] [measure, [measure, [...]]]

    measures include:
      location
      station_id
      latitude
      longitude
      observation_time
      observation_time_rfc822
      weather
      temperature_string
      temp_f
      temp_c
      relative_humidity
      wind_string
      wind_dir
      wind_degrees
      wind_mph
      wind_kt
      pressure_string
      pressure_mb
      pressure_in
      dewpoint_string
      dewpoint_f
      dewpoint_c
      visibility
    """)
  
    System.halt(0)
  end

  def decode_response({:ok, body}), do: body
  def decode_response({:error, error}) do 
    IO.puts("Error fetching from weather.gov: #{error["message"]}")
    System.halt(2)
  end

  def get_measures(measures_map, measures_list) do 
    with measures = for m <- measures_list, do: measures_map[m]
    do 
      # Enum.zip(measures_list, measures)
      {measures_list, measures}
    end
  end
end
