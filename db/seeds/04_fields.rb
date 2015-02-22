Field.create([{
	:name => 'description',
	:args => {
		:as => :wysiwyg,
		:input_html => {
			:class => 'input-block-level'
		}
	},
	:field_objects_attributes => [
		{
			:object => Location.name
		},
		{
			:object => Permit.name
		}
	]
}])


Field.create([{
	:name => 'featured',
	:args => {
		:as => :boolean,
		:input_html => {
			:class => ''
		}
	},
	:field_objects_attributes => [
		{
			:object => Location.name
		},
		{
			:object => Category.name
		}
	]
}])