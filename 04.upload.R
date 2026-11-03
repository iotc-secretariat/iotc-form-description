SERVER_ROOT = "/reference"

FORMS_FOLDER         = "forms"
ROS_FORMS_FOLDER     = paste0(FORMS_FOLDER, "/ros")

DATA_IOTC_SERVER_IP = Sys.getenv("DATA_IOTC_SERVER_IP")
DATA_IOTC_USERNAME  = Sys.getenv("DATA_IOTC_USERNAME")
DATA_IOTC_PASSWORD  = Sys.getenv("DATA_IOTC_PASSWORD")

print(paste0("IOTC data server IP: ", DATA_IOTC_SERVER_IP))
print(paste0("IOTC data username : ", DATA_IOTC_USERNAME))
print(paste0("IOTC data password : ", str_replace_all(DATA_IOTC_PASSWORD, ".", "*")))

CURL_CMD <- function(url, cmd) {
  curlPerform(url = url, quote = cmd)
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

full_folder = function(version, folder = NA) {
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

upload_forms <- function(version) {
  folder = full_folder(version, FORMS_FOLDER)
  
  for(form in list.files("./form_reporting_templates", pattern = "*.xlsx")) {
    print(paste0("Uploading form '", form, "' in ", folder, "..."))
    
    CURL_FTPu(
      filename   = paste0("./form_reporting_templates/", form),
      target_url = ftp_url(paste0(folder, "/", form))
    )
  }
  
  print(paste0("Uploading all statistical forms as a zipped archive in ", folder, "..."))
  
  zip::zip(zipfile = "./form_reporting_templates/IOTC-stats-forms.zip", 
           files = list.files("./form_reporting_templates/", pattern = "Form-.+.xlsx", full.names = TRUE),
           mode = "cherry-pick")
  
  CURL_FTPu(
    filename   = "./form_reporting_templates/IOTC-stats-forms.zip",
    target_url = ftp_url(paste0(folder, "/IOTC-stats-forms.zip"))
  )
}

upload_ros_forms = function(version) {
  for(form in list.files("./form_reporting_templates/ros", pattern = "*.xlsx")) {
    folder = full_folder(version, ROS_FORMS_FOLDER)
    
    print(paste0("Uploading form '", form, "' in ", folder, "..."))
    
    CURL_FTPu(
      filename   = paste0("./form_reporting_templates/ros/", form),
      target_url = ftp_url(paste0(folder, "/", form))
    )
  }

  print(paste0("Uploading all ROS forms as a zipped archive in ", folder, "..."))
  
  zip::zip(zipfile = "./form_reporting_templates/ros/IOTC-ROS-forms.zip", 
           files = list.files("./form_reporting_templates/ros/", pattern = "Form-.+.xlsx", full.names = TRUE),
           mode = "cherry-pick")
  
  CURL_FTPu(
    filename   = "./form_reporting_templates/ros/IOTC-ROS-forms.zip",
    target_url = ftp_url(paste0(folder, "/IOTC-ROS-forms.zip"))
  )
}

upload_form_docs = function(version) {
  folder = full_folder(version)

  folder = paste0(full_folder(version, "forms"))

  for(form in list.files(paste0("./out/HTML/"), pattern = "*.html")) {
    print(paste0("Uploading form document '", form, "' in ", folder, "..."))

    CURL_FTPu(
      filename   = paste0("./out/HTML/", form),
      target_url = paste0(ftp_url(folder), "/", form)
    )
  }
 }

upload_ros_form_docs <- function(version) {
  
  folder <- paste0(full_folder(version, "forms/ros"))
  
  for(formdoc in list.files(paste0("./out/HTML/ros"), pattern = "*.html")) {
    print(paste0("Uploading form document '", formdoc, "' in ", folder, "..."))
    
    CURL_FTPu(
      filename   = paste0("./out/HTML/ros/", formdoc),
      target_url = paste0(ftp_url(folder), "/", formdoc)
    )
  }
}

disseminate <- function(version) {
  upload_forms(version)
  upload_ros_forms(version)
  upload_form_docs(version)
  upload_ros_form_docs(version)
}

form_version <- "1.0.0"

# Upload forms and descriptions
disseminate(form_version)   

# Upload descriptions only
upload_ros_form_docs(form_version)


