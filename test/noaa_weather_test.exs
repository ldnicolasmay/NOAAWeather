defmodule NoaaWeatherTest do
  use ExUnit.Case
  doctest NoaaWeather

  test "greets the world" do
    assert NoaaWeather.hello() == :world
  end
end
