package com.coway.trust.api.mobile.sales.productInfoListApi;

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
@ApiModel(value = "ProductInfoListApiForm", description = "ProductInfoListApiForm")
public class ProductInfoListApiForm {



	public static Map<String, Object> createMap(ProductInfoListApiForm vo){
		Map<String, Object> params = new HashMap<>();
		params.put("stkCtgryId", vo.getStkCtgryId());
		return params;
	}



	private int stkCtgryId;



    public int getStkCtgryId() {
        return stkCtgryId;
    }



    public void setStkCtgryId(int stkCtgryId) {
        this.stkCtgryId = stkCtgryId;
    }
}
