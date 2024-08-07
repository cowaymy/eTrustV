package com.coway.trust.api.project.eCommerce;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;


/**
 * @ClassName : EComApiCustCatForm.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2024. 03. 19.    MY-HLTANG   First creation
 * </pre>
 */
@ApiModel(value = "EComApiCustCatForm", description = "EComApiCustCatForm")
public class EComApiCustCatForm {


	public static Map<String, Object> createMap(EComApiCustCatForm ecomForm){
		Map<String, Object> params = new HashMap<>();
		params.put("custNric", ecomForm.getCustNric());
		return params;
	}

	public static Map<String, Object> createRegOrdMap(EComApiCustCatForm ecomForm){
    Map<String, Object> params = new HashMap<>();
    params.put("custNric", ecomForm.getCustNric());

    return params;
  }

	private String custNric;

	public String getCustNric() {
		return custNric;
	}

	public void setCustNric(String custNric) {
		this.custNric = custNric;
	}

}
