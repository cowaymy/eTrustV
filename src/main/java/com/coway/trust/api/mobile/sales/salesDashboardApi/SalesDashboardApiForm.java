package com.coway.trust.api.mobile.sales.salesDashboardApi;

import java.util.HashMap;
import java.util.Map;

import com.coway.trust.util.BeanConverter;

import io.swagger.annotations.ApiModel;


/**
 * @ClassName : SalesDashboardApiForm.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 12. 23.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
@ApiModel(value = "SalesDashboardApiForm", description = "SalesDashboardApiForm")
public class SalesDashboardApiForm {



    public static SalesDashboardApiForm create(Map<String, Object> customerMap) {
        return BeanConverter.toBean(customerMap, SalesDashboardApiForm.class);
    }



	public static Map<String, Object> createMap(SalesDashboardApiForm vo){
		Map<String, Object> params = new HashMap<>();
		params.put("memId", vo.getMemId());
		return params;
	}



	private int memId;



    public int getMemId() {
        return memId;
    }



    public void setMemId(int memId) {
        this.memId = memId;
    }

}
