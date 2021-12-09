
clc
clear%主程式
%資料集: CF dqc servoR concrete yh concreteSlump1
data=load('BC.txt'); %載資料
[row,column]=size(data);
exp_times=30; 					% 實驗次數
class = max(data(:,end));       % 類別數    

% 將各類別的 data 分割出來----------------------
	if class==2
		[pattern1,pattern2] = cut_class_data(data);  	
		pattern1_size = length(pattern1(:,1));          % class1 的樣本數
		pattern2_size = length(pattern2(:,1));          % class2 的樣本數
		rate_pattern1 = pattern1_size/row;        		% class1 所佔比例
		rate_pattern2 = pattern2_size/row;        		% class2 所佔比例
		
	elseif class==3
		[pattern1,pattern2,pattern3] = cut_class_data(data);  
		pattern1_size = length(pattern1(:,1));          % class1 的樣本數
		pattern2_size = length(pattern2(:,1));          % class2 的樣本數
		pattern3_size = length(pattern3(:,1));          % class3 的樣本數
		rate_pattern1 = pattern1_size/row;        		% class1 所佔比例
		rate_pattern2 = pattern2_size/row;        		% class2 所佔比例
		rate_pattern3 = pattern3_size/row;        		% class3 所佔比例
	
	end	

for tt=1:1
	%train_size=tt*3;						% 訓練資料筆數	10,10,100
	train_size=16;						% 訓練資料筆數	10,10,100
	test_data_size=row-train_size;  		% 測試資料筆數
	vs_size=round((train_size/2)/class);   % 虛擬樣本數量
	%vs_size=round(100/class);       		% 虛擬樣本數量 取100則t-test容易不顯著
	
	for aa=1:exp_times 
		% training data 選出的方式--每個類別資料個數照比例rate_pattern1,rate_pattern2,...抽取
		if class==2	
			train_size1 = round(rate_pattern1*train_size);
			train_size2 = train_size-train_size1;
			TRS1=[];
			TRS2=[];
			TRS1_Attr=[];
			TRS2_Attr=[];
			TRS1=randi(pattern1_size,1,train_size1);
			TRS2=randi(pattern2_size,1,train_size2);
			for i=1:train_size1
				TRS1_Class(i)=pattern1(TRS1(i),column); 	% 取出train_size1的class
				TRS1_Attr(i,:)=pattern1(TRS1(i),1:(column-1)); 
			end
			for i=1:train_size2
				TRS2_Class(i)=pattern2(TRS2(i),column); 	% 取出train_size2的class
				TRS2_Attr(i,:)=pattern2(TRS2(i),1:(column-1));
			end
		
			TRS1data=[TRS1_Attr TRS1_Class'];
			TRS2data=[TRS2_Attr TRS2_Class'];
			TRS_data=[TRS1data;TRS2data];
			
			pattern1(TRS1,:)=[];
			TES1data=pattern1;	
			pattern2(TRS2,:)=[];
			TES2data=pattern2;		
		
			TES_data=[TES1data;TES2data];
			pattern1=[pattern1;TRS1data];
			pattern2=[pattern2;TRS2data];	
		elseif class==3
			train_size1 = round(rate_pattern1*train_size);
			train_size2 = round(rate_pattern2*train_size);
			train_size3 = train_size-train_size1-train_size2;	
			TRS1=[];
			TRS2=[];
			TRS3=[];
			TRS1_Attr=[];
			TRS2_Attr=[];
			TRS3_Attr=[];
			TRS1=randi(pattern1_size,1,train_size1);
			TRS2=randi(pattern2_size,1,train_size2);
			TRS3=randi(pattern3_size,1,train_size3);
		
			for i=1:train_size1
				TRS1_Class(i)=pattern1(TRS1(i),column); % 取出train_size1的class
				TRS1_Attr(i,:)=pattern1(TRS1(i),1:(column-1)); 
			end	
			for i=1:train_size2
				TRS2_Class(i)=pattern2(TRS2(i),column); % 取出train_size2的class
				TRS2_Attr(i,:)=pattern2(TRS2(i),1:(column-1));
			end	
			for i=1:train_size3
				TRS3_Class(i)=pattern3(TRS3(i),column); % 取出train_size3的class
				TRS3_Attr(i,:)=pattern3(TRS3(i),1:(column-1));
			end
		
			TRS1data=[TRS1_Attr TRS1_Class'];
			TRS2data=[TRS2_Attr TRS2_Class'];
			TRS3data=[TRS3_Attr TRS3_Class'];
			TRS_data=[TRS1data;TRS2data;TRS3data];
		
			pattern1(TRS1,:)=[];
			TES1data=pattern1;
			pattern2(TRS2,:)=[];
			TES2data=pattern2;		
			pattern3(TRS3,:)=[];
			TES3data=pattern3;		
			TES_data=[TES1data;TES2data;TES3data];
			pattern1=[pattern1;TRS1data];
			pattern2=[pattern2;TRS2data];
			pattern3=[pattern3;TRS3data];
		end
		
		VS_IMTD=[];
		VS_IMTD_Class=[];
		VS_MTD=[];
		VS_MTD_Class=[];
		
		[VS_IMTD,VS_IMTD_Class,VS_MTD,VS_MTD_Class]=VSG(TRS_data,vs_size);
    
		TRS_data_input=TRS_data(:,1:(column-1));
		TRS_data_output=TRS_data(:,column);
	
		VStest_input=TES_data(:,1:(column-1));
		VStest_output=TES_data(:,column);
    		
		NEW_VS_MTD=[TRS_data_input;VS_MTD];
		NEW_VS_IMTD=[TRS_data_input;VS_IMTD];
		
		NEW_VS_MTD_Class=[TRS_data_output;VS_MTD_Class];
		NEW_VS_IMTD_Class=[TRS_data_output;VS_IMTD_Class];
		
		%[acc_BPN]=BPN(TRS_data_input',TRS_data_output',VStest_input',VStest_output');    
		[acc_MTD]=BPN(NEW_VS_MTD',NEW_VS_MTD_Class',VStest_input',VStest_output');
		[acc_IMTD]=BPN(NEW_VS_IMTD',NEW_VS_IMTD_Class',VStest_input',VStest_output');
		
		%ACC_BPN(aa)=acc_BPN;
		ACC_MTD(aa)=acc_MTD;
		ACC_IMTD(aa)=acc_IMTD;    		
		
	end
	%m_BPN(tt)=mean(ACC_BPN);
	m_MTD(tt)=mean(ACC_MTD);
	m_IMTD(tt)=mean(ACC_IMTD);
		
	%s_BPN(tt)=std(ACC_BPN);
	s_MTD(tt)=std(ACC_MTD);
	s_IMTD(tt)=std(ACC_IMTD);
		
	%[h1(tt),p_value1(tt)] = ttest(ACC_IMTD,ACC_BPN);
	[h2(tt),p_value2(tt)] = ttest(ACC_IMTD,ACC_MTD);
end

%mean_acc=[m_BPN;m_MTD;m_IMTD];
mean_acc=[m_MTD;m_IMTD];
mean_acc=mean_acc'

%std_acc=[s_BPN;s_MTD;s_IMTD];
std_acc=[s_MTD;s_IMTD];
std_acc=std_acc'

%pvalue_acc=[p_value1;p_value2];
pvalue_acc=p_value2;
pvalue_acc=pvalue_acc'