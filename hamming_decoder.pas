//Copyright 2017 Andrey S. Ionisyan (anserion@gmail.com)
//
//Licensed under the Apache License, Version 2.0 (the "License");
//you may not use this file except in compliance with the License.
//You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//Unless required by applicable law or agreed to in writing, software
//distributed under the License is distributed on an "AS IS" BASIS,
//WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//See the License for the specific language governing permissions and
//limitations under the License.

//учебный шаблон расшифровки помехоустойчивого кода Хэмминга
//(с нарезкой на блоки)
 
program hamming;
const max_m=16; //максимальное число контрольных битов (шаблон учебный)
var
   s:string; //результат (входное сообщение в двоичном коде)
   ss:string; //блок из сообщения s
   c:string; //двоичный код Хэмминга
   cc:string; //блок результата
   n:integer; //длина блока сообщения
   m:integer; //количество контрольных битов для блока сообщения
   b:array[1..max_m]of integer; //контрольные биты   
   w:integer; //вектор ошибки (номер ошибочного бита)
   i,j,k,r,blocks_num,align_c:integer; //вспомогательные переменные
   cc_tmp,cc_tmp2:string; //вспомогательная переменная
   
begin
   //ввод сообщения
   writeln('Decode Hamming code');
   write('c='); readln(c);
   write('block_size='); readln(n);
   
   //выравнивание входного кода путем добавления нулей слева
   align_c:=n-(length(c) mod n);
   if align_c=n then align_c:=0;
   for i:=1 to align_c do c:='0'+c;
   blocks_num:=length(c) div n;

   //печать выровненного входного бинарного кода
   writeln('===========================');
   writeln('add ',align_c,' zero bits to S');
   for i:=1 to length(c) do
   begin
      write(c[i]);
      if (i mod n)=0 then write(' ');
   end;
   writeln;
   writeln('===========================');
      
   //определяем количество контрольных битов в блоке
   k:=1; m:=0;
   while k<n do
   begin
      k:=k*2;
      m:=m+1;
   end;
   //вывод количества контрольных битов
   writeln('Number of control bits: m=',m);
   writeln;

   //поблочно анализируем код Хэмминга
   s:='';
   for i:=1 to blocks_num do
   begin
      //вырезаем n бит из кода Хэмминга (формируем блок)
      cc:='';
      for j:=1 to n do cc:=cc+c[(i-1)*n+j];

      //пересчитываем контрольные биты кода Хэмминга
      k:=1;
      for r:=1 to m do
      begin
         b[r]:=0;
         for j:=1 to n do
            if (j and k)=k then
               if cc[j]='1' then 
                  if b[r]=0 then b[r]:=1 else b[r]:=0;
         k:=k*2;
      end;
      //вычисляем вектор ошибки (номер неправильного бита в блоке)
      w:=0; for j:=m downto 1 do w:=w*2+b[j];
      //инвертитуем неправильный бит
      //если w=0, то ошибки не было
      cc_tmp:=cc;
      if w<>0 then if cc[w]='1' then cc[w]:='0' else cc[w]:='1';
      //извлекаем из блока кода Хэмминга блок сообщения
      cc_tmp2:=cc;
      k:=1; for j:=1 to m do begin cc[k]:='b'; k:=k*2; end;
      ss:=''; for j:=1 to n do if cc[j]<>'b' then ss:=ss+cc[j];
      cc:=cc_tmp2;
      
      //наращивание окончательного ответа
      s:=s+ss;
      //печать промежуточного результата
      writeln('block',i:3,': c_in=',cc_tmp,'   c=',cc,'    s=',ss);
      //печатаем контрольные биты
      write('control bits: ');
      k:=1; for j:=1 to m do begin write('c',k,'=',b[j],' '); k:=k*2; end;
      writeln;
      writeln('Hamming error position = ',w);
      writeln;
   end;

   //печатаем исправленное сообщение
   writeln('==============================');
   writeln('Decode message:');
   writeln(s);

   //"отрезаем" нули и одну единицу слева от декдированного ответа
   //для извлечения исходного сообщения
   j:=1; while s[j]='0' do j:=j+1;
   j:=j+1; ss:=s; s:='';
   for i:=j to length(ss) do s:=s+ss[i];   
   //печатаем извлеченное из кода Хэмминга сообщение
   writeln('==============================');
   writeln('Original message:');
   writeln('length of binary code block: ',n-m);
   writeln(s);
end.
