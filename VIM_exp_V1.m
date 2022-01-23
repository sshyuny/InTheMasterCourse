% Motion-induced brightness shift

clear;

monitor_num=input('monitor number \n'); % 
participant_num=input('name\n'); % 파일 저장에 사용되는 참가자 번호

% Screen
[window,rect]=Screen('Openwindow', monitor_num, [0 0 0], [], [], [], []);
ifi = Screen('GetFlipInterval', window);
ifi_monitor = ifi; % ifi 값 확인을 위해 변인 하나 더 만들어서 살핌
Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
% 모니터 중앙 위치
[screenXcenter, screenYcenter] = Screen('WindowSize', window);
screenXcenter=screenXcenter/2;
screenYcenter=screenYcenter/2;
% 기타 설정
rng('shuffle');
HideCursor(window);
KbName('UnifyKeyNames');
InitializePsychSound(1);
% 모니터 값 가져오기 위한 첫번째 Screen Openwindow 때 보여주는 글
Screen('TextSize', window, 30);
Screen('TextFont', window, 'Times');
a=['Thank you for your paricipating! \n \n Please press space bar.'];
DrawFormattedText(window, a, 'center', 'center', [100 100 100]);
Screen('Flip', window);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 모니터에 따라 직접 넣어줘야 하는 값들
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[secs, keyCode, deltaSecs] = KbStrokeWait(0); % 원하는 키를 누를 때까지 기다리거라
% [VPixx]
if keyCode(KbName('space'))
    st_70cd=255;          % 70cd
    st_0d5cd=0;           % 0.5cd
    monitor_xcm = 53.13;  % 모니터 가로 길이 (cm)
    monitor_xpx = 1920;   % 모니터 가로 길이 (pixel) 
    st_resDots_1 = [0 40 55 68 79 90 99 107 114 122 129 135 142 148 154 160 166 171 177 181]; % 반응점들 밝기
%     st_resDots_1 = [0 38 55 68 75 87 97 105 112 120 127 133 140 147 152 158 164 170 173 181]; % 반응점들 밝기
%     st_resDots_1 = [0 43 61 74 86 95 103 112 121 128 135 141 148 153 160 165 171 176 181 186]; % 반응점들 밝기
%     st_resDots_1 = [0 46 64 80 91 103 111 121 125 132 139 146 152 158 164 169 175 180 186 190]; % 반응점들 밝기
%     st_resDots_1 = [0 46 64 80 91 103 111 121 128 135 141 149 155 162 167 173 177 183 188 193]; % 반응점들 밝기
elseif keyCode(KbName('escape'))
    sca;
    return;
end

%%%%%%%%%%%%%%%%%%%%
% 픽셀 수 계산
%%%%%%%%%%%%%%%%%%%%
px_x = monitor_xcm / monitor_xpx; % 모니터 가로 픽셀 크기 (cm)
distance = 90; % 눈과 화면과의 거리
VisualAngle = [0.25 0.3 0.6 1 2]; % 시각도
px_num = [0 0 0 0 0 0];
for i01 = 1:5
    st_size = tan(deg2rad(VisualAngle(i01)))*distance; % "자극 크기" 계산!
    px_num(i01) = round(st_size / px_x); % 몇 픽셀을 써야 해당 "자극 크기"로 나타나는지 계산해줌!
end
st_0d25deg=px_num(1); % 0.25 도  (자극점 지름)
st_0d3deg=px_num(2); % 0.3 도  
st_0d6deg=px_num(3); % 0.6 도  
st_1deg=px_num(4); % 1 도 
st_2deg=px_num(5); % 2 도  ("응시선-중심점" 거리)

%%%%%%%%%%%%%%%%%%%%
% 변인들에 값 기입      (주석처리된 값들은 이후 바뀌는 경우!)
%%%%%%%%%%%%%%%%%%%%
%%%%% 자극 크기
st_size_dia=st_0d25deg; % 자극 점 지름
    %    st_size_circle1=st_0d4deg; % "중심점-위성점" (내부 궤도의 반지름)
st_size_circle2=st_1deg; % "중심점-위성점" (외부 궤도의 반지름)
st_size_circle3=st_2deg; % "응시선-중심점"
    %    st_size_apart_x=st_2deg/(2^0.5); % "응시선-중심점"거리(x축)    +에 따라 수평(x축)으로 얼마나 이동해야 하는지 계산
    %    st_size_apart_y=st_2deg/(2^0.5); % "응시선-중심점"거리(y축)    +에 따라 수직(y축)으로 얼마나 이동해야 하는지 계산
st_size_apart_resp=st_2deg; % "응시선-반응점" (반응점 원형의 반지름)
st_size_fix=st_0d25deg; % 응시선 길이
st_size_dia_resp=st_0d25deg; % "반응점 지름"
%%%%% 자극 밝기
st_bright = 0; % 자극점의 밝기
st_bright_bg = st_70cd; % 배경 밝기
st_fixation = st_0d5cd; % 응시선 색
%%%%% 기타
    %    st_time1=0; % 자극 점1(중심점 ; 내부 궤도)이 한바퀴 돌 때 걸리는 시간
st_time2=1; % 자극 점2(위성점 ; 외부 궤도)이 한바퀴 돌 때 걸리는 시간
st_time3=1.67; % 자극 자체(중심점 기준)가 한바퀴 돌 때 걸리는 시간
st_resDots=st_resDots_1; % 반응점들 밝기
st_voiceVolume=0.1; % 소리 크기
    %    st_voice_hl=0; % 높은음/낮은음
repblink = 4; %  자극이 한 위치에서 몇 frame동안 제시되는지(여기선 4번 제시)

%%%%%%%%%%%%%%%%%%%%
% 변인 값 계산-1
%%%%%%%%%%%%%%%%%%%%
% 응시선
st_lineplace01=[screenXcenter, screenXcenter, screenXcenter-st_size_fix/2, screenXcenter+st_size_fix/2 ; screenYcenter-st_size_fix/2, screenYcenter+st_size_fix/2, screenYcenter, screenYcenter];

%%%%%%%%%%%%%%%%%%%%
% mat01
%%%%%%%%%%%%%%%%%%%%
var01=3; % [조작] 
var02=2; % [조작] 
rep = 10; % 시행 반복 수
mat01=[]; % [내부궤도반지름(1) 응답점(2) 시행순서(3) 정지시간(4) 운동시간(5) 반응점(6)]
for i01=1:var01
    for i02=1:var02
        mat01 = [mat01 ; i01 i02 0 0 0 0];
    end
end
mat01=repmat(mat01, rep, 1); % 반복수 넣음
var_trial=(var01*var02)*rep; % 총 시행 수
% 랜덤 시행 순서 넣는 과정
mat01(:,3)=randperm(var_trial); 
mat02=mat01;
mat01=sortrows(mat02, 3);

sca;
[window,rect]=Screen('Openwindow', monitor_num, st_bright_bg, [], [], [], []);
for i01 = 1:var_trial
    
    % [mat01의 1열]
    % 변인1
    if mat01(i01, 1) == 1
        st_size_circle1=0.001;    % "중심점-위성점" (내부 궤도의 반지름)
        st_time1=1;               % 자극 점1(중심점 ; 내부 궤도)이 한바퀴 돌 때 걸리는 시간
    elseif mat01(i01, 1) == 2
        st_size_circle1=st_0d3deg;    % "중심점-위성점" (내부 궤도의 반지름)
        st_time1=0.3;               % 자극 점1(중심점 ; 내부 궤도)이 한바퀴 돌 때 걸리는 시간
    elseif mat01(i01, 1) == 3
        st_size_circle1=st_0d6deg;    % "중심점-위성점" (내부 궤도의 반지름)
        st_time1=0.6;               % 자극 점1(중심점 ; 내부 궤도)이 한바퀴 돌 때 걸리는 시간
    end
    
    % [mat01의 2열]
    % 고정점/위성점
    if mat01(i01, 2) == 1
        st_voice_hl=300; % 낮은음(중심점)
    elseif mat01(i01, 2) == 2
        st_voice_hl=500; % 높은음(위성점)
    end
    
    %%%%%%%%%%%%%%%%%%%%
    % 변인 값 계산-2
    %%%%%%%%%%%%%%%%%%%%
    % 움직임 구현 계산
    moving = [st_time1 st_time2 st_time3; st_size_circle1 st_size_circle2 st_size_circle3; 0 0 0];
    for i02=1:3
        c11=moving(1, i02)/(ifi*repblink); % 원이 한번 돌 때의 프레임 개수
        c11=round(c11);
        c12=2*moving(2, i02)*pi/c11; % 한 프레임에 몇 픽셀 움직이는지
        c13=(c12/moving(2, i02)); % 라디안(한 프레임이 움직이는 만큼 라디안 각도)
        moving(3, i02) = c13;
    end
    st_circle1_mov=moving(3, 1); % 한 frame마다 몇 라디안씩 움직이는지
    st_circle2_mov=moving(3, 2);
    st_circle3_mov=moving(3, 3);
    % 랜덤한 시작 각도
    random_deg1 = datasample(1:360, 1)*pi/180;
    random_deg3 = datasample(1:360, 1)*pi/180;
    random_deg5 = datasample(1:360, 1)*pi/180;
    % 점 움직임 시작 위치 계산
    st_circle1_str_1_x=cos(random_deg1)*st_size_circle1; % x축 위치
    st_circle1_str_1_y=sin(random_deg1)*st_size_circle1; % y축 위치
    st_circle2_str_1_x=cos(random_deg3)*st_size_circle2; % 
    st_circle2_str_1_y=sin(random_deg3)*st_size_circle2; % 
    % 두 자극세트 시작 위치 계산
    st_size_apart_x=cos(random_deg5)*st_size_circle3; % x축 위치
    st_size_apart_y=sin(random_deg5)*st_size_circle3; % y축 위치
    
    %%%%%%%%%%%%%%%%%%%%
    % 자극
    %%%%%%%%%%%%%%%%%%%%
    % [대기화면]
    % 응시선 제시. 스페이스 바 눌러야 다음 진행.
    while 1==1
        HideCursor(window);
        Screen('DrawLines', window, st_lineplace01,[], st_fixation);
        vbl = Screen('Flip', window);
        [secs, keyCode, deltaSecs] = KbStrokeWait(0); % 원하는 키를 누를 때까지 기다리거라
        if keyCode(KbName('space'))
            break;
        elseif keyCode(KbName('escape'))
            sca;
            return;
        end
    end
    
    % [응시선: 깜빡임 + 1초간 제시]
    HideCursor(window);
    Screen('Flip', window);
    WaitSecs(0.5);
    Screen('DrawLines', window, st_lineplace01,[], st_fixation);
    Screen('Flip', window);
    WaitSecs(1);
    
    % [소리] 
    % 운동점에 응답하는지 고정점에 응답하는지 알려주는 소리
        % (소리)
    pahandle = PsychPortAudio('Open', [], 1, 1, 48000, 2);
    PsychPortAudio('Volume', pahandle, st_voiceVolume);
    myBeep = MakeBeep(st_voice_hl, 1, 48000);
    PsychPortAudio('FillBuffer', pahandle, [myBeep; myBeep]);
    PsychPortAudio('Start', pahandle, 1, 0, 1);
    PsychPortAudio('Stop', pahandle, 1, 1);
    PsychPortAudio('Close', pahandle);
    WaitSecs(0.5);
    
    
    % [1초간 내부 운동점만 움직이는 자극 제시]
    h=round((1/ifi)*1); % 1초에 해당하는 frame 개수
    h=h/(repblink); % 앞서 계산한 'frame 개수'를 '자극 반복 횟수'으로 나눔
    st_getTime01=GetSecs; % 시간 잼
    for i02 = 1:h
        % 점 위치, 매 frame마다 계산
        st_circle1_str_1_x=cos(random_deg1)*st_size_circle1; % 점 움직임 시작 각도
        st_circle1_str_1_y=sin(random_deg1)*st_size_circle1; % 점 움직임 시작 각도
        st_circle2_str_1_x=cos(random_deg3)*st_size_circle2; % 점 움직임 시작 각도
        st_circle2_str_1_y=sin(random_deg3)*st_size_circle2; % 점 움직임 시작 각도
        % 두 자극세트 위치, 매 frame마다 계산
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
        
        random_deg1=random_deg1+st_circle1_mov; % 점 움직이게 만드는 부분!
%         random_deg3=random_deg3+st_circle2_mov; % 점 움직이게 만드는 부분!
%         random_deg5 = random_deg5 + st_circle3_mov; % 자극 전체 움직이게 만드는 부분!
    end
    % 시간 잼
    st_getTime02=GetSecs;
    st_getTime03=st_getTime02-st_getTime01;
    
    % [3초간 움직이는 자극 제시]
    h=round((1/ifi)*3); % 3초에 해당하는 frame 개수
    h=h/(repblink); % 앞서 계산한 'frame 개수'를 '자극 반복 횟수'으로 나눔
    st_getTime04=GetSecs; % 시간 잼
    for i02 = 1:h
        % 점 위치, 매 frame마다 계산
        st_circle1_str_1_x=cos(random_deg1)*st_size_circle1; % 점 움직임 시작 각도
        st_circle1_str_1_y=sin(random_deg1)*st_size_circle1; % 점 움직임 시작 각도
        st_circle2_str_1_x=cos(random_deg3)*st_size_circle2; % 점 움직임 시작 각도
        st_circle2_str_1_y=sin(random_deg3)*st_size_circle2; % 점 움직임 시작 각도
        % 두 자극세트 위치, 매 frame마다 계산
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
        
        random_deg1=random_deg1+st_circle1_mov; % 점 움직이게 만드는 부분!
        random_deg3=random_deg3+st_circle2_mov; % 점 움직이게 만드는 부분!
%         random_deg5 = random_deg5 + st_circle3_mov; % 자극 전체 움직이게 만드는 부분!
        
    end
    % 시간 잼
    st_getTime05=GetSecs;
    st_getTime06=st_getTime05-st_getTime04;
    
    % [잠깐 빈화면]
    Screen('DrawLines', window, st_lineplace01,[], st_fixation);
    Screen('Flip', window);
    WaitSecs(0.5);
    
    % [반응 점들] 
    % 밝기 반응하는 점들 원형으로 띄움
    ShowCursor('Arrow');
    st23=0:18:342;% 18도씩 20개 360도까지
    st21=datasample(st23,1);% 20개 각도 중 하나 랜덤으로 고름
    st21=st21*pi/180; % 라디안으로 변환
    % [마우스 값 받기] & [자극 수정]
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
    % 데이터 저장
    % ----
    mat01(i01,4)=st_getTime03;
    mat01(i01,5)=st_getTime06;
    % 마우스 값 변환 과정
    rk=zeros(20,4);
    for i03=1:20
        rk(i03,1)=screenXcenter+cos(st21+(i03-1)*18*pi/180)*st_size_apart_resp-st_size_dia_resp/2 ; % 시작 x
        rk(i03,2)=screenXcenter+st_size_dia_resp+cos(st21+(i03-1)*18*pi/180)*st_size_apart_resp-st_size_dia_resp/2 ; % 끝 x
        rk(i03,3)=screenYcenter-sin(st21+(i03-1)*18*pi/180)*st_size_apart_resp-st_size_dia_resp/2 ; % 시작 y
        rk(i03,4)=screenYcenter+st_size_dia_resp-sin(st21+(i03-1)*18*pi/180)*st_size_apart_resp-st_size_dia_resp/2; % 끝y
        % 마우스 클릭 x, y 좌표 값을, 1(검정)~20(하양)으로 변환
        if x>=rk(i03,1) && x<=rk(i03,2) && y>=rk(i03,3) && y<=rk(i03,4)
            mat01(i01,6)=i03; % 클릭한 반응점 몇번짼지 행렬에 넣음!
        end
    end
    % 시행마다 메모장으로 저장
    participant_num=num2str(participant_num); % (참가자번호)
    dlmwrite(['data_exp_V1_' participant_num  '.txt'], mat01);
    
    
    % [쉬는 시간 20초]
    if (i01==15) || (i01==30) || (i01==45)
        st_getTime07=GetSecs; % 시간 잼
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
    end % 쉬는시간 end
    
end
    
% [실험 완료] 실험 완료 글자 띄우기
Screen('FillRect', window, [0 0 0], rect);
Screen('TextSize', window, 30);
Screen('TextFont', window, 'Times');
DrawFormattedText(window, 'The experiment is over! \n \n Thank you for your participating.', 'center', 'center', [100 100 100]);
Screen('Flip', window);

% 엑셀 저장
xlswrite(['data_exp_V1_' participant_num '.xlsx'], mat01);

sca;