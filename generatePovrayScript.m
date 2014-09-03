function generatePovrayScript(filename)
plyNames = dir('models/frame*.ply');
fid = fopen(filename, 'w');
for i = 1 : length(plyNames)
    [~, name, ~] = fileparts(plyNames(i).name);
    fprintf(fid, 'meshlabserver -i models/%s.ply -o models/%s.obj -om vc\n', ...
        name, name);
end

for i = 1 : length(plyNames)
    [~, name, ~] = fileparts(plyNames(i).name);
    fprintf(fid, './Obj2mesh2 models/%s.obj models/%03d.mesh2\n', ...
        name, i);
end

fclose(fid);
end