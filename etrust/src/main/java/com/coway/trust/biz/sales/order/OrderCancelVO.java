package com.coway.trust.biz.sales.order;

import java.io.Serializable;

public class OrderCancelVO implements Serializable {

	private static final long serialVersionUID = 445980703103400364L;
	
	private int reqId;
	private String reqNo;
	private int ordId;
	private int reqStusId;
	private String reqStusCode;
	private String reqStusName;
	private int reqResnId;
	private String reqResnCode;
	private String reqResnDesc;
	private int appTypeId;
	private String appTypeCode;
	private String appTypeName;
	private String attach;
	private int callStusId;
	private String callStusCode;
	private String callStusName;
	private String custName;
	private String callRecallDt;
	private int reqStageId;
	private String reqStage;
	private String custIc;				//nric / Comp No
	private int brnchId;
	private String brnchName;
	private int memId;
	private String memCodeName;
	private int resnId;
	private String codeResnDesc;
	
	public int getReqId() {
		return reqId;
	}
	public void setReqId(int reqId) {
		this.reqId = reqId;
	}
	public String getReqNo() {
		return reqNo;
	}
	public void setReqNo(String reqNo) {
		this.reqNo = reqNo;
	}
	public int getOrdId() {
		return ordId;
	}
	public void setOrdId(int ordId) {
		this.ordId = ordId;
	}
	public int getReqStusId() {
		return reqStusId;
	}
	public void setReqStusId(int reqStusId) {
		this.reqStusId = reqStusId;
	}
	public String getReqStusCode() {
		return reqStusCode;
	}
	public void setReqStusCode(String reqStusCode) {
		this.reqStusCode = reqStusCode;
	}
	public String getReqStusName() {
		return reqStusName;
	}
	public void setReqStusName(String reqStusName) {
		this.reqStusName = reqStusName;
	}
	public int getReqResnId() {
		return reqResnId;
	}
	public void setReqResnId(int reqResnId) {
		this.reqResnId = reqResnId;
	}
	public String getReqResnCode() {
		return reqResnCode;
	}
	public void setReqResnCode(String reqResnCode) {
		this.reqResnCode = reqResnCode;
	}
	public String getReqResnDesc() {
		return reqResnDesc;
	}
	public void setReqResnDesc(String reqResnDesc) {
		this.reqResnDesc = reqResnDesc;
	}
	public int getAppTypeId() {
		return appTypeId;
	}
	public void setAppTypeId(int appTypeId) {
		this.appTypeId = appTypeId;
	}
	public String getAppTypeCode() {
		return appTypeCode;
	}
	public void setAppTypeCode(String appTypeCode) {
		this.appTypeCode = appTypeCode;
	}
	public String getAppTypeName() {
		return appTypeName;
	}
	public void setAppTypeName(String appTypeName) {
		this.appTypeName = appTypeName;
	}
	public String getAttach() {
		return attach;
	}
	public void setAttach(String attach) {
		this.attach = attach;
	}
	public int getCallStusId() {
		return callStusId;
	}
	public void setCallStusId(int callStusId) {
		this.callStusId = callStusId;
	}
	public String getCallStusCode() {
		return callStusCode;
	}
	public void setCallStusCode(String callStusCode) {
		this.callStusCode = callStusCode;
	}
	public String getCallStusName() {
		return callStusName;
	}
	public void setCallStusName(String callStusName) {
		this.callStusName = callStusName;
	}
	public String getCustName() {
		return custName;
	}
	public void setCustName(String custName) {
		this.custName = custName;
	}
	public String getCallRecallDt() {
		return callRecallDt;
	}
	public void setCallRecallDt(String callRecallDt) {
		this.callRecallDt = callRecallDt;
	}
	public int getReqStageId() {
		return reqStageId;
	}
	public void setReqStageId(int reqStageId) {
		this.reqStageId = reqStageId;
	}
	public String getReqStage() {
		return reqStage;
	}
	public void setReqStage(String reqStage) {
		this.reqStage = reqStage;
	}
	public String getCustIc() {
		return custIc;
	}
	public void setCustIc(String custIc) {
		this.custIc = custIc;
	}
	public int getBrnchId() {
		return brnchId;
	}
	public void setBrnchId(int brnchId) {
		this.brnchId = brnchId;
	}
	public String getBrnchName() {
		return brnchName;
	}
	public void setBrnchName(String brnchName) {
		this.brnchName = brnchName;
	}
	public int getMemId() {
		return memId;
	}
	public void setMemId(int memId) {
		this.memId = memId;
	}
	public String getMemCodeName() {
		return memCodeName;
	}
	public void setMemCodeName(String memCodeName) {
		this.memCodeName = memCodeName;
	}
	public int getResnId() {
		return resnId;
	}
	public void setResnId(int resnId) {
		this.resnId = resnId;
	}
	public String getCodeResnDesc() {
		return codeResnDesc;
	}
	public void setCodeResnDesc(String codeResnDesc) {
		this.codeResnDesc = codeResnDesc;
	}
	
	

}
