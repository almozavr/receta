app = angular.module('app', ['templates', 'ngRoute', 'ngResource', 'controllers'])
app.config(
  ['$routeProvider', ($routeProvider)->
    $routeProvider
    .when('/',
      templateUrl: 'index.html',
      controller: 'RecipesController'
    )
    .when('/recipes/:id',
      templateUrl: 'show.html',
      controller: 'RecipeController'
    )
  ]
)
controllers = angular.module('controllers', [])
