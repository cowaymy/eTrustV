package com.coway.trust.api.mobile.Service.heartService;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "HeartServiceJobDto", description = "공통코드 Dto")
public class HeartServiceJobDto {

	@ApiModelProperty(value = "주문번호")	
	private String salesOrderNo;
	
	@ApiModelProperty(value = "EX_BS00000 / AS00000")
	private String serviceNo;
	
	@ApiModelProperty(value = "고객명")
	private String custName;
	
	@ApiModelProperty(value = "AS / HS / INST / PR 구분값")
	private String jobType;
	
	@ApiModelProperty(value = "ACT / COMPLETE / FAIL / CANCLE 구분")
	private String jobStatus;
	
	public static HeartServiceJobDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, HeartServiceJobDto.class);
	}
	
	public String getSalesOrderNo() {
		return salesOrderNo;
	}
	public void setSalesOrderNo(String salesOrderNo) {
		this.salesOrderNo = salesOrderNo;
	}
	public String getServiceNo() {
		return serviceNo;
	}
	public void setServiceNo(String serviceNo) {
		this.serviceNo = serviceNo;
	}
	public String getCustName() {
		return custName;
	}
	public void setCustName(String custName) {
		this.custName = custName;
	}
	public String getJobType() {
		return jobType;
	}
	public void setJobType(String jobType) {
		this.jobType = jobType;
	}
	public String getJobStatus() {
		return jobStatus;
	}
	public void setJobStatus(String jobStatus) {
		this.jobStatus = jobStatus;
	}
	
	
	
	
	
	
	
}
