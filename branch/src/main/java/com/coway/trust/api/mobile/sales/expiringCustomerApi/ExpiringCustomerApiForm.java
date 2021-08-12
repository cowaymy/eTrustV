package com.coway.trust.api.mobile.sales.expiringCustomerApi;

import java.util.HashMap;
import java.util.Map;

import com.coway.trust.util.BeanConverter;

import io.swagger.annotations.ApiModel;


/**
 * @ClassName : ExpiringCustomerApiForm.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 12. 30.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
@ApiModel(value = "ExpiringCustomerApiForm", description = "ExpiringCustomerApiForm")
public class ExpiringCustomerApiForm {



    public static ExpiringCustomerApiForm create(Map<String, Object> map) {
        return BeanConverter.toBean(map, ExpiringCustomerApiForm.class);
    }



	public static Map<String, Object> createMap(ExpiringCustomerApiForm vo){
		Map<String, Object> params = new HashMap<>();
		params.put("memId", vo.getMemId());
        params.put("srvExprMth", vo.getSrvExprMth());
        params.put("id", vo.getId());
        params.put("custId", vo.getCustId());
		return params;
	}



	private int memId;
	private int srvExprMth;
	private int id;
	private int custId;



    public int getMemId() {
        return memId;
    }



    public void setMemId(int memId) {
        this.memId = memId;
    }



    public int getSrvExprMth() {
        return srvExprMth;
    }



    public void setSrvExprMth(int srvExprMth) {
        this.srvExprMth = srvExprMth;
    }



    public int getId() {
        return id;
    }



    public void setId(int id) {
        this.id = id;
    }



    public int getCustId() {
        return custId;
    }



    public void setCustId(int custId) {
        this.custId = custId;
    }
}
