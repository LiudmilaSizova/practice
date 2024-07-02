*** Settings ***
Documentation   Proverka perevoda temperatyri C v temperatyry F
*** Test Cases ***
Proverka perevoda temperatyri C v temperatyry F
    ${temperaturaC}=    Convert to number    50
    ${temperaturaF}=    Convert to number    122
    ${temperaturaF_new}=    Perevod v F    ${temperaturaC}
    Log To Console  ''
    Log To Console  Temperatura F: ${temperaturaF}
    Log To Console  Temperatura F posle perevoda: ${temperaturaF_new}
    [Documentation]     Сравниваем начальную температуру F с температурой после перевода в F
    Should Be Equal As Numbers    ${temperaturaF}   ${temperaturaF_new}

*** Keywords ***
[Documentation]    Перевод температуры из С в F
Perevod v F
    [Arguments]    ${temperaturaC}
    ${temperaturaF_new}=    Evaluate    9/5 * ${temperaturaC} + 32
    RETURN    ${temperaturaF_new}