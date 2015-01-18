describe "RecipeController", ->
  scope = null
  ctrl = null
  routeParams = null
  location = null
  httpBackend = null
  flash = null

  recipeId = 42
  fakeRecipe =
    id: recipeId
    name: "Backed Potatos"
    instruction: "Pierce potato with fork, nuke for 20 minutes"

  setupController = (recipeExists = true, recipeId = 42)->
    inject(($routeParams, $location, $rootScope, $httpBackend, $controller, _flash_)->
      scope = $rootScope.$new()
      httpBackend = $httpBackend
      routeParams = $routeParams
      routeParams.id = recipeId if recipeId
      location = $location
      flash = _flash_

      if recipeId
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

  describe 'create', ->
    newRecipe =
      id: 42
      name: 'Toast'
      instruction: 'put in toaster, push lever, add butter'

    beforeEach ->
      setupController(false, false)
      request = new RegExp("\/recipes")
      httpBackend.expectPOST(request).respond(201, newRecipe)

    it 'posts to the backend', ->
      scope.recipe.name = newRecipe.name
      scope.recipe.instruction = newRecipe.instruction
      scope.save()
      httpBackend.flush()
      expect(location.path()).toBe("/recipes/#{newRecipe.id}")

  describe 'update', ->
    updatedRecipe =
      name: 'Toast'
      instruction: 'put in toaster, push lever, add butter'

    beforeEach ->
      setupController()
      httpBackend.flush()
      request = new RegExp("\/recipes")
      httpBackend.expectPUT(request).respond(204)

    it 'posts to the backend', ->
      scope.recipe.name = updatedRecipe.name
      scope.recipe.instruction = updatedRecipe.instruction
      scope.save()
      httpBackend.flush()
      expect(location.path()).toBe("/recipes/#{scope.recipe.id}")

  describe 'delete', ->
    beforeEach ->
      setupController()
      httpBackend.flush()
      request = new RegExp("\/recipes")
      httpBackend.expectDELETE(request).respond(204)

    it 'posts to the backend', ->
      scope.delete()
      httpBackend.flush()
      expect(location.path()).toBe("/")
