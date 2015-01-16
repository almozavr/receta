app = angular.module('app', ['templates', 'ngRoute', 'ngResource', 'controllers'])
app.config(
  ['$routeProvider', ($routeProvider)->
    $routeProvider
    .when('/',
      templateUrl: 'index.html',
      controller: 'RecipesController'
    )
  ]
)
controllers = angular.module('controllers', [])
