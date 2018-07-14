function plots (numPoints, data, delta_t)

A = zeros(numPoints, 1);

for i = 1:numPoints
    if ismember(data, i)
        A(i) = 1;
    end
end

figure;        
colormap(gray);
N = size(A,2);
t = (1:N)*delta_t;
imagesc(t,1,A);