package com.coway.trust.api.mobile.sales.orderList;

import com.coway.trust.util.BeanConverter;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;


/**
 * @ClassName : OrderListApiDto.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 12. 23.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
@ApiModel(value = "OrderListApiDto", description = "OrderListApiDto")
@JsonIgnoreProperties(ignoreUnknown = true)
public class OrderListApiDto{



	@SuppressWarnings("unchecked")
	public static OrderListApiDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, OrderListApiDto.class);
	}



	private int salesOrdNo;
	private int custId;
	private String custIdName;
	private String salesDt;
	private int stusCodeId;
	private String stusCodeIdName;
	private int stkCode;
	private String stkDesc;
	private String prgrs;
	private int memId;
	private int appTypeId;
	private String appTypeIdName;
	private String hcGu;




    public String getHcGu() {
        return hcGu;
    }
    public void setHcGu(String hcGu) {
        this.hcGu = hcGu;
    }
    public int getSalesOrdNo() {
        return salesOrdNo;
    }
    public void setSalesOrdNo(int salesOrdNo) {
        this.salesOrdNo = salesOrdNo;
    }
    public int getCustId() {
        return custId;
    }
    public void setCustId(int custId) {
        this.custId = custId;
    }
    public String getCustIdName() {
        return custIdName;
    }
    public void setCustIdName(String custIdName) {
        this.custIdName = custIdName;
    }
    public String getSalesDt() {
        return salesDt;
    }
    public void setSalesDt(String salesDt) {
        this.salesDt = salesDt;
    }
    public int getStusCodeId() {
        return stusCodeId;
    }
    public void setStusCodeId(int stusCodeId) {
        this.stusCodeId = stusCodeId;
    }
    public String getStusCodeIdName() {
        return stusCodeIdName;
    }
    public void setStusCodeIdName(String stusCodeIdName) {
        this.stusCodeIdName = stusCodeIdName;
    }
    public int getStkCode() {
        return stkCode;
    }
    public void setStkCode(int stkCode) {
        this.stkCode = stkCode;
    }
    public String getStkDesc() {
        return stkDesc;
    }
    public void setStkDesc(String stkDesc) {
        this.stkDesc = stkDesc;
    }
    public String getPrgrs() {
        return prgrs;
    }
    public void setPrgrs(String prgrs) {
        this.prgrs = prgrs;
    }
    public int getMemId() {
        return memId;
    }
    public void setMemId(int memId) {
        this.memId = memId;
    }
    public int getAppTypeId() {
        return appTypeId;
    }
    public void setAppTypeId(int appTypeId) {
        this.appTypeId = appTypeId;
    }
    public String getAppTypeIdName() {
        return appTypeIdName;
    }
    public void setAppTypeIdName(String appTypeIdName) {
        this.appTypeIdName = appTypeIdName;
    }
}
