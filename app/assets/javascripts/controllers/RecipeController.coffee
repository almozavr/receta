controllers = angular.module("controllers")
controllers.controller("RecipeController", ['$scope', '$routeParams', '$location', '$resource', 'flash'
  ($scope, $routeParams, $location, $resource, flash) ->
    Recipe = $resource('/recipes/:recipeId', {recipeId: @id, format: 'json'})

    Recipe.get({recipeId: $routeParams.id},
      ((recipe) -> $scope.recipe = recipe),
      ((httpResponse) ->
        $scope.recipe = null
        flash.error = "There is no recipe with ID #{$routeParams.id}"
      )
    )

    $scope.back = -> $location.path("/")
])