load('PracticeProblemInput.mat'); 

[C_rows, C_cols] = size(C);
Ax = zeros(C_rows, C_cols);
Ay = zeros(C_rows, C_cols);
%Loop for Ax matrix
for i = 1:C_rows
    fprintf('i: %d\n', i);
    members = find(C(i,:)); %columns of C
    disp('members:');
    disp(members);
    for j = 1:numel(members)
        fprintf('j: %d\n', j);
        joints = find(C(:, members(j))); %rows of C
        joints = joints';
        disp('joints');
        disp(joints);
        x1 = X(joints(1)); %lower x
        x2 = X(joints(2)); %higher x
        y1 = Y(joints(1)); %lower y
        y2 = Y(joints(2)); %higher y
        fprintf('x1: %f\n', x1);
        fprintf('x2: %f\n', x2);
        fprintf('y1: %f\n', y1);
        fprintf('y2: %f\n', y2);
        r = sqrt((x2 - x1)^2 + (y2 - y1)^2);
        fprintf('r: %f\n', r);
        if i == joints(1)
            Ax(joints(1), members(j)) = x2 - x1/r;
            Ay(joints(1), members(j)) = y2 - y1/r;
        else
            Ax(joints(2), members(j)) = x1 - x2/r;
            Ay(joints(2), members(j)) = y1 - y2/r;
        end
    end
end
disp(Ax);
