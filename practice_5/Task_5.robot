*** Settings ***
Library          SeleniumLibrary
Documentation    Задание 5. Школа тестировщиков. Модуль 2
Resource          resource.robot
*** Variables ***
${USERNAME}         Login
${PASSWORD}         Password

*** Test Cases ***
Task_5
    Comment     Открыть браузер на странице авторизации в портал обучения
    Open To Portal

    Comment    Вводим логин
    SeleniumLibrary.Wait Until Page Contains Element        //input[@type='text']       timeout=20
    SeleniumLibrary.Input Text    //input[@type='text']     ${USERNAME}

    Comment    Вводим пароль
    SeleniumLibrary.Wait Until Page Contains Element        //input[@type='password']       timeout=20
    SeleniumLibrary.Input Text       //input[@type='password']      ${PASSWORD}

    Comment    Нажимаем кнопку "Войти" после ввода логина и пароля на форме
    SeleniumLibrary.Wait Until Page Contains Element    //n-button/button[contains(@class, 'p-element n-button n-button--type-accent n-button--prevention- n-button--size-large')]    timeout=20
    SeleniumLibrary.Click Element    //n-button/button[contains(@class, 'p-element n-button n-button--type-accent n-button--prevention- n-button--size-large')]
    
    Comment    Заходим на страницу активного курса 'Введение в Postman'
    SeleniumLibrary.Wait Until Page Contains Element        //n-education-card[@class='n-education-list__item ng-star-inserted']      timeout=20
    SeleniumLibrary.double click element     //n-education-card[@class='n-education-list__item ng-star-inserted']

    Comment       Открываем блок обучения 'Интерфейс системы. Перый запрос'
    SeleniumLibrary.Wait Until Page Contains Element        //span[contains(.,'Интерфейс системы. Перый запрос')]       timeout=20
    SeleniumLibrary.double click element       //span[contains(.,'Интерфейс системы. Перый запрос')]

    Comment          Нажимаем кнопку 'Завершить обучение'
   # SeleniumLibrary.Wait Until Page Contains Element        //div[@class='n-button__title txt-accent-m' and contains(.,' Завершить изучение')]      timeout=20
   # SeleniumLibrary.Click Element       //div[@class='n-button__title txt-accent-m' and contains(.,' Завершить изучение')]

    Comment          Переходим на страницу 'Обучение участника. Просмотр'
    SeleniumLibrary.Wait Until Page Contains Element            //a[@class='bread-crumbs-item ng-star-inserted' and contains(.,'Обучение участника. Просмотр')]        timeout=20
    SeleniumLibrary.Click Element           //a[@class='bread-crumbs-item ng-star-inserted' and contains(.,'Обучение участника. Просмотр')]

    Comment          Проверяем, что 'Прогресс курса' не равен 0%
    Wait Until Keyword Succeeds      10 sec        5 sec
    ...        SeleniumLibrary.element_text_should_not_be          //div[@class='ng-star-inserted']//span[@class='txt-accent-s']               textContent          0%            msg=Прогресс курса 0%, блок обучения не пройден

    Sleep    5 sec