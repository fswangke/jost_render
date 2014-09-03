function generateFrameModel()
load('theSelectedId');
load C;
load models;
load computedPos;

id = theSelectedId;
numPeople = length(id);
gender = randi([1,2], numPeople, 1);
isRotate = randi([0, 1], numPeople, 1);

for i = 1 : length(id)
    % adjust people model
    pose = calculatedPos(:, id(i));
    if pose(1) > -4.25
        R = rotateY(pi * randi([0, 1]));
    else
        R = rotateY(pi/2 + pi * randi([0,1]));
    end
    
    vertex = models(gender(i)).vertex;
    vertex(:, 1:3) = vertex(:, 1:3) .* 1.6;
    vertex(:, 1:3) = vertex(:, 1:3) * R;
    vertex(:, 1:3) = vertex(:, 1:3) + repmat(pose', size(vertex, 1), 1);
    v = vertex;
    f = models(gender(i)).faces;
    
    % add a model to the scene
    % scene_ascii.ply
    v(:, 2) = v(:, 2) + 0.2;
    mergePeopleWithSceneMex('models/scene_ascii.ply', v, f, sprintf('models/frame_%03d.ply', i));
    fprintf('models/frame_%03d.ply done.\n', i);
end
end

function mergePeopleWithScene(scene_name, vertex, faces, outname)
if ~exist(scene_name, 'file')
    error('File not found');
end

fin = fopen(scene_name, 'r');
fout = fopen(outname, 'w');

(fgetl(fin));
(fgetl(fin));
(fgetl(fin));
vtxNum = fscanf(fin, 'element vertex %d');
for i = 1 : 8
    text = fgetl(fin);
end
faceNum = fscanf(fin, 'element face %d');
for i = 1 : 3
    fgetl(fin);
end
fprintf('%d, %d\n', vtxNum, faceNum);

% write header
vtxNum2 = size(vertex, 1);
faceNum2 = size(faces, 1);
fprintf(fout, 'ply\n');
fprintf(fout, 'format ascii 1.0\n');
fprintf(fout, 'element vertex %d\n', vtxNum + vtxNum2);
fprintf(fout, 'property float x\n');
fprintf(fout, 'property float y\n');
fprintf(fout, 'property float z\n');
fprintf(fout, 'property uchar red\n');
fprintf(fout, 'property uchar green\n');
fprintf(fout, 'property uchar blue\n');
fprintf(fout, 'property uchar alpha\n');
fprintf(fout, 'element face %d\n', faceNum + faceNum2);
fprintf(fout, 'property list uchar int vertex_indices\n');
fprintf(fout, 'end_header\n');

% vertices
for i = 1 : vtxNum
    text = fgetl(fin);
    fprintf(fout, '%s\n', text);
end
for i = 1 : vtxNum2
    fprintf(fout, '%f %f %f %d %d %d 255\n', ...
        vertex(i, 1), vertex(i, 2), vertex(i, 3), ...
        vertex(i, 4), vertex(i, 5), vertex(i, 6));
end
% faces
for i = 1 : faceNum
    text = fgetl(fin);
    fprintf(fout, '%s\n', text);
end
faces = faces + vtxNum;
for i = 1 : faceNum2
    fprintf(fout, '3 %d %d %d\n', ...
        faces(i, 1), faces(i, 2), faces(i, 3));
end

fclose(fin);
fclose(fout);
end

function R = rotateY(theta)
R = [cos(theta), 0, sin(theta); 0 1 0; -sin(theta) 0 cos(theta)];
end