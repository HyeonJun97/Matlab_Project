global MN;
global rsong1;
global rsong2;
global rsong3;
global rsong4;
global rsong5;
%% 음악찾기
run('Sample1.m')
run('Sample2.m')
run('Sample3.m')
run('Sample4.m')
run('Sample5.m')

r=[rsong1 rsong2 rsong3 rsong4 rsong5];
rmax=max(r);
rindex=find(r==rmax);

switch rindex
    case 1
        MN=sprintf('해당노래는 장범준-노래방에서 입니다.');
    case 2
        MN=sprintf('해당노래는 TWICE-Fancy 입니다');
    case 3
        MN=sprintf('해당노래는 BTS-Idol 입니다.');
    case 4
        MN=sprintf('해당노래는 겨울왕국-Let It Go 입니다.');
    case 5
        MN=sprintf('해당노래는 ITZY-달라달라 입니다.');
end