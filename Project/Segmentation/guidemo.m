function varargout = guidemo(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @guidemo_OpeningFcn, ...
                   'gui_OutputFcn',  @guidemo_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
   
% End initialization code - DO NOT EDIT


% --- Executes just before guidemo is made visible.
function guidemo_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to guidemo (see VARARGIN)

% Choose default command line output for guidemo
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes guidemo wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = guidemo_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in Browse.
function Browse_Callback(hObject, eventdata, handles)
% hObject    handle to Browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


    [filename, pathname] = uigetfile('*.jpg', 'Select a Image');
    if isequal(filename,0) || isequal(pathname,0)
    else
    filename=strcat(pathname,filename);
    InputImage=imread(filename);
    axes(handles.axes1);
    imshow(InputImage);
    set(handles.text5,'String','Selected Image');
    handles.InputImage=InputImage;
    end
    % Update handles structure
guidata(hObject, handles);
% --- Executes on button press in AdaptiveMedianFilter.
function AdaptiveMedianFilter_Callback(hObject, eventdata, handles)
% hObject    handle to AdaptiveMedianFilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
        InputImage=handles.InputImage;
        [R,C,D]=size(InputImage);
        if(D>2)
        InputImage=rgb2gray(InputImage); 
        end    
        NoisyImage=double(InputImage);
        PreProcessedImage=zeros(R,C);
        Zmin=[];
        Zmax=[];
        Zmed=[];
        
        for i=1:R
            for j=1:C
                if (i==1 && j==1)      
          % for right top corner[8,7,6]
                elseif (i==1 && j==C)      
			% for bottom left corner[2,3,4]
                elseif (i==R && j==1)      
                         % for bottom right corner[8,1,2]
                elseif (i==R && j==C)
                    
        		    %for top edge[8,7,6,5,4]
                elseif (i==1)
                     		      			% for right edge[2,1,8,7,6]
                elseif (i==R)
		      			 
		      			% // for bottom edge[8,1,2,3,4] 
                elseif (j==C)
		      
                         %// for left edge[2,3,4,5,6]
						 
                elseif (j==1)
 
               else
                             SR1 = NoisyImage((i-1),(j-1)); %diagonal1
 							 SR2 = NoisyImage((i-1),(j));   %upper pixel
    						 SR3 = NoisyImage((i-1),(j+1));   %diognal2
 							 SR4 = NoisyImage((i),(j-1));   %left
                             SR5 = NoisyImage(i,j);         %origin
 							 SR6 = NoisyImage((i),(j+1));   %right
 							 SR7 = NoisyImage((i+1),(j-1));   %diagonal3
 							 SR8 = NoisyImage((i+1),(j));  %bottom
 							 SR9 = NoisyImage((i+1),(j+1)); %diagonal4
                             TempPixel=[SR1,SR2,SR3,SR4,SR5,SR6,SR7,SR8,SR9];
                             Zxy=NoisyImage(i,j);
                             Zmin=min(TempPixel);
                             Zmax=max(TempPixel);
                             Zmed=median(TempPixel);
                             A1 = Zmed - Zmin;
                             A2 = Zmed - Zmax;
                             if A1 > 0 && A2 < 0     
                    %   go to level B
                                  B1 = Zxy - Zmin;
                                  B2 = Zxy - Zmax;
                                  if B1 > 0 && B2 < 0
                                      PreProcessedImage(i,j)= Zxy;
                                  else
                                      PreProcessedImage(i,j)= Zmed;
                                 end
                             else
                                 %increase/expand window size
                                 if ((R > 4 && R < R-5) && (C > 4 && C < C-5))
                                 S1 = NoisyImage((i-1),(j-1));
                                 S2 = NoisyImage((i-2),(j-2));
                                 S3 = NoisyImage((i-1),(j));
                                 S4 = NoisyImage((i-2),(j));
                                 S5 = NoisyImage((i-1),(j+1));
                                 S6 = NoisyImage((i-2),(j+2));
                                 S7 = NoisyImage((i),(j-1));
                                 S8 = NoisyImage((i),(j-2));
                                 S9 = NoisyImage(i,j);
                                 S10 = NoisyImage((i),(j+1));
                                 S11 = NoisyImage((i),(j+2));
                                 S12 = NoisyImage((i+1),(j-1));
                                 S13 = NoisyImage((i+2),(j-2));
                                 S14 = NoisyImage((i+1),(j));
                                 S15 = NoisyImage((i+2),(j));
                                 S16 = NoisyImage((i+1),(j+1));
                                 S17 = NoisyImage((i+2),(j+2));
                                 TempPixel2=[S1,S2,S3,S4,S5,S6,S7,S8,S9,S10,S11,S12,S13,S14,S15,S16,S17];
                                 Zmed2=median(TempPixel2);
                                  PreProcessedImage(i,j)= Zmed2;
                                 else  
                                 PreProcessedImage(i,j)= Zmed;
                                 end
                             end         
    
                end 
            end
        end
          
       PreProcessedImage3=[]
        PreProcessedImage3(:,:,1)=PreProcessedImage;
        PreProcessedImage3(:,:,2)=PreProcessedImage;
        PreProcessedImage3(:,:,3)=PreProcessedImage;
        PreProcessedImage=PreProcessedImage3;
        PreProcessedImage=uint8(PreProcessedImage);
        axes(handles.axes1);
        imshow(PreProcessedImage,[]);
        handles.PreProcessedImage=PreProcessedImage;
         set(handles.text5,'String','Filtered Image');
    % Update handles structure
guidata(hObject, handles);
%  Executes on GMM Segmentation.
function GMMSegmentation_Callback(hObject, eventdata, handles)
% hObject    handle to GMMSegmentation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
        PreProcessedImage=  handles.PreProcessedImage;
        Y=double(PreProcessedImage);
        k=2; % k: number of regions
        g=2; % g: number of GMM components
        beta=1; % beta: unitary vs. pairwise
        EM_iter=10; % max num of iterations
        MAP_iter=10; % max num of iterations
       % fprintf('Performing k-means segmentation\n');
        [X,GMM,ShapeTexture]=image_kmeans(Y,k,g);
        [X,Y,GMM]=HMRF_EM(X,Y,GMM,k,g,EM_iter,MAP_iter,beta);
        Y=Y*80;
        Y=uint8(Y);
        Y=rgb2gray(Y);
    Y=double(Y);
    statsa = glcm(Y,0,ShapeTexture);
    ExtractedFeatures1=statsa;
    axes(handles.axes1);
    imshow(Y,[]);
    Y=uint8(Y);
    handles.ExtractedFeatures=ExtractedFeatures1;  
    handles.gmm=1;
    % Update handles structure
    guidata(hObject, handles);
     set(handles.text5,'String','Segmented Image');
function Classifier_Callback(hObject, eventdata, handles)
% hObject    handle to Classifier (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gmm=0;
gmm=handles.gmm;
load ExtractedFeatures
A=1:20;
B=21:40;
C=41:60;
P = [A B C];
Tc = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1  2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3];

k=2; % k: number of regions
g=2; % g: number of GMM components

beta=1; % beta: unitary vs. pairwise
EM_iter=10; % max num of iterations
MAP_iter=10; % max num of iterations
 file=handles.InputImage;
 [R,C,D]=size(file);
 if(D>2)
    file=rgb2gray(file);
 end
    file=adaptivemedian(file);
    [Xk,GMMk,ShapeTexture]=image_kmeans(file,k,g);
    PreProcessedImage(:,:,1)=file;
    PreProcessedImage(:,:,2)=file;
    PreProcessedImage(:,:,3)=file;

    
    stats= gmmsegmentation(Xk,PreProcessedImage,GMMk,k,g,beta,EM_iter,MAP_iter,ShapeTexture);

    ShapeTexture=stats.ShapeTexture;
    
    for i=1:60
        
         statsa=ExtractedFeature{i};
         ShapeTexturea=statsa.ShapeTexture;
         
%           contr: 1.009343523879179e+04
%            corrm: -1.418636507817068e-01
%            corrp: -1.418636507820288e-01
%            cprom: 1.401715132552546e+08
%            cshad: -5.383904478067012e+04
%            dissi: 7.682897985689002e+01
%            energ: 3.431092389799559e-05
%            entro: 1.062998117740541e+01
%            homom: 4.224863191210370e-02
%            homop: 1.433346931769391e-02
%            maxpr: 5.297210924967812e-05
%            sosvh: 1.408273420241230e+04
%            savgh: 2.434734485092406e+02
%            svarh: 6.299666464377906e+04
%            senth: 5.757012620902187e+00
%            dvarh: 1.009343523879205e+04
%            denth: 5.258320847693307e+00
%            inf1h: -3.933982450962872e-02
%            inf2h: 5.914821945236276e-01
%            indnc: 7.945157263269642e-01
%            idmnc: 8.914962508154409e-01
%            
         
         diff1(i)=corr2(stats.autoc,statsa.autoc);
         diff2(i)=corr2(stats.contr,statsa.contr);
         diff3(i)=corr2(stats.corrm,statsa.corrm);
         diff4(i)=corr2(stats.cprom,statsa.cprom);
         diff5(i)=corr2(stats.cshad,statsa.cshad);
         diff6(i)=corr2(stats.dissi,statsa.dissi);
         diff7(i)=corr2(stats.energ,statsa.energ);
         diff8(i)=corr2(stats.entro,statsa.entro);
         diff9(i)=corr2(stats.homom,statsa.homom);
         diff10(i)=corr2(stats.homop,statsa.homop);
         diff11(i)=corr2(stats.maxpr,statsa.maxpr);
         diff12(i)=corr2(stats.sosvh,statsa.sosvh);
         diff13(i)=corr2(stats.savgh,statsa.savgh);
         diff14(i)=corr2(stats.svarh,statsa.svarh);
         diff15(i)=corr2(stats.senth,statsa.senth);
         diff16(i)=corr2(stats.dvarh,statsa.dvarh);
         diff17(i)=corr2(stats.denth,statsa.denth);
         diff18(i)=corr2(stats.inf1h,statsa.inf1h);
         diff19(i)=corr2(stats.inf2h,statsa.inf2h);
         diff19(i)=corr2(stats.indnc,statsa.indnc);
         diff19(i)=corr2(stats.idmnc,statsa.idmnc);
         diff20(i)=corr2(ShapeTexture,ShapeTexturea);
    end

    [val1,index1]=max(diff1);
    [val2,index2]=max(diff2);
    [val3,index3]=max(diff3);
    [val4,index4]=max(diff4);
    [val5,index5]=max(diff5);
    [val6,index6]=max(diff6);
    [val7,index7]=max(diff7);
    [val8 index8]=max(diff8);
    [val9,index9]=max(diff9);
    [val10,index10]=max(diff10);
    [val11,index11]=max(diff11);
    [val12,index12]=max(diff12);
    [val13,index13]=max(diff13);
    [val14,index14]=max(diff14);
    [val15,index15]=max(diff15);
    [val16,index16]=max(diff16);
    [val17,index17]=max(diff17);
    [val18,index18]=max(diff18);
    [val19,index19]=max(diff19);
    [val20,index20]=max(diff20);

T = ind2vec(Tc);
spread = 1;
net = newpnn(P,T,spread);
A = sim(net,P);
Ac = vec2ind(A);
pl(1) = index20;
p1(2) = index1;
p1(3) = index2;
p1(4) = index3;
p1(5) = index4;
p1(6) = index5;
p1(7) = index6;
p1(8) = index7;
p1(9) = index8;
p1(10) = index9;
p1(11) = index10;
p1(12) = index11;
p1(13) = index12;
p1(14) = index13;
p1(15) = index14;
p1(16) = index15;
p1(17)= index16;
p1(18) = index17;
p1(19) = index18;
p1(20) = index19;
a = sim(net,pl);
ac = vec2ind(a);
disp(ac);
ac=num2str(ac);
label='';
if ac=='1'
    label='Benign';
end
if ac=='2'
    label='Malignant';
end
if ac=='3'
    label='Normal';
end
set(handles.text5,'String',label);
% --- Executes on button press in loaddatabase.
function loaddatabase_Callback(hObject, eventdata, handles)
% hObject    handle to loaddatabase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    clc;
    k=2; % k: number of regions
    g=2; % g: number of GMM components

    beta=1; % beta: unitary vs. pairwise
    EM_iter=10; % max num of iterations
    MAP_iter=10; % max num of iteration
    len=1;
    len1=21;
    len2=41;
            
        
for num=1:20
   filename1=strcat('C:\Users\faizah\Music\M-Images\benign\Benign',num2str(num),'.jpg');
    filename2=strcat('C:\Users\faizah\Music\M-Images\malign\Malign',num2str(num),'.jpg');
    filename3=strcat('C:\Users\faizah\Music\M-Images\normal\Normal',num2str(num),'.jpg');
    a=imread(filename1);
    b=imread(filename2);
    c=imread(filename3);
    a=adaptivemedian(a);
    b=adaptivemedian(b);
    c=adaptivemedian(c);  
   [Xka,GMMka,ShapeTexturea]=image_kmeans(a,k,g);
   [Xkb,GMMkb,ShapeTextureb]=image_kmeans(b,k,g);
   [Xkc,GMMkc,ShapeTexturec]=image_kmeans(c,k,g);
    PreProcessedImagea(:,:,1)=a;
    PreProcessedImagea(:,:,2)=a;
    PreProcessedImagea(:,:,3)=a;
    PreProcessedImageb(:,:,1)=b;
    PreProcessedImageb(:,:,2)=b;
    PreProcessedImageb(:,:,3)=b;
    PreProcessedImagec(:,:,1)=c;
    PreProcessedImagec(:,:,2)=c;
    PreProcessedImagec(:,:,3)=c;
    statsa= gmmsegmentation(Xka,PreProcessedImagea,GMMka,k,g,beta,EM_iter,MAP_iter,ShapeTexturea);
    statsb= gmmsegmentation(Xkb,PreProcessedImageb,GMMkb,k,g,beta,EM_iter,MAP_iter,ShapeTextureb);
    statsc=gmmsegmentation(Xkc,PreProcessedImagec,GMMkc,k,g,beta,EM_iter,MAP_iter,ShapeTexturec)

     diff{len}=statsa;
     diff{len1}=statsb;
     diff{len2}=statsc;

    len=len+1;
    len1=len1+1;
    len2=len2+1;  
end
save extractedfeatures diff
close(h);




[val index]=max(diff);

disp('exit');

warndlg('Process completed'); 

% --- Executes on button press in TrainPNN.
function TrainPNN_Callback(hObject, eventdata, handles)
% hObject    handle to TrainPNN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

A=1:20;
B=21:40;
C=41:60;

P = [A B C];
Tc = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1  2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3];

T = ind2vec(Tc);
spread = 1;
net = newpnn(P,T,spread);

warndlg('Training Completed Sucessfully');
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=ones(256,256);
axes(handles.axes1);
imshow(a);
set(handles.text5,'String',' ');
clear;
