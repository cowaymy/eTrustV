package com.coway.trust.api.mobile.services.serviceDashboardApi;

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
@ApiModel(value = "ServiceDashboardApiForm", description = "ServiceDashboardApiForm")
public class ServiceDashboardApiForm {



    public static ServiceDashboardApiForm create(Map<String, Object> customerMap) {
        return BeanConverter.toBean(customerMap, ServiceDashboardApiForm.class);
    }


	public static Map<String, Object> createMap(ServiceDashboardApiForm vo){
		Map<String, Object> params = new HashMap<>();
		params.put("memId", vo.getMemId());
		params.put("regId", vo.getRegId());
		return params;
	}



	private int memId;
	private String regId;

    public int getMemId() {
        return memId;
    }

    public void setMemId(int memId) {
        this.memId = memId;
    }

    public String getRegId() {
        return regId;
    }

    public void setRegId(String regId) {
        this.regId = regId;
    }


}
