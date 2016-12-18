%showImages(fea, 32, 32, nsubjects, ntrain)

%figure;
for s = 1:5
	for j = 1:8
		subplot(5, 8, (s-1)*8+j);
		imshow(real(Gimgfiles{1, 1}{s, j}), []);
	end
end