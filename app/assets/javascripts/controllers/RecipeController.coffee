controllers = angular.module("controllers")
controllers.controller("RecipeController", ['$scope', '$routeParams', '$location', '$resource', 'flash'
  ($scope, $routeParams, $location, $resource, flash) ->
    Recipe = $resource('/recipes/:recipeId', {recipeId: @id, format: 'json'},
      {
        'save': {method: 'PUT'},
        'create': {method: 'POST'}
      }
    )

    if ($routeParams.id)
      Recipe.get({recipeId: $routeParams.id},
        ((recipe) -> $scope.recipe = recipe),
        ((httpResponse) ->
          $scope.recipe = null
          flash.error = "There is no recipe with ID #{$routeParams.id}"
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
        $scope.recipe.$save(
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