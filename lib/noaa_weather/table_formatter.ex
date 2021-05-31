defmodule TableFormatter do
  def print_table(columnar_data) do 
    # {
    #   ["location", "station_id", "observation_time", "weather", "temperature_string", 
    #     "pressure_string", "wind_string"],
    #   ["Flagstaff Pulliam Airport, AZ", "KFLG",
    #     "Last Updated on May 30 2021, 10:57 am MST", "Fair", "71.0 F (21.7 C)",
    #     "1010.1 mb", "from the South at 12.7 gusting to 19.6 MPH (11 gusting to 17 KT)"]
    # }
    with col_data_list = columnar_data |> Tuple.to_list(),
         # [
         #   ["location", "station_id", "observation_time", "weather",
         #    "temperature_string", "pressure_string", "wind_string"],
         #   ["Flagstaff Pulliam Airport, AZ", "KFLG",
         #    "Last Updated on May 30 2021, 10:57 am MST", "Fair", "71.0 F (21.7 C)",
         #    "1010.1 mb",
         #    "from the South at 12.7 gusting to 19.6 MPH (11 gusting to 17 KT)"]
         # ]
         data_as_rows = col_data_list |> Enum.zip(),
         # [
         #   {"location", "Flagstaff Pulliam Airport, AZ"},
         #   {"station_id", "KFLG"},
         #   {"observation_time", "Last Updated on May 30 2021, 10:57 am MST"},
         #   {"weather", "Fair"},
         #   {"temperature_string", "71.0 F (21.7 C)"},
         #   {"pressure_string", "1010.1 mb"},
         #   {"wind_string",
         #    "from the South at 12.7 gusting to 19.6 MPH (11 gusting to 17 KT)"}
         # ]
         col_data_widths = (for col <- col_data_list, do: Enum.map(col, &String.length/1)),
         # [[8, 10, 16, 7, 18, 15, 11], [29, 4, 41, 4, 15, 9, 64]]
         col_max_widths = (for col <- col_data_widths, do: Enum.reduce(col, &max/2)),
         # [18, 64]
         formatted_data_as_rows = data_as_rows 
                                  |> Enum.map(&format_row(&1, col_max_widths, "|", " "))
    do
      print_header({"measure", "value"}, col_max_widths)
      formatted_data_as_rows |> Enum.each(&IO.puts/1)
      print_table_boundary(col_max_widths)
    end
  end

  def format_row(row_tuple, col_widths, sep \\ "|", pad \\ " ") do 
    with row_list = Tuple.to_list(row_tuple),
         row_vals_col_widths = Enum.zip(row_list, col_widths),
         row_vals_padded = (for {row_val, col_width} <- row_vals_col_widths do 
           String.pad_trailing(row_val, col_width)
           end),
         row_vals_separated = Enum.map_join(row_vals_padded, pad <> sep <> pad, &(&1))
    do
      "#{sep}#{pad}" <> row_vals_separated <> "#{pad}#{sep}"
    end
  end

  def to_row(row_list, sep \\ "|", pad \\ " ") do
    Enum.map_join(row_list, pad <> sep <> pad, &(&1))
  end

  def repeat_str(str, n) do 
    Enum.to_list(1..n)
    |> List.foldl("", fn _, acc -> acc <> str end)
  end

  def print_header(label_tuple, col_max_widths) do 
    print_table_boundary(col_max_widths)
    label_tuple |> format_row(col_max_widths) |> IO.puts()
    print_table_boundary(col_max_widths)
  end

  def print_table_boundary(col_max_widths) do 
    col_max_widths 
    |> Enum.map(&repeat_str("-", &1))
    |> List.to_tuple()
    |> format_row(col_max_widths, "+", "-")
    |> IO.puts()
  end

end

