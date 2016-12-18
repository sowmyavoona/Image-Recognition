function  showImages(T, wid, hei, nc, nstr)
	x = 1;
	tmp = 0;
	p1 = 0;
	p2 = 0.6;
	sz = 56/(nc*20);
	y1 = ceil(double(sqrt(nc)));
	
	if(sz > 0.2)
		sz=0.2;
	end

	for i = 1:size(T, 2)
		subplot('Position', [p1 p2 sz sz]);
		if(rem(i, nstr) == 0)
			imshow(uint8(reshape(T(:, i), hei, wid)));
			x = x + 1;
			tmp = tmp + 1;
			p1 = p1 + sz;
			if(tmp == y1)
				tmp = 0;
				p2 = p2 - sz - 0.01;
				p1 = 0;
			end
		end
		drawnow expose;
	end
	xlabel('TRAINING IMAGE SAMPLES');
