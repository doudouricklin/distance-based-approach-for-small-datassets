function [VS_IMTD,VS_IMTD_Class,VS_MTD,VS_MTD_Class]=VSG(inputdata,class_vs_size)

%clc
%clear

%inputdata=[1 5 1;1 5 1;1 5 1; 2 4 2; 2 2 2; 2 3 2];
%class_vs_size=2;
[row,column]=size(inputdata);
FeedingS_Class=inputdata(:,column);
FeedingS_attr=inputdata(:,1:(column-1));

%MTD%
VS_MTD=[];

for i=1:(column-1)
	add_mtd_vir_sample=[];
	for j=1:max(FeedingS_Class)    
        mtd_vir_sample=[];
		data=[];
		data=FeedingS_attr(FeedingS_Class(:)==j,i);
		core_MTD=(max(data)+min(data))/2;
        tempNL_MTD=find(data<core_MTD >0);
        tempNU_MTD=find(data>core_MTD >0);        
		NL_MTD=length(tempNL_MTD);
		NU_MTD=length(tempNU_MTD);
        SkewL_MTD=NL_MTD/(NL_MTD+NU_MTD);
        SkewU_MTD=NU_MTD/(NL_MTD+NU_MTD);		
		
		data_std=std(data);
		data_var=data_std^2;
		
		if NL_MTD==0
            L_MTD=core_MTD/5;
        else
            L_MTD=core_MTD-SkewL_MTD*((-2*(data_var/NL_MTD)*log(10^(-20)))^0.5);
        end
		
		if NU_MTD==0
            U_MTD=core_MTD*5;
        else
            U_MTD=core_MTD+SkewU_MTD*((-2*(data_var/NU_MTD)*log(10^(-20)))^0.5);
        end
		
		if NL_MTD==0 && NU_MTD==0
			L_MTD=core_MTD/5;
			U_MTD=core_MTD*5;
		end		
		%disp('start')
		%tempNL_MTD
		%tempNU_MTD
		%NL_MTD
		%NU_MTD
		%SkewL_MTD
		%SkewU_MTD
		%L_MTD
		%U_MTD
		mtd_vir_sample=L_MTD+(U_MTD-L_MTD)*rand(class_vs_size,1);
		add_mtd_vir_sample=[add_mtd_vir_sample;mtd_vir_sample];
		
	end
	VS_MTD(:,i)=add_mtd_vir_sample;	
end

VS_MTD_Class=[];
for j=1:max(FeedingS_Class)
	VS_MTD_Class=[VS_MTD_Class;j*ones(class_vs_size,1)];
end

%MTD%


VS_IMTD=[];

%IMTD%    
for i=1:(column-1)
	add_vir_sample=[];
	for j=1:max(FeedingS_Class)
		vir_sample=[];
		data=[];
		data=FeedingS_attr(FeedingS_Class(:)==j,i);
		%CV=abs(std(data)/mean(data));
		CV_std=std(data);
		CV=abs(CV_std);
		%CV=CV_std^2;			
		[M,F,C] = mode(data);
		
		if F==1			
			%core=median;
			core=(max(data)+min(data))/2;
			%core=median(data);
			tempL=find(data<core >0);
			tempU=find(data>core >0);
			tempGL=data(tempL);
			tempGU=data(tempU);
			GL_num=length(tempGL);
			GU_num=length(tempGU);
			GL=sum(abs(core-tempGL));
			GU=sum(abs(tempGU-core));
			SkewL_G=GL/(GL+GU);
			SkewU_G=GU/(GL+GU);
			
			if GL==0
				%ak=core/5;				
				ak=core;
				
			else
				ak=core-SkewL_G*((-2*(CV/GL)*log(10^(-20)))^0.5);
			end
			
			if GU==0
				%bk=core*5;								
				bk=core;
			else
				bk=core+SkewU_G*((-2*(CV/GU)*log(10^(-20)))^0.5);
			end		
			
			if GL==0 && GU==0
				%ak=core/5;
				%bk=core*5;								
				ak=core;
				bk=core;
			end
			
			vir_sample = ak + (bk-ak)*rand(class_vs_size,1);
		end
		
		
		if F~=1
			if length(C{1})==3				
				%core=mode;
				for p=1:3
					core=C{1}(p);
					tempL=find(data<core >0);
					tempU=find(data>core >0);
					tempGL=data(tempL);
					tempGU=data(tempU);
					GL_num=length(tempGL);
					GU_num=length(tempGU);
					GL=sum(abs(core-tempGL));
					GU=sum(abs(tempGU-core));
					SkewL_G=GL/(GL+GU);
					SkewU_G=GU/(GL+GU);
					if GL==0
						%ak(p)=core/5;
						ak(p)=core;
					else
						ak(p)=core-SkewL_G*((-2*(CV/GL)*log(10^(-20)))^0.5);
					end
					if GU==0
						%bk(p)=core*5;
						bk(p)=core;
					else
						bk(p)=core+SkewU_G*((-2*(CV/GU)*log(10^(-20)))^0.5);
					end
					
					if GL==0 && GU==0
						%ak(p)=core/5;
						%bk(p)=core*5;
						ak(p)=core;
						bk(p)=core;
					end					
					
				end
				class_vs_size1=round(class_vs_size/3);
				class_vs_size2=round(class_vs_size/3);
				class_vs_size3=class_vs_size-class_vs_size1-class_vs_size2;
				vir_sample1 = ak(1) + (bk(1)-ak(1))*rand(class_vs_size1,1);
				vir_sample2 = ak(2) + (bk(2)-ak(2))*rand(class_vs_size2,1);
				vir_sample3 = ak(3) + (bk(3)-ak(3))*rand(class_vs_size3,1);
				
				vir_sample=[vir_sample1;vir_sample2;vir_sample3];
				
			elseif length(C{1})==2			
				for p=1:2
					core=C{1}(p);
					tempL=find(data<core >0);
					tempU=find(data>core >0);
					tempGL=data(tempL);
					tempGU=data(tempU);
					GL_num=length(tempGL);
					GU_num=length(tempGU);
					GL=sum(abs(core-tempGL));
					GU=sum(abs(tempGU-core));
					SkewL_G=GL/(GL+GU);
					SkewU_G=GU/(GL+GU);
					if GL==0
						%ak(p)=core/5;
						ak(p)=core;
					else
						ak(p)=core-SkewL_G*((-2*(CV/GL)*log(10^(-20)))^0.5);
					end
					if GU==0
						%bk(p)=core*5;
						bk(p)=core;
					else
						bk(p)=core+SkewU_G*((-2*(CV/GU)*log(10^(-20)))^0.5);
					end

					if GL==0 && GU==0
						%ak(p)=core/5;
						%bk(p)=core*5;
						ak(p)=core;
						bk(p)=core;
					end		
					
				end
				class_vs_size1=round(class_vs_size/2);
				class_vs_size2=class_vs_size-class_vs_size1;
				vir_sample1 = ak(1) + (bk(1)-ak(1))*rand(class_vs_size1,1);
				vir_sample2 = ak(2) + (bk(2)-ak(2))*rand(class_vs_size2,1);
				
				vir_sample=[vir_sample1;vir_sample2];
				
			else				
				%core=mode
				core=C{1}(1);
				tempL=find(data<core >0);
				tempU=find(data>core >0);
				tempGL=data(tempL);
				tempGU=data(tempU);
				GL_num=length(tempGL);
				GU_num=length(tempGU);
				GL=sum(abs(core-tempGL));
				GU=sum(abs(tempGU-core));
				SkewL_G=GL/(GL+GU);
				SkewU_G=GU/(GL+GU);
				
				if GL==0
					%ak=core/5;
					ak=core;
				else
					ak=core-SkewL_G*((-2*(CV/GL)*log(10^(-20)))^0.5);
				end
				
				if GU==0
					%bk=core*5;
					bk=core;
				else
					bk=core+SkewU_G*((-2*(CV/GU)*log(10^(-20)))^0.5);
				end
								
				if GL==0 && GU==0
					%ak=core/5;
					%bk=core*5;
					ak=core;
					bk=core;
				end		
				
				vir_sample = ak + (bk-ak)*rand(class_vs_size,1);				
			end					
		
		end
		%disp('start')
		%tempL
		%tempU
		%tempGL		
		%tempGU
		%GL_num
		%GU_num
		%GL
		%GU
		%SkewL_G
		%SkewU_G
		add_vir_sample=[add_vir_sample;vir_sample];
		
	end
	VS_IMTD(:,i)=add_vir_sample;	
end

VS_IMTD_Class=[];
for j=1:max(FeedingS_Class)
	VS_IMTD_Class=[VS_IMTD_Class;j*ones(class_vs_size,1)];
end

%IMTD%
