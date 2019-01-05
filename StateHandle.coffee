{createElement} = require 'react'
{render} = require 'react-dom'
# class to handle the app state.
class StateHandle
	constructor: (props)->
		props = props || {}
		@view = props.view
		@_el = props.el
		@state = {}
		@_binds = []
	
	setState: (state)=>
		if !state
			return @render()
		
		new_state = Object.assign({},@state,state)
		@preSetState?(@state,new_state)
		old_state = @state
		@state = new_state
		for bind in @_binds
			if !bind.key? || state[bind.key]
				bind()
		@render()
		@postSetState?(@state,old_state)

	bind: (fn,key)->
		fn.key = key
		@_binds.push fn

	unbind: (fn)->
		@_binds.splice @_binds.indexOf(fn),1

	render: =>
		render(createElement(@view,@state),@_el)

module.exports = StateHandle