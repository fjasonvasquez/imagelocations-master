
default_categories = [
	{:name=>"Bank"}, 
	{:name=>"Bar"}, 
	{:name=>"Bathroom"}, 
	{:name=>"Beach House"}, 
	{:name=>"Bungalow"}, 
	{:name=>"Americana"}, 
	#{:name=>"10 Most Viewed"}, 
	{:name=>"Beach House"}, 
	{:name=>"Concrete Loft"}, 
	#{:name=>"Exclusives"}, 
	{:name=>"Garden"}, 
	{:name=>"Mansion"}, 
	{:name=>"Mediterranean"}, 
	{:name=>"Mid-Century Modern"}, 
	{:name=>"Modern"}, 
	#{:name=>"New"}, 
	{:name=>"Office"}, 
	{:name=>"Retro"}
]

$CATEGORIES = Category.create(default_categories)

NewCategory.create({:name => "New"})
TopCategory.create({:name => "10 Most Viewed"})
ExclusiveCategory.create({:name => "Exclusives"})