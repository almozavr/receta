controllers = angular.module("controllers")
controllers.controller("RecipeController", ['$scope', '$routeParams', '$location', '$resource', 'flash'
  ($scope, $routeParams, $location, $resource, flash) ->
    Recipe = $resource('/recipes/:recipeId', {recipeId: '@id', format: 'json'},
      {
        'save': {method: 'PUT'},
        'create': {method: 'POST'}
      }
    )

    if ($routeParams.recipeId)
      Recipe.get({recipeId: $routeParams.recipeId},
        ((recipe) -> $scope.recipe = recipe),
        ((httpResponse) ->
          $scope.recipe = null
          flash.error = "There is no recipe with ID #{$routeParams.recipeId}"
        )
      )
    else
      $scope.recipe = {}

    $scope.back = -> $location.path("/")

    $scope.edit = -> $location.path("/recipes/#{$scope.recipe.id}/edit")
    $scope.cancel = ->
      if $scope.recipe.id
        $location.path("/recipes/#{$scope.recipe.id}")
      else
        $location.path("/")

    $scope.save = ->
      onError = (httpResponse)-> flash.error = "Something went wrong"
      if $scope.recipe.id
        Recipe.save({recipeId:$scope.recipe.id}, $scope.recipe,
          (()-> $location.path("/recipes/#{$scope.recipe.id}")),
          onError
        )
      else
        Recipe.create($scope.recipe,
          ((newRecipe)-> $location.path("/recipes/#{newRecipe.id}")),
          onError
        )

    $scope.delete = ->
      $scope.recipe.$delete()
      $scope.back()
])