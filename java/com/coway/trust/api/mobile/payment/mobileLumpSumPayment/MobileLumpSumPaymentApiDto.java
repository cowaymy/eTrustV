package com.coway.trust.api.mobile.payment.mobileLumpSumPayment;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;

@ApiModel(value = "MobileLumpSumPaymentApiDto", description = "MobileLumpSumPaymentApiDto")
public class MobileLumpSumPaymentApiDto {
	private List<MobileLumpSumPaymentApiDto> list;
	//customer info search
	private String nric;
	private String accBillCrtDt;
	private int accBillGrpId;
	private int custId;
	private String name;
	private String email;
	private int custTypeId;
	private String custTypeCode;
	private String custTypeCodeName;
	private int custCorpTypeId;
	private String custCorpTypeCode;
	private String custCorpTypeCodeName;

	//customer order search
	private int srvMemId;
	private int ordId;
	private String ordNo;
	private int ordPaymentTypeId;
	private String ordPaymentTypeName;
	private String payType;
	private Double otstndAmt;
	private int ordTypeId;
	private String ordTypeName;

	//Cash Matching Order Search
	private String mobPayGroupNo;
	private Double totPayAmt;
	private int payMode;
	private String payModeName;
	private int payStusId;
	private String payStusName;
	private String crtDt;
	private String remarks;

	//History
	private String serialNo;

	//Result
	private int responseCode;

	@SuppressWarnings("unchecked")
	public static MobileLumpSumPaymentApiDto create(EgovMap egovMap){
	 return BeanConverter.toBean(egovMap, MobileLumpSumPaymentApiDto.class);
	}

	public static Map<String, Object> createMap(MobileLumpSumPaymentApiDto vo){
		Map<String, Object> params = new HashMap<>();
		params.put("list", vo.getList());

		//customer info search
		params.put("nric", vo.getNric());
		params.put("accBillCrtDt", vo.getAccBillCrtDt());
		params.put("accBillGrpId", vo.getAccBillGrpId());
		params.put("custId", vo.getCustId());
		params.put("name", vo.getName());
		params.put("email", vo.getEmail());
		params.put("custTypeId", vo.getCustTypeId());
		params.put("custTypeCode", vo.getCustTypeCode());
		params.put("custTypeCodeName", vo.getCustTypeCodeName());
		params.put("custCorpTypeId", vo.getCustCorpTypeId());
		params.put("custCorpTypeCode", vo.getCustCorpTypeCode());
		params.put("custCorpTypeCodeName", vo.getCustCorpTypeCodeName());

		//customer order search
		params.put("srvMemId", vo.getSrvMemId());
		params.put("ordId",vo.getOrdId());
		params.put("ordNo",vo.getOrdNo());
		params.put("payType",vo.getPayType());
		params.put("otstndAmt",vo.getOtstndAmt());
		params.put("ordPaymentTypeId",vo.getOrdPaymentTypeId());
		params.put("ordPaymentTypeName",vo.getOrdPaymentTypeName());
		params.put("ordTypeId",vo.getOrdTypeId());
		params.put("ordTypeName",vo.getOrdTypeName());

		//cash matching order search
		params.put("mobPayGroupNo",vo.getMobPayGroupNo());
		params.put("totPayAmt",vo.getTotPayAmt());
		params.put("payMode",vo.getPayMode());
		params.put("payModeName",vo.getPayModeName());
		params.put("payStusId",vo.getPayStusId());
		params.put("payStusName",vo.getPayStusName());
		params.put("crtDt",vo.getCrtDt());

		//History
		params.put("serialNo",vo.getSerialNo());

		params.put("responseCode", vo.getResponseCode());
		return params;
	}

	public int getResponseCode() {
		return responseCode;
	}

	public void setResponseCode(int responseCode) {
		this.responseCode = responseCode;
	}

	public String getNric() {
		return nric;
	}

	public void setNric(String nric) {
		this.nric = nric;
	}

	public String getAccBillCrtDt() {
		return accBillCrtDt;
	}

	public void setAccBillCrtDt(String accBillCrtDt) {
		this.accBillCrtDt = accBillCrtDt;
	}

	public int getAccBillGrpId() {
		return accBillGrpId;
	}

	public void setAccBillGrpId(int accBillGrpId) {
		this.accBillGrpId = accBillGrpId;
	}

	public int getCustId() {
		return custId;
	}

	public void setCustId(int custId) {
		this.custId = custId;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public int getCustTypeId() {
		return custTypeId;
	}

	public void setCustTypeId(int custTypeId) {
		this.custTypeId = custTypeId;
	}

	public String getCustTypeCode() {
		return custTypeCode;
	}

	public void setCustTypeCode(String custTypeCode) {
		this.custTypeCode = custTypeCode;
	}

	public String getCustTypeCodeName() {
		return custTypeCodeName;
	}

	public void setCustTypeCodeName(String custTypeCodeName) {
		this.custTypeCodeName = custTypeCodeName;
	}

	public int getCustCorpTypeId() {
		return custCorpTypeId;
	}

	public void setCustCorpTypeId(int custCorpTypeId) {
		this.custCorpTypeId = custCorpTypeId;
	}

	public String getCustCorpTypeCode() {
		return custCorpTypeCode;
	}

	public void setCustCorpTypeCode(String custCorpTypeCode) {
		this.custCorpTypeCode = custCorpTypeCode;
	}

	public String getCustCorpTypeCodeName() {
		return custCorpTypeCodeName;
	}

	public void setCustCorpTypeCodeName(String custCorpTypeCodeName) {
		this.custCorpTypeCodeName = custCorpTypeCodeName;
	}

	public int getOrdId() {
		return ordId;
	}

	public void setOrdId(int ordId) {
		this.ordId = ordId;
	}

	public String getOrdNo() {
		return ordNo;
	}

	public void setOrdNo(String ordNo) {
		this.ordNo = ordNo;
	}

	public String getPayType() {
		return payType;
	}

	public void setPayType(String payType) {
		this.payType = payType;
	}

	public Double getOtstndAmt() {
		return otstndAmt;
	}

	public void setOtstndAmt(Double otstndAmt) {
		this.otstndAmt = otstndAmt;
	}

	public int getOrdPaymentTypeId() {
		return ordPaymentTypeId;
	}

	public void setOrdPaymentTypeId(int ordPaymentTypeId) {
		this.ordPaymentTypeId = ordPaymentTypeId;
	}

	public int getOrdTypeId() {
		return ordTypeId;
	}

	public void setOrdTypeId(int ordTypeId) {
		this.ordTypeId = ordTypeId;
	}

	public String getOrdTypeName() {
		return ordTypeName;
	}

	public void setOrdTypeName(String ordTypeName) {
		this.ordTypeName = ordTypeName;
	}

	public String getOrdPaymentTypeName() {
		return ordPaymentTypeName;
	}

	public void setOrdPaymentTypeName(String ordPaymentTypeName) {
		this.ordPaymentTypeName = ordPaymentTypeName;
	}

	public List<MobileLumpSumPaymentApiDto> getList() {
		return list;
	}

	public void setList(List<MobileLumpSumPaymentApiDto> list) {
		this.list = list;
	}

	public String getMobPayGroupNo() {
		return mobPayGroupNo;
	}

	public void setMobPayGroupNo(String mobPayGroupNo) {
		this.mobPayGroupNo = mobPayGroupNo;
	}

	public Double getTotPayAmt() {
		return totPayAmt;
	}

	public void setTotPayAmt(Double totPayAmt) {
		this.totPayAmt = totPayAmt;
	}

	public int getPayMode() {
		return payMode;
	}

	public void setPayMode(int payMode) {
		this.payMode = payMode;
	}

	public String getPayModeName() {
		return payModeName;
	}

	public void setPayModeName(String payModeName) {
		this.payModeName = payModeName;
	}

	public int getPayStusId() {
		return payStusId;
	}

	public void setPayStusId(int payStusId) {
		this.payStusId = payStusId;
	}

	public String getPayStusName() {
		return payStusName;
	}

	public void setPayStusName(String payStusName) {
		this.payStusName = payStusName;
	}

	public String getCrtDt() {
		return crtDt;
	}

	public void setCrtDt(String crtDt) {
		this.crtDt = crtDt;
	}

	public int getSrvMemId() {
		return srvMemId;
	}

	public void setSrvMemId(int srvMemId) {
		this.srvMemId = srvMemId;
	}

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	public String getSerialNo() {
		return serialNo;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}
}
