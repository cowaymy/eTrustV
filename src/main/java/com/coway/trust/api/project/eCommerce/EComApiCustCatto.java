package com.coway.trust.api.project.eCommerce;

import java.util.HashMap;
import java.util.Map;

import com.coway.trust.api.project.common.CommonApiDto;
import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;


/**
 * @ClassName : EComApiCustCatto.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author             Description
 * -------------    -----------          -------------
 * 2024. 03. 19.    MY.HLTANG    First creation
 * </pre>
 */
@ApiModel(value = "EComApiCustCatto", description = "EComApiCustCatto")
public class EComApiCustCatto{

	@SuppressWarnings("unchecked")
	public static EComApiCustCatto create(Map<String, Object> egvoMap) {
		return BeanConverter.toBean(egvoMap, EComApiCustCatto.class);
	}

	 public static Map<String, Object> createMap(EComApiCustCatto eComApiDto){
	    Map<String, Object> params = new HashMap<>();
	    params.put("success", eComApiDto.getSuccess());
	    params.put("statusCode", eComApiDto.getStatusCode());
	    params.put("message", eComApiDto.getMessage());
	    params.put("custCatCode", eComApiDto.getCustCatCode());
	    params.put("custCatNm", eComApiDto.getCustCatNm());
	    return params;
	  }

	private Boolean success;
	private int statusCode;
	private String message;
	private String custCatCode;
	private String custCatNm;

	public Boolean getSuccess() {
		return success;
	}

	public void setSuccess(Boolean success) {
		this.success = success;
	}

	public int getStatusCode() {
		return statusCode;
	}

	public void setStatusCode(int statusCode) {
		this.statusCode = statusCode;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	public String getCustCatCode() {
		return custCatCode;
	}

	public void setCustCatCode(String custCatCode) {
		this.custCatCode = custCatCode;
	}

	public String getCustCatNm() {
		return custCatNm;
	}

	public void setCustCatNm(String custCatNm) {
		this.custCatNm = custCatNm;
	}



}
