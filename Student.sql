create table Student
(Sid Int,
Sname varchar(255),
Sage date,
Ssex char(1)
);

INSERT INTO Student values (1,'?雷','1990-01-01','男');
INSERT INTO Student values (2,'??','1990-12-21','男');
INSERT INTO Student values (3,'??','1990-12-20','男');
INSERT INTO Student values (4,'李云','1990-12-06','男');
INSERT INTO Student values (5,'周梅','1991-12-01','女');
INSERT INTO Student values (6,'??','1992-01-01','女');
INSERT INTO Student values (7,'?竹','1989-01-01','女');
INSERT INTO Student values (9,'?三','2017-12-20','女');
INSERT INTO Student values (10,'李四','2017-12-25','女');
INSERT INTO Student values (11,'李四','2012-06-06','女');
INSERT INTO Student values (12,'?六','2013-06-13','女');
INSERT INTO Student values (13,'?七','2014-06-01','女');

Select *From Student Where Sname Like '李%';
Select *From Student Where Sname Like '%三%';

Select *From Student Where Sname IN ('?三','王五','李四');


Select *From Student Where Sname Like '李%';
Select *From Student Where Sname Like '%三%';

Select *From Student Where Sname IN ('?三','王五','李四');


//11
select s.sid,s.sname,s.sage,s.ssex,resultfunc.cid
from Student as s
inner join (select * from SC where SC.cid In (1,2,3) and SC.sid <> 1) as resultfunc
on s.sid = resultfunc.sid

//12
select s.sid,s.sname,s.sage,s.ssex
from (select s2.sid,count(*)
      from (select * from SC where SC.sid = 1) as s1
           inner join 
           (select * from SC where SC.sid <>1) as s2
           on s1.cid = s2.cid
           group by s2.sid
           having count(*) = 3) as list
      inner join 
      Student as s
      on s.sid = list.sid

//13
select s.sid,s.sname
from Student as s 
where s.sid not in (
            select SC.sid from Teacher as t 
            inner join 
            Course as c 
            on t.tid = c.tid
            inner join 
            SC as sc
            on c.cid = sc.cid
            where t.tname = '?三')

//14 
select s.sid,s.sname,s.sage,s.ssex,resultAvg.avg
from
(select SC.sid, count(SC.cid)from SC
where SC.score < 60
group by SC.sid
having count(SC.cid) >= 2) as s1
inner join
Student as s
on s.sid = s1.sid
inner join
(select SC.sid,avg(SC.score) as avg from SC
group by SC.sid) as resultAvg
on resultAvg.sid = s.sid 


//15
select distinct s.sid,s.sname,s.sage,s.ssex,s1.score
from
(select * from SC Where SC.score < 60) as s1
inner join 
(select * from SC Where SC.cid = 1) as s2
on s1.cid = s2.cid
inner join 
Student as s
on s1.sid = s.sid           
            
//16
select s.sid,s.sname,s.sage,s.ssex,list1.savg,sc.score
from
(select SC.sid,avg(SC.score) as savg from SC
group by SC.sid
order by savg DESC) as list1
inner join 
SC as sc
on list1.sid = sc.sid
inner join 
Student as s
on list1.sid = s.sid

//17
select *
from

(select sc.cid, Max(sc.score) as maxScore from SC as sc
group by sc.cid) as maxList
inner join 
SC as maxSc
on maxSc.score = maxList.maxScore
inner join 
Student as smax
on smax.sid = maxSc.sid
left join
(select sc.cid, Min(sc.score) as minScore from SC as sc
group by sc.cid) as minList
on maxList.cid = minList.cid
inner join 
SC as minSc
on minSc.score = minList.minScore
inner join 
Student as smin
on smin.sid = minSc.sid
inner join 
(select sc.cid, avg(sc.score) as savg from SC as sc
group by sc.cid) as avg
on avg.cid = maxList.cid

where maxSc.cid = 1

//18 /***************** Select *,Rank()over(Partition By 按??分? Order By 按??排序)From 表名 ****************/

select *,RANK()over(Partition By SC.cid Order By SC.score DESC)
from SC as sc
inner join 
Student as s
on s.sid = sc.sid

//19 
select *,DENSE_RANK()over(Partition By SC.cid Order By SC.score DESC)
from SC as sc
inner join 
Student as s
on s.sid = sc.sid

//20,
select s.sid,s.sname,s.sage,s.ssex,rankList.rank
from
(select sc.sid, sum(sc.score),RANK()over( Order By sum(sc.score) DESC ) as rank
from SC as sc
group by sc.sid) as rankList
inner join 
Student as s
on rankList.sid = s.sid

//21

//22

//23 
select *
from(
select *, RANK()over(Partition By sc.cid Order By sc.score DESC) as rank
from SC as sc) as list
where list.rank in (1,2,3)

//24
select list1.cid ,count(*) from SC as list1
group by list1.cid

//25
select *
from 
(select sc.sid,count(sc.cid) from SC as sc
group by sc.sid
having count(sc.cid) = 2) as list 
inner join 
Student as s
on s.sid = list.sid

//26
select s.ssex,count(*) from Student as s
group by s.ssex

//27
select * from Student as s
where s.sname like '%?%'

//28
select s.sname, count(*) from Student as s
group by s.sname
having count(*) > 1

//29
select s.sid,s.sname,s.sage,s.ssex, EXTRACT(Year from s.sage)
from Student as s
where EXTRACT(Year from s.sage) = 1990

//30
select sc.cid, avg(sc.score) as savg from SC as sc
group by sc.cid
order by savg

//31
select sc.sid, avg(sc.score) as savg from SC as sc
group by sc.sid
having avg(sc.score) > 85

//32
select s.sid,s.sname,s.sage,s.ssex,c.cname,sc.score
from Course as c
inner join SC as sc
on c.cid = sc.cid
inner join Student as s
on s.sid = sc.sid
where c.cname = '数学' and sc.score > 60

//33
select *
from 
SC as sc 
right join
Student as s
on sc.sid = s.sid

//34
select *
from 
SC as sc
inner join 
Student as s
on sc.sid = s.sid
where sc.score > 70

//35
select *
from 
SC as sc
inner join 
Student as s
on sc.sid = s.sid
where sc.score < 60

//36
select *
from SC as sc 
inner join Student as s
on sc.sid = s.sid
where sc.cid = 1 AND sc.score >= 80

//37
select sc.cid,count(*)
from SC as sc
group by sc.cid

//38
select *
from Teacher as t
inner join Course as c
on t.tid = c.tid
inner join Sc as sc
on c.cid = sc.cid
inner join Student as s
on s.sid = sc.sid
where t.tname = '?三'
order by sc.score DESC
limit 1

//39

//40
select */*s.sid,s.sname,s.sage,s.ssex*/
from 
(select sc.score,count(sc.score)
from SC as sc
group by score 
having count(sc.score) > 1) as list
inner join 
SC as scList
on list.score = scList.score
inner join 
Student as s
on s.sid = scList.sid

//41
select *
from(
select *, RANK()over(Partition By sc.cid Order By sc.score DESC) as rank
from SC as sc) as list
where list.rank in (1,2)

//42
select sc.cid,count(*) from SC as sc
group by sc.cid
having count(*) >= 5

//43
select sc.sid,count(*) from SC as sc
group by sc.sid
having count(*) >= 2

//44
select sc.sid,count(*) from SC as sc
group by sc.sid
having count(*) = 3

//45
select *,EXTRACT(Year from Current_TimeStamp) - EXTRACT(Year from s.sage) as age
from Student as s

//46

