package com.coway.trust.api.mobile.sales.epapanApi;

import java.util.HashMap;
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


}
