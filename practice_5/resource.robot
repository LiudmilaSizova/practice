*** Settings ***
Documentation     Общие кейворды

*** Keywords ***

Open To Portal
    [Documentation]    Открыть браузер на странице авторизации в портал обучения
    [Timeout]          5 minutes
    SeleniumLibrary.Open Browser    https://neon.nexign.com/education        Chrome
    Maximize Browser Window
