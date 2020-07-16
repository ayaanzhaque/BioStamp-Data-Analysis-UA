%Tremblay, Weiner 2019
%MATLAB R2019a Required for Optimal Use
clc; close all; clear;
subjectList = ["subject3","subject4", "subject5", "subject6", "subject7", "subject8"];
reflexType = ["achilles" "patellar" "tricep"];
exType = ["exercise" "normal"];
signalType = ["elecRaw" "hammer" "response"];
readType =["accel", "gyro"];
%subjectList = ["subject5"];
%reflexType = ["patellar"];
%exType = ["exercise"];
% signalType = ["hammer"];
% readType =["accel"];
MasterTable = strings(1,8);
for subj=1:length(subjectList)
    for refT=1:length(reflexType)
        for exT=1:length(exType)
            for sigT=1:length(signalType)
                SL = subjectList(subj);
                RT = reflexType(refT);
                ET = exType(exT);
                ST = signalType(sigT);
                fpHammer = sprintf("%s/%s/%s/hammer/accel.csv",SL, RT, ET);
                fpResponse = sprintf("%s/%s/%s/response/accel.csv",SL, RT, ET);
                %Hammer/Response accel and gyro
                

                
                HAMData = readmatrix(fpHammer, "OutputType", "double");
                TNAUGHT = HAMData(1,1);
                HAMData(1:400,:) = [];
                HAMData(:,1)=(HAMData(:,1)-TNAUGHT)/1000000;
                HAMX = HAMData(:,2);
                HAMY = HAMData(:,3);
                HAMZ = HAMData(:,4);
                HAMT = HAMData(:,1);
                HAMxPeaks = islocalmax(HAMX,'MinSeparation',5,'MinProminence',0.1,'SamplePoints',HAMT);
                HAMyPeaks = islocalmax(HAMY,'MinSeparation',5,'MinProminence',0.1,'SamplePoints',HAMT);
                HAMzPeaks = islocalmax(HAMZ,'MinSeparation',5,'MinProminence',0.1,'SamplePoints',HAMT);
                
                fpV = sprintf("%s/%s/%s/elecRaw/elec.csv",SL, RT, ET);
                
                ELECData = readmatrix(fpV, "OutputType", "double");
                ELECData(1:400,:) = [];
                ELECData(:,1)=(ELECData(:,1)-TNAUGHT)/1000000;
                ELECT = ELECData(:,1);
                ELECV = ELECData(:,2)*1000;
                
                EMGPeaks = islocalmax(ELECV,'MinSeparation',3,'MinProminence',0.00001,'SamplePoints',ELECT);
                ELECPeakT = ELECT(EMGPeaks);
                ELECPeakV = ELECV(EMGPeaks);
                
                
                HAMZPeakT = HAMT(HAMzPeaks);%Time of Peaks Z
                HAMpeakZ = HAMZ(HAMzPeaks);%Value of Peaks Z
                HAMXPeakT = HAMT(HAMxPeaks);%Time of Peaks X
                HAMpeakX = HAMX(HAMxPeaks);%Value of Peaks X
                HAMYPeakT = HAMT(HAMyPeaks);%Time of Peaks Y
                HAMpeakY = HAMY(HAMyPeaks);%Value of Peaks Y
                RESData = readmatrix(fpResponse, "OutputType", "double");
                RESData(1:400,:) = [];
                RESData(:,1)=(RESData(:,1)-TNAUGHT)/1000000;
                RESX = RESData(:,2);
                RESY = RESData(:,3);
                RESZ = RESData(:,4);
                REST = RESData(:,1);
                RESxPeaks =islocalmax(RESX,'MinSeparation',5,'MinProminence',0.1,'SamplePoints',REST);
                RESyPeaks =islocalmax(RESY,'MinSeparation',5,'MinProminence',0.1,'SamplePoints',REST);
                RESzPeaks =islocalmax(RESZ,'MinSeparation',5,'MinProminence',0.1,'SamplePoints',REST);
                RESXPeakT = REST(RESxPeaks);%Time of Peaks X
                RESpeakX = RESX(RESxPeaks);%Value of Peaks X
                RESYPeakT = REST(RESyPeaks);%Time of Peaks Y
                RESpeakY = RESY(RESyPeaks);%Value of Peaks Y
                RESZPeakT = REST(RESzPeaks);%Time of Peaks Z
                RESpeakZ = RESZ(RESzPeaks);%Value of Peaks Z
       
                C = plot(HAMT, HAMZ, REST, RESY, REST, RESX, REST, RESZ);
                legend("Hammer", "Y", "X", "Z");
                disp("T1");
                
%                 hams = ["HAMZPeakT", "HAMYPeakT"];
%                 resp = ["RESXPeakT", "RESYPeakT", "RESZPeakT"];

                if(length(peakMatcher2(HAMZPeakT, ELECPeakT)) > 5)
                    disp("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
                    a = peakMatcher2(HAMZPeakT, ELECPeakT);
                    toApp = strings(length(a),5);
                    
                    for k = 1:size(a,1)
                        toApp(k, 1) = SL;
                        toApp(k, 2) = RT;
                        toApp(k, 3) = ET;
                        toApp(k, 4) = "HAMZPeakT";                    
                        toApp(k, 5) = "ELECPeakT";
                    end
                    t = horzcat(toApp, a);
                    MasterTable = [MasterTable; t];
                    plot(ELECT, ELECV);
                    xlabel('Time (s)');
                    ylabel('Acceleration (g)');
                    hold on
                    %plot(x,y)
                    %axis([zoomLowLimit zoomUpLimit inf inf]);
                    for i=1:length(HAMZPeakT)
                        xline(HAMZPeakT(i),'--');
                    end
                    hold off
                    saveName = sprintf("%s_%s_%s_HAMZ_ELECV",SL, RT, ET);
                    saveLoc2 = sprintf('peakLineGraphsTIF/%s.tif', saveName);
                    saveas(gcf, saveLoc2);
                    zoomUpLimit = HAMZPeakT(3) + 0.25;
                    zoomLowLimit = HAMZPeakT(3) - 0.25;
                    hold on
                    plot(ELECT, ELECV,'--b');
                    xlabel('Time (s)');
                    ylabel('EMG Reading (mV)');
                    axis([zoomLowLimit zoomUpLimit -inf inf]);
                    hold on
                    for i=1:length(HAMZPeakT)
                        xline(HAMZPeakT(i),'--');
                    end
                    hold off
                    saveName = sprintf("%s_%s_%s_HAMZ_ELECV_ZOOM",SL, RT, ET);
                    saveLoc2 = sprintf('peakLineGraphsTIF/%s.tif', saveName);
                    saveas(gcf, saveLoc2);
                end

                if(length(peakMatcher2(HAMZPeakT, RESXPeakT)) > 5)
                    a = peakMatcher2(HAMZPeakT, RESXPeakT);
                    toApp = strings(length(a), 5);
                    for k = 1:size(a,1)
                        toApp(k, 1) = SL;
                        toApp(k, 2) = RT;
                        toApp(k, 3) = ET;
                        toApp(k, 4) = "HAMZPeakT";
                        
                        toApp(k, 5) = "RESXPeakT";
                    end
                    t = horzcat(toApp, a);
                    MasterTable = [MasterTable; t];
                    disp("DDD");
                    plot(REST, RESX);
                    xlabel('Time (s)');
                    ylabel('Acceleration (g)');
                    hold on
                    %plot(x,y)
                    %axis([zoomLowLimit zoomUpLimit inf inf]);
                    for i=1:length(HAMZPeakT)
                        xline(HAMZPeakT(i),'--');
                    end
                    hold off
                    saveName = sprintf("%s_%s_%s_HAMZ_RESX",SL, RT, ET);
                    saveLoc2 = sprintf('peakLineGraphsTIF/%s.tif', saveName);
                    saveas(gcf, saveLoc2);
                    zoomUpLimit = HAMZPeakT(3) + 0.25;
                    zoomLowLimit = HAMZPeakT(3) - 0.25;
                    hold on
                    plot(REST, RESX,'--b');
                    xlabel('Time (s)');
                    ylabel('Acceleration (g)');
                    axis([zoomLowLimit zoomUpLimit -inf inf]);
                    hold on
                    for i=1:length(HAMZPeakT)
                        xline(HAMZPeakT(i),'--');
                    end
                    hold off
                    saveName = sprintf("%s_%s_%s_HAMZ_RESX_ZOOM",SL, RT, ET);
                    saveLoc2 = sprintf('peakLineGraphsTIF/%s.tif', saveName);
                    saveas(gcf, saveLoc2);

                end
                
                if(length(peakMatcher2(HAMZPeakT, RESYPeakT)) > 5)
                    a = peakMatcher2(HAMZPeakT, RESYPeakT);
                    toApp = strings(length(a), 5);
                    for k = 1:size(a,1)
                        toApp(k, 1) = SL;
                        toApp(k, 2) = RT;
                        toApp(k, 3) = ET;
                        toApp(k, 4) = "HAMZPeakT";
                        
                        toApp(k, 5) = "RESYPeakT";
                    end
                    t = horzcat(toApp, a);
                    MasterTable = [MasterTable; t];
                    disp("DDD");
                    plot(REST, RESY);
                    xlabel('Time (s)');
                    ylabel('Acceleration (g)');
                    hold on
                    %plot(x,y)
                    %axis([zoomLowLimit zoomUpLimit inf inf]);
                    for i=1:length(HAMZPeakT)
                        xline(HAMZPeakT(i),'--');
                    end
                    hold off
                    saveName = sprintf("%s_%s_%s_HAMZ_RESY",SL, RT, ET);
                    saveLoc2 = sprintf('peakLineGraphsTIF/%s.tif', saveName);
                    saveas(gcf, saveLoc2);
                    zoomUpLimit = HAMZPeakT(3) + 0.25;
                    zoomLowLimit = HAMZPeakT(3) - 0.25;
                    hold on
                    plot(REST, RESY,'--b');
                    xlabel('Time (s)');
                    ylabel('Acceleration (g)');
                    axis([zoomLowLimit zoomUpLimit -inf inf]);
                    hold on
                    for i=1:length(HAMZPeakT)
                        xline(HAMZPeakT(i),'--');
                    end
                    hold off
                    saveName = sprintf("%s_%s_%s_HAMZ_RESY_ZOOM",SL, RT, ET);
                    saveLoc2 = sprintf('peakLineGraphsTIF/%s.tif', saveName);
                    saveas(gcf, saveLoc2);
                    % dlmwrite('TestNote.txt', t, '-append');
                end
                if(length(peakMatcher2(HAMZPeakT, RESZPeakT)) > 5)
                    a = peakMatcher2(HAMZPeakT, RESZPeakT);
                    toApp = strings(length(a), 5);
                    for k = 1:size(a,1)
                        toApp(k, 1) = SL;
                        toApp(k, 2) = RT;
                        toApp(k, 3) = ET;
                        toApp(k, 4) = "HAMZPeakT";
                        toApp(k, 5) = "RESZPeakT";
                    end
                    t = horzcat(toApp, a);
                    MasterTable = [MasterTable; t];
                    disp("DDD");
                    plot(REST, RESZ);
                    xlabel('Time (s)');
                    ylabel('Acceleration (g)');
                    hold on
                    
                    %plot(x,y)
                    %axis([zoomLowLimit zoomUpLimit inf inf]);
                    for i=1:length(HAMZPeakT)
                        xline(HAMZPeakT(i),'--');
                    end
                    hold off
                    saveName = sprintf("%s_%s_%s_HAMZ_RESZ",SL, RT, ET);
                    saveLoc2 = sprintf('peakLineGraphsTIF/%s.tif', saveName);
                    saveas(gcf, saveLoc2);
                    zoomUpLimit = HAMZPeakT(3) + 0.25;
                    zoomLowLimit = HAMZPeakT(3) - 0.25;
                    hold on
                    plot(REST, RESZ,'--b');
                    xlabel('Time (s)');
                    ylabel('Acceleration (g)');
                    axis([zoomLowLimit zoomUpLimit -inf inf]);
                    hold on
                    for i=1:length(HAMZPeakT)
                        xline(HAMZPeakT(i),'--');
                    end
                    hold off
                    saveName = sprintf("%s_%s_%s_HAMZ_RESZ_ZOOM",SL, RT, ET);
                    saveLoc2 = sprintf('peakLineGraphsTIF/%s.tif', saveName);
                    saveas(gcf, saveLoc2);
                    %dlmwrite('TestNote.txt', t, '-append');
                end
                
                if(length(peakMatcher2(HAMYPeakT, ELECPeakT)) > 5)
                    disp("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
                    a = peakMatcher2(HAMYPeakT, ELECPeakT);
                    toApp = strings(length(a),5);
                    
                    for k = 1:size(a,1)
                        toApp(k, 1) = SL;
                        toApp(k, 2) = RT;
                        toApp(k, 3) = ET;
                        toApp(k, 4) = "HAMYPeakT";                    
                        toApp(k, 5) = "ELECPeakT";
                    end
                    t = horzcat(toApp, a);
                    MasterTable = [MasterTable; t];
                    plot(ELECT, ELECV);
                    xlabel('Time (s)');
                    ylabel('EMG Reading (mV)');
                    hold on
                    %plot(x,y)
                    %axis([zoomLowLimit zoomUpLimit inf inf]);
                    for i=1:length(HAMYPeakT)
                        xline(HAMYPeakT(i),'--');
                    end
                    hold off
                    saveName = sprintf("%s_%s_%s_HAMY_ELECV",SL, RT, ET);
                    saveLoc2 = sprintf('peakLineGraphsTIF/%s.tif', saveName);
                    saveas(gcf, saveLoc2);
                    zoomUpLimit = HAMYPeakT(3) + 0.25;
                    zoomLowLimit = HAMYPeakT(3) - 0.25;
                    hold on
                    plot(ELECT, ELECV,'--b');
                    xlabel('Time (s)');
                    ylabel('EMG Reading (mV)');
                    axis([zoomLowLimit zoomUpLimit -inf inf]);
                    hold on
                    for i=1:length(HAMYPeakT)
                        xline(HAMYPeakT(i),'--');
                    end
                    hold off
                    saveName = sprintf("%s_%s_%s_HAMY_ELECV_ZOOM",SL, RT, ET);
                    saveLoc2 = sprintf('peakLineGraphsTIF/%s.tif', saveName);
                    saveas(gcf, saveLoc2);
                end
                
                if(length(peakMatcher2(HAMYPeakT, RESXPeakT)) > 5)
                    a = peakMatcher2(HAMYPeakT, RESXPeakT);
                    toApp = strings(length(a), 5);
                    for k = 1:size(a,1)
                        toApp(k, 1) = SL;
                        toApp(k, 2) = RT;
                        toApp(k, 3) = ET;
                        toApp(k, 4) = "HAMYPeakT";
                        toApp(k, 5) = "RESXPeakT";
                    end
                    t = horzcat(toApp, a);
                    MasterTable = [MasterTable; t];
                    disp("DDD");
                    plot(REST, RESX);
                    xlabel('Time (s)');
                    ylabel('Acceleration (g)');
                    hold on
                    %plot(x,y)
                    %axis([zoomLowLimit zoomUpLimit inf inf]);
                    for i=1:length(HAMYPeakT)
                        xline(HAMYPeakT(i),'--');
                    end
                    hold off
                    saveName = sprintf("%s_%s_%s_HAMY_RESX",SL, RT, ET);
                    saveLoc2 = sprintf('peakLineGraphsTIF/%s.tif', saveName);
                    saveas(gcf, saveLoc2);
                    zoomUpLimit = HAMYPeakT(3) + 0.25;
                    
                    zoomLowLimit = HAMYPeakT(3) - 0.25;
                    hold on
                    plot(REST, RESX,'--b');
                    xlabel('Time (s)');
                    ylabel('Acceleration (g)');
                    axis([zoomLowLimit zoomUpLimit -inf inf]);
                    hold on
                    for i=1:length(HAMYPeakT)
                        xline(HAMYPeakT(i),'--');
                    end
                    hold off
                    saveName = sprintf("%s_%s_%s_HAMY_RESX_ZOOM",SL, RT, ET);
                    saveLoc2 = sprintf('peakLineGraphsTIF/%s.tif', saveName);
                    saveas(gcf, saveLoc2);
                    % dlmwrite('TestNote.txt', t, '-append');
                end
                if(length(peakMatcher2(HAMYPeakT, RESYPeakT)) > 5)
                    a = peakMatcher2(HAMYPeakT, RESYPeakT);
                    toApp = strings(length(a), 5);
                    for k = 1:size(a,1)
                        toApp(k, 1) = SL;
                        toApp(k, 2) = RT;
                        toApp(k, 3) = ET;
                        toApp(k, 4) = "HAMYPeakT";
                        toApp(k, 5) = "RESYPeakT";
                    end
                    t = horzcat(toApp, a);
                    MasterTable = [MasterTable; t];
                    disp("DDD");
                    plot(REST, RESY);
                    xlabel('Time (s)');
                    ylabel('Acceleration (g)');
                    hold on
                    %plot(x,y)
                    %axis([zoomLowLimit zoomUpLimit inf inf]);
                    for i=1:length(HAMYPeakT)
                        xline(HAMYPeakT(i),'--');
                    end
                    hold off
                    saveName = sprintf("%s_%s_%s_HAMY_RESY",SL, RT, ET);
                    saveLoc2 = sprintf('peakLineGraphsTIF/%s.tif', saveName);
                    saveas(gcf, saveLoc2);
                    zoomUpLimit = HAMYPeakT(3) + 0.25;
                    zoomLowLimit = HAMYPeakT(3) - 0.25;
                    hold on
                    plot(REST, RESY,'--b');
                    xlabel('Time (s)');
                    ylabel('Acceleration (g)');
                    axis([zoomLowLimit zoomUpLimit -inf inf]);
                    hold on
                    for i=1:length(HAMYPeakT)
                        xline(HAMYPeakT(i),'--');
                    end
                    hold off
                    saveName = sprintf("%s_%s_%s_HAMY_RESY_ZOOM",SL, RT, ET);
                    
                    saveLoc2 = sprintf('peakLineGraphsTIF/%s.tif', saveName);
                    saveas(gcf, saveLoc2);
                    %dlmwrite('TestNote.txt', t, '-append');
                end
                if(length(peakMatcher2(HAMYPeakT, RESZPeakT)) > 5)
                    a = peakMatcher2(HAMYPeakT, RESZPeakT);
                    toApp = strings(length(a), 5);
                    for k = 1:size(a,1)
                        toApp(k, 1) = SL;
                        toApp(k, 2) = RT;
                        toApp(k, 3) = ET;
                        toApp(k, 4) = "HAMYPeakT";
                        toApp(k, 5) = "RESZPeakT";
                    end
                    t = horzcat(toApp, a);
                    MasterTable = [MasterTable; t];
                    disp("DDD");
                    plot(REST, RESZ);
                    xlabel('Time (s)');
                    ylabel('Acceleration (g)');
                    hold on
                    %plot(x,y)
                    %axis([zoomLowLimit zoomUpLimit inf inf]);
                    for i=1:length(HAMYPeakT)
                        xline(HAMYPeakT(i),'--');
                    end
                    hold off
                    saveName = sprintf("%s_%s_%s_HAMY_RESZ",SL, RT, ET);
                    saveLoc2 = sprintf('peakLineGraphsTIF/%s.tif', saveName);
                    saveas(gcf, saveLoc2);
                    zoomUpLimit = HAMYPeakT(3) + 0.25;
                    zoomLowLimit = HAMYPeakT(3) - 0.25;
                    hold on
                    plot(REST, RESZ,'--b');
                    xlabel('Time (s)');
                    ylabel('Acceleration (g)');
                    axis([zoomLowLimit zoomUpLimit -inf inf]);
                    hold on
                    for i=1:length(HAMYPeakT)
                        xline(HAMYPeakT(i),'--');
                    end
                    hold off
                    saveName = sprintf("%s_%s_%s_HAMY_RESZ_ZOOM",SL, RT, ET);
                    saveLoc2 = sprintf('peakLineGraphsTIF/%s.tif', saveName);
                    saveas(gcf, saveLoc2);
                    % dlmwrite('TestNote.txt', t, '-append');
                end
                
            end
        end
        
    end
end
writematrix(MasterTable, "MasterTable3.csv");