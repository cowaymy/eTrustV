package com.coway.trust.api.mobile.sales.productInfoListApi;

import java.math.BigDecimal;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;


/**
 * @ClassName : ProductInfoListApiDto.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 11. 13.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
@ApiModel(value = "ProductInfoListApiDto", description = "ProductInfoListApiDto")
public class ProductInfoListApiDto {



	@SuppressWarnings("unchecked")
	public static ProductInfoListApiDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, ProductInfoListApiDto.class);
	}



	private int codeMasterId;
    private int codeId;
    private String code;
    private String codeName;
    private String codeDesc;
	private String stkCode;
	private String stkDesc;
	private int stkCtgryId;
	private String stkCtgryIdName;
	private BigDecimal stkCommAs;
	private BigDecimal stkCommBs;
	private BigDecimal stkCommIns;
	private int stkTypeId;
	private BigDecimal monthlyRental;
	private BigDecimal prcRpf;
	private BigDecimal normalPrice;
	private BigDecimal pointOfValue;
	private String imgUrl;

    public int getCodeMasterId() {
        return codeMasterId;
    }
    public void setCodeMasterId(int codeMasterId) {
        this.codeMasterId = codeMasterId;
    }
    public int getCodeId() {
        return codeId;
    }
    public void setCodeId(int codeId) {
        this.codeId = codeId;
    }
    public String getCode() {
        return code;
    }
    public void setCode(String code) {
        this.code = code;
    }
    public String getCodeName() {
        return codeName;
    }
    public void setCodeName(String codeName) {
        this.codeName = codeName;
    }
    public String getCodeDesc() {
        return codeDesc;
    }
    public void setCodeDesc(String codeDesc) {
        this.codeDesc = codeDesc;
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
    public int getStkCtgryId() {
        return stkCtgryId;
    }
    public void setStkCtgryId(int stkCtgryId) {
        this.stkCtgryId = stkCtgryId;
    }
    public String getStkCtgryIdName() {
        return stkCtgryIdName;
    }
    public void setStkCtgryIdName(String stkCtgryIdName) {
        this.stkCtgryIdName = stkCtgryIdName;
    }
    public BigDecimal getStkCommAs() {
        return stkCommAs;
    }
    public void setStkCommAs(BigDecimal stkCommAs) {
        this.stkCommAs = stkCommAs;
    }
    public BigDecimal getStkCommBs() {
        return stkCommBs;
    }
    public void setStkCommBs(BigDecimal stkCommBs) {
        this.stkCommBs = stkCommBs;
    }
    public BigDecimal getStkCommIns() {
        return stkCommIns;
    }
    public void setStkCommIns(BigDecimal stkCommIns) {
        this.stkCommIns = stkCommIns;
    }
    public int getStkTypeId() {
        return stkTypeId;
    }
    public void setStkTypeId(int stkTypeId) {
        this.stkTypeId = stkTypeId;
    }
    public BigDecimal getMonthlyRental() {
        return monthlyRental;
    }
    public void setMonthlyRental(BigDecimal monthlyRental) {
        this.monthlyRental = monthlyRental;
    }
    public BigDecimal getPrcRpf() {
        return prcRpf;
    }
    public void setPrcRpf(BigDecimal prcRpf) {
        this.prcRpf = prcRpf;
    }
    public BigDecimal getNormalPrice() {
        return normalPrice;
    }
    public void setNormalPrice(BigDecimal normalPrice) {
        this.normalPrice = normalPrice;
    }
    public BigDecimal getPointOfValue() {
        return pointOfValue;
    }
    public void setPointOfValue(BigDecimal pointOfValue) {
        this.pointOfValue = pointOfValue;
    }
    public String getImgUrl() {
        return imgUrl;
    }
    public void setImgUrl(String imgUrl) {
        this.imgUrl = imgUrl;
    }
}
