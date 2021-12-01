load mri;
figure(1)
montage (D,map) %D=dimesion %montage(permite hacer montaje de imagenes)
title('Horizontal Slices')

%Plano Sagital
M1=D(:,64,:,:); %arreglo donde disminuyo a la mitad el tamaño del plano y a la mitad 
size(M1)
M2=reshape(M1,[128 27]); %aqui es donde se le da la resolucion al resultado y al ser 27 valores, queda muy pequeña la resolucion
size(M2)
figure(2)
imshow(M2,map)
title('Sagittal - Raw Data')

figure(3)
imagen1=D(:,:,1,15);
imhist(imagen1)
J=histeq(imagen1);
imshowpair(imagen1,J,'montage')
title('Sagittal - Matriz 15 - Ecualizacion') %se encarga de transformar la escala de grises y lo vuelve plano

figure(4)
BW2=edge(imagen1,'canny'); 
imshow(BW2)
title('Sagittal - Matriz 15 - Canny') 

figure(5)
BW2=edge(imagen1,'prewitt'); 
imshow(BW2)
title('Sagittal - Matriz 15 - Prewitt')

figure(6)
BW2=edge(imagen1,'roberts');
imshow(BW2)
title('Sagittal - Matriz 15 - Roberts')

%Las funciones para detectar los bordes pueden ser;
%Canny:utiliza dos umbrales para detectar bordes fuertes y débiles, no es
%tan probable que sus resultados se vean afectados por el ruido como
%otros metodos.
%Prewitt:se encarga de encontrar los bordes donde el gradiente es maximo,
%utilizando la derivada aproximada de Prewitt
%Roberts:se encarga de encontrar los bordes donde el gradiente es maximo,
%utilizanfo la derivada aproximada de Roberts

figure(7)
BW=imbinarize(imagen1,'adaptive','ForegroundPolarity','dark','Sensitivity',0.2); %el 0.4 es un valor que debe estar siempre entre 0 y 1, es el numero de pixeles que tendra la imagen
imshow(BW)
title('Sagittal - Matriz 15 - Binarizacion') %se encarga de modificar la escala de grises sometiendo la imagen a mas luz

%Plano Coronal
M3=D(64,:,:,:); %arreglo donde disminuyo a la mitad el tamaño del plano x a la mitad
size(M3)
M4=reshape(M3,[128 27]);
size(M4)
figure(8)
imshow(M4,map)
title('Coronal - Raw Data')

T0=maketform('affine',[0 -2.5; 1 0; 0 0]);
R2=makeresampler({'cubic', 'nearest'},'fill');
M5=imtransform(M2,T0,R2);
figure(9)
imshow(M5,map)
title('Sagittal - IMTRANSFORM')

T1=maketform('affine',[-2.5 0; 0 1; 68.5 0]);
inverseFcn=@(X,t) [X repmat(t.tdata,[size(X,1) 1])];
T2=maketform('custom',3,2,[],inverseFcn,64);
Tc=maketform('composite',T1,T2);
R3=makeresampler({'cubic','nearest','nearest'},'fill');
M6=tformarray(D,Tc,R3,[4 1 2],[1 2],[66 128],[],0);
figure(10)
imshow(M6,map)
title('Sagittal - TFORMARRAY')

T3=maketform('affine',[-2.5 0 0; 0 1 0; 0 0 0.5; 68.5 0 -14]);
S=tformarray(D,T3,R3,[4 1 2],[1 2 4],[66 128 35],[],0);
S2=padarray(S,[6 0 0 0],0,'both');
figure(11)
montage(S2,map)
title('Sagittal Slices')

%Plano Coronal
T4=maketform('affine',[-2.5 0 0; 0 1 0; 0 0 -0.5; 68.5 0 61]);
C=tformarray(D,T4,R3,[4 2 1],[1 2 4],[66 128 45],[],0); %mi total de matrices es de 45
C2=padarray(C,[6 0 0 0],0,'both');
figure(12)
montage(C2,map)
title('Coronal Slices')

figure(13)
imagen2=C2(:,:,1,30)
imshow(imagen2)
J=histeq(imagen2);
imshowpair(imagen2,J,'montage')
title('Coronal - Matriz 30 - Ecualizacion')

figure(14)
BW2=edge(imagen2,'canny'); 
imshow(BW2)
title('Coronal - Matriz 30 - Canny') 

figure(15)
BW2=edge(imagen2,'prewitt'); 
imshow(BW2)
title('Coronal - Matriz 30 - Prewitt')

figure(16)
BW2=edge(imagen2,'roberts');
imshow(BW2)
title('Coronal - Matriz 30 - Roberts')

figure(17)
BW=imbinarize(imagen2,'adaptive','ForegroundPolarity','dark','Sensitivity',0.8); %el 0.4 es un valor que debe estar siempre entre 0 y 1, es el numero de pixeles que tendra la imagen
imshow(BW)
title('Coronal - Matriz 30 - Binarizacion')