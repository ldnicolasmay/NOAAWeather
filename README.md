# NoaaWeather

Elixir CLI utility to retrieve NOAA current weather for an airport's ICAO code.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `noaa_weather` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:noaa_weather, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/noaa_weather](https://hexdocs.pm/noaa_weather).

## Build Binary Erlang Executable

```shell
mix escript.build
```

## Basic Run

The default airport is `KARB` (Ann Arbor Municipal).

The default measures are `location`, `station_id`, `observation_time`, `weather`, `temperature_string`, `pressure_string`, and `wind_string`

```shell
./noaa_weather
```

yields

```
+--------------------+--------------------------------------------+
| measure            | value                                      |
+--------------------+--------------------------------------------+
| location           | Ann Arbor, Ann Arbor Municipal Airport, MI |
| station_id         | KARB                                       |
| observation_time   | Last Updated on Jul 9 2021, 10:53 pm EDT   |
| weather            | Fair                                       |
| temperature_string | 56.0 F (13.3 C)                            |
| pressure_string    | 1018.6 mb                                  |
| wind_string        | Calm                                       |
+--------------------+--------------------------------------------+
```

To get the default weather measures from a specific airport, add the `--icao-code` option and an airport code, like `KFLG` (Flagstaff Pulliam). 

```shell
./noaa_weather --icao-code KFLG
```

yields

```
+--------------------+-----------------------------------------+
| measure            | value                                   |
+--------------------+-----------------------------------------+
| location           | Flagstaff Pulliam Airport, AZ           |
| station_id         | KFLG                                    |
| observation_time   | Last Updated on Jul 9 2021, 7:57 pm MST |
| weather            | Fair                                    |
| temperature_string | 79.0 F (26.1 C)                         |
| pressure_string    | 1013.3 mb                               |
| wind_string        | Calm                                    |
+--------------------+-----------------------------------------+
```

To get specific weather measures, list them after the executable or the `--icao-code` option.

```shell
./noaa_weather location observation_time weather temperature_string
```

yields

```
+--------------------+--------------------------------------------+
| measure            | value                                      |
+--------------------+--------------------------------------------+
| location           | Ann Arbor, Ann Arbor Municipal Airport, MI |
| observation_time   | Last Updated on Jul 9 2021, 10:53 pm EDT   |
| weather            | Fair                                       |
| temperature_string | 56.0 F (13.3 C)                            |
+--------------------+--------------------------------------------+
```

```shell
./noaa_weather --icao-code KFLG location observation_time weather temperature_string
```

yields

```
+--------------------+-----------------------------------------+
| measure            | value                                   |
+--------------------+-----------------------------------------+
| location           | Flagstaff Pulliam Airport, AZ           |
| observation_time   | Last Updated on Jul 9 2021, 7:57 pm MST |
| weather            | Fair                                    |
| temperature_string | 79.0 F (26.1 C)                         |
+--------------------+-----------------------------------------+
```

