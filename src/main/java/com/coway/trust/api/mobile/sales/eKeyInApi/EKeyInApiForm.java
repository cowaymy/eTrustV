package com.coway.trust.api.mobile.sales.eKeyInApi;

import java.util.HashMap;
import java.util.Map;

import com.coway.trust.util.BeanConverter;

import io.swagger.annotations.ApiModel;

/**
 * @ClassName : EKeyInApiForm.java
 * @Description : TO-DO Class Description
 *
 * @History
 *
 *          <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 12. 09.    KR-JAEMJAEM:)   First creation
 * 2020. 03. 20.    MY-ONGHC         Add User Name
 * 2020. 04. 08.    MY-ONGHC         Add cpntCode
 *          </pre>
 */
@ApiModel(value = "EKeyInApiForm", description = "EKeyInApiForm")
public class EKeyInApiForm {

	public static EKeyInApiForm create(Map<String, Object> map) {
		return BeanConverter.toBean(map, EKeyInApiForm.class);
	}

	public static Map<String, Object> createMap(EKeyInApiForm vo) {
		Map<String, Object> params = new HashMap<>();
		params.put("reqstDtFrom", vo.getReqstDtFrom());
		params.put("reqstDtTo", vo.getReqstDtTo());
		params.put("selectType", vo.getSelectType());
		params.put("selectKeyword", vo.getSelectKeyword());
		params.put("regId", vo.getRegId());
		params.put("preOrdId", vo.getPreOrdId());
		params.put("appTypeId", vo.getAppTypeId());
		params.put("codeMasterId", vo.getCodeMasterId());
		params.put("srvCntrctPacId", vo.getSrvCntrctPacId());
		params.put("typeId", vo.getTypeId());
		params.put("empChk", vo.getEmpChk());
		params.put("exTrade", vo.getExTrade());
		params.put("srvPacId", vo.getSrvPacId());
		params.put("promoId", vo.getPromoId());
		params.put("itmStkId", vo.getItmStkId());
		params.put("stkCtgryId", vo.getStkCtgryId());
		params.put("custId", vo.getCustId());
		params.put("custCrcId", vo.getCustCrcId());
		params.put("custOriCrcNo", vo.getCustOriCrcNo());
		params.put("sofNo", vo.getSofNo());
		params.put("nric", vo.getNric());
		params.put("atchFileGrpId", vo.getAtchFileGrpId());
		params.put("promoDt", vo.getPromoDt());
		params.put("gu", vo.getGu());
		params.put("stusCodeId", vo.getStusCodeId());
		params.put("userNm", vo.getUserNm());
		params.put("cpntCode", vo.getCpntCode());
		params.put("instPriod", vo.getInstPriod());
		params.put("voucherType", vo.getVoucherType());
		params.put("voucherCode", vo.getVoucherCode());
		params.put("voucherEmail", vo.getVoucherEmail());
		params.put("voucherPromotion", vo.getVoucherPromotion());
		params.put("customerStatusCode", vo.getCustomerStatusCode());
		return params;
	}

	private String reqstDtFrom;
	private String reqstDtTo;
	private String selectType;
	private String selectKeyword;
	private String regId;
	private int preOrdId;
	private int appTypeId;
	private int codeMasterId;
	private int srvCntrctPacId;
	private int typeId;
	private int empChk;
	private int exTrade;
	private int srvPacId;
	private int promoId;
	private int itmStkId;
	private int stkCtgryId;
	private int custId;
	private int custCrcId;
	private String custOriCrcNo;
	private String sofNo;
	private String nric;
	private int atchFileGrpId;
	private String promoDt;
	private String gu;
	private int stusCodeId;
	private String userNm;
	private String cpntCode;
	private int instPriod;
	private int voucherType;
	private String voucherCode;
	private String voucherEmail;
	private int voucherPromotion;
	private String customerStatusCode;

	public int getStusCodeId() {
		return stusCodeId;
	}

	public void setStusCodeId(int stusCodeId) {
		this.stusCodeId = stusCodeId;
	}

	public String getGu() {
		return gu;
	}

	public void setGu(String gu) {
		this.gu = gu;
	}

	public String getPromoDt() {
		return promoDt;
	}

	public void setPromoDt(String promoDt) {
		this.promoDt = promoDt;
	}

	public int getAtchFileGrpId() {
		return atchFileGrpId;
	}

	public void setAtchFileGrpId(int atchFileGrpId) {
		this.atchFileGrpId = atchFileGrpId;
	}

	public String getReqstDtFrom() {
		return reqstDtFrom;
	}

	public void setReqstDtFrom(String reqstDtFrom) {
		this.reqstDtFrom = reqstDtFrom;
	}

	public String getReqstDtTo() {
		return reqstDtTo;
	}

	public void setReqstDtTo(String reqstDtTo) {
		this.reqstDtTo = reqstDtTo;
	}

	public String getSelectType() {
		return selectType;
	}

	public void setSelectType(String selectType) {
		this.selectType = selectType;
	}

	public String getSelectKeyword() {
		return selectKeyword;
	}

	public void setSelectKeyword(String selectKeyword) {
		this.selectKeyword = selectKeyword;
	}

	public String getRegId() {
		return regId;
	}

	public void setRegId(String regId) {
		this.regId = regId;
	}

	public int getPreOrdId() {
		return preOrdId;
	}

	public void setPreOrdId(int preOrdId) {
		this.preOrdId = preOrdId;
	}

	public int getAppTypeId() {
		return appTypeId;
	}

	public void setAppTypeId(int appTypeId) {
		this.appTypeId = appTypeId;
	}

	public int getCodeMasterId() {
		return codeMasterId;
	}

	public void setCodeMasterId(int codeMasterId) {
		this.codeMasterId = codeMasterId;
	}

	public int getSrvCntrctPacId() {
		return srvCntrctPacId;
	}

	public void setSrvCntrctPacId(int srvCntrctPacId) {
		this.srvCntrctPacId = srvCntrctPacId;
	}

	public int getTypeId() {
		return typeId;
	}

	public void setTypeId(int typeId) {
		this.typeId = typeId;
	}

	public int getEmpChk() {
		return empChk;
	}

	public void setEmpChk(int empChk) {
		this.empChk = empChk;
	}

	public int getExTrade() {
		return exTrade;
	}

	public void setExTrade(int exTrade) {
		this.exTrade = exTrade;
	}

	public int getSrvPacId() {
		return srvPacId;
	}

	public void setSrvPacId(int srvPacId) {
		this.srvPacId = srvPacId;
	}

	public int getPromoId() {
		return promoId;
	}

	public void setPromoId(int promoId) {
		this.promoId = promoId;
	}

	public int getItmStkId() {
		return itmStkId;
	}

	public void setItmStkId(int itmStkId) {
		this.itmStkId = itmStkId;
	}

	public int getStkCtgryId() {
		return stkCtgryId;
	}

	public void setStkCtgryId(int stkCtgryId) {
		this.stkCtgryId = stkCtgryId;
	}

	public int getCustId() {
		return custId;
	}

	public void setCustId(int custId) {
		this.custId = custId;
	}

	public int getCustCrcId() {
		return custCrcId;
	}

	public void setCustCrcId(int custCrcId) {
		this.custCrcId = custCrcId;
	}

	public String getCustOriCrcNo() {
		return custOriCrcNo;
	}

	public void setCustOriCrcNo(String custOriCrcNo) {
		this.custOriCrcNo = custOriCrcNo;
	}

	public String getSofNo() {
		return sofNo;
	}

	public void setSofNo(String sofNo) {
		this.sofNo = sofNo;
	}

	public String getNric() {
		return nric;
	}

	public void setNric(String nric) {
		this.nric = nric;
	}

	public String getUserNm() {
		return userNm;
	}

	public void setUserNm(String userNm) {
		this.userNm = userNm;
	}

	public String getCpntCode() {
		return cpntCode;
	}

	public void setCpntCode(String cpntCode) {
		this.cpntCode = cpntCode;
	}

	public int getInstPriod() {
		return instPriod;
	}

	public void setInstPriod(int instPriod) {
		this.instPriod = instPriod;
	}

	public int getVoucherType() {
		return voucherType;
	}

	public void setVoucherType(int voucherType) {
		this.voucherType = voucherType;
	}

	public String getVoucherCode() {
		return voucherCode;
	}

	public void setVoucherCode(String voucherCode) {
		this.voucherCode = voucherCode;
	}

	public String getVoucherEmail() {
		return voucherEmail;
	}

	public void setVoucherEmail(String voucherEmail) {
		this.voucherEmail = voucherEmail;
	}

	public int getVoucherPromotion() {
		return voucherPromotion;
	}

	public void setVoucherPromotion(int voucherPromotion) {
		this.voucherPromotion = voucherPromotion;
	}

  public String getCustomerStatusCode() {
    return customerStatusCode;
  }

  public void setCustomerStatusCode(String customerStatusCode) {
    this.customerStatusCode = customerStatusCode;
  }
}
