*** Settings ***
Documentation    Задание 4-2. Школа тестировщиков. Модуль 2. Вызов API openapi/v1/agents - Получение списка агентов (get)
Library     RequestsLibrary
Library     OperatingSystem
Library     DateTime
Library     XML
Library     Jsonschema
Suite Setup     Suite Setup

*** Variables ***
${BASE_URL}=     http://srv3-sso-scc.net.billing.ru:47141/openapi/v1
${LOGIN}=     ROBOT_FR      #TESTOV
${PASSWORD}=     1111

*** Test Cases ***
Test_Agents
    ${schema}=    Get Binary File    ./schema.json
    ${schema}=    Evaluate    json.loads('''${schema}''')    json
    #Log to console  ${schema}
    ${response_agents}=    Test_Agents    agent_id=5299
    Log    ${response_agents.json()}
    ${instance}=      Evaluate       json.loads(json.dumps(${response_agents.json()}, indent=4))      json
    Validate             instance=${instance}        schema=${schema}
    #Log to console  ${instance}

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

    Comment       Выполнение вызова API openapi/v1/agents
    ${response}=    GET On session    alias    ${route}    params=${params}   expected_status=${expected_status}

    Comment          Проверка наличия хедера Content-Type
    Should Contain    ${response.headers}    Content-Type   msg=Хедер Content-Type отсутствует

    Comment          Проверка времени выполнения
    ${date_after_request} =         Get Current Date
    ${response_time} =  Subtract Date From Date    ${date_after_request}    ${date_before_request}
    Should Be True     '${response_time}'<='${response_time_check}'    msg=Время выполнения вызова больше ${response_time_check}s
    RETURN    ${response}

Test_Agents
   Comment         AAPI openapi/v1/agents - Получение списка агентов (get)
   [Arguments]    ${agent_id}
   ${response}=    Proverka    200    /agents   0.5    agent_id=${agent_id}
   RETURN    ${response}

