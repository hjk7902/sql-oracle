select * from supermarket_sales;

1. 전체 구매 건수
select count(*) from supermarket_sales;

2. 지점(Branch)별 구매 건수
select branch, count(*) from supermarket_sales
group by branch;

3. 지점별 남성과 여성 고객의 수
select branch, gender, count(gender) from supermarket_sales
group by branch, gender
order by branch
;

4. 지점별 수익(gross_income) 현황(총계)
select branch, sum(gross_income) from supermarket_sales
group by branch;


select distinct purchase_date from supermarket_sales;
5. 지점별 월별 수익(gross_income)현황
select branch, to_char(purchase_date, 'MM') as month, sum(gross_income) as income from supermarket_sales
group by branch, to_char(purchase_date, 'MM');

select distinct time from supermarket_sales;

6. 수익이(gross_income) 높은 시간대
select substr(time, 1, 2) as hour, sum(gross_income) as total_income from supermarket_sales
group by substr(time, 1, 2)
order by total_income desc;

7. 평가(Rating)가 좋은 지점
select branch, round(avg(rating),2) rating from supermarket_sales
group by branch
order by rating desc;

select customer_type, count(*) from supermarket_sales
group by customer_type;

8. 매출(Total)이 놓은 결제 수단(Payment)
select payment, count(*),sum(Total) from supermarket_sales
group by payment;

9. 매출(Total)이 높은 라인(Product_line)
select Product_line, sum(Total) from supermarket_sales
group by Product_line 
order by 2 desc;

10. 많이 팔리는 라인(Product_line)
select Product_line, count(*) from supermarket_sales
group by Product_line 
order by 2 desc;

select branch, gender, count(gender), grouping_id(branch) from supermarket_sales
group by cube(branch, gender)
order by branch;


11. 거래별 구매한 제품의 수량(Quantity) 평균
select avg(Quantity) from supermarket_sales;


추가
--지점별 시간대별 매출
select branch, substr(time, 1, 2) as time, sum(total)
from supermarket_sales
group by branch, substr(time, 1 , 2)
order by branch, time;

-- 지점별 수입이 가장 높은 시간대 상위 3개씩 출력
select * from(
select branch, substr(time, 1, 2) as time, sum(total), 
    rank() over(partition by branch order by sum(total) desc) rnum
    from supermarket_sales
    group by branch, substr(time, 1 , 2)
    order by branch, rnum
    )
where rnum between 1 and 3
order by branch, rnum;

--지점별 결제 수단별 매출 총액은?
select branch, payment, sum(total) from supermarket_sales
group by branch, payment;

--지점별 현금결제 매출 총액은?
select branch, sum(total) from supermarket_sales
where payment='Cash'
group by branch;

-- 가장 큰 수익을 낸 구매의 결제 방법은?
select payment, max(gross_income) from supermarket_sales
group by payment;

select payment from supermarket_sales
where gross_income = (
    select max(gross_income) 
    from supermarket_sales
    )
;

