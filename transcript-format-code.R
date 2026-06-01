library(tidyverse)


#In Panopto - ID speakers (A:, B:, P:, S:..)
#Export the Transcript
#Run Code to get Spreadsheet
#Correct Text as Coding in Spreadsheet (save xlxs)


transcripts <- read_delim("original/name-here.txt",  #delete name-here.txt and press tab to select the right transcript from the original folder
                          delim = "\" \"", 
                          skip_empty_rows = TRUE, 
                          col_names = FALSE)


transcripts |> 
  filter(!str_detect(X1, "Auto-generated")) |> 
  group_by(grp = str_c('Column', rep(1:3, length.out = n()))) |> 
  mutate(rn = row_number()) |> 
  ungroup() |> 
  pivot_wider(names_from = grp, 
              values_from = X1) |> 
  select(-rn) |> 
  separate(Column2, 
           into = c("start_time", "end_time"), 
           sep = " --> ") |>  
  mutate(chunks = str_extract_all(Column3, "[A-Z]:.*?(?=\\s*[A-Z]:|$)")) |> 
  unnest(chunks) |> 
  mutate(
    label = str_match(chunks, "^([A-Z]):")[,2],  #    label = str_match(chunks, "^([A-Z]):")[,2],
    text = str_trim(str_replace(chunks, "^[A-Z]:", ""))) |> 
  group_by(Column3) |> 
  mutate(order = row_number()) |> 
  ungroup() |> 
  rename(original = Column3) |> 
  select(start_time, order, label, text, original) |> 
  write_excel_csv("clean/clean_example.csv")  #change name to id video as date, initials of speakers, group, marker
#example transcript-01-27-26-jg-me-group-4-red.csv

