function generateMergedModels(filename)
load ./C.mat;
load ./computedPos.mat;
load ./models.mat;

numPeople = size(calculatedPos, 2);

gender = randi([1,2], numPeople, 1);
isRotate = randi([0, 3], numPeople, 1);

vertex = [];
faces = [];
for i = 1 : 2 : numPeople
    curVtxNum = size(vertex, 1);
    [v, f] = generatePeopleModel(models, calculatedPos(:, i), gender(i), isRotate(i));
    vertex = [vertex; v];
    %f(:, 2:4) = f(:, 2:4) + curVtxNum;
    faces = [faces; f + curVtxNum];
end
%writeCamPly(vertex, faces, 'ori.ply');
vertex(:, 2) = vertex(:, 2) + 0.2;
writeCamPly(vertex, faces, filename);
end

function [v, f] = generatePeopleModel(model, pose, gender, rotate)
% x = -4.25
if pose(1) > -4.25
    R = rotateY(pi * randi([0, 1]));
else
    R = rotateY(pi/2 + pi * randi([0,1]));
end

vertex = model(gender).vertex;
vertex(:, 1:3) = vertex(:, 1:3) .* 1.6;
vertex(:, 1:3) = vertex(:, 1:3) * R;
vertex(:, 1:3) = vertex(:, 1:3) + repmat(pose', size(vertex, 1), 1);
v = vertex;
f = model(gender).faces;
end

function writeCamPly(vertex, faces, filename)

f_out = fopen(filename, 'w');

% write header
fprintf(f_out, 'ply\n');
fprintf(f_out, 'format ascii 1.0\n');
fprintf(f_out, 'element vertex %d\n', size(vertex, 1));
fprintf(f_out, 'property float x\n');
fprintf(f_out, 'property float y\n');
fprintf(f_out, 'property float z\n');
fprintf(f_out, 'property uchar red\n');
fprintf(f_out, 'property uchar green\n');
fprintf(f_out, 'property uchar blue\n');
fprintf(f_out, 'element face %d\n', size(faces, 1));
fprintf(f_out, 'property list uchar int vertex_indices\n');
fprintf(f_out, 'end_header\n');

for i = 1 : size(vertex, 1)
    fprintf(f_out, '%f %f %f %d %d %d\n', ...
        vertex(i, 1), vertex(i, 2), vertex(i, 3), ...
        vertex(i, 4), vertex(i, 5), vertex(i, 6));
end
for i = 1 : size(faces, 1)
    fprintf(f_out, '3 %d %d %d\n', ...
        faces(i, 1), faces(i, 2), faces(i, 3));
end

fclose(f_out);
end

function R = rotateY(theta)
    R = [cos(theta), 0, sin(theta); 0 1 0; -sin(theta) 0 cos(theta)];
end