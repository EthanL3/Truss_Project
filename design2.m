X = [0, 0, 8.25, 8.25, 16.5, 16.5, 24.75, 24.75, 33, 33];
Y = [8.75, 0, 8.75, 0, 8.75, 0, 8.5, 0, 8.75, 0];
connections = {[1, 2, 3], [1, 5], [2, 4, 6, 7], [3, 4, 5, 8], [6, 9, 10], [7, 8, 9, 11, 12], [10, 11, 13, 14], [12, 13, 15, 16], [14, 15, 17], [16, 17]};
C = zeros(10, 17);
for i = 1:10
    joints = connections{i};
    for j = 1:numel(joints)
        C(i, joints(j)) = 1;
    end
end
Sx = zeros(10, 3);
Sx(2, 1) = 1;
Sy = zeros(10, 3);
Sy(2, 2) = 1;
Sy(10, 3) = 1;
L = zeros(20, 1);
L(18, 1) = 32;
save('truss2.mat', 'C', 'X', 'Y', 'Sx', 'Sy', 'L');