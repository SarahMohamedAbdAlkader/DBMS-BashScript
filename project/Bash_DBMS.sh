#!/usr/bin/bash
function mainMenu
{

echo "Please, Enter your choice: "
options=("create Database" "List Databases" "Connect To Databases" "Drop Database" "Exit");
select choice in  "${options[@]}"
do
case $choice in
"create Database")
echo "createDB"
createDataBase;
break;
;;
"List Databases")
echo "List DBs: "
#  ls ./DataBases

  if [ -z "$(ls -A ./DataBases)" ]; 
		then
			echo "There Is No Database To Be Listed";
			mainMenu;

else
	echo "This Is List With Available Databases : ";
	i=1;
	for DB in `ls ./DataBases`
	do
		DBArray[$i]=$DB;
		echo $i") "$DB;
		let i=i+1;
	done
fi
mainMenu
break;
;;
"Connect To Databases")
echo " Your DataBases are : `ls ./DataBases`"
echo "Enter Database name you want to be connected to:"
read dBName
if [ ! -d   ./DataBases/$dBName ]
then
echo "This is dB doen't exist"
else
pwd
echo "Connect to $dBName"
dBOptions=("create Table" "List Tables" "Drop Table" "Insert Into Table" "Select From Table" "Delete From Table" "Back To Main Menu" "Exit")
PS3="Enter YOUR choice : " ;
flag2=1;
while ( test $flag2 -eq 1 )
do
select choice in "${dBOptions[@]}"
do
case $choice in
"create Table")
 echo "create table is in progress"
createTable
break;
;;
"List Tables")
 echo "List Tables is in progress";
listTables;
 break; ;;
"Drop Table")
echo "your tables are"
ls -d ./DataBases/$dBName
 echo "Drop Table is in progress"
 echo "enter table name"
read tname
if [ ! -d   ./DataBases/$dBName/$tname.csv ]
then
rm  ./DataBases/$dBName/$tname.csv
rm  ./DataBases/$dBName/$tname.meta
echo "Done"
else 
echo "This tabel does not exist"
fi
 break; ;;
"Insert Into Table")
 echo "Insert Into Table is in progress"
 echo "Your Tables are: "
 ls -a ./DataBases/$dBName
 insertRaw
 break;
 ;;
"Select From Table")
echo "YOUr Tables Are"
ls -a ./DataBases/$dBName
 echo "Select From table is in progress"
 echo "enter table name"
read  tname
echo "*******************************************"
 cat ./DataBases/$dBName/$tname.csv | more | column -t -s ","
 echo "Enter value that you want to search:"
read value
grep -w "$value" ./DataBases/$dBName/$tname.csv
break;
 ;;
"Delete From Table")
 echo "Delete From Table is in progress"
  echo "enter table name"
read  tname
 echo "Enter PrimaryKeyvalue that you want to delete its record:"
read value
 egrep -v "$value|EXPDTA" ./DataBases/$dBName/$tname.csv > ./DataBases/$dBName/$tname
 mv ./DataBases/$dBName/$tname ./DataBases/$dBName/$tname.csv
# grep -w "$value" ./DataBases/$dBName/$tname.csv | xargs rm -f >> ./DataBases/$dBName/$tableName.csv;
 break;
 ;;
 "Back To Main Menu") echo "Bye"
mainMenu
break;
;;
"Exit")
 exit -1;
 break;;

esac
done
done
break;
fi
;;
"Drop Database")
for DB in `ls ./DataBases`
	do
		DBArray[$i]=$DB;
		let i=i+1;
	done
  if [[ ${#DBArray[@]} -eq 0 ]]; 
		then
			echo "There Is No Database To Be Listed";
			mainMenu;
	else

	echo "This Is List With Available Databases : ";
	i=1;
	for DB in `ls ./DataBases`
	do
		DBArray[$i]=$DB;
		echo $i") "$DB;
		let i=i+1;
	done
	echo "${DBARR[@]}";
  read -p "Choose Database You Want To Drop  : " choise ;
  rm -r ./DataBases/${DBArray[$choise]};
  fi
break;
;;
"Exit")
echo "exit"
flag=0;
break;

esac
done
}
function createDataBase
{
echo "Enter Database Name:"
read dBName
echo $dBName
if test -z "$dBName"
then
    echo "please enter valid DB name";
else
if [ -d ./DataBases/$dBName ]
then echo "This Database exists.";
else
    mkdir ./DataBases/$dBName;
echo "YOUR Database Created Successfully!"
fi
fi
}
function createTable
{
read -p "Enter Table Name : " tableName ;
if [[ ! -e ./DataBases/$dBName/$tableName ]] && [[ $tableName != "" ]]
		then	
echo "$dBName"
touch ./DataBases/$dBName/$tableName.csv;
touch ./DataBases/$dBName/$tableName.meta;
chmod +x ./DataBases/$dBName/$tableName.meta;
chmod +x ./DataBases/$dBName/$tableName.csv;

echo "*****$tableName Meta Data ****" >./DataBases/$dBName/$tableName.meta;
 echo "Table Name:$tableName " >> ./DataBases/$dBName/$tableName.meta;
 echo "Enter The Number Of Columns : "
read  tableColumns
 echo "The Number Of Columns Is: $tableColumns" >> ./DataBases/$dBName/$tableName.meta;
for (( i = 1; i <= tableColumns ; i++ )); do
read -p "Enter Name Of Column [$i] : " ColName ;
echo   "Column[$i]: $ColName" >> ./DataBases/$dBName/$tableName.meta ;
columnsArray[$i]=$ColName 
select columnType in String  Integer
do
case $columnType in
 "String")
echo  "Column Type is:String" >>  ./DataBases/$dBName/$tableName.meta;
break ;      		
;;
"Integer")
echo "Column Type is :Integer" >> $ ./DataBases/$dBName/$tableName.meta;
break ;
;;
*)	
echo "You Must Choose The Column Data Type"
esac
done
done
  colArrIndex=1 
		       echo "***********" >> ./DataBases/$dBName/$tableName.meta;  
 while [ $colArrIndex -le $tableColumns ]
      do
     if [ $colArrIndex -eq $tableColumns ]
       then echo -e "${columnsArray[colArrIndex]}" >> ./DataBases/$dBName/$tableName.csv;          else 
    echo -n "${columnsArray[colArrIndex]}," >> ./DataBases/$dBName/$tableName.csv;
    fi 		       
colArrIndex=$((colArrIndex+1));
 done
echo $tableName" Done";
else 
    echo "This Table exists"
fi
}
function listTables
{
if [ -z "$(ls -A ./DataBases/$dBName)" ]; then
   echo "Empty"
else
   echo "Not Empty"
   ls -a  ./DataBases/$dBName
fi
}

function insertRaw
{

read -p "enter table name : " tableName 
if [ ! -d ./DataBases/$dBName ]
  then
    echo "this name does not exist,please try again"
    insertRaw
  else 
  
      tableData="./DataBases/$dBName/$tableName.csv"
    tableMeta="./DataBases/$dBName/$tableName.meta"
 
  echo "This exists"
  DataNum=$(cat $tableData | wc -l)
  echo "$DataNum"
   record=""
noCols=$((`awk -F: '{if (NR == 3) print $2 }' $tableMeta`));
echo "Number of columns: $noCols"
pkVal=$((noCols+2))
pkVal=`cut -f2 -d: $tableMeta | head -$pkVal  | tail -1 `  
echo "Primary key column is : $pkVal"
for (( i = 1; i <= noCols ; i++ )); do

 colType=$( grep -n "Type" $tableMeta | cut  -d':' -f 3)
# i=1
#         for col in $colType
#         do
#             colName=$(echo $col | cut -d':' -f 1)
#            colsArray[$i]=$col;
#            echo $i") "$col;
		  
# if [ "$col" == "String" ]
#  then 
#  stringRegex='^[]0-9a-zA-Z,!^`@{}=().;/~_[:space:]|[-]+$'
# read -p "Enter value of Column [$i] : " ColValue 
#  if [[ $ColValue  == $stringRegex ]]
#  then
#                                 echo "please enter a string value"
#                                 read -p "Enter value of Column [$i] : " ColValue 
                            
#      fi                   
# echo "string"
# else 
#  read -p "Enter value of Column [$i] : " ColValue
#  echo "Integer" 
# fi
#            let i=i+1
#         done

 read -p "Enter value of Column [$i] : " ColValue 
record+=$ColValue:
done
sed -i ''$DataNum' a '$record'' ./DataBases/$dBName/$tableName.csv
sed -i 's/:/ , /g' ./DataBases/$dBName/$tableName.csv
  fi

}


flag=1;
while ( test $flag -eq 1 )
do
PS3="Enter YOUR Choice: "
mainMenu
done
