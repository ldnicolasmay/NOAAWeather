defmodule NOAAWeather do

  # require Logger

  @noaa_url Application.get_env(:noaa_weather, :noaa_weather_url)

  def fetch(icao_code) do 
    # Logger.info("Fetching weather at #{icao_code}")

    weather_url(icao_code)
    |> HTTPoison.get()
    |> handle_response()
  end

  defp weather_url(icao_code), do: "#{@noaa_url}?stid=#{icao_code}"

  defp handle_response({_, %{status_code: status_code, body: body}}) do 
    # Logger.info("Got reponse: status_code=#{status_code}")
    # Logger.debug(fn -> IO.inspect(body) end)

    {
      status_code |> check_for_error(),
      body |> parse_xml()
    }
  end

  defp check_for_error(200), do: :ok
  defp check_for_error(_), do: :error

  defp parse_xml(xml_str) do 
    with parsed_xml_map = XmlToMap.naive_map(xml_str)
    do 
      parsed_xml_map["current_observation"]["#content"]
    end
  end
end
