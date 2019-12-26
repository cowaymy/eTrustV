package com.coway.trust.api.mobile.sales.SalesDashboardApi;

import com.coway.trust.util.BeanConverter;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;


/**
 * @ClassName : SalesDashboardApiDto.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 12. 23.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
@ApiModel(value = "SalesDashboardApiDto", description = "SalesDashboardApiDto")
@JsonIgnoreProperties(ignoreUnknown = true)
public class SalesDashboardApiDto{



	@SuppressWarnings("unchecked")
	public SalesDashboardApiDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, SalesDashboardApiDto.class);
	}



	private int id;
	private int memId;
	private String memCode;
	private int memType;
	private String year;
	private String month;
	private int totSales;
	private int netSales;
	private int shi;
	private int pvTot;
	private int ownPurchase;
	private int hsSuccessRate;
	private int collectionRate;
	private int rejoin;
	private int membership;
	private int updUserId;
	private String updDt;

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
    public int getTotSales() {
        return totSales;
    }
    public void setTotSales(int totSales) {
        this.totSales = totSales;
    }
    public int getNetSales() {
        return netSales;
    }
    public void setNetSales(int netSales) {
        this.netSales = netSales;
    }
    public int getShi() {
        return shi;
    }
    public void setShi(int shi) {
        this.shi = shi;
    }
    public int getPvTot() {
        return pvTot;
    }
    public void setPvTot(int pvTot) {
        this.pvTot = pvTot;
    }
    public int getOwnPurchase() {
        return ownPurchase;
    }
    public void setOwnPurchase(int ownPurchase) {
        this.ownPurchase = ownPurchase;
    }
    public int getHsSuccessRate() {
        return hsSuccessRate;
    }
    public void setHsSuccessRate(int hsSuccessRate) {
        this.hsSuccessRate = hsSuccessRate;
    }
    public int getCollectionRate() {
        return collectionRate;
    }
    public void setCollectionRate(int collectionRate) {
        this.collectionRate = collectionRate;
    }
    public int getRejoin() {
        return rejoin;
    }
    public void setRejoin(int rejoin) {
        this.rejoin = rejoin;
    }
    public int getMembership() {
        return membership;
    }
    public void setMembership(int membership) {
        this.membership = membership;
    }
    public int getUpdUserId() {
        return updUserId;
    }
    public void setUpdUserId(int updUserId) {
        this.updUserId = updUserId;
    }
    public String getUpdDt() {
        return updDt;
    }
    public void setUpdDt(String updDt) {
        this.updDt = updDt;
    }
}
