function features = extractFeatures(file)
%EXTRACTFEATURES Summary of this function goes here
%   Detailed explanation goes here

    sensor1 = file.sensor1Data;
    sensor2 = file.sensor2Data;
    sensor3 = file.sensor3Data;
    sensor4 = file.sensor4Data;
    
    mean1 = mean(sensor1);
    mean2 = mean(sensor2);
    mean3 = mean(sensor3);
    mean4 = mean(sensor4);
    
    std1 = std(sensor1);
    std2 = std(sensor2);
    std3 = std(sensor3);
    std4 = std(sensor4);
        
    max1 = max(sensor1);
    max2 = max(sensor2);
    max3 = max(sensor3);
    max4 = max(sensor4);
    
    meanValues = [mean1 mean2 mean3 mean4];
    stdValues = [std1 std2 std3 std4];
    maxValues = [max1 max2 max3 max4];
    
    features = [meanValues stdValues maxValues];

end

