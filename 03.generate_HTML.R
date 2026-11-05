### Limit all interactive tables to a number of rows
options(DT.options = list(pageLength = 3))

# Form Main Access Page (EN) ####
render_iotc(
  input = "./RMDs/Form-main.Rmd", 
  output_dir = "./out/HTML/", 
  output_file = "index.html", 
  toc = FALSE
)

# FORM SUMMARY (FR) ####
# render("./RMDs/Form-main_fr.Rmd",
#       output_format = "html_document2",
#        output_file = "index_fr.html",
#        output_dir = "./out/HTML/")

# IOTC STATISTICAL FORMS ####

## Amount of discards ####

### Form 1-DI ####
render_iotc(
  input = "./RMDs/stats/Form-1DI.rmd", 
  output_dir ="./out/HTML/stats/", 
  output_file = "Form-1DI.html"
)

## Species presence in the catch ####

### Form 1-DR ####
render_iotc(
  input = "./RMDs/stats/Form-1DR.Rmd", 
  output_dir ="./out/HTML/stats/", 
  output_file = "Form-1DR.html"
)

## Interactions with ETP species ####

### Form 1-IN ####
render_iotc(
  input = "./RMDs/stats/Form-1IN.Rmd", 
  output_dir ="./out/HTML/stats/", 
  output_file = "Form-1IN.html"
)

## Amount of fish caught and retained ####

### Form 1-RC #####
render_iotc(
  input = "./RMDs/stats/Form-1RC.Rmd", 
  output_dir ="./out/HTML/stats/", 
  output_file = "Form-1RC.html"
)

## Geo-referenced catches and efforts ####

### Form 3-CE ####
render_iotc(
  input = "./RMDs/stats/Form-3CE.Rmd", 
  output_dir ="./out/HTML/stats/", 
  output_file = "Form-3CE.html"
)

## Geo-referenced size frequencies ####

### Form 4-SF ####
render_iotc(
  input = "./RMDs/stats/Form-4SF.Rmd", 
  output_dir ="./out/HTML/stats/", 
  output_file = "Form-4SF.html"
)

## AFAD-related activities ####

### Form 3-AA ####
render_iotc(
  input = "./RMDs/stats/Form-3AA.Rmd", 
  output_dir ="./out/HTML/stats/", 
  output_file = "Form-3AA.html"
)

## DFOB-related activities ####

### Form 3-DA ####
render_iotc(
  input = "./RMDs/stats/Form-3DA.Rmd", 
  output_dir ="./out/HTML/stats/", 
  output_file = "Form-3DA.html"
)

## Daily buoy positions ####

### Form 3BU ####
render_iotc(
  input = "./RMDs/stats/Form-3BU.Rmd", 
  output_dir ="./out/HTML/stats/", 
  output_file = "Form-3BU.html"
)

## Fishing craft statistics ####

### Form 2FC #####
render_iotc(
  input = "./RMDs/stats/Form-2FC.Rmd", 
  output_dir ="./out/HTML/stats/", 
  output_file = "Form-2FC.html"
)

## Form 5MB ####
render_iotc(
  input = "./RMDs/stats/Form-5MB.Rmd", 
  output_dir ="./out/HTML/stats/", 
  output_file = "Form-5MB.html"
)

### Form 6LG #####
render_iotc(
  input = "./RMDs/stats/Form-6LG.Rmd", 
  output_dir ="./out/HTML/stats/", 
  output_file = "Form-6LG.html"
)

### Form 7PR #####
render_iotc(
  input = "./RMDs/stats/Form-7PR.Rmd", 
  output_dir ="./out/HTML/stats/", 
  output_file = "Form-7PR.html"
)

# ROS REPORTING FORMS ####

## LONGLINE ####
render_iotc(
  input = "./RMDs/ros/ROS-LL.Rmd", 
  output_dir ="./out/HTML/ros/", 
  output_file = "Form-ROS-LL.html"
)

## POLE-AND-LINE ####
render_iotc(
  input = "./RMDs/ros/ROS-PL.Rmd", 
  output_dir ="./out/HTML/ros/", 
  output_file = "Form-ROS-PL.html"
)

## PURSE SEINE ####
render_iotc(
  input = "./RMDs/ros/ROS-PS.Rmd", 
  output_dir ="./out/HTML/ros/", 
  output_file = "Form-ROS-PS.html"
)

## GILLNET ####
render_iotc(
  input = "./RMDs/ros/ROS-GN.Rmd", 
  output_dir ="./out/HTML/ros/", 
  output_file = "Form-ROS-GN.html"
)
