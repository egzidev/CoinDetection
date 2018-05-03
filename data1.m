function varargout = data1(varargin)
% DATA1 MATLAB code for data1.fig
%      DATA1, by itself, creates a new DATA1 or raises the existing
%      singleton*.
%
%      H = DATA1 returns the handle to a new DATA1 or the handle to
%      the existing singleton*.
%
%      DATA1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DATA1.M with the given input arguments.
%
%      DATA1('Property','Value',...) creates a new DATA1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before data1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to data1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDEs Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help data1

% Last Modified by GUIDE v2.5 28-Apr-2016 01:24:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @data1_OpeningFcn, ...
                   'gui_OutputFcn',  @data1_OutputFcn, ...
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


% --- Executes just before data1 is made visible.
function data1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to data1 (see VARARGIN)

% Choose default command line output for data1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes data1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = data1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in PARAQIT_FOTON.
function PARAQIT_FOTON_Callback(hObject, eventdata, handles)
% hObject    handle to PARAQIT_FOTON (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[path,user_cance] = imgetfile();
if user_cance
    msgbox(sprintf('Nuk keni futur foto.'),'Error','Error');
    % Nese klikojm per te zgjedhur foto dhe dalim pa futur 
    % Do te paraqitet mesazhi NUK KENI FUTUR FOTO.

    return
end

handles.grayImage = imread(path);
[rows, columns, numberOfColorBands] = size(handles.grayImage)
if numberOfColorBands > 1
	% Nuk eshte ne shkallen gri siq pritej por eshte me ngjyra
    % Konvertohet ne shkallen gri duke marre vetem kanalin e ngjelber.

	handles.grayImage1 = handles.grayImage(:, :, 2); % 2- ngjyra gjelber.
end
% Display the original gray scale image.

imshow(handles.grayImage1,'Parent',handles.axes1);
guidata(hObject,handles);




% --- Executes on button press in HISTOGRAMI.
function HISTOGRAMI_Callback(hObject, eventdata, handles)
% hObject    handle to HISTOGRAMI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Le te llogaritet dhe te shfaqim Histogramin
[handles.pixelCount, handles.grayLevels] = imhist(handles.grayImage1);
bar(handles.pixelCount,'Parent',handles.axes2);
axes(handles.axes2);
xlim([0 handles.grayLevels(end)]); % shkalla ne boshtin x ne forme manuale.
guidata(hObject,handles);

% --- Executes on button press in FOTO_BINAR.
function FOTO_BINAR_Callback(hObject, eventdata, handles)
% hObject    handle to FOTO_BINAR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Fill holes

handles.binaryImage = handles.grayImage1 < 250;
imshow(handles.binaryImage,'Parent',handles.axes5);

% plotesimi i vrimave
% po ashtu bwconvhull llogarit konveksin e te gjitha objekteve ne BW
% por ne ne kete rast kemi marre me objects dhe me numrin 4
% ku 4 eshte dy- dimensional qe lidhet me 4 fqinje
% dhe objects eshte lidhje e deshiruar 
% ku perdoret per percaktimin e objekteve individuale


binaryImage1 = bwconvhull(handles.binaryImage, 'objects', 4)

% Te hjek piskellat me te vogla se 1000 pixels.

binaryImage2 = bwareaopen(binaryImage1, 1000);
handles.b=binaryImage2
guidata(hObject,handles);

% --- Executes on button press in MBLIDH_PARATE.
function MBLIDH_PARATE_Callback(hObject, eventdata, handles)
% hObject    handle to MBLIDH_PARATE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% etiketimi I imazhit perms bwlabel(handles.LabeledImage).
[handles.LabeledImage, handles.numberOfCoins]=bwlabel(handles.b);
% measurements(matja) behet permes qendres se siperfaqes
measurements = regionprops(handles.LabeledImage,'Area','Centroid');
% printimi I siperfaqes.

allAreas = [measurements.Area]
imshow(handles.grayImage1,'Parent',handles.axes6);   
axes(handles.axes6);

% totali eshte ne fillim 0
% por me futjen e vlerave te reja ne fund ndryshon 

total=0.0;

% unaza permes numrimit dhe etiketimin e monedhave
for n=1:size(measurements,1)
	centroid = measurements(n).Centroid;
	X=centroid(1);
	Y=centroid(2);
	if measurements(n).Area >= 10136  
		text(X-10,Y,'2 euro','Color','black','FontSize',14);
		total=total+2.0
    elseif measurements(n).Area >= 9312
		text(X-10,Y,'50 cent','Color','black','FontSize',14);
		total=total+0.50
    
    elseif measurements(n).Area >= 8315
		text(X-10,Y,'1 euro','Color','black','FontSize',14);
		total=total+1.0
        
     elseif measurements(n).Area >= 6905
         if measurements(n).Area >= 6906
             text(X-10,Y,'20 cent','Color','black','FontSize',14);
             total=total+0.20
         else
             text(X-10,Y,'5 cent','Color','black','FontSize',14);
             total=total+0.05
         end
    elseif measurements(n).Area > 5941
		text(X-10,Y,'10 cent','Color','black','FontSize',14);
		total=total+0.10
    elseif measurements(n).Area > 5370
		text(X-10,Y,'2 cent','Color','black','FontSize',14);
		total=total+0.02
	else
		total=total+0.01;
		text(X-10,Y,'1 cent','Color','black','FontSize',14);
	end
end
number = n
euro = total
hold on

set(handles.text3,'string',euro);
set(handles.text6,'string',number);
guidata(hObject,handles);


% --- Executes on button press in FOTO_ORIGJINALE.
function FOTO_ORIGJINALE_Callback(hObject, eventdata, handles)
% hObject    handle to FOTO_ORIGJINALE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

imshow(handles.grayImage,'Parent',handles.axes9)
axes(handles.axes9);

% --- Executes on button press in PERMASAT_E_FOTOS.
function PERMASAT_E_FOTOS_Callback(hObject, eventdata, handles)
% hObject    handle to PERMASAT_E_FOTOS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%PERMASAT E FOTOS
[height,width,d]=size(handles.grayImage)
set(handles.text7,'string',height);
set(handles.text8,'string',width);



% --- Executes on button press in MBYLL_PROGRAMIN.
function MBYLL_PROGRAMIN_Callback(hObject, eventdata, handles)
% hObject    handle to MBYLL_PROGRAMIN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;    % fshirja e komandes
close all;  % i mbyll te gjitha figurat
