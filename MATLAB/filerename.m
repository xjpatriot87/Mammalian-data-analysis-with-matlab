% rename the files 

file_dir = 'E:\Pei\OneDrive\_Research\_Mammalian Platform\_Results\20190719_VTR3_Tyrosine\DU\Du_GFP_RFP_293T\96 Well - Flat bottom 001_005\'; %read file dir

% background files
rows = ['F']; %background row
back_num = 1;
for row = rows
    for col = 1:3
        oldname = [file_dir, 'Specimen_001_', row, num2str(col), '_', row, num2str(col,'%02d'), '.fcs'];
        background_newname = [file_dir, 'b_', num2str(back_num), '.fcs'];

        if (exist(oldname, 'file'))
            copyfile(oldname, background_newname);
            back_num = back_num + 1;
        end
        
    end
end


% experiment files
rows = ['A','B','C','D','E']; %sample occupied row
file_num = 1;
for row = rows
    for col = 1:12
        oldname = [file_dir, 'Specimen_001_', row, num2str(col), '_', row, num2str(col,'%02d'), '.fcs'];
        expr_newname = [file_dir, num2str(file_num), '.fcs'];
        disp(oldname);
        if (exist(oldname, 'file'))&& file_num <= 60 %actual sample number
            
            disp(expr_newname);
            copyfile(oldname, expr_newname);
            file_num = file_num+1;
        end
        
    end
end

% rows = ['E','F','G'];
% file_num = 35;
% for row = rows
%     for col = 1:12
%         oldname = [file_dir, 'Specimen_001_', row, num2str(col), '_', row, num2str(col,'%02d'), '.fcs'];
%         expr_newname = [file_dir, num2str(file_num), '.fcs'];
%         disp(oldname);
%         if (exist(oldname, 'file'))&& file_num <= 68
%             
%             disp(expr_newname);
%             copyfile(oldname, expr_newname);
%             file_num = file_num+1;
%         end
%         
%     end
% end
% 
