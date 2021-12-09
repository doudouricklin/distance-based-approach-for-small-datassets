
% 分割資料依據不同類別
function [pattern1,pattern2,pattern3,pattern4] = cut_class_data(pattern)

s_size = length(pattern(:,1));
class_locat = length(pattern(1,:));
class = max(pattern(:,class_locat));

kk1=0;kk2=0;kk3=0;kk4=0;
pattern1=[];pattern2=[];pattern3=[];pattern4=[];

switch class
    
    case {2}
        for kk=1:s_size        
            switch pattern(kk,class_locat)
                case {1}
                    kk1=kk1+1;
                    pattern1(kk1,1:class_locat)=pattern(kk,1:class_locat);                    
                    
                case {2}
                    kk2=kk2+1;
                    pattern2(kk2,1:class_locat)=pattern(kk,1:class_locat);                    
                    
            end
        end
        
    case {3}
        for kk=1:s_size
               switch pattern(kk,class_locat)
                   case {1}
                       kk1=kk1+1;
                       pattern1(kk1,1:class_locat)=pattern(kk,1:class_locat);
                       
                   case {2}
                       kk2=kk2+1;
                       pattern2(kk2,1:class_locat)=pattern(kk,1:class_locat);
                       
                   case {3}
                       kk3=kk3+1;
                       pattern3(kk3,1:class_locat)=pattern(kk,1:class_locat);                       
                       
               end
        end
    case {4}
        for kk=1:s_size
               switch pattern(kk,class_locat)
                   case {1}
                       kk1=kk1+1;
                       pattern1(kk1,1:class_locat)=pattern(kk,1:class_locat);
                       
                   case {2}
                       kk2=kk2+1;
                       pattern2(kk2,1:class_locat)=pattern(kk,1:class_locat);
                       
                   case {3}
                       kk3=kk3+1;
                       pattern3(kk3,1:class_locat)=pattern(kk,1:class_locat);                       
                       
                   case {4}
                       kk4=kk4+1;
                       pattern4(kk4,1:class_locat)=pattern(kk,1:class_locat);                       
                       
               end
        end
end

