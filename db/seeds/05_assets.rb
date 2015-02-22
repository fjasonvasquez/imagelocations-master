#Images

default_images = [
	{
		:source =>  File.open("#{Rails.root}/public/image_location.jpg")
	}

]

$IMAGES = Image.create(default_images)