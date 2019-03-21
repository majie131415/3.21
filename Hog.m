function HOG
clear all ;

img=double(imread('lean.jpg'));

imshow(img,[]);
[m,n]=size(img);

img=sqrt(img);
%下边是求边缘
fy=[-1 0 1]; %定义竖直模板
fx=fy'; %定义水平模板
Iy=imfilter(img,fy,'replicate');
Ix=imfilter(img,fx,'replicate');
Ied=sqrt(Ix.^2+Iy.^2); %边缘强度（幅值）
Iphase=Iy./Ix;
%下边是求cell
step=8;
orient=9;
jiao=360/orient;
Cell=cell(1,1);   %所有的角度直方图，cell是可以动态增加的，所以先设了一个
ii=1;
jj=1;
for i=1:step:m
    ii=1;
    for j=1:step:n
        tmpx=Ix(i:i+step-1,j:j+step-1);
        tmped=Ied(i:i+step-1,j:j+step-1);
        tmped=tmped/sum(sum(tmped)); %边缘强度归一化
        tmpphase=Iphase(i:i+step-1,j:j+step-1);
        Hist=zeros(1,orient);   %当前step*step像素块统计角度直方图，就是cell
        for p=1:step
            for q=1:step
                if isnan(tmpphase(p,q))==1 %0/0会得到nan，如果像素是nan，重设为0
                    tmpphase(p,q)=0;
                end
                ang=atan(tmpphase(p,q));
                ang=mod(ang*180/pi,360); %全部变正，-90变成270
                if tmpx(p,q)<0 %根据x的方向确定真正的角度
                    if ang<90
                        ang=ang+180;
                    end
                    if ang>270
                        ang=ang-180;
                    end
                end
                ang=ang+0.0000001;
                Hist(ceil(ang/jiao))=Hist(ceil(ang/jiao))+tmped(p,q); %ceil向上取整，使用边缘强度加权
            end
        end
        Hist=Hist/sum(Hist);
        Cell{ii,jj}=Hist;
        ii=ii+1;
    end
    jj=jj+1;
end
%下边是求feature，2*2个cell合成一个block,没有显式的求block
[m,n]=size(Cell);
feature=cell(1,(m-1)*(n-1));
for i=1:m-1
    for j=1:n-1
        f=[];
        f=[f Cell{i,j}(:)' Cell{i,j+1}(:)' Cell{i+1,j}(:)' Cell{i+1,j+1}(:)'];
        feature{(i-1)*(n-1)+j}=f;
    end
end

l=length(feature);
f=[];
for i=1:l
    f=[f;feature{i}(:)'];
end
figure
mesh(f)
    
        


