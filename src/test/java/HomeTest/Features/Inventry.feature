Feature: Inventory API Tests

  Background:
    * url 'http://localhost:3101'
  Scenario: Get all menu items
    Given path '/api/inventory'
    When method GET
    Then status 200
    And match response contains
      """
      {
        "data": [
          {
            "id": "1",
            "name": "Classic Muzzarella",
            "image": "classic.png",
            "price": "$8"
          },
          {
            "id": "2",
            "name": "Crispy Bacon",
            "image": "bacon.png",
            "price": "$9"
          },
          {
            "id": "3",
            "name": "Baked Rolls x 8",
            "image": "roll.png",
            "price": "$10"
          },
          {
            "id": "4",
            "name": "Garlic Mix",
            "image": "garlicmix.png",
            "price": "$9"
          },
          {
            "id": "5",
            "name": "Margarita",
            "image": "margarita.png",
            "price": "$9"
          },
          {
            "id": "6",
            "name": "Veggie",
            "image": "veggie.png",
            "price": "$8"
          },
          {
            "id": "7",
            "name": "Super Pepperoni",
            "image": "extrapeperoni.png",
            "price": "$10"
          },
          {
            "id": "8",
            "name": "Evergreen Cream",
            "image": "evergreen.png",
            "price": "$9"
          },
          {
            "id": "9",
            "name": "Muzzarella BBQ",
            "image": "bbqcheese.png",
            "price": "$9"
          },
          {
            "id": "10",
            "name": "Hawaiian",
            "image": "hawaiian.png",
            "price": "$14"
          },
          {
            "id": "11",
            "name": "Hawaiian",
            "image": "hawaiian.png",
            "price": "$14"
          },
          {
            "id": "12",
            "name": "Hawaiian",
            "image": "hawaiian.png",
            "price": "$14"
          }
        ]
      }
      """

  Scenario: Filter by id
    Given path '/api/inventory/filter'
    And param id = 3
    When method GET
    Then status 200
    And match response ==
      """
      {
        "id": "3",
        "name": "Baked Rolls x 8",
        "image": "roll.png",
        "price": "$10"
      }
      """

  Scenario: Add item for non-existent id
    Given path '/api/inventory/add'
    And request
      """
      {
        "id": "13",
        "name": "Hawaiian",
        "image": "hawaiian.png",
        "price": "$14"
      }
      """
    When method POST
    Then status 200

  Scenario: Add item for existent id
    Given path '/api/inventory/add'
    And request
      """
      {
        "id": "10",
        "name": "Hawaiian",
        "image": "hawaiian.png",
        "price": "$14"
      }
      """
    When method POST
    Then status 400

  Scenario: Try to add item with missing information (without id)
    Given path '/api/inventory/add'
    And request
      """
      {
        "name": "Soda",
        "price": "$2"
      }
      """
    When method POST
    Then status 400
    And match response contains "Not all requirements are met"

  Scenario: Validate recent added item is present in the inventory
    Given path '/api/inventory'
    When method GET
    Then status 200
    And match response contains
      """
      {
        "id": "10",
        "name": "Hawaiian",
        "image": "hawaiian.png",
        "price": "$14"
      }
    """