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

	public static Map<String, Object> createMap(CustomerTierPointApiDto vo){
		Map<String, Object> params = new HashMap<>();
		params.put("custId", vo.getCustId());
		params.put("custTier", vo.getCustTier());
		params.put("tCurPoint", vo.gettCurPoint());
		params.put("tExpiredPoint", vo.gettExpiredPoint());
		params.put("tOnholdPoint", vo.gettOnholdPoint());
        params.put("tExpiringPoint", vo.gettExpiringPoint());
        params.put("ptToAchNxLvl", vo.getPtToAchNxLvl());
        params.put("mthToAchNxLvl", vo.getMthToAchNxLvl());
		return params;
	}

	private int custId;
	private String custTier;
	private String oriTier;
	private int tCurPoint;
	private int tExpiredPoint;
	private int tOnholdPoint;
	private int tExpiringPoint;

	private List<CustomerTierCatListApiDto> categoryList;

	private int ptToAchNxLvl;
	private int mthToAchNxLvl;

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
	public String getOriTier() {
		return oriTier;
	}

	public void setOriTier(String oriTier) {
		this.oriTier = oriTier;
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
	public List<CustomerTierCatListApiDto> getCategoryList() {
		return categoryList;
	}
	public void setCategoryList(List<CustomerTierCatListApiDto> categoryList) {
		this.categoryList = categoryList;
	}
	public int getPtToAchNxLvl() {
		return ptToAchNxLvl;
	}
	public void setPtToAchNxLvl(int ptToAchNxLvl) {
		this.ptToAchNxLvl = ptToAchNxLvl;
	}
	public int getMthToAchNxLvl() {
		return mthToAchNxLvl;
	}
	public void setMthToAchNxLvl(int mthToAchNxLvl) {
		this.mthToAchNxLvl = mthToAchNxLvl;
	}



}
