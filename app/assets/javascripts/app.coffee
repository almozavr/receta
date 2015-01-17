app = angular.module('app',
  ['templates', 'ngRoute', 'ngResource', 'controllers', 'angular-flash.service', 'angular-flash.flash-alert-directive'])
app.config(
  ['$routeProvider', 'flashProvider',
    ($routeProvider, flashProvider)->
      $routeProvider
      .when('/',
        templateUrl: 'index.html',
        controller: 'RecipesController'
      )
      .when('/recipes/:id',
        templateUrl: 'show.html',
        controller: 'RecipeController'
      )
      flashProvider.errorClassnames.push("alert-danger")
      flashProvider.warnClassnames.push("alert-warning")
      flashProvider.infoClassnames.push("alert-info")
      flashProvider.successClassnames.push("alert-success")
  ]
)
controllers = angular.module('controllers', [])
