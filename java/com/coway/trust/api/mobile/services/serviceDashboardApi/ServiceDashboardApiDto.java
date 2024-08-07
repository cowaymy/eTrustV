package com.coway.trust.api.mobile.services.serviceDashboardApi;

import java.math.BigDecimal;

import com.coway.trust.util.BeanConverter;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;


/**
 * @ClassName : SalesDashboardApiDto.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 12. 23.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
@ApiModel(value = "ServiceDashboardApiDto", description = "ServiceDashboardApiDto")
@JsonIgnoreProperties(ignoreUnknown = true)
public class ServiceDashboardApiDto{



	@SuppressWarnings("unchecked")
	public static ServiceDashboardApiDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, ServiceDashboardApiDto.class);
	}

	private String csType;
	private int actCount;
	private int comCount;
	private int cancelCount;
	private int failCount;
	private int totalCount;

	public String getCsType() {
		return csType;
	}
	public int getActCount() {
		return actCount;
	}
	public int getComCount() {
		return comCount;
	}
	public int getCancelCount() {
		return cancelCount;
	}
	public int getFailCount() {
		return failCount;
	}
	public int getTotalCount() {
		return totalCount;
	}
	public void setCsType(String csType) {
		this.csType = csType;
	}
	public void setActCount(int actCount) {
		this.actCount = actCount;
	}
	public void setComCount(int comCount) {
		this.comCount = comCount;
	}
	public void setCancelCount(int cancelCount) {
		this.cancelCount = cancelCount;
	}
	public void setFailCount(int failCount) {
		this.failCount = failCount;
	}
	public void setTotalCount(int totalCount) {
		this.totalCount = totalCount;
	}


}
