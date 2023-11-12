load('PracticeProblemInput.mat'); 

[C_rows, C_cols] = size(C);
Ax = zeros(C_rows, C_cols);
Ay = zeros(C_rows, C_cols);
%Loop for Ax matrix
for i = 1:C_rows
    members = find(C(i,:)); %columns of C
    for j = 1:numel(members)
        joints = find(C(:, members(j))); %rows of C
        joints = joints';
        x1 = X(joints(1)); %lower x
        x2 = X(joints(2)); %higher x
        y1 = Y(joints(1)); %lower y
        y2 = Y(joints(2)); %higher y
        r = sqrt((x2 - x1)^2 + (y2 - y1)^2);
        if x1 == i %if row# == lower x
            Ax(i, members(j)) = x2 - x1/r;
            Ay(i, members(j)) = y2 - y1/r;
        else
            Ax(i, members(j)) = x1 - x2/r;
            Ay(i, members(j)) = y1 - y2/r;
        end 
    end
end
disp(Ax);
disp(Ay);





