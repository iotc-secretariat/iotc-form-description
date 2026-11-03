# Libraries
library(RCurl)
library(stringr)
library(data.table)

# Server path configuration 
SERVER_ROOT <- "/reference"

FORM_DESCRIPTIONS_FOLDER       <- "form-descriptions"
STATS_DESCRIPTIONS_FOLDER      <- paste0(FORM_DESCRIPTIONS_FOLDER, "/stats")
ROS_DESCRIPTIONS_FOLDER        <- paste0(FORM_DESCRIPTIONS_FOLDER, "/ros")

DATA_IOTC_SERVER_IP = Sys.getenv("DATA_IOTC_SERVER_IP")
DATA_IOTC_USERNAME  = Sys.getenv("DATA_IOTC_USERNAME")
DATA_IOTC_PASSWORD  = Sys.getenv("DATA_IOTC_PASSWORD")

print(paste0("IOTC data server IP: ", DATA_IOTC_SERVER_IP))
print(paste0("IOTC data username : ", DATA_IOTC_USERNAME))
print(paste0("IOTC data password : ", str_replace_all(DATA_IOTC_PASSWORD, ".", "*")))

CURL_CMD <- function(url, cmd) {
  invisible(
    curlPerform(
      url = url,
      quote = cmd,
      writefunction = function(x) nchar(x)
    )
  )
}

CURL_FTPu <- function(filename, target_url, asText = FALSE) {
  ftpUpload(what = filename, 
            to = target_url, 
            asText = asText,
            .opts = list(ftp.create.missing.dirs = TRUE))
}

check_connection <- function(command) {
  if(!can_connect()) 
    stop(
      paste0("Cannot connect with remote server at ", DATA_IOTC_SERVER_IP, " using ", DATA_IOTC_USERNAME, " as username: please check that server IP and credentials are correct...")
    )
}

userpwd <- function() {
  return(paste0(DATA_IOTC_USERNAME, ":", DATA_IOTC_PASSWORD))
}

ftp_root <- function() {
  return(ftp_url())
}

ftp_url <- function(path = NA) {
  return(
    paste0(
      "sftp://", 
      userpwd(), 
      "@", DATA_IOTC_SERVER_IP, 
      ifelse(is.na(path), "", paste0("/", path))
    )
  )
}

can_connect <- function() {
  return(url.exists(ftp_url(), userpwd = userpwd()))
}

full_folder <- function(version, folder = NA) {
  return(
    paste0(SERVER_ROOT, "/", version, ifelse(is.na(folder), "", paste0("/", folder)))
  )
}

create_folder <- function(version, folder) {
  folder = paste0(full_folder(version, folder), "/")
  
  print(paste0("Creating empty remote folder ", folder, "..."))
  
  cmd = paste0("mkdir ", folder)
  
  CURL_CMD(ftp_root(), cmd)
}

initialize_folder <- function(version, folder) {
  folder = full_folder(version, folder)
  
  print(paste0("FOLDER: ", folder))
  
  if(url.exists(ftp_url(folder), userpwd = userpwd())) {
    print(paste0("Remote folder ", folder, " already exists...")) 
  } else {
    print(paste0("Creating empty remote folder ", folder, "..."))
    
    cmd = paste0("mkdir ", folder)
    
    CURL_CMD(ftp_root(), cmd)
  }
}

initialize_version <- function(version) {
  check_connection()
  
  folder = full_folder(version)
  
  if(url.exists(ftp_url(folder))) {
    print(paste0("Remote folder for version ", version, " already exists... Skipping folder creation."))
  } else {
    print(paste0("Creating remote folder for version '", version, "'..."))
    
    CURL_CMD(ftp_root(), paste0("mkdir ", folder))
  }
  
  initialize_forms(version)
}

upload_form_pages <- function(type = c("root", "stats", "ros")) {
  
  type <- match.arg(type)
  
  local_folder <- switch(
    type,
    root  = "./out/HTML",
    stats = "./out/HTML/stats",
    ros   = "./out/HTML/ros"
  )
  
  remote_folder <- switch(
    type,
    root  = full_folder(FORM_DESCRIPTIONS_FOLDER),
    stats = full_folder(STATS_DESCRIPTIONS_FOLDER),
    ros   = full_folder(ROS_DESCRIPTIONS_FOLDER)
  )
  
  # Only the two landing pages at the root
  if (type == "root") {
    
    files <- file.path(
      local_folder,
      c("index.html", "index_fr.html")
    )
    
    missing_files <- files[!file.exists(files)]
    
    if (length(missing_files)) {
      warning(
        "Skipping missing landing page(s): ",
        paste(basename(missing_files), collapse = ", ")
      )
    }
    
    # Keep only files that actually exist
    files <- files[file.exists(files)]
    
  } else {
    
    files <- list.files(
      local_folder,
      pattern = "\\.html$",
      full.names = TRUE
    )
  }
  
  for (file in files) {
    
    filename <- basename(file)
    
    print(paste0(
      "Uploading form description '",
      filename,
      "' in ",
      remote_folder,
      "..."
    ))
    
    CURL_FTPu(
      filename   = file,
      target_url = paste0(
        ftp_url(remote_folder),
        "/",
        filename
      )
    )
  }
  
  invisible(files)
}

# Uploading pages
upload_form_pages("root")
upload_form_pages("stats")
upload_form_pages("ros")

