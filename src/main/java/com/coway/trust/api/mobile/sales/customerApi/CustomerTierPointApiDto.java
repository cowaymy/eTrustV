package com.coway.trust.api.mobile.sales.customerApi;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;


/**
 * @ClassName : CustomerApiDto.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 09. 16.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
@ApiModel(value = "CustomerApiDto", description = "CustomerApiDto")
public class CustomerTierPointApiDto {



	@SuppressWarnings("unchecked")
	public static CustomerTierPointApiDto create(Map<String, Object> egvoMap) {
		return BeanConverter.toBean(egvoMap, CustomerTierPointApiDto.class);
	}
//
//
//
//	public static Map<String, Object> createMap(CustomerTierPointApiDto vo){
//		Map<String, Object> params = new HashMap<>();
//		params.put("custId", vo.getCustId());
//		params.put("name", vo.getName());
//		params.put("addrDtl", vo.getAddrDtl());
//		params.put("addr", vo.getAddr());
//		params.put("typeIdName", vo.getTypeIdName());
//        params.put("custAddId", vo.getCustAddId());
//        params.put("postcode", vo.getPostcode());
//        params.put("custVaNo", vo.getCustVaNo());
//        params.put("nationName", vo.getNationName());
//        params.put("raceIdName", vo.getRaceIdName());
//        params.put("telM1", vo.getTelM1());
//        params.put("telO", vo.getTelO());
//        params.put("telR", vo.getTelR());
//        params.put("email", vo.getEmail());
//        params.put("custCntcId", vo.getCustCntcId());
//        params.put("typeId", vo.getTypeId());
//        params.put("salesOrdId", vo.getSalesOrdId());
//        params.put("salesOrdNo", vo.getSalesOrdNo());
//        params.put("salesDt", vo.getSalesDt());
//        params.put("stusCodeIdName", vo.getStusCodeIdName());
//        params.put("appTypeIdName", vo.getAppTypeIdName());
//        params.put("stkDescName", vo.getStkDescName());
//		return params;
//	}



	private int custId;
	private String custTier;
	private int tCurPoint;
	private int tExpiredPoint;
	private int tOnholdPoint;
	private int tExpiringPoint;

	//OrderList:
	private List<CustomerTierOrderListApiDto> orderList;

	private int tBdayPoint;
	private String bdayPointStatus;
	private int tMcsPoint;
	private String mcsPointStatus;
	private int tOtherPoint;
	private String otherPointStatus;

	public int getCustId() {
		return custId;
	}
	public void setCustId(int custId) {
		this.custId = custId;
	}
	public String getCustTier() {
		return custTier;
	}
	public void setCustTier(String custTier) {
		this.custTier = custTier;
	}
	public int gettCurPoint() {
		return tCurPoint;
	}
	public void settCurPoint(int tCurPoint) {
		this.tCurPoint = tCurPoint;
	}
	public int gettExpiredPoint() {
		return tExpiredPoint;
	}
	public void settExpiredPoint(int tExpiredPoint) {
		this.tExpiredPoint = tExpiredPoint;
	}
	public int gettOnholdPoint() {
		return tOnholdPoint;
	}
	public void settOnholdPoint(int tOnholdPoint) {
		this.tOnholdPoint = tOnholdPoint;
	}
	public int gettExpiringPoint() {
		return tExpiringPoint;
	}
	public void settExpiringPoint(int tExpiringPoint) {
		this.tExpiringPoint = tExpiringPoint;
	}
	public List<CustomerTierOrderListApiDto> getOrderList() {
		return orderList;
	}
	public void setOrderList(List<CustomerTierOrderListApiDto> orderList) {
		this.orderList = orderList;
	}
	public int gettBdayPoint() {
		return tBdayPoint;
	}
	public void settBdayPoint(int tBdayPoint) {
		this.tBdayPoint = tBdayPoint;
	}
	public String getBdayPointStatus() {
		return bdayPointStatus;
	}
	public void setBdayPointStatus(String bdayPointStatus) {
		this.bdayPointStatus = bdayPointStatus;
	}
	public int gettMcsPoint() {
		return tMcsPoint;
	}
	public void settMcsPoint(int tMcsPoint) {
		this.tMcsPoint = tMcsPoint;
	}
	public String getMcsPointStatus() {
		return mcsPointStatus;
	}
	public void setMcsPointStatus(String mcsPointStatus) {
		this.mcsPointStatus = mcsPointStatus;
	}
	public int gettOtherPoint() {
		return tOtherPoint;
	}
	public void settOtherPoint(int tOtherPoint) {
		this.tOtherPoint = tOtherPoint;
	}
	public String getOtherPointStatus() {
		return otherPointStatus;
	}
	public void setOtherPointStatus(String otherPointStatus) {
		this.otherPointStatus = otherPointStatus;
	}



}
