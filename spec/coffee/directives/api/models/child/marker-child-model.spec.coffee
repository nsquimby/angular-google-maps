describe "MarkerChildModel", ->
	beforeEach( ->
		#comparison variables
		@index = 0 
		@model = 
			icon:'icon.png'
			coords:
				latitude:90
				longitude:90
			options: 
				animation:google.maps.Animation.BOUNCE
		@iconKey = 'icon'
		@coordsKey = 'coords'
		@optionsKey = 'options'

		#define / inject values into the item we are testing... not a controller but it allows us to inject
		angular.module('mockModule',[])
		.value('index',@index)
		.value('gMap',document.gMap)
		.value('defaults',{})
		.value('model', @model)
		.value('gMarkerManager',new directives.api.managers.MarkerManager(document.gMap,undefined,undefined))
		.value('doClick',->
		)
		.value('model',{})
		.controller('childModel', directives.api.models.child.MarkerChildModel)

		angular.mock.module('mockModule')

		inject( ($timeout,$rootScope,$controller) =>
			scope = $rootScope.$new()
			scope.click = ->
			scope.icon = @iconKey
			scope.coords = @coordsKey
			scope.options = @optionsKey
			@subject = $controller('childModel', {
				parentScope : scope
			})
		)
	)

	it 'can be created', ->
		expect(@subject != undefined).toEqual(true)
		expect(@subject.index).toEqual(@index)
		
	it 'parentScope keys are set correctly',->
		expect(@subject.iconKey).toEqual(@iconKey)
		expect(@subject.coordsKey).toEqual(@coordsKey)
		expect(@subject.optionsKey).toEqual(@optionsKey)

	it 'scope values are equal to the model values by key',->
		#since evalHModelHandle does not use => and uses ->
		#it is a prototype function which is more static, and kinda private.. as in not obvious to find
		#2 ways to get to it instance.__proto__.function or classType.prototype.function
		# equates to @subject.__proto_.evalModelHandle or directives.api.model.child.MarkerChildModel.prototype.evalModelHandle
		expect(@subject.__proto__.evalModelHandle(@model,@iconKey)).toEqual(@model.icon)
		expect(@subject.__proto__.evalModelHandle(@model,@coordsKey)).toEqual(@model.coords)
		expect(@subject.__proto__.evalModelHandle(@model,@optionsKey)).toEqual(@model.options)
	xit 'updates an existing models properties via watch, icon',->
		@model.icon = 'test.png'
		expect(@subject.__proto__.evalModelHandle(@model,@iconKey)).toEqual(@model.icon)

	xit 'evalModelHandle, undefined model returns undefined',->

	xit 'evalModelHandle modelKey of self returns model',->

	xit 'evalModelHandle modelKey of !self returns model[modelKey]',->


	describe 'destroy()', ->
		it 'wipes internal scope', ->
			@subject.destroy()
			expect(@subject.myScope.$$destroyed).toEqual(true)

		it 'wipes gMarker', ->
			@subject.destroy()
			expect(@subject.gMarker).toEqual(undefined)
			expect(@subject.gMarkerManager.gMarkers.length).toEqual(0)