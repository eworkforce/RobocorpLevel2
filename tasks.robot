*** Settings ***

Library    RPA.Browser.Selenium  auto_close=${False}
Library    RPA.HTTP
Library    RPA.Tables
Library    RPA.PDF
Library    RPA.Images
Library    RPA.Desktop
Library    OperatingSystem

*** Variables *** 

*** Keywords ***
uKw_Login into CRM Website
    Open Available Browser    https://robotsparebinindustries.com/
    Input Text    username    maria
    Input Password    password    thoushallnotpass
    Submit Form 
#uKw_Download order file
    #Download    https://robotsparebinindustries.com/orders.csv   input    overwrite=True
uKw_Goto order page
        Click Link    alias:Orderyourrobot
        Click Button When Visible    alias:Alertbuttonsbtndark
uKw_Fill in an order form 
    [Arguments]    ${Order}
        Select From List By Index    alias:Head    ${Order}[Head]
        Click Element  css:.radio:nth-child( ${Order}[Body] )
        Input Text        alias:Legs   ${Order}[Legs]
        Input Text    alias:Address     ${Order}[Address]
uKw_Make order
    Click Button   alias:Preview
    Click Button  alias:Order
    Sleep    1s
    Element Should Not Contain    alias:Containercontainer    Error
       
uKW_Save order receipt
    [Arguments]    ${Order}
    ${receit_image}=    Set Variable      
    ${bot_image}=    Set Variable   
    ${receit_image} =    Get Element Attribute    alias:Dividordercompletiondiv    outerHTML
    #${bot_image} = Get Element Attribute    locator    attribute
    Html To Pdf    ${receit_image}   ${OUTPUT_DIR}${/}orde_${Order}[Order number].pdf
    Sleep    2s
    Click Button    alias:Orderanother
    Click Button When Visible    alias:Alertbuttonsbtndark

.

uKw_Fill in all order form 
    ${ORDERFILE}=  Read table from CSV    input/orders.csv  header=${True}
    FOR    ${order}    IN    @{ORDERFILE}
        uKw_Fill in an order form    ${order}
        Wait Until Keyword Succeeds    3x    1s    uKw_Make order
        uKW_Save order receipt    ${order}
    END
#uKw_Save receits in Zip file
    

*** Tasks ***
Order robots from RobotSpareBin Industries Inc
    #uKw_Download order file
    uKw_Login into CRM Website
    uKw_Goto order page
    uKw_Fill in all order form 
    #uKw_Save receits in Zip file 

