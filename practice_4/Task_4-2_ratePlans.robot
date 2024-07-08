*** Settings ***
Documentation    Задание 4-2. Школа тестировщиков. Модуль 2. Вызов API openapi/v1/dictionaries/common/ratePlans - Получение списка ТП с учетом типа нумерации
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
Test_Rate_Plans
    ${response_rate_plans}=    Test_Rate_Plans    numberCategoryId=2

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
    Comment       Получение времени перед выполнением вызова
    ${date_before_request} =         Get Current Date

    Comment       Выполнение вызова API openapi/v1/dictionaries/common/ratePlans
    ${response}=    GET On session    alias    ${route}    params=${params}   expected_status=${expected_status}

    Comment          Проверка наличия хедера Content-Type
    Should Contain    ${response.headers}    Content-Type   msg=Хедер Content-Type отсутствует

    Comment          Проверка времени выполнения
    ${date_after_request} =         Get Current Date
    ${response_time} =  Subtract Date From Date    ${date_after_request}    ${date_before_request}
    Should Be True     '${response_time}'<='${response_time_check}'    msg=Время выполнения вызова больше ${response_time_check}s
    RETURN    ${response}

Test_Rate_Plans
   Comment         API openapi/v1/dictionaries/common/ratePlans - Получение списка ТП с учетом типа нумерации
   [Arguments]    ${numberCategoryId}
   ${response}=    Proverka    200    /dictionaries/common/ratePlans   0.2    numberCategoryId=${numberCategoryId}
   RETURN    ${response}