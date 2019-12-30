package com.coway.trust.api.mobile.sales.salesDashboardApi;

import java.math.BigDecimal;

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
	private BigDecimal totSales;
	private BigDecimal netSales;
	private BigDecimal shi;
	private BigDecimal pvTot;
	private BigDecimal ownPurchase;
	private BigDecimal hsSuccessRate;
	private BigDecimal collectionRate;
	private BigDecimal rejoin;
	private BigDecimal membership;
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
    public BigDecimal getTotSales() {
        return totSales;
    }
    public void setTotSales(BigDecimal totSales) {
        this.totSales = totSales;
    }
    public BigDecimal getNetSales() {
        return netSales;
    }
    public void setNetSales(BigDecimal netSales) {
        this.netSales = netSales;
    }
    public BigDecimal getShi() {
        return shi;
    }
    public void setShi(BigDecimal shi) {
        this.shi = shi;
    }
    public BigDecimal getPvTot() {
        return pvTot;
    }
    public void setPvTot(BigDecimal pvTot) {
        this.pvTot = pvTot;
    }
    public BigDecimal getOwnPurchase() {
        return ownPurchase;
    }
    public void setOwnPurchase(BigDecimal ownPurchase) {
        this.ownPurchase = ownPurchase;
    }
    public BigDecimal getHsSuccessRate() {
        return hsSuccessRate;
    }
    public void setHsSuccessRate(BigDecimal hsSuccessRate) {
        this.hsSuccessRate = hsSuccessRate;
    }
    public BigDecimal getCollectionRate() {
        return collectionRate;
    }
    public void setCollectionRate(BigDecimal collectionRate) {
        this.collectionRate = collectionRate;
    }
    public BigDecimal getRejoin() {
        return rejoin;
    }
    public void setRejoin(BigDecimal rejoin) {
        this.rejoin = rejoin;
    }
    public BigDecimal getMembership() {
        return membership;
    }
    public void setMembership(BigDecimal membership) {
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
