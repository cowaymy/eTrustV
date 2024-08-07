package com.coway.trust.api.mobile.sales.orderList;

import java.util.HashMap;
import java.util.Map;

import com.coway.trust.util.BeanConverter;

import io.swagger.annotations.ApiModel;


/**
 * @ClassName : OrderListApiForm.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 12. 23.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
@ApiModel(value = "OrderListApiForm", description = "OrderListApiForm")
public class OrderListApiForm {



    public static OrderListApiForm create(Map<String, Object> customerMap) {
        return BeanConverter.toBean(customerMap, OrderListApiForm.class);
    }



	public static Map<String, Object> createMap(OrderListApiForm vo){
		Map<String, Object> params = new HashMap<>();
		params.put("memId", vo.getMemId());
        params.put("salesDtFrom", vo.getSalesDtFrom());
        params.put("salesDtTo", vo.getSalesDtTo());
        params.put("selectType", vo.getSelectType());
        params.put("selectKeyword", vo.getSelectKeyword());
		return params;
	}



	private int memId;
	private String salesDtFrom;
    private String salesDtTo;
    private String selectType;
    private String selectKeyword;
    public int getMemId() {
        return memId;
    }



    public void setMemId(int memId) {
        this.memId = memId;
    }



    public String getSalesDtFrom() {
        return salesDtFrom;
    }



    public void setSalesDtFrom(String salesDtFrom) {
        this.salesDtFrom = salesDtFrom;
    }



    public String getSalesDtTo() {
        return salesDtTo;
    }



    public void setSalesDtTo(String salesDtTo) {
        this.salesDtTo = salesDtTo;
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
}
