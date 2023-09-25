*** Settings ***
Documentation   This is the WebUI login test part.

Library      SeleniumLibrary
#Library      \lib\gui_sources.robot


*** Variables ***
${WEBSITE URL}     https://192.168.0.100/
${BROWSER}         chrome     
${Username}        ${EMPTY} ##ipmi_test
${Passward}        ${EMPTY} ##Admin#21

### Other features on WebUI login page
# "Language Selection" part will need other tools to distinguish the languages. span
# "Remember Username" selection
# "I Forgot my Password" which need passward change or even the OTP auth.
###


# Menu Bar / Dashboard check 
${UP TIME}          Power-On Hours
# ${TIMER POWER ON}   3600   # Time in seconds.
${web_element_up_time}  ${EMPTY}
${ACCESS LOGS}      Access logs
${MORE INFO}        More info

*** Test Cases ***
Open Test Website And Close Browser
    Open Test Website & log in seccessfully In Chrome
    BMC Up Time Check
    Audit Log check
    Time And Date Check
    # Push result to excel
    [Teardown]    Close Browser


*** Keywords ***
Open Test Website & log in seccessfully In Chrome
    # need to check the html 
    Open Browser      ${WEBSITE URL}    ${BROWSER}
    Maximize Browser Window
    Input Text        id=userid     ${Username}
    Input Text        id=passward   ${Passward} 
    Click Button      id=btn-login  ## it is th button id of sign me in
    
    Title Should Be   Successfully log in! 

BMC Up Time Check
    Title Should Be    Display the BMC up time
    #Page Should Contain Element    name = ${UP TIME}  
    Element Should Contain    id=uptime     d
    ${web_element_up_time} = Get WebElement id:uptime
    ${UP TIME} = Get Element Size ${web_element_up_time}
    Log The UP time of BMC is ${UP TIME}   console==yes
    ### check the BMC up time increased for 1 hr
    # Get Element Size    locator   ## Not sure if this method can work.
    # 還不確定server時間的計算
    # https://gerrit.openbmc.org/plugins/gitiles/openbmc/openbmc-test-automation/+/af2226ecd950186dcb503a3c707c115264766efa/openpower/test_timed_power_on.robot?autodive=0
    ###
    Title Should Be    Display the BMC up time complete! 

Audit Log check
    Page Should Contain Element    name =${ACCESS LOGS}
    ## element? link?
    Click Link    href = https://192.168.0.100/#logs/audit-log

    Title Should Be    Audit log to record Pending Deassertions complete!
   # [Arguments]       ${passed}
   # ${passed} = Run Keyword And Run Status Page Should Contain Link   href = https://192.168.0.100/#logs/audit-log
   # return ${passed}

Time And Date Check
   [Documentation]    This is the basic time and date setting part. 
...    1. The BMC time and date shall be display in page.
...    2. Set up the NTP server.
...    3. After setting up NTP server, change the time zone and using IPMI tool to verify the time you changed.
    
    # 1.
    #click setting
    #click data and time
    # check there are time info
    Title Should Be    The BMC time and date displays in page.  --complete!

    # 2.
    # refresh GUI , setting is in \lib\gui_resouces.robot
    # or wait until the page contain ..
    
    # check the page can setup the first & second NTP server
    # 另外定義與設定 ntp server (台灣的)
    # input text on first NTP server
    # click button save
    # 會跳出提醒視窗  語法?
    # 重新登入
    # 重新導向時間設定頁面
    # 檢視時區資訊
    # 與ipmitool 對比時間是否相同
    # if success,   Title Should Be     The BMC time and date shall be sync with NTP server.
    # if fail(not changed),     強制 error log & Title Should Be     NTP server does not match(or change)


    # 3,
    # 2.成功後再跑，否則直接提醒無法執行
    # if exists, select the time zone you want
    # un-click "automate NTP server"
    # save button
    # 跳出提醒視窗並重新登入
    # 檢視時間資訊是否符合
    Title Should Be    Time has matched you set!



