load('PracticeProblemInput.mat'); 

[C_rows, C_cols] = size(C);
Ax = zeros(C_rows, C_cols);
Ay = zeros(C_rows, C_cols);
%Loop for Ax matrix
for i = 1:C_rows
    %fprintf('i: %d\n', i);
    members = find(C(i,:)); %columns of C
    %disp('members:');
    %disp(members);
    for j = 1:numel(members)
        %fprintf('j: %d\n', j);
        joints = find(C(:, members(j))); %rows of C
        joints = joints';
        %disp(joints);
        x1 = X(joints(1)); %lower x
        x2 = X(joints(2)); %higher x
        y1 = Y(joints(1)); %lower y
        y2 = Y(joints(2)); %higher y
        %fprintf('x1: %f\n', x1);
        %fprintf('x2: %f\n', x2);
        %fprintf('y1: %f\n', y1);
        %fprintf('y2: %f\n', y2);
        r = sqrt((x2 - x1)^2 + (y2 - y1)^2);
        %fprintf('r: %f\n', r);
        Ax(i, members(j)) = abs(x2-x1)/r;
        Ay(i, members(j)) = abs(y2 - y1)/r;
    end
end
Ax_final = [Ax, Sx];
Ay_final = [Ay, Sy];
A = [Ax_final; Ay_final];
T = A\L; %inv(A) * L
disp(T);






