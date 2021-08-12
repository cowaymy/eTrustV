package com.coway.trust.api.mobile.sales.expiringCustomerApi;

import java.util.List;

import com.coway.trust.util.BeanConverter;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;


/**
 * @ClassName : ExpiringCustomerApiDto.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 12. 30.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
@ApiModel(value = "ExpiringCustomerApiDto", description = "ExpiringCustomerApiDto")
@JsonIgnoreProperties(ignoreUnknown = true)
public class ExpiringCustomerApiDto{



	@SuppressWarnings("unchecked")
    public static ExpiringCustomerApiDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, ExpiringCustomerApiDto.class);
	}


	private List<ExpiringCustomerApiDto> detailList;
	private int id;
	private int memId;
	private String memCode;
	private int memType;
	private String year;
	private String month;
	private int salesOrdId;
	private String salesOrdNo;
	private String srvExprDt;
	private int srvExprMth;
	private String custName;
	private int custId;
	private String email;
	private String telM;
	private String salesDt;
	private int stusCodeId;
	private String stusCodeIdName;
	private int appTypeId;
	private String appTypeIdName;
	private String stkCode;
	private String stkDesc;
	private String addr;



    public List<ExpiringCustomerApiDto> getDetailList() {
        return detailList;
    }
    public void setDetailList(List<ExpiringCustomerApiDto> detailList) {
        this.detailList = detailList;
    }
    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }
    public int getMemId() {
        return memId;
    }
    public void setMemId(int memId) {
        this.memId = memId;
    }
    public String getMemCode() {
        return memCode;
    }
    public void setMemCode(String memCode) {
        this.memCode = memCode;
    }
    public int getMemType() {
        return memType;
    }
    public void setMemType(int memType) {
        this.memType = memType;
    }
    public String getYear() {
        return year;
    }
    public void setYear(String year) {
        this.year = year;
    }
    public String getMonth() {
        return month;
    }
    public void setMonth(String month) {
        this.month = month;
    }
    public int getSalesOrdId() {
        return salesOrdId;
    }
    public void setSalesOrdId(int salesOrdId) {
        this.salesOrdId = salesOrdId;
    }
    public String getSalesOrdNo() {
        return salesOrdNo;
    }
    public void setSalesOrdNo(String salesOrdNo) {
        this.salesOrdNo = salesOrdNo;
    }
    public String getSrvExprDt() {
        return srvExprDt;
    }
    public void setSrvExprDt(String srvExprDt) {
        this.srvExprDt = srvExprDt;
    }
    public int getSrvExprMth() {
        return srvExprMth;
    }
    public void setSrvExprMth(int srvExprMth) {
        this.srvExprMth = srvExprMth;
    }
    public String getCustName() {
        return custName;
    }
    public void setCustName(String custName) {
        this.custName = custName;
    }
    public int getCustId() {
        return custId;
    }
    public void setCustId(int custId) {
        this.custId = custId;
    }
    public String getEmail() {
        return email;
    }
    public void setEmail(String email) {
        this.email = email;
    }
    public String getTelM() {
        return telM;
    }
    public void setTelM(String telM) {
        this.telM = telM;
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
    public String getStkCode() {
        return stkCode;
    }
    public void setStkCode(String stkCode) {
        this.stkCode = stkCode;
    }
    public String getStkDesc() {
        return stkDesc;
    }
    public void setStkDesc(String stkDesc) {
        this.stkDesc = stkDesc;
    }
    public String getAddr() {
        return addr;
    }
    public void setAddr(String addr) {
        this.addr = addr;
    }
}
