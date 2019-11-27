package com.coway.trust.api.mobile.sales.productInfoListApi;

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
	private int stkCommAs;
	private int stkCommBs;
	private int stkCommIns;
	private int stkTypeId;
	private int monthlyRental;
	private int prcRpf;
	private int normalPrice;
	private int pointOfValue;
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



    public int getStkCommAs() {
        return stkCommAs;
    }



    public void setStkCommAs(int stkCommAs) {
        this.stkCommAs = stkCommAs;
    }



    public int getStkCommBs() {
        return stkCommBs;
    }



    public void setStkCommBs(int stkCommBs) {
        this.stkCommBs = stkCommBs;
    }



    public int getStkCommIns() {
        return stkCommIns;
    }



    public void setStkCommIns(int stkCommIns) {
        this.stkCommIns = stkCommIns;
    }



    public int getStkTypeId() {
        return stkTypeId;
    }



    public void setStkTypeId(int stkTypeId) {
        this.stkTypeId = stkTypeId;
    }



    public int getMonthlyRental() {
        return monthlyRental;
    }



    public void setMonthlyRental(int monthlyRental) {
        this.monthlyRental = monthlyRental;
    }



    public int getPrcRpf() {
        return prcRpf;
    }



    public void setPrcRpf(int prcRpf) {
        this.prcRpf = prcRpf;
    }



    public int getNormalPrice() {
        return normalPrice;
    }



    public void setNormalPrice(int normalPrice) {
        this.normalPrice = normalPrice;
    }



    public int getPointOfValue() {
        return pointOfValue;
    }



    public void setPointOfValue(int pointOfValue) {
        this.pointOfValue = pointOfValue;
    }



    public String getImgUrl() {
        return imgUrl;
    }



    public void setImgUrl(String imgUrl) {
        this.imgUrl = imgUrl;
    }
}
