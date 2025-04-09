from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.chrome.service import Service as ChromeService
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.chrome.options import Options
from datetime import date
import sys
import time

options = Options()
options.add_argument("--headless")

sys.argv[1]
name = sys.argv[1]
email = sys.argv[2]
option_to_select_text = sys.argv[3]
send_responses = sys.argv[4]=="Y"

driver = webdriver.Chrome(options=options)
driver.get("https://app.smartsheet.com/b/form/7fad7575b1da4b64a96c8d55358821a0")  


entryDateField = WebDriverWait(driver, 10).until(
    EC.presence_of_element_located((By.ID, "date_Entry Date"))
)
entryDateField.clear()
entryDateField.send_keys(date.today().strftime('%m/%d/%Y'))

nameField = WebDriverWait(driver, 10).until(
    EC.presence_of_element_located((By.ID, "text_box_Name"))
)
nameField.clear()
nameField.send_keys(name)

emailField = WebDriverWait(driver, 10).until(
    EC.presence_of_element_located((By.ID, "text_box_Email"))
)
emailField.clear
emailField.send_keys(email)
dropdown_control = WebDriverWait(driver, 10).until(
    EC.presence_of_element_located((By.CLASS_NAME, "css-kf2egt-control"))
)
dropdown_control.click()
options_menu = WebDriverWait(driver, 10).until(
    EC.presence_of_element_located((By.CLASS_NAME, "react-select__menu"))
)
option_to_select = WebDriverWait(driver, 10).until(  # Increased timeout
    EC.presence_of_element_located((By.XPATH, f"//div[text()='{option_to_select_text}']"))
)
option_to_select.click()
dropdown_control.click()

if(send_responses):
    responseCheck = driver.find_element(by=By.NAME, value="EMAIL_RECEIPT_CHECKBOX") 
    responseCheck.click()

responseEmail = WebDriverWait(driver,10).until(
    EC.presence_of_element_located((By.ID,"text_box_EMAIL_RECEIPT"))
)
responseEmail.send_keys(email)

submitButton = WebDriverWait(driver,10).until(
    EC.presence_of_element_located((By.XPATH,"//button[@type='submit' and @value='submit']"))
)
submitButton.click()
time.sleep(5)
print("ALL CLEAR")
driver.quit()

