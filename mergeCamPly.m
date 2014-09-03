function mergeCamPly(camera_model, camera_param, filename)

numCam = length(camera_param);
numVtx = size(camera_model.vertex, 1);
vertex = [];
faces = [];

for i = 1 : numCam
    % rotate camera
    R = camera_param{i}.R(1:3, 1:3);
    C = camera_param{i}.C;
    curVtxNum = size(vertex, 1);
    vertex = [vertex;
        (camera_model.vertex(:, 1:3).*0.5) * R + repmat(C', numVtx, 1)];
    faces = [faces;
        camera_model.faces(:, 1:3) + curVtxNum];
end
vertex(:, 2) = vertex(:, 2) + 0.2;
writeCamPly(vertex, faces, filename);
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
    fprintf(f_out, '%f %f %f 255 255 255\n', ...
        vertex(i, 1), vertex(i, 2), vertex(i, 3));
end
for i = 1 : size(faces, 1)
    fprintf(f_out, '3 %d %d %d\n', ...
        faces(i, 1), faces(i, 2), faces(i, 3));
end

fclose(f_out);
end
