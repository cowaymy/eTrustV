package com.coway.trust.api.mobile.sales.customerApi;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.coway.trust.api.mobile.logistics.audit.InputBarcodeListForm;
import com.coway.trust.api.mobile.logistics.audit.InputBarcodePartsForm;
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
public class CustomerTierCatListApiDto {

	@SuppressWarnings("unchecked")
	public static CustomerTierCatListApiDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, CustomerTierCatListApiDto.class);
	}

	private String categoryName;
	private List<CustomerTierOrderListApiDto> orderList;
	private int totalPoint;
	private String pointStatus;

	public String getCategoryName() {
		return categoryName;
	}
	public void setCategoryName(String categoryName) {
		this.categoryName = categoryName;
	}
	public List<CustomerTierOrderListApiDto> getOrderList() {
		return orderList;
	}
	public void setOrderList(List<CustomerTierOrderListApiDto> orderList) {
		this.orderList = orderList;
	}
	public int getTotalPoint() {
		return totalPoint;
	}
	public void setTotalPoint(int totalPoint) {
		this.totalPoint = totalPoint;
	}
	public String getPointStatus() {
		return pointStatus;
	}
	public void setPointStatus(String pointStatus) {
		this.pointStatus = pointStatus;
	}
}
