function h = plot_Class_Vector(class_vector,h)

	bar(h,class_vector)
	xlabel(h,'Set Class');
	title(h,'Class Vector')
	xlim(h,[0 351])