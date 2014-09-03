function test

load mixtwoLane.mat;

for i = 1:numel(camera)
   img1 = imread(camera(i).fileName ); 
   figure(1); imagesc(img1); axis equal;
   hold on; 
    plot( pointsPos(i,1), pointsPos(i,2), '*' );
    hold off
end








