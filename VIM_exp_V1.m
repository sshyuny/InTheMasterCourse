% Motion-induced brightness shift

clear;

monitor_num=input('monitor number \n'); % 
participant_num=input('name\n'); % ���� ���忡 ���Ǵ� ������ ��ȣ

% Screen
[window,rect]=Screen('Openwindow', monitor_num, [0 0 0], [], [], [], []);
ifi = Screen('GetFlipInterval', window);
ifi_monitor = ifi; % ifi �� Ȯ���� ���� ���� �ϳ� �� ���� ����
Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
% ����� �߾� ��ġ
[screenXcenter, screenYcenter] = Screen('WindowSize', window);
screenXcenter=screenXcenter/2;
screenYcenter=screenYcenter/2;
% ��Ÿ ����
rng('shuffle');
HideCursor(window);
KbName('UnifyKeyNames');
InitializePsychSound(1);
% ����� �� �������� ���� ù��° Screen Openwindow �� �����ִ� ��
Screen('TextSize', window, 30);
Screen('TextFont', window, 'Times');
a=['Thank you for your paricipating! \n \n Please press space bar.'];
DrawFormattedText(window, a, 'center', 'center', [100 100 100]);
Screen('Flip', window);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ����Ϳ� ���� ���� �־���� �ϴ� ����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[secs, keyCode, deltaSecs] = KbStrokeWait(0); % ���ϴ� Ű�� ���� ������ ��ٸ��Ŷ�
% [VPixx]
if keyCode(KbName('space'))
    st_70cd=255;          % 70cd
    st_0d5cd=0;           % 0.5cd
    monitor_xcm = 53.13;  % ����� ���� ���� (cm)
    monitor_xpx = 1920;   % ����� ���� ���� (pixel) 
    st_resDots_1 = [0 40 55 68 79 90 99 107 114 122 129 135 142 148 154 160 166 171 177 181]; % �������� ���
%     st_resDots_1 = [0 38 55 68 75 87 97 105 112 120 127 133 140 147 152 158 164 170 173 181]; % �������� ���
%     st_resDots_1 = [0 43 61 74 86 95 103 112 121 128 135 141 148 153 160 165 171 176 181 186]; % �������� ���
%     st_resDots_1 = [0 46 64 80 91 103 111 121 125 132 139 146 152 158 164 169 175 180 186 190]; % �������� ���
%     st_resDots_1 = [0 46 64 80 91 103 111 121 128 135 141 149 155 162 167 173 177 183 188 193]; % �������� ���
elseif keyCode(KbName('escape'))
    sca;
    return;
end

%%%%%%%%%%%%%%%%%%%%
% �ȼ� �� ���
%%%%%%%%%%%%%%%%%%%%
px_x = monitor_xcm / monitor_xpx; % ����� ���� �ȼ� ũ�� (cm)
distance = 90; % ���� ȭ����� �Ÿ�
VisualAngle = [0.25 0.3 0.6 1 2]; % �ð���
px_num = [0 0 0 0 0 0];
for i01 = 1:5
    st_size = tan(deg2rad(VisualAngle(i01)))*distance; % "�ڱ� ũ��" ���!
    px_num(i01) = round(st_size / px_x); % �� �ȼ��� ��� �ش� "�ڱ� ũ��"�� ��Ÿ������ �������!
end
st_0d25deg=px_num(1); % 0.25 ��  (�ڱ��� ����)
st_0d3deg=px_num(2); % 0.3 ��  
st_0d6deg=px_num(3); % 0.6 ��  
st_1deg=px_num(4); % 1 �� 
st_2deg=px_num(5); % 2 ��  ("���ü�-�߽���" �Ÿ�)

%%%%%%%%%%%%%%%%%%%%
% ���ε鿡 �� ����      (�ּ�ó���� ������ ���� �ٲ�� ���!)
%%%%%%%%%%%%%%%%%%%%
%%%%% �ڱ� ũ��
st_size_dia=st_0d25deg; % �ڱ� �� ����
    %    st_size_circle1=st_0d4deg; % "�߽���-������" (���� �˵��� ������)
st_size_circle2=st_1deg; % "�߽���-������" (�ܺ� �˵��� ������)
st_size_circle3=st_2deg; % "���ü�-�߽���"
    %    st_size_apart_x=st_2deg/(2^0.5); % "���ü�-�߽���"�Ÿ�(x��)    +�� ���� ����(x��)���� �󸶳� �̵��ؾ� �ϴ��� ���
    %    st_size_apart_y=st_2deg/(2^0.5); % "���ü�-�߽���"�Ÿ�(y��)    +�� ���� ����(y��)���� �󸶳� �̵��ؾ� �ϴ��� ���
st_size_apart_resp=st_2deg; % "���ü�-������" (������ ������ ������)
st_size_fix=st_0d25deg; % ���ü� ����
st_size_dia_resp=st_0d25deg; % "������ ����"
%%%%% �ڱ� ���
st_bright = 0; % �ڱ����� ���
st_bright_bg = st_70cd; % ��� ���
st_fixation = st_0d5cd; % ���ü� ��
%%%%% ��Ÿ
    %    st_time1=0; % �ڱ� ��1(�߽��� ; ���� �˵�)�� �ѹ��� �� �� �ɸ��� �ð�
st_time2=1; % �ڱ� ��2(������ ; �ܺ� �˵�)�� �ѹ��� �� �� �ɸ��� �ð�
st_time3=1.67; % �ڱ� ��ü(�߽��� ����)�� �ѹ��� �� �� �ɸ��� �ð�
st_resDots=st_resDots_1; % �������� ���
st_voiceVolume=0.1; % �Ҹ� ũ��
    %    st_voice_hl=0; % ������/������
repblink = 4; %  �ڱ��� �� ��ġ���� �� frame���� ���õǴ���(���⼱ 4�� ����)

%%%%%%%%%%%%%%%%%%%%
% ���� �� ���-1
%%%%%%%%%%%%%%%%%%%%
% ���ü�
st_lineplace01=[screenXcenter, screenXcenter, screenXcenter-st_size_fix/2, screenXcenter+st_size_fix/2 ; screenYcenter-st_size_fix/2, screenYcenter+st_size_fix/2, screenYcenter, screenYcenter];

%%%%%%%%%%%%%%%%%%%%
% mat01
%%%%%%%%%%%%%%%%%%%%
var01=3; % [����] 
var02=2; % [����] 
rep = 10; % ���� �ݺ� ��
mat01=[]; % [���α˵�������(1) ������(2) �������(3) �����ð�(4) ��ð�(5) ������(6)]
for i01=1:var01
    for i02=1:var02
        mat01 = [mat01 ; i01 i02 0 0 0 0];
    end
end
mat01=repmat(mat01, rep, 1); % �ݺ��� ����
var_trial=(var01*var02)*rep; % �� ���� ��
% ���� ���� ���� �ִ� ����
mat01(:,3)=randperm(var_trial); 
mat02=mat01;
mat01=sortrows(mat02, 3);

sca;
[window,rect]=Screen('Openwindow', monitor_num, st_bright_bg, [], [], [], []);
for i01 = 1:var_trial
    
    % [mat01�� 1��]
    % ����1
    if mat01(i01, 1) == 1
        st_size_circle1=0.001;    % "�߽���-������" (���� �˵��� ������)
        st_time1=1;               % �ڱ� ��1(�߽��� ; ���� �˵�)�� �ѹ��� �� �� �ɸ��� �ð�
    elseif mat01(i01, 1) == 2
        st_size_circle1=st_0d3deg;    % "�߽���-������" (���� �˵��� ������)
        st_time1=0.3;               % �ڱ� ��1(�߽��� ; ���� �˵�)�� �ѹ��� �� �� �ɸ��� �ð�
    elseif mat01(i01, 1) == 3
        st_size_circle1=st_0d6deg;    % "�߽���-������" (���� �˵��� ������)
        st_time1=0.6;               % �ڱ� ��1(�߽��� ; ���� �˵�)�� �ѹ��� �� �� �ɸ��� �ð�
    end
    
    % [mat01�� 2��]
    % ������/������
    if mat01(i01, 2) == 1
        st_voice_hl=300; % ������(�߽���)
    elseif mat01(i01, 2) == 2
        st_voice_hl=500; % ������(������)
    end
    
    %%%%%%%%%%%%%%%%%%%%
    % ���� �� ���-2
    %%%%%%%%%%%%%%%%%%%%
    % ������ ���� ���
    moving = [st_time1 st_time2 st_time3; st_size_circle1 st_size_circle2 st_size_circle3; 0 0 0];
    for i02=1:3
        c11=moving(1, i02)/(ifi*repblink); % ���� �ѹ� �� ���� ������ ����
        c11=round(c11);
        c12=2*moving(2, i02)*pi/c11; % �� �����ӿ� �� �ȼ� �����̴���
        c13=(c12/moving(2, i02)); % ����(�� �������� �����̴� ��ŭ ���� ����)
        moving(3, i02) = c13;
    end
    st_circle1_mov=moving(3, 1); % �� frame���� �� ���Ⱦ� �����̴���
    st_circle2_mov=moving(3, 2);
    st_circle3_mov=moving(3, 3);
    % ������ ���� ����
    random_deg1 = datasample(1:360, 1)*pi/180;
    random_deg3 = datasample(1:360, 1)*pi/180;
    random_deg5 = datasample(1:360, 1)*pi/180;
    % �� ������ ���� ��ġ ���
    st_circle1_str_1_x=cos(random_deg1)*st_size_circle1; % x�� ��ġ
    st_circle1_str_1_y=sin(random_deg1)*st_size_circle1; % y�� ��ġ
    st_circle2_str_1_x=cos(random_deg3)*st_size_circle2; % 
    st_circle2_str_1_y=sin(random_deg3)*st_size_circle2; % 
    % �� �ڱؼ�Ʈ ���� ��ġ ���
    st_size_apart_x=cos(random_deg5)*st_size_circle3; % x�� ��ġ
    st_size_apart_y=sin(random_deg5)*st_size_circle3; % y�� ��ġ
    
    %%%%%%%%%%%%%%%%%%%%
    % �ڱ�
    %%%%%%%%%%%%%%%%%%%%
    % [���ȭ��]
    % ���ü� ����. �����̽� �� ������ ���� ����.
    while 1==1
        HideCursor(window);
        Screen('DrawLines', window, st_lineplace01,[], st_fixation);
        vbl = Screen('Flip', window);
        [secs, keyCode, deltaSecs] = KbStrokeWait(0); % ���ϴ� Ű�� ���� ������ ��ٸ��Ŷ�
        if keyCode(KbName('space'))
            break;
        elseif keyCode(KbName('escape'))
            sca;
            return;
        end
    end
    
    % [���ü�: ������ + 1�ʰ� ����]
    HideCursor(window);
    Screen('Flip', window);
    WaitSecs(0.5);
    Screen('DrawLines', window, st_lineplace01,[], st_fixation);
    Screen('Flip', window);
    WaitSecs(1);
    
    % [�Ҹ�] 
    % ����� �����ϴ��� �������� �����ϴ��� �˷��ִ� �Ҹ�
        % (�Ҹ�)
    pahandle = PsychPortAudio('Open', [], 1, 1, 48000, 2);
    PsychPortAudio('Volume', pahandle, st_voiceVolume);
    myBeep = MakeBeep(st_voice_hl, 1, 48000);
    PsychPortAudio('FillBuffer', pahandle, [myBeep; myBeep]);
    PsychPortAudio('Start', pahandle, 1, 0, 1);
    PsychPortAudio('Stop', pahandle, 1, 1);
    PsychPortAudio('Close', pahandle);
    WaitSecs(0.5);
    
    
    % [1�ʰ� ���� ����� �����̴� �ڱ� ����]
    h=round((1/ifi)*1); % 1�ʿ� �ش��ϴ� frame ����
    h=h/(repblink); % �ռ� ����� 'frame ����'�� '�ڱ� �ݺ� Ƚ��'���� ����
    st_getTime01=GetSecs; % �ð� ��
    for i02 = 1:h
        % �� ��ġ, �� frame���� ���
        st_circle1_str_1_x=cos(random_deg1)*st_size_circle1; % �� ������ ���� ����
        st_circle1_str_1_y=sin(random_deg1)*st_size_circle1; % �� ������ ���� ����
        st_circle2_str_1_x=cos(random_deg3)*st_size_circle2; % �� ������ ���� ����
        st_circle2_str_1_y=sin(random_deg3)*st_size_circle2; % �� ������ ���� ����
        % �� �ڱؼ�Ʈ ��ġ, �� frame���� ���
        st_size_apart_x=cos(random_deg5)*st_2deg;
        st_size_apart_y=sin(random_deg5)*st_2deg;
        
        st_rup_sd_1=[screenXcenter-st_size_apart_x-st_size_dia/2 screenYcenter+st_size_apart_y-st_size_dia/2 screenXcenter-st_size_apart_x+st_size_dia/2 screenYcenter+st_size_apart_y+st_size_dia/2];
        st_rup_md1_1=[screenXcenter-st_size_apart_x+st_circle1_str_1_x-st_size_dia/2 screenYcenter+st_size_apart_y-st_circle1_str_1_y-st_size_dia/2 screenXcenter-st_size_apart_x+st_size_dia+st_circle1_str_1_x-st_size_dia/2 screenYcenter+st_size_apart_y+st_size_dia-st_circle1_str_1_y-st_size_dia/2];
        st_rup_md2_1=[screenXcenter-st_size_apart_x+st_circle2_str_1_x-st_size_dia/2 screenYcenter+st_size_apart_y-st_circle2_str_1_y-st_size_dia/2 screenXcenter-st_size_apart_x+st_size_dia+st_circle2_str_1_x-st_size_dia/2 screenYcenter+st_size_apart_y+st_size_dia-st_circle2_str_1_y-st_size_dia/2];
        
        % [1 frame]
        Screen('DrawLines', window, st_lineplace01,[], st_fixation);
%         Screen('FillOval', window , st_bright, st_rup_sd_1);
        Screen('FillOval', window , st_bright, st_rup_md1_1);
%         Screen('FillOval', window , st_bright, st_rup_md2_1);
        vbl = Screen('Flip', window, vbl + (0.5) * ifi); 
        % [2 frame]
        Screen('DrawLines', window, st_lineplace01,[], st_fixation);
%         Screen('FillOval', window , st_bright_bg, st_rup_sd_1);
        Screen('FillOval', window , st_bright_bg, st_rup_md1_1);
%         Screen('FillOval', window , st_bright_bg, st_rup_md2_1);
        vbl = Screen('Flip', window, vbl + (0.5) * ifi); 
        % [3 frame]
        Screen('DrawLines', window, st_lineplace01,[], st_fixation);
%         Screen('FillOval', window , st_bright, st_rup_sd_1);
        Screen('FillOval', window , st_bright, st_rup_md1_1);
%         Screen('FillOval', window , st_bright, st_rup_md2_1);
        vbl = Screen('Flip', window, vbl + (0.5) * ifi); 
        % [4 frame]
        Screen('DrawLines', window, st_lineplace01,[], st_fixation);
%         Screen('FillOval', window , st_bright, st_rup_sd_1);
        Screen('FillOval', window , st_bright, st_rup_md1_1);
%         Screen('FillOval', window , st_bright, st_rup_md2_1);
        vbl = Screen('Flip', window, vbl + (0.5) * ifi); 
        
        random_deg1=random_deg1+st_circle1_mov; % �� �����̰� ����� �κ�!
%         random_deg3=random_deg3+st_circle2_mov; % �� �����̰� ����� �κ�!
%         random_deg5 = random_deg5 + st_circle3_mov; % �ڱ� ��ü �����̰� ����� �κ�!
    end
    % �ð� ��
    st_getTime02=GetSecs;
    st_getTime03=st_getTime02-st_getTime01;
    
    % [3�ʰ� �����̴� �ڱ� ����]
    h=round((1/ifi)*3); % 3�ʿ� �ش��ϴ� frame ����
    h=h/(repblink); % �ռ� ����� 'frame ����'�� '�ڱ� �ݺ� Ƚ��'���� ����
    st_getTime04=GetSecs; % �ð� ��
    for i02 = 1:h
        % �� ��ġ, �� frame���� ���
        st_circle1_str_1_x=cos(random_deg1)*st_size_circle1; % �� ������ ���� ����
        st_circle1_str_1_y=sin(random_deg1)*st_size_circle1; % �� ������ ���� ����
        st_circle2_str_1_x=cos(random_deg3)*st_size_circle2; % �� ������ ���� ����
        st_circle2_str_1_y=sin(random_deg3)*st_size_circle2; % �� ������ ���� ����
        % �� �ڱؼ�Ʈ ��ġ, �� frame���� ���
        st_size_apart_x=cos(random_deg5)*st_2deg;
        st_size_apart_y=sin(random_deg5)*st_2deg;
        
        st_rup_sd_1=[screenXcenter-st_size_apart_x-st_size_dia/2 screenYcenter+st_size_apart_y-st_size_dia/2 screenXcenter-st_size_apart_x+st_size_dia/2 screenYcenter+st_size_apart_y+st_size_dia/2];
        st_rup_md1_1=[screenXcenter-st_size_apart_x+st_circle1_str_1_x-st_size_dia/2 screenYcenter+st_size_apart_y-st_circle1_str_1_y-st_size_dia/2 screenXcenter-st_size_apart_x+st_size_dia+st_circle1_str_1_x-st_size_dia/2 screenYcenter+st_size_apart_y+st_size_dia-st_circle1_str_1_y-st_size_dia/2];
        st_rup_md2_1=[screenXcenter-st_size_apart_x+st_circle2_str_1_x-st_size_dia/2 screenYcenter+st_size_apart_y-st_circle2_str_1_y-st_size_dia/2 screenXcenter-st_size_apart_x+st_size_dia+st_circle2_str_1_x-st_size_dia/2 screenYcenter+st_size_apart_y+st_size_dia-st_circle2_str_1_y-st_size_dia/2];
        
        % [1 frame]
        Screen('DrawLines', window, st_lineplace01,[], st_fixation);
%         Screen('FillOval', window , st_bright, st_rup_sd_1);
        Screen('FillOval', window , st_bright, st_rup_md1_1);
        Screen('FillOval', window , st_bright, st_rup_md2_1);
        vbl = Screen('Flip', window, vbl + (0.5) * ifi); 
        % [2 frame]
        Screen('DrawLines', window, st_lineplace01,[], st_fixation);
%         Screen('FillOval', window , st_bright_bg, st_rup_sd_1);
        Screen('FillOval', window , st_bright_bg, st_rup_md1_1);
        Screen('FillOval', window , st_bright_bg, st_rup_md2_1);
        vbl = Screen('Flip', window, vbl + (0.5) * ifi); 
        % [3 frame]
        Screen('DrawLines', window, st_lineplace01,[], st_fixation);
%         Screen('FillOval', window , st_bright, st_rup_sd_1);
        Screen('FillOval', window , st_bright, st_rup_md1_1);
        Screen('FillOval', window , st_bright, st_rup_md2_1);
        vbl = Screen('Flip', window, vbl + (0.5) * ifi); 
        % [4 frame]
        Screen('DrawLines', window, st_lineplace01,[], st_fixation);
%         Screen('FillOval', window , st_bright, st_rup_sd_1);
        Screen('FillOval', window , st_bright, st_rup_md1_1);
        Screen('FillOval', window , st_bright, st_rup_md2_1);
        vbl = Screen('Flip', window, vbl + (0.5) * ifi); 
        
        random_deg1=random_deg1+st_circle1_mov; % �� �����̰� ����� �κ�!
        random_deg3=random_deg3+st_circle2_mov; % �� �����̰� ����� �κ�!
%         random_deg5 = random_deg5 + st_circle3_mov; % �ڱ� ��ü �����̰� ����� �κ�!
        
    end
    % �ð� ��
    st_getTime05=GetSecs;
    st_getTime06=st_getTime05-st_getTime04;
    
    % [��� ��ȭ��]
    Screen('DrawLines', window, st_lineplace01,[], st_fixation);
    Screen('Flip', window);
    WaitSecs(0.5);
    
    % [���� ����] 
    % ��� �����ϴ� ���� �������� ���
    ShowCursor('Arrow');
    st23=0:18:342;% 18���� 20�� 360������
    st21=datasample(st23,1);% 20�� ���� �� �ϳ� �������� ��
    st21=st21*pi/180; % �������� ��ȯ
    % [���콺 �� �ޱ�] & [�ڱ� ����]
    [x, y, buttons] = GetMouse(window);
    [ keyIsDown, seconds, keyCode ] = KbCheck;
    keyBase = keyIsDown;
    while ~any(buttons) && keyIsDown==keyBase % wait for press
        for i03=1:20
            Screen('FillOval', window , [st_resDots(i03) st_resDots(i03) st_resDots(i03)], [screenXcenter+cos(st21+(i03-1)*18*pi/180)*st_size_apart_resp-st_size_dia_resp/2 screenYcenter-sin(st21+(i03-1)*18*pi/180)*st_size_apart_resp-st_size_dia_resp/2 screenXcenter+st_size_dia_resp+cos(st21+(i03-1)*18*pi/180)*st_size_apart_resp-st_size_dia_resp/2 screenYcenter+st_size_dia_resp-sin(st21+(i03-1)*18*pi/180)*st_size_apart_resp-st_size_dia_resp/2]);
        end
        vbl = Screen('Flip', window, vbl + (0.5) * ifi);        
        [ keyIsDown, seconds, keyCode ] = KbCheck;
        if keyCode(KbName('escape'))
            sca;
            return;
        end
        [x,y,buttons] = GetMouse;
    end
    
    % ----
    % ������ ����
    % ----
    mat01(i01,4)=st_getTime03;
    mat01(i01,5)=st_getTime06;
    % ���콺 �� ��ȯ ����
    rk=zeros(20,4);
    for i03=1:20
        rk(i03,1)=screenXcenter+cos(st21+(i03-1)*18*pi/180)*st_size_apart_resp-st_size_dia_resp/2 ; % ���� x
        rk(i03,2)=screenXcenter+st_size_dia_resp+cos(st21+(i03-1)*18*pi/180)*st_size_apart_resp-st_size_dia_resp/2 ; % �� x
        rk(i03,3)=screenYcenter-sin(st21+(i03-1)*18*pi/180)*st_size_apart_resp-st_size_dia_resp/2 ; % ���� y
        rk(i03,4)=screenYcenter+st_size_dia_resp-sin(st21+(i03-1)*18*pi/180)*st_size_apart_resp-st_size_dia_resp/2; % ��y
        % ���콺 Ŭ�� x, y ��ǥ ����, 1(����)~20(�Ͼ�)���� ��ȯ
        if x>=rk(i03,1) && x<=rk(i03,2) && y>=rk(i03,3) && y<=rk(i03,4)
            mat01(i01,6)=i03; % Ŭ���� ������ ���²�� ��Ŀ� ����!
        end
    end
    % ���ึ�� �޸������� ����
    participant_num=num2str(participant_num); % (�����ڹ�ȣ)
    dlmwrite(['data_exp_V1_' participant_num  '.txt'], mat01);
    
    
    % [���� �ð� 20��]
    if (i01==15) || (i01==30) || (i01==45)
        st_getTime07=GetSecs; % �ð� ��
        st_getTime08=1;
        while st_getTime08>0
            st_getTime09=GetSecs;
            st_getTime08=st_getTime09-st_getTime07;
            st_getTime08=20-st_getTime08;
            st_getTime08=round(st_getTime08);
            st_breaktime=num2str(st_getTime08);

            wr01=['This is break time. \n \n The experiment will start after ' st_breaktime ' seconds.'];

            Screen('TextSize', window, 30);
            Screen('TextFont', window, 'Times');
            DrawFormattedText(window, wr01, 'center', 'center', [100 100 100]);
            Screen('Flip', window);

            [ keyIsDown, seconds, keyCode ] = KbCheck;
            if keyCode(KbName('escape'))
                break;
            end
        end
    end % ���½ð� end
    
end
    
% [���� �Ϸ�] ���� �Ϸ� ���� ����
Screen('FillRect', window, [0 0 0], rect);
Screen('TextSize', window, 30);
Screen('TextFont', window, 'Times');
DrawFormattedText(window, 'The experiment is over! \n \n Thank you for your participating.', 'center', 'center', [100 100 100]);
Screen('Flip', window);

% ���� ����
xlswrite(['data_exp_V1_' participant_num '.xlsx'], mat01);

sca;