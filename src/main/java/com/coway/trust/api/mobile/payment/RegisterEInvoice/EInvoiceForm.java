package com.coway.trust.api.mobile.payment.RegisterEInvoice;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.commons.codec.binary.Base64;
import com.coway.trust.util.BeanConverter;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

/**
 * @ClassName : RegisterEInvoiceForm.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 1.   KR-HAN        First creation
 * </pre>
 */
@ApiModel(value = "EInvoiceForm", description = "E-Invoice Form")
public class EInvoiceForm {

	@ApiModelProperty(value = "userId 예)1 ", example = "1")
	private String userId;

	@ApiModelProperty(value = "searchType 예)1 ", example = "1")
	private String searchType;

	@ApiModelProperty(value = "searchKeyword 예)0030784", example = "0030784")
	private String searchKeyword;

	@ApiModelProperty(value = "custId 예)0030784", example = "0030784")
	private int custId;

	@ApiModelProperty(value = "salesOrdNo 예)0030784", example = "0030784")
	private int salesOrdNo;

	@ApiModelProperty(value = "emailAddr 예)test@tset.com", example = "test@tset.com")
	private String emailAddr;

	@ApiModelProperty(value = "addEmailAddr 예)test@test.com", example = "test@test.com")
	private String addEmailAddr;

	@ApiModelProperty(value = "agreeYN 예)Y", example = "Y")
	private String agreeYN;

	@ApiModelProperty(value = "base64 Data")
	private String signData;

	@ApiModelProperty(value = "transitDate 예)Y", example = "Y")
	private String transitDate;

	public String getAgreeYN() {
		return agreeYN;
	}

	public void setAgreeYN(String agreeYN) {
		this.agreeYN = agreeYN;
	}

	public String getSignData() {
		return signData;
	}

	public void setSignData(String signData) {
		this.signData = signData;
	}

	public String getTransitDate() {
		return transitDate;
	}

	public void setTransitDate(String transitDate) {
		this.transitDate = transitDate;
	}

	public int getCustId() {
		return custId;
	}

	public String getEmailAddr() {
		return emailAddr;
	}

	public void setEmailAddr(String emailAddr) {
		this.emailAddr = emailAddr;
	}

	public String getAddEmailAddr() {
		return addEmailAddr;
	}

	public void setAddEmailAddr(String addEmailAddr) {
		this.addEmailAddr = addEmailAddr;
	}

	public void setCustId(int custId) {
		this.custId = custId;
	}

	public int getSalesOrdNo() {
		return salesOrdNo;
	}

	public void setSalesOrdNo(int salesOrdNo) {
		this.salesOrdNo = salesOrdNo;
	}

	public String getSearchKeyword() {
		return searchKeyword;
	}

	public void setSearchKeyword(String searchKeyword) {
		this.searchKeyword = searchKeyword;
	}

	public String getSearchType() {
		return searchType;
	}

	public void setSearchType(String searchType) {
		this.searchType = searchType;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public List<Map<String, Object>> createMaps(EInvoiceForm eInvoiceForm) {

		List<Map<String, Object>> list = new ArrayList<>();
			Map<String, Object> map;

//			for(InstallationResultForm form : installationResultForm){
////				map = BeanConverter.toMap(installationResultForm, "signData");
////				map.put("signData", Base64.decodeBase64(installationResultForm.getSignData()));
//
//				list.add(map);
//			}
				map = BeanConverter.toMap(eInvoiceForm, "signData");
				map.put("signData", Base64.decodeBase64(eInvoiceForm.getSignData()));

				// install Result



				map.put("userId",   				eInvoiceForm.getUserId());
				map.put("searchType",   		eInvoiceForm.getSearchType());
				map.put("searchKeyword",   	eInvoiceForm.getSearchKeyword());
				map.put("custId",   				eInvoiceForm.getCustId());
				map.put("salesOrdNo",   		eInvoiceForm.getSearchKeyword());

				map.put("emailAddr",   			eInvoiceForm.getEmailAddr());
				map.put("addEmailAddr",   		eInvoiceForm.getAddEmailAddr());
				map.put("agreeYN",   			eInvoiceForm.getAgreeYN());
				map.put("transitDate",   		eInvoiceForm.getTransitDate());

				list.add(map);

				return list;
	}

	public static Map<String, Object> createMap1(EInvoiceForm eInvoiceForm){
		Map<String, Object> params;
		params = BeanConverter.toMap(eInvoiceForm, "signData");

		params.put("userId",   				eInvoiceForm.getUserId());
		params.put("searchType",   		eInvoiceForm.getSearchType());
		params.put("searchKeyword",   	eInvoiceForm.getSearchKeyword());
		params.put("custId",   				eInvoiceForm.getCustId());
		params.put("salesOrdNo",   		eInvoiceForm.getSearchKeyword());

		params.put("emailAddr",   			eInvoiceForm.getEmailAddr());
		params.put("addEmailAddr",   		eInvoiceForm.getAddEmailAddr());
		params.put("agreeYN",   			eInvoiceForm.getAgreeYN());
//		params.put("signData",   			Base64.decodeBase64( eInvoiceForm.getSignData()) );
		params.put("signData",   			eInvoiceForm.getSignData() );
		params.put("transitDate",   		eInvoiceForm.getTransitDate());

		return params;
	}



}
