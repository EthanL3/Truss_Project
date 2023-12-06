load('truss1.mat');
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
    joints = joints';
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
p_crit_nom = zeros(1, c_cols);
p_crit_strong = zeros(1, c_cols);
p_crit_weak = zeros(1, c_cols);
r_m = ones(1, c_cols);
w_failure_nom = zeros(1, c_cols);
w_failure_strong = zeros(1, c_cols);
w_failure_weak = zeros(1, c_cols);
for i = 1:c_cols
    p_crit_nom(i) = 3654.533 * (r_vec(i)^(-2.119));
    p_crit_strong(i) = 3654.533 * (r_vec(i)^(-2.119)) + 1.685;
    p_crit_weak(i) = 3654.533 * (r_vec(i)^(-2.119)) - 1.685;
    if T(i) ~= 0
        r_m(i) = T(i)/w_l;
        w_failure_nom(i) = (-1*p_crit_nom(i))/r_m(i);
        w_failure_strong(i) = (-1*p_crit_strong(i))/r_m(i);
        w_failure_weak(i) = (-1*p_crit_weak(i))/r_m(i);
    else
        %if zero-force member, then w_failure is set to NaN
        w_failure_nom(i) = NaN; 
        w_failure_strong(i) = NaN;
        w_failure_weak(i) = NaN;
    end
end


%Critical member info:
compressions_nom = w_failure_nom > 0;
compressions_strong = w_failure_strong > 0;
compressions_weak = w_failure_weak > 0;

buckling_strengths_nom = w_failure_nom(compressions_nom);
buckling_strengths_strong = w_failure_strong(compressions_strong);
buckling_strengths_weak = w_failure_weak(compressions_weak);

crit_load_nom = min(buckling_strengths_nom);
crit_member_nom = find(w_failure_nom == crit_load_nom);
crit_length_nom = r_vec(crit_member_nom);

crit_load_strong = min(buckling_strengths_strong);
crit_member_strong = find(w_failure_strong == crit_load_strong);
crit_length_strong = r_vec(crit_member_strong);

crit_load_weak = min(buckling_strengths_weak);
crit_member_weak = find(w_failure_weak == crit_load_weak);
crit_length_weak = r_vec(crit_member_weak);

uncertainty = zeros(1, length(buckling_strengths_nom));
for i = 1:length(buckling_strengths_nom)
    uncertainty(i) = buckling_strengths_strong(i) - buckling_strengths_weak(i);
end



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
fprintf('Sy1: %.2f\n', T(length(T)-1));
fprintf('Sy2: %.2f\n', T(length(T)));
fprintf('Total cost: %.2f\n', total_cost);

fprintf('Nominal buckling strengths:\n');
disp(buckling_strengths_nom);
fprintf('Nominal Theoretical max load/cost ratio in oz/$: %.2f\n', crit_load_nom/total_cost);
fprintf('Nominal Critical member: %d\n', crit_member_nom);
fprintf('Nominal Critical member length: %.2f\n', crit_length_nom);
fprintf('Nominal Theoretical maximum load possible (oz): %.2f\n', crit_load_nom);

fprintf('Strong buckling strengths\n')
disp(buckling_strengths_strong);
fprintf('Strong Theoretical max load/cost ratio in oz/$: %.2f\n', crit_load_strong/total_cost);
fprintf('Strong Critical member: %d\n', crit_member_strong);
fprintf('Strong Critical member length: %.2f\n', crit_length_strong);
fprintf('Strong Theoretical maximum load possible (oz): %.2f\n', crit_load_strong);

fprintf('Weak buckling strengths\n');
disp(buckling_strengths_weak);
fprintf('Nominal Theoretical max load/cost ratio in oz/$: %.2f\n', crit_load_weak/total_cost);
fprintf('Nominal Critical member: %d\n', crit_member_weak);
fprintf('Nominal Critical member length: %.2f\n', crit_length_weak);
fprintf('Nominal Theoretical maximum load possible (oz): %.2f\n', crit_load_weak);

fprintf('Uncertainties:\n');
disp(uncertainty);
