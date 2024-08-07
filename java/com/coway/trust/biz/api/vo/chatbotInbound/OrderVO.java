package com.coway.trust.biz.api.vo.chatbotInbound;

import java.io.Serializable;
import java.util.Map;

import com.coway.trust.biz.api.vo.SurveyCategoryDto;
import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public class OrderVO implements Serializable{
	private int orderId;
	private String orderNo;
	private int custAddId;
	private String productCode;
	private String productCatName;
	private String productName;
	private String area;
	private String appType;

	@SuppressWarnings("unchecked")
	public static OrderVO create(Map<String, Object> egvoMap) {
		return BeanConverter.toBean(egvoMap, OrderVO.class);
	}

	public int getOrderId() {
		return orderId;
	}

	public void setOrderId(int orderId) {
		this.orderId = orderId;
	}

	public String getOrderNo() {
		return orderNo;
	}

	public void setOrderNo(String orderNo) {
		this.orderNo = orderNo;
	}

	public int getCustAddId() {
		return custAddId;
	}

	public void setCustAddId(int custAddId) {
		this.custAddId = custAddId;
	}

	public String getProductCode() {
		return productCode;
	}

	public void setProductCode(String productCode) {
		this.productCode = productCode;
	}

	public String getProductCatName() {
		return productCatName;
	}

	public void setProductCatName(String productCatName) {
		this.productCatName = productCatName;
	}

	public String getProductName() {
		return productName;
	}

	public void setProductName(String productName) {
		this.productName = productName;
	}

	public String getArea() {
		return area;
	}

	public void setArea(String area) {
		this.area = area;
	}

	public String getAppType() {
		return appType;
	}

	public void setAppType(String appType) {
		this.appType = appType;
	}
}
