global MN;
global rsong1;
global rsong2;
global rsong3;
global rsong4;
global rsong5;
%% ����ã��
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
        MN=sprintf('�ش�뷡�� �����-�뷡�濡�� �Դϴ�.');
    case 2
        MN=sprintf('�ش�뷡�� TWICE-Fancy �Դϴ�');
    case 3
        MN=sprintf('�ش�뷡�� BTS-Idol �Դϴ�.');
    case 4
        MN=sprintf('�ش�뷡�� �ܿ�ձ�-Let It Go �Դϴ�.');
    case 5
        MN=sprintf('�ش�뷡�� ITZY-�޶�޶� �Դϴ�.');
end