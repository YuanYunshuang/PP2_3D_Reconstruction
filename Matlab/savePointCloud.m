function [  ] = savePointCloud( filename, pt )
    if exist(filename,'file')==2
        delete(filename);
    end
    fileID = fopen(filename,'wt');
    for i=1:length(pt);
        fprintf(fileID,'%.6f %.6f %.6f %d %d %d\n',pt(i,:));
    end
    fclose(fileID);
end

