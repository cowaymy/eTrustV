package com.coway.trust.api.mobile.services.history;

import java.util.List;

import com.coway.trust.api.mobile.logistics.stocktransfer.StockTransferReqStatusMListDto;
import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "ServiceHistoryDto", description = "공통코드 Dto")
public class ServiceHistoryDto {


	@ApiModelProperty(value = "작업 상태")
	private int jobStatus;

	@ApiModelProperty(value = "서비스 번호")
	private String serviceNo;

	@ApiModelProperty(value = "settled 날짜(YYYYMMDD)")
	private String settleDate;

	@ApiModelProperty(value = "hsr / asr No")
	private String hsrAsrNo;

	@ApiModelProperty(value = "action 멤버")
	private String actionMember;

	@ApiModelProperty(value = "작업 타입(as / hs / inst / pr)")
	private String jobType;

	@ApiModelProperty(value = "실패사유")
	private String failReason;


	private int collectionCode;


	private String collectionName;


	private String resultRemark;

	@ApiModelProperty(value = "filterList")
	private List<ServiceHistoryFilterDetailDto>  filterList = null;

	
	@ApiModelProperty(value = "partList")
	private List<ServiceHistoryPartDetailDto>  partList = null;


	public static ServiceHistoryDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, ServiceHistoryDto.class);
	}





	public List<ServiceHistoryFilterDetailDto> getFilterList() {
		return filterList;
	}


	public void setFilterList(List<ServiceHistoryFilterDetailDto> filterList) {
		this.filterList = filterList;
	}


	public List<ServiceHistoryPartDetailDto> getPartList() {
		return partList;
	}


	public void setPartList(List<ServiceHistoryPartDetailDto> partList) {
		this.partList = partList;
	}


	public int getJobStatus() {
		return jobStatus;
	}


	public void setJobStatus(int jobStatus) {
		this.jobStatus = jobStatus;
	}


	public String getServiceNo() {
		return serviceNo;
	}


	public void setServiceNo(String serviceNo) {
		this.serviceNo = serviceNo;
	}


	public String getSettleDate() {
		return settleDate;
	}


	public void setSettleDate(String settleDate) {
		this.settleDate = settleDate;
	}


	public String getHsrAsrNo() {
		return hsrAsrNo;
	}


	public void setHsrAsrNo(String hsrAsrNo) {
		this.hsrAsrNo = hsrAsrNo;
	}


	public String getActionMember() {
		return actionMember;
	}


	public void setActionMember(String actionMember) {
		this.actionMember = actionMember;
	}


	public String getJobType() {
		return jobType;
	}


	public void setJobType(String jobType) {
		this.jobType = jobType;
	}


	public String getFailReason() {
		return failReason;
	}


	public void setFailReason(String failReason) {
		this.failReason = failReason;
	}


	public  int getCollectionCode() {
		return collectionCode;
	}


	public void setCollectionCode( int collectionCode) {
		this.collectionCode = collectionCode;
	}


	public String getCollectionName() {
		return collectionName;
	}


	public void setCollectionName(String collectionName) {
		this.collectionName = collectionName;
	}


	public String getResultRemark() {
		return resultRemark;
	}


	public void setResultRemark(String resultRemark) {
		this.resultRemark = resultRemark;
	}



	
	
}
