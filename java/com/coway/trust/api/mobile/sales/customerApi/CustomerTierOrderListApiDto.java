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
public class CustomerTierOrderListApiDto {



//	@SuppressWarnings("unchecked")
//	public static CustomerTierPointApiDto create(EgovMap egvoMap) {
//		return BeanConverter.toBean(egvoMap, CustomerTierPointApiDto.class);
//	}
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



	private String prodName;
	private String refNo;
	private int tPoint;
	private String pointStatus;
	private String pointExpiryDt;

	public String getProdName() {
		return prodName;
	}
	public void setProdName(String prodName) {
		this.prodName = prodName;
	}
	public String getRefNo() {
		return refNo;
	}
	public void setRefNo(String refNo) {
		this.refNo = refNo;
	}
	public int gettPoint() {
		return tPoint;
	}
	public void settPoint(int tPoint) {
		this.tPoint = tPoint;
	}
	public String getPointStatus() {
		return pointStatus;
	}
	public void setPointStatus(String pointStatus) {
		this.pointStatus = pointStatus;
	}
	public String getPointExpiryDt() {
		return pointExpiryDt;
	}
	public void setPointExpiryDt(String pointExpiryDt) {
		this.pointExpiryDt = pointExpiryDt;
	}

}
