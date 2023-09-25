*** Settings ***
Documentation  This is a resource file containing user-defined keywords for new Vue based OpenBMC GUI.
Library        XvfbRobot
Library        SeleniumLibrary
#Library        SSHLibrary  30 Seconds
#Resource       ../lib/state_manager.robot
Variables      ../data/gui_variables.py


*** Variables ***
${obmc_gui_url}              https://192.168.0.100    #https://${OPENBMC_HOST}
${xpath_power_page}          //*[@data-test-id='appHeader-container-power']
${xpath_power_shutdown}      //*[@data-test-id='serverPowerOperations-button-shutDown']
${xpath_power_power_on}      //*[@data-test-id='serverPowerOperations-button-powerOn']
${xpath_power_reboot}        //*[@data-test-id='serverPowerOperations-button-reboot']
${xpath_confirm}             //button[contains(text(),'Confirm')]
# Default GUI browser and mode is set to "Firefox" and "headless"
# respectively here.
${GUI_BROWSER}               chrome    #ff
#${GUI_MODE}                  headless


*** Keywords ***

#Open Browser With URL
#    [Documentation]  Open browser with specified URL and returns browser id.
#    [Arguments]  ${URL}  ${browser}=ff  ${mode}=${GUI_MODE}
    # Description of argument(s):
    # URL      Openbmc GUI URL to be open
    #          (e.g. https://openbmc-test.mybluemix.net/#/login).
    # browser  Browser used to open above URL
    #          (e.g. gc for google chrome, ff for firefox).
    # mode     Browser opening mode(e.g. headless, header).
#    ${browser_ID}=  Run Keyword If  '${mode}' == 'headless'
#    ...  Launch Headless Browser  ${URL}  ${browser}
#    ...  ELSE  Open Browser  ${URL}  ${browser}
#    [Return]  ${browser_ID}

Launch Header Browser
    [Documentation]  Open the browser with the URL and
    ...              login on windows platform.
    [Arguments]  ${browser_type}=${GUI_BROWSER}
    # Description of argument(s):
    # browser_type  Type of browser (e.g. "firefox", "chrome", etc.).
    ${BROWSER_ID}=  Open Browser  ${obmc_gui_url}  ${browser_type}
    Maximize Browser Window
    Set Global Variable  ${BROWSER_ID}


#Launch Headless Browser
#    [Documentation]  Launch headless browser.
#    [Arguments]  ${URL}=${obmc_gui_url}  ${browser}=${GUI_BROWSER}
    # Description of argument(s):
    # URL      Openbmc GUI URL to be open
    #          (e.g. https://openbmc-test.mybluemix.net/#/login).
    # browser  Browser to open given URL in headless way
    #          (e.g. gc for google chrome, ff for firefox).
#    Start Virtual Display
#    ${browser_ID}=  Open Browser  ${URL}
#    Set Window Size  1920  1080
#    [Return]  ${browser_ID}


Launch Browser And Login GUI
    [Documentation]  Launch browser and login to OpenBMC GUI, retry 2 attempts
    ...              in 1 minute time.
    Wait Until Keyword Succeeds  130 sec   65 sec  Retry Browser Login Attempts
Retry Browser Login Attempts
#    [Documentation]  Launch browser and login to OpenBMC GUI.
#    Open Browser With URL  ${obmc_gui_url}
#    Login GUI  ${OPENBMC_USERNAME}  ${OPENBMC_PASSWORD}


    # 不用上面的方法，我是用 gui_url 登入
    [Documentation]  Launch browser and login to OpenBMC GUI.
    [Arguments]  ${browser_type}=${GUI_BROWSER}
    # Description of argument(s):
    # browser_type  Type of browser (e.g. "firefox", "chrome", etc.).
    Open Browser  ${obmc_gui_url}  ${browser_type}
    Maximize Browser Window
    Wait Until Element Is Enabled  id=userid    #${xpath_login_username_input}
    Input Text  id=userid  ipmi_test   #${xpath_login_username_input}  ${username}
    Input Password  id=passward  Admin#@1    #${xpath_login_password_input}  ${password}
    Wait Until Element Is Enabled  id=btn-login    #${xpath_login_button}
    Click Element  id=btn-login    #${xpath_login_button}
    Wait Until Page Contains  Overview  timeout=60s


Login GUI
## 9/18 登入資訊先都寫死! 先不用導向這個function
    [Documentation]  Login to OpenBMC GUI.
    [Arguments]   ${username}=ipmi_test   ${passward}=Admin#21
#    [Arguments]  ${username}=${OPENBMC_USERNAME}  ${password}=${OPENBMC_PASSWORD}
    # Description of argument(s):
    # username  The username to be used for login.
    # password  The password to be used for login.
    Go To  ${obmc_gui_url}
    Wait Until Element Is Enabled  id=userid    #${xpath_login_username_input}
    Input Text  id=userid  ipmi_test   #${xpath_login_username_input}  ${username}
    Input Password  id=passward  Admin#@1    #${xpath_login_password_input}  ${password}
    Wait Until Element Is Enabled  id=btn-login    #${xpath_login_button}
    Click Element  id=btn-login    #${xpath_login_button}
    Wait Until Page Contains  Overview  timeout=60s


Logout GUI
    [Documentation]  Logout of OpenBMC GUI.
    Click Element  ${xpath_root_button_menu}    # 去看他們的id
    Click Element  ${xpath_logout_button}
    Wait Until Page Contains Element  id=btn-login   #${xpath_login_button}


#Generate Test Error Log
#    [Documentation]  Generate test error log.
#    BMC Execute Command  ${CMD_UNRECOVERABLE_ERROR}


#Set Timezone In Profile Settings Page
#    [Documentation]  Set the given timezone in profile settings page.
#    [Arguments]  ${timezone}=Default
    # Description of argument(s):
    # timezone  Timezone to select (eg. Default or Browser_offset).
#    Wait Until Page Contains Element  ${xpath_root_button_menu}
#    Click Element  ${xpath_root_button_menu}
#    Click Element  ${xpath_profile_settings}
#    Click Element At Coordinates  ${xpath_default_UTC}  0  0
#    Click Element  ${xpath_profile_save_button}


Refresh GUI
    [Documentation]  Refresh GUI via refresh button in header.
    Click Element  ${xpath_refresh_button}
    # Added delay for page to load fully after refresh.
    Sleep  5s


Refresh GUI And Verify Element Value
    [Documentation]  Refresh GUI using refresh button and verify that given element contains expected value.
    [Arguments]  ${element}  ${expected_value}
    # Description of argument(s):
    # element         Element whose value need to be checked.
    # expected_value  Expected value of for the given element.
    # Refresh GUI.
    Click Element  ${xpath_refresh_button}
    # Check element value and verify that it contains expected value.
    ${element_value}=  Get Text  ${element}
    Log  ${element_value}
    Should Contain  ${element_value}  ${expected_value}