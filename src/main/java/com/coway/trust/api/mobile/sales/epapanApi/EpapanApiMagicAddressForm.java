package com.coway.trust.api.mobile.sales.epapanApi;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.swagger.annotations.ApiModel;


/**
 * @ClassName : ProductInfoListApiForm.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 11. 13.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
@ApiModel(value = "EpapanApiMagicAddressForm", description = "EpapanApiMagicAddressForm")
public class EpapanApiMagicAddressForm {

	public static Map<String, Object> createMap(EpapanApiMagicAddressForm vo){
		Map<String, Object> params = new HashMap<>();


		params.put("searchStreet", vo.getSearchStreet());
		params.put("state", vo.getState());
		params.put("postcode", vo.getPostCode());
		params.put("city", vo.getCity());
		params.put("groupCode", vo.getGroupCode());
		params.put("isAllowForDd", vo.getIsAllowForDd());
		params.put("ddlChnl", vo.getDdlChnl());
		params.put("refId", vo.getRefId());
		params.put("contactNumber", vo.getContactNumber());
		params.put("callPrgm", vo.getCallPrgm());
		params.put("custId", vo.getCustId());
		params.put("searchWord", vo.getSearchWord());
		params.put("custCntcId", vo.getCustCntcId());
		params.put("custAddId", vo.getCustAddId());
		params.put("sofNo", vo.getSofNo());
		params.put("selType", vo.getSelType());
		params.put("stkType", vo.getStkType());
		params.put("srvPacId", vo.getSrvPacId());
		params.put("productType", vo.getProductType());
		params.put("stkId", vo.getStkId());
		params.put("isHomecare", vo.getIsHomecare());
		params.put("isAC", vo.getIsAC());
		params.put("product", vo.getProduct());
		params.put("appTypeId", vo.getAppTypeId());
		params.put("product1", vo.getProduct1());
		params.put("product2", vo.getProduct2());
		params.put("arrPreOrdStusId", vo.getArrPreOrdStusId());
		params.put("_memCode", vo.getMemCode());
		params.put("_sofNo", vo.getSofNo());
		params.put("_reqstStartDt", vo.getReqstStartDt());
		params.put("_reqstEndDt", vo.getReqstEndDt());
		params.put("orgCode", vo.getOrgCode());
		params.put("grpCode", vo.getGrpCode());
		params.put("deptCode", vo.getDeptCode());
		params.put("_ordNo", vo.getOrdNo());
		params.put("promoId", vo.getPromoId());
		params.put("insCustId", vo.getInsCustId());
		params.put("stusId", vo.getStusId());
		params.put("addrRem", vo.getAddrRem());
		params.put("areaId", vo.getAreaId());
		params.put("addrDtl", vo.getAddrDtl());
		params.put("streetDtl", vo.getStreetDtl());
		params.put("userId", vo.getUserId());
		params.put("bankCustAccNo", vo.getBankCustAccNo());
		params.put("bankCustAccOwner", vo.getBankCustAccOwner());
		params.put("bankCustAccTypeId", vo.getBankCustAccTypeId());
		params.put("bankCustAccBankId", vo.getBankCustAccBankId());
		params.put("bankCustAccBankBrnch", vo.getBankCustAccBankBrnch());
		params.put("bankCustAccRem", vo.getBankCustAccRem());
		params.put("custCrcId", vo.getCustCrcId());
		params.put("custOriCrcNo", vo.getCustOriCrcNo());
		params.put("custCrcOwner", vo.getCustCrcOwner());
		params.put("custCrcTypeId", vo.getCustCrcTypeId());
		params.put("custCrcBankId", vo.getCustCrcBankId());
		params.put("custCrcRem", vo.getCustCrcRem());
		params.put("cardExpr", vo.getCardExpr());
		params.put("cardTypeId", vo.getCardTypeId());
		params.put("tknId", vo.getTknId());
		params.put("refNo", vo.getRefNo());
		params.put("cntcName", vo.getCntcName());
		params.put("cntcInitial", vo.getCntcInitial());
		params.put("cntcNric", vo.getCntcNric());
		params.put("cntcPos", vo.getCntcPos());
		params.put("cntcTelm", vo.getCntcTelm());
		params.put("cntcTelo", vo.getCntcTelo());
		params.put("cntcTelr", vo.getCntcTelr());
		params.put("cntcTelf", vo.getCntcTelf());
		params.put("cntcDob", vo.getCntcDob());
		params.put("cntcGender", vo.getCntcGender());
		params.put("cntcCmbRaceTypeId", vo.getCntcCmbRaceTypeId());
		params.put("cntcEmail", vo.getCntcEmail());
		params.put("cntcDept", vo.getCntcDept());
		params.put("cntcExpno", vo.getCntcExpno());
		params.put("userTypeId", vo.getUserTypeId());
		params.put("preOrdId", vo.getPreOrdId());
		params.put("atchFileGrpId", vo.getAtchFileGrpId());

		return params;
	}




	/*
	 * */

    public String searchStreet;
    public String getSearchStreet() {
		return searchStreet;
	}
	public void setSearchStreet(String searchStreet) {
		this.searchStreet = searchStreet;
	}
	public String getState() {
		return state;
	}
	public void setState(String state) {
		this.state = state;
	}
	public String getCity() {
		return city;
	}
	public void setCity(String city) {
		this.city = city;
	}
	public String getPostCode() {
		return postCode;
	}
	public void setPostCode(String postCode) {
		this.postCode = postCode;
	}
	public String getGroupCode() {
		return groupCode;
	}
	public void setGroupCode(String groupCode) {
		this.groupCode = groupCode;
	}
	public String getIsAllowForDd() {
		return isAllowForDd;
	}
	public void setIsAllowForDd(String isAllowForDd) {
		this.isAllowForDd = isAllowForDd;
	}
	public String getDdlChnl() {
		return ddlChnl;
	}
	public void setDdlChnl(String ddlChnl) {
		this.ddlChnl = ddlChnl;
	}
    public String getRefId() {
		return refId;
	}
	public void setRefId(String refId) {
		this.refId = refId;
	}
	public String getContactNumber() {
		return contactNumber;
	}
	public void setContactNumber(String contactNumber) {
		this.contactNumber = contactNumber;
	}
	public String getCallPrgm() {
		return callPrgm;
	}
	public void setCallPrgm(String callPrgm) {
		this.callPrgm = callPrgm;
	}
	public String getCustId() {
		return custId;
	}
	public void setCustId(String custId) {
		this.custId = custId;
	}
	public String getSearchWord() {
		return searchWord;
	}
	public void setSearchWord(String searchWord) {
		this.searchWord = searchWord;
	}
	public String getCustCntcId() {
		return custCntcId;
	}
	public void setCustCntcId(String custCntcId) {
		this.custCntcId = custCntcId;
	}
	public String getCustAddId() {
		return custAddId;
	}
	public void setCustAddId(String custAddId) {
		this.custAddId = custAddId;
	}
	public String getSofNo() {
		return sofNo;
	}
	public void setSofNo(String sofNo) {
		this.sofNo = sofNo;
	}
	public String getSelType() {
		return selType;
	}
	public void setSelType(String selType) {
		this.selType = selType;
	}
	public String getStkType() {
		return stkType;
	}
	public void setStkType(String stkType) {
		this.stkType = stkType;
	}
	public String getSrvPacId() {
		return srvPacId;
	}
	public void setSrvPacId(String srvPacId) {
		this.srvPacId = srvPacId;
	}
	public String getProductType() {
		return productType;
	}
	public void setProductType(String productType) {
		this.productType = productType;
	}
	public String getStkId() {
		return stkId;
	}
	public void setStkId(String stkId) {
		this.stkId = stkId;
	}
	public String getIsHomecare() {
		return isHomecare;
	}
	public void setIsHomecare(String isHomecare) {
		this.isHomecare = isHomecare;
	}
	public String getIsAC() {
		return isAC;
	}
	public void setIsAC(String isAC) {
		this.isAC = isAC;
	}
	public String getProduct() {
		return product;
	}
	public void setProduct(String product) {
		this.product = product;
	}
	public String getAppTypeId() {
		return appTypeId;
	}
	public void setAppTypeId(String appTypeId) {
		this.appTypeId = appTypeId;
	}
	public String getProduct1() {
		return product1;
	}
	public void setProduct1(String product1) {
		this.product1 = product1;
	}
	public String getProduct2() {
		return product2;
	}
	public void setProduct2(String product2) {
		this.product2 = product2;
	}
	public String getMemCode() {
		return memCode;
	}
	public void setMemCode(String _memCode) {
		this.memCode = _memCode;
	}
	public String getReqstStartDt() {
		return reqstStartDt;
	}
	public void setReqstStartDt(String _reqstStartDt) {
		this.reqstStartDt = _reqstStartDt;
	}
	public String getReqstEndDt() {
		return reqstEndDt;
	}
	public void setReqstEndDt(String _reqstEndDt) {
		this.reqstEndDt = _reqstEndDt;
	}
	public String[] getArrPreOrdStusId() {

		if(null != arrPreOrdStusId){
			return arrPreOrdStusId.toArray(new String[arrPreOrdStusId.size()]);
		}else{

			return null;
		}
	}
	public void setArrPreOrdStusId(List<String> arrPreOrdStusId) {
		this.arrPreOrdStusId = arrPreOrdStusId;
	}
	public String getOrgCode() {
		return orgCode;
	}
	public void setOrgCode(String orgCode) {
		this.orgCode = orgCode;
	}
	public String getGrpCode() {
		return grpCode;
	}
	public void setGrpCode(String grpCode) {
		this.grpCode = grpCode;
	}
	public String getDeptCode() {
		return deptCode;
	}
	public void setDeptCode(String deptCode) {
		this.deptCode = deptCode;
	}
	public String getOrdNo() {
		return ordNo;
	}
	public void setOrdNo(String ordNo) {
		this.ordNo = ordNo;
	}
	public String getPromoId() {
		return promoId;
	}
	public void setPromoId(String promoId) {
		this.promoId = promoId;
	}
	public String getInsCustId() {
		return insCustId;
	}
	public void setInsCustId(String insCustId) {
		this.insCustId = insCustId;
	}
	public String getStusId() {
		return stusId;
	}
	public void setStusId(String stusId) {
		this.stusId = stusId;
	}
	public String getAddrRem() {
		return addrRem;
	}
	public void setAddrRem(String addrRem) {
		this.addrRem = addrRem;
	}
	public String getAreaId() {
		return areaId;
	}
	public void setAreaId(String areaId) {
		this.areaId = areaId;
	}
	public String getAddrDtl() {
		return addrDtl;
	}
	public void setAddrDtl(String addrDtl) {
		this.addrDtl = addrDtl;
	}
	public String getStreetDtl() {
		return streetDtl;
	}
	public void setStreetDtl(String streetDtl) {
		this.streetDtl = streetDtl;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getBankCustAccNo() {
		return bankCustAccNo;
	}
	public void setBankCustAccNo(String bankCustAccNo) {
		this.bankCustAccNo = bankCustAccNo;
	}
	public String getBankCustAccOwner() {
		return bankCustAccOwner;
	}
	public void setBankCustAccOwner(String bankCustAccOwner) {
		this.bankCustAccOwner = bankCustAccOwner;
	}
	public String getBankCustAccTypeId() {
		return bankCustAccTypeId;
	}
	public void setBankCustAccTypeId(String bankCustAccTypeId) {
		this.bankCustAccTypeId = bankCustAccTypeId;
	}
	public String getBankCustAccBankId() {
		return bankCustAccBankId;
	}
	public void setBankCustAccBankId(String bankCustAccBankId) {
		this.bankCustAccBankId = bankCustAccBankId;
	}
	public String getBankCustAccBankBrnch() {
		return bankCustAccBankBrnch;
	}
	public void setBankCustAccBankBrnch(String bankCustAccBankBrnch) {
		this.bankCustAccBankBrnch = bankCustAccBankBrnch;
	}
	public String getBankCustAccRem() {
		return bankCustAccRem;
	}
	public void setBankCustAccRem(String bankCustAccRem) {
		this.bankCustAccRem = bankCustAccRem;
	}
	public String getCustCrcId() {
		return custCrcId;
	}
	public void setCustCrcId(String custCrcId) {
		this.custCrcId = custCrcId;
	}
	public String getCustOriCrcNo() {
		return custOriCrcNo;
	}
	public void setCustOriCrcNo(String custOriCrcNo) {
		this.custOriCrcNo = custOriCrcNo;
	}
	public String getCustCrcOwner() {
		return custCrcOwner;
	}
	public void setCustCrcOwner(String custCrcOwner) {
		this.custCrcOwner = custCrcOwner;
	}
	public String getCustCrcTypeId() {
		return custCrcTypeId;
	}
	public void setCustCrcTypeId(String custCrcTypeId) {
		this.custCrcTypeId = custCrcTypeId;
	}
	public String getCustCrcBankId() {
		return custCrcBankId;
	}
	public void setCustCrcBankId(String custCrcBankId) {
		this.custCrcBankId = custCrcBankId;
	}
	public String getCustCrcRem() {
		return custCrcRem;
	}
	public void setCustCrcRem(String custCrcRem) {
		this.custCrcRem = custCrcRem;
	}
	public String getCardExpr() {
		return cardExpr;
	}
	public void setCardExpr(String cardExpr) {
		this.cardExpr = cardExpr;
	}
	public String getCardTypeId() {
		return cardTypeId;
	}
	public void setCardTypeId(String cardTypeId) {
		this.cardTypeId = cardTypeId;
	}
	public String getTknId() {
		return tknId;
	}
	public void setTknId(String tknId) {
		this.tknId = tknId;
	}
	public String getRefNo() {
		return refNo;
	}
	public void setRefNo(String refNo) {
		this.refNo = refNo;
	}
	public String getCntcName() {
		return cntcName;
	}
	public void setCntcName(String cntcName) {
		this.cntcName = cntcName;
	}
	public String getCntcInitial() {
		return cntcInitial;
	}
	public void setCntcInitial(String cntcInitial) {
		this.cntcInitial = cntcInitial;
	}
	public String getCntcNric() {
		return cntcNric;
	}
	public void setCntcNric(String cntcNric) {
		this.cntcNric = cntcNric;
	}
	public String getCntcPos() {
		return cntcPos;
	}
	public void setCntcPos(String cntcPos) {
		this.cntcPos = cntcPos;
	}
	public String getCntcTelm() {
		return cntcTelm;
	}
	public void setCntcTelm(String cntcTelm) {
		this.cntcTelm = cntcTelm;
	}
	public String getCntcTelo() {
		return cntcTelo;
	}
	public void setCntcTelo(String cntcTelo) {
		this.cntcTelo = cntcTelo;
	}
	public String getCntcTelr() {
		return cntcTelr;
	}
	public void setCntcTelr(String cntcTelr) {
		this.cntcTelr = cntcTelr;
	}
	public String getCntcTelf() {
		return cntcTelf;
	}
	public void setCntcTelf(String cntcTelf) {
		this.cntcTelf = cntcTelf;
	}
	public String getCntcDob() {
		return cntcDob;
	}
	public void setCntcDob(String cntcDob) {
		this.cntcDob = cntcDob;
	}
	public String getCntcGender() {
		return cntcGender;
	}
	public void setCntcGender(String cntcGender) {
		this.cntcGender = cntcGender;
	}
	public String getCntcCmbRaceTypeId() {
		return cntcCmbRaceTypeId;
	}
	public void setCntcCmbRaceTypeId(String cntcCmbRaceTypeId) {
		this.cntcCmbRaceTypeId = cntcCmbRaceTypeId;
	}
	public String getCntcEmail() {
		return cntcEmail;
	}
	public void setCntcEmail(String cntcEmail) {
		this.cntcEmail = cntcEmail;
	}
	public String getCntcDept() {
		return cntcDept;
	}
	public void setCntcDept(String cntcDept) {
		this.cntcDept = cntcDept;
	}
	public String getCntcExpno() {
		return cntcExpno;
	}
	public void setCntcExpno(String cntcExpno) {
		this.cntcExpno = cntcExpno;
	}
	public String getUserTypeId() {
		return userTypeId;
	}
	public void setUserTypeId(String userTypeId) {
		this.userTypeId = userTypeId;
	}
	public String getPreOrdId() {
		return preOrdId;
	}
	public void setPreOrdId(String preOrdId) {
		this.preOrdId = preOrdId;
	}
	public String getAtchFileGrpId() {
		return atchFileGrpId;
	}
	public void setAtchFileGrpId(String atchFileGrpId) {
		this.atchFileGrpId = atchFileGrpId;
	}


	public String state;
    public String city;
    public String postCode;
    public String groupCode;
    public String isAllowForDd;
    public String ddlChnl;
	public String refId;
	public String contactNumber;
    public String callPrgm;
	public String custId;
	public String searchWord;
    public String custCntcId;
	public String custAddId;
	public String sofNo;
	public String selType;
	public String stkType;
	public String srvPacId;
	public String productType;
	public String stkId;
	public String isHomecare;
	public String isAC;
	public String product;
	public String product1;
	public String product2;
	public String appTypeId;
	public List<String> arrPreOrdStusId;
	public String memCode;
	public String reqstStartDt;
	public String reqstEndDt;
	public String orgCode;
	public String grpCode;
	public String deptCode;
	public String ordNo;
	public String promoId;
	public String insCustId;
	public String stusId;
	public String addrRem;
	public String areaId;
	public String addrDtl;
	public String streetDtl;
	public String userId;
	public String bankCustAccNo;
	public String bankCustAccOwner;
	public String bankCustAccTypeId;
	public String bankCustAccBankId;
	public String bankCustAccBankBrnch;
	public String bankCustAccRem;
	public String custCrcId;
	public String custOriCrcNo;
	public String custCrcOwner;
	public String custCrcTypeId;
	public String custCrcBankId;
	public String custCrcRem;
	public String cardExpr;
	public String cardTypeId;
	public String tknId;
	public String refNo;
	public String cntcName;
	public String cntcInitial;
	public String cntcNric;
	public String cntcPos;
	public String cntcTelm;
	public String cntcTelo;
	public String cntcTelr;
	public String cntcTelf;
	public String cntcDob;
	public String cntcGender;
	public String cntcCmbRaceTypeId;
	public String cntcEmail;
	public String cntcDept;
	public String cntcExpno;
	public String userTypeId;
	public String preOrdId;
	public String atchFileGrpId;

}
