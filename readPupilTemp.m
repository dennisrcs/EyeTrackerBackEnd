path = 'C:\Program Files (x86)\Gazepoint\Gazepoint\demo\CSharp\CSharp\CSharp\bin\Debug\10_22_2018 11_35_16_AM.csv';
file = csvread(path);

plot(file(:,1), file(:,3));

ylabel("Right Pupil Size", "FontSize", 20);
xlabel("Time (s)", "FontSize", 20);