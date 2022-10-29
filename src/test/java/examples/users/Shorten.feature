@Smoke
Feature: API Shorten

  Background:
    Given url urlBaseShorten
    And header x-rapidapi-key = rapidapi_key

  @RequestExitosa
    #1- Shorten - Status 200 - Response {"result_url": Validar que es un String}
  Scenario: POST Shorten
    * def body = {"url": "https://crowdar.com.ar"}
    And path 'shorten'
    And request body
    When method POST
    Then status 200
    And match response.result_url == '#string'

  @EmptyUrl
    #2- Shorten Sin Body - Status 400 - Validar Response {"error": "API Error: URL is empty"}
  Scenario: POST Shorten sin Body
    * def schema = read('classpath:examples/users/response/error_Shorten_urlEmpty.json')
    And path 'shorten'
    And request {}
    When method POST
    Then status 400
    And match response == schema

  @InvalidUrl
  #3- Shorten Invalid URL - Status 400 - Validar Response {"error": "API Error: After sanitization URL is empty"}
  Scenario: POST Shorten Invalid Url
    * def body = {"url": "sdfadfadsfdfsdf"}
    And path 'shorten'
    And request body
    When method POST
    Then status 400
    And match response == {"error": "API Error: URL is invalid (check #1)"}

  @InvalidToken
  #4- Shorten invalid Token - Status 403 - Validar Response {"message": "You are not subscribed to this API."}
  Scenario: POST Shorten Invalid Token
    * def schema = read('classpath:examples/users/response/error_Invalid_Token.json')
    * configure headers = {x-rapidapi-key: 'asdasdas'}
    * def body = {"url": "https://crowdar.com.ar"}
    And path 'shorten'
    And request body
    When method POST
    Then status 403
    And match response == schema

