describe "RecipeController", ->
  scope = null
  ctrl = null
  routeParams = null
  httpBackend = null
  flash = null
  recipeId = 42

  fakeRecipe =
    id: recipeId
    name: "Backed Potatos"
    instruction: "Pierce potato with fork, nuke for 20 minutes"

  setupController = (recipeExists = true)->
    inject(($routeParams, $rootScope, $httpBackend, $controller, _flash_)->
      scope = $rootScope.$new()
      httpBackend = $httpBackend
      routeParams = $routeParams
      routeParams.recipeId = recipeId
      flash = _flash_

      request = new RegExp("\/recipes/#{recipeId}")
      results = if recipeExists
        [200, fakeRecipe]
      else
        [404]

      httpBackend.expectGET(request).respond(results[0], results[1])

      ctrl = $controller('RecipeController', $scope: scope)
    )

  beforeEach(module('app'))
  afterEach ->
    httpBackend.verifyNoOutstandingExpectation()
    httpBackend.verifyNoOutstandingRequest()

  describe 'controller initialization', ->
    describe 'recipe is found', ->
      beforeEach ->
        setupController()
        httpBackend.flush()
      it 'loads the given recipe', ->
        expect(scope.recipe).toEqualData(fakeRecipe)
    describe 'recipe is not found', ->
      beforeEach ->
        setupController(false)
        httpBackend.flush()
      it 'loads the given recipe', ->
        expect(scope.recipe).toBe(null)
        expect(flash.error).toBe("There is no recipe with ID #{recipeId}")