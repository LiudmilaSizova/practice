*** Settings ***
Documentation    Задание 4-2. Школа тестировщиков. Модуль 2. Вызов API openapi/v1/dictionaries/adjustments/adjustmentTypes - Получение всех типов корректировок
Library     RequestsLibrary
Library     OperatingSystem
Library     DateTime
Library     XML
Suite Setup     Suite Setup

*** Variables ***
${BASE_URL}=     http://srv3-sso-scc.net.billing.ru:47141/openapi/v1
${LOGIN}=     ROBOT_FR      #TESTOV
${PASSWORD}=     1111

*** Test Cases ***
Test_Adjustment_Types
    Comment         API openapi/v1/dictionaries/adjustments/adjustmentTypes Получение всех типов корректировок
    ${adjustment_types}=      Test_Adjustment_Types

    Comment         Типы корректировок
    Log       ${adjustment_types.json()}

*** Keywords ***
Suite Setup
    ${token_xml_response}=   GET    url=${BASE_URL}/tokens-stub/get   params=LOGIN=${LOGIN}&PASSWORD=${PASSWORD}  expected_status=200
    ${root_xml} =	Parse XML	${token_xml_response.content}
    ${session_id}=	Get Element	   ${root_xml}	 SESSION_ID
    ${token}=	Set Variable  ${session_id.text}
    ${headers}=       Create Dictionary    Content-Type=application/json   Authorization=Bearer ${token}
    Create session    alias    ${BASE_URL}    ${headers}

Proverka
    [Arguments]    ${expected_status}    ${route}    ${response_time_check}    ${params}=${None}
    ${date_before_request} =         Get Current Date
    ${response}=    GET On session    alias    ${route}    params=${params}   expected_status=${expected_status}
    ${date_after_request} =         Get Current Date
    ${response_time} =  Subtract Date From Date    ${date_after_request}    ${date_before_request}
    Should Be True     '${response_time}'<='${response_time_check}'    msg=Время выполнения вызова больше ${response_time_check}s
    RETURN    ${response}

Test_Adjustment_Types
    Comment          Проверка, укладывается ли выполнение вызова API openapi/v1/dictionaries/adjustments/adjustmentTypes в 50 ms
    ${proverka_ms_adjustment_types}=     Proverka       200    /agents   0.05
    RETURN    ${proverka_ms_adjustment_types}