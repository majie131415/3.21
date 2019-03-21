function HOG
clear all ;

img=double(imread('lean.jpg'));

imshow(img,[]);
[m,n]=size(img);

img=sqrt(img);
%�±������Ե
fy=[-1 0 1]; %������ֱģ��
fx=fy'; %����ˮƽģ��
Iy=imfilter(img,fy,'replicate');
Ix=imfilter(img,fx,'replicate');
Ied=sqrt(Ix.^2+Iy.^2); %��Եǿ�ȣ���ֵ��
Iphase=Iy./Ix;
%�±�����cell
step=8;
orient=9;
jiao=360/orient;
Cell=cell(1,1);   %���еĽǶ�ֱ��ͼ��cell�ǿ��Զ�̬���ӵģ�����������һ��
ii=1;
jj=1;
for i=1:step:m
    ii=1;
    for j=1:step:n
        tmpx=Ix(i:i+step-1,j:j+step-1);
        tmped=Ied(i:i+step-1,j:j+step-1);
        tmped=tmped/sum(sum(tmped)); %��Եǿ�ȹ�һ��
        tmpphase=Iphase(i:i+step-1,j:j+step-1);
        Hist=zeros(1,orient);   %��ǰstep*step���ؿ�ͳ�ƽǶ�ֱ��ͼ������cell
        for p=1:step
            for q=1:step
                if isnan(tmpphase(p,q))==1 %0/0��õ�nan�����������nan������Ϊ0
                    tmpphase(p,q)=0;
                end
                ang=atan(tmpphase(p,q));
                ang=mod(ang*180/pi,360); %ȫ��������-90���270
                if tmpx(p,q)<0 %����x�ķ���ȷ�������ĽǶ�
                    if ang<90
                        ang=ang+180;
                    end
                    if ang>270
                        ang=ang-180;
                    end
                end
                ang=ang+0.0000001;
                Hist(ceil(ang/jiao))=Hist(ceil(ang/jiao))+tmped(p,q); %ceil����ȡ����ʹ�ñ�Եǿ�ȼ�Ȩ
            end
        end
        Hist=Hist/sum(Hist);
        Cell{ii,jj}=Hist;
        ii=ii+1;
    end
    jj=jj+1;
end
%�±�����feature��2*2��cell�ϳ�һ��block,û����ʽ����block
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
    
        


