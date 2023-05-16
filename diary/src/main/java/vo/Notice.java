package vo;
// notice 테이블의 한 행(레코드)을 저장하는 용도
// Value Object or Data Transfer Object or Domain(한 테이블의 컬럼이 가질 수 있는 범위)
public class Notice {
	public int noticeNo; // 데이터의 컬럼명과 다르다 -> select에서 알리어스(AS)로 맞춰준다 or API사용
	public String noticeTitle;
	public String noticeContent;
	public String noticeWriter;
	public String createdate; 
	public String updatedate;
	public String noticePw;
	/*
	 * 날짜 데이터는 날짜타입으로 받는 것이 좋지만(날짜계산 가능)
	 * 데이터를 가져올 때 계산할 수도 있으므로 String타입이 가장 편함
	 */
	
}
