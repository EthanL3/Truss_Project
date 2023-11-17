load('PracticeProblemInput.mat'); 

[c_rows, c_cols] = size(C);

Ax = zeros(c_rows, c_cols); 
Ay = zeros(c_rows, c_cols);

total_length = 0; %sum of the lengths of all members
total_cost = 10 * c_rows; %keeps track of cost

r_vec = zeros(1, c_cols); %to store r values for each member

w_l = L(find(L)); %Value of load
%Indexing columns of C matrix
for i = 1:c_cols
    joints = find(C(:,i));
    x1 = X(joints(1)); %lower x
    x2 = X(joints(2)); %higher x
    y1 = Y(joints(1)); %lower y
    y2 = Y(joints(2)); %higher y

    r = norm([x1,y1]-[x2,y2]); 
    r_vec(i) = r;
    total_length = total_length + r;

    Ax(joints(1), i)  = (x2 - x1)/r;
    Ax(joints(2), i) = (x1-x2)/r;
    Ay(joints(1), i) = (y2-y1)/r;
    Ay(joints(2), i) = (y1-y2)/r;
end
total_cost = total_cost + total_length;
Ax_final = [Ax, Sx];
Ay_final = [Ay, Sy];
A = [Ax_final; Ay_final];
T = A\L;
T = T';

%Live load
p_crit = zeros(1, c_cols);
r_m = ones(1, c_cols);
w_failure = zeros(1, c_cols);
for i = 1:c_cols
    if T(i) ~= 0
        r_m(i) = T(i)/w_l;
    end
    p_crit(i) = 3654.533 * (r_vec(i)^(-2.119));
    w_failure(i) = (-1*p_crit(i))/r_m(i);
end


%Critical member info:
crit_load = min(abs(w_failure));
crit_member = find(abs(w_failure) == crit_load);
crit_length = r_vec(crit_member);


disp('EK301, Section A6, Ethan L., Margaret H., Micheal M., 11/17/2023');
fprintf('Load in oz: %.2f\n', w_l);
disp('Member forces in oz');
for i = 1:length(T) - 3
    if T(i) < 0
        fprintf('m%d: %.2f (C)\n', i, -1*T(i));
    elseif T(i) > 0
        fprintf('m%d: %.2f (T)\n', i, T(i));
    else
        fprintf('m%d: 0.00\n', i);
    end
end
disp('Reaction forces in oz:');
fprintf('Sx1: %.2f\n', T(length(T)-2));
fprintf('Sx2: %.2f\n', T(length(T)-1));
fprintf('Sx3: %.2f\n', T(length(T)));
fprintf('Total cost: %.2f\n', total_cost);
fprintf('Theoretical max load/cost ratio in oz/$: %.2f\n', crit_load/total_cost);
fprintf('Critical member: %d\n', crit_member);
fprintf('Critical member length: %.2f\n', crit_length);
fprintf('Theoretical maximum load possible (oz): %.2f\n', crit_load);
