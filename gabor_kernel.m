function [ G, scaleXY ] = gabor_kernel( mu, nu, sigma, scaleXY, imgSz )

%[G, gWinLen] = genGaborKernelF(mu, nu, pi, 0, imgSz);
    
    kmax = pi/4;
    f = sqrt(2);
    angStep = (pi/10);
    
    if scaleXY == 0
        th = 5e-3;
        scaleXY = ceil(sqrt(-log(th*sigma^2/kmax^2)*2*sigma^2/kmax^2));
    end
    
    [X Y] = meshgrid(-scaleXY:scaleXY, -scaleXY:scaleXY);
    DC = exp(-sigma^2/2); 

    g = cell(length(nu), length(mu));

    for scale_idx = 1:length(nu)
        for angle_idx = 1:length(mu)
            phi = angStep*mu(angle_idx);
            k = kmax/f^nu(scale_idx);
            g{scale_idx, angle_idx} = k^2/sigma^2 * exp(-k^2*(X.^2+Y.^2)/2/sigma^2)...
                .*(exp(1i*(k*cos(phi)*X+k*sin(phi)*Y)));
        end
    end

    %function [ G, gWinLen ] = genGaborKernelF( mu, nu, sigma, scaleXY, imgSz )
    realSz = 2^nextpow2(max(imgSz)+scaleXY*2); % nextpow2 can speed up a little
	G = cell(size(g));

	for p = 1:size(g, 1)
		for q = 1:size(g, 2)
			G{p, q} = fft2(g{p, q}, realSz, realSz);
			%G{p, q} = fft2(g{p, q}, 9, 9);
			G{p, q}(1, 1) = 0; % reduce the DC
		end
    end

end

