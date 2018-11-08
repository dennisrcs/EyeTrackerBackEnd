close all;

load trial2;

%% Plotting signal
figure;
plot(time, lpd);

vline(db.start);
vline(db.end);

vline(concwt.start);
vline(concwt.end);

vline(inccwt.start);
vline(inccwt.end);

ylabel("Left Pupil Size", "FontSize", 20);
xlabel("Time (s)", "FontSize", 20);

%% Plotting histogram
db_lpd = lpd(time > db.start & time < db.end);
concwt_lpd = lpd(time > concwt.start & time < concwt.end);
inccwt_lpd = lpd(time > inccwt.start & time < inccwt.end);

db_lpd = validateRange(db_lpd);
concwt_lpd = validateRange(concwt_lpd);
inccwt_lpd = validateRange(inccwt_lpd);

[f_db,x_db] = ksdensity(db_lpd);
[f_concwt,x_concwt] = ksdensity(concwt_lpd); 
[f_inccwt,x_inccwt] = ksdensity(inccwt_lpd); 

figure;
plot(x_db, f_db, 'b', 'LineWidth', 1); title ('Typing Task'); hold on;
plot(x_concwt, f_concwt, 'r', 'LineWidth', 1); hold on;
plot(x_inccwt, f_inccwt, 'k', 'LineWidth', 1);
legend('DB', 'Cong. CWT', 'Incong. CWT');

% figure;
% subplot(1,3,1); hist(db_lpd, 20);
% subplot(1,3,2); hist(concwt_lpd, 20);
% subplot(1,3,3); hist(inccwt_lpd, 20);

function values = validateRange(values)
    values(values > 30) = [];
end
