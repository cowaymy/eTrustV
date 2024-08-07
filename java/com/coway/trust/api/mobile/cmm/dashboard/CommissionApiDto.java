package com.coway.trust.api.mobile.cmm.dashboard;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;


/**
 * @ClassName : CommissionApiDto.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date            Author          Description
 * -------------   -----------     -------------
 * 2019. 11. 05.   KR-JAEMJAEM:)   First creation
 * </pre>
 */
@ApiModel(value = "CommissionApiDto", description = "CommissionApiDto")
public class CommissionApiDto {



	@SuppressWarnings("unchecked")
	public static CommissionApiDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, CommissionApiDto.class);
	}



	private String mmYyyy;
	private String btnNm;
	private int val;
	private int valSum;
	private int valPercentage;



    public String getMmYyyy() {
        return mmYyyy;
    }
    public void setMmYyyy(String mmYyyy) {
        this.mmYyyy = mmYyyy;
    }
    public String getBtnNm() {
        return btnNm;
    }
    public void setBtnNm(String btnNm) {
        this.btnNm = btnNm;
    }
    public int getVal() {
        return val;
    }
    public void setVal(int val) {
        this.val = val;
    }
    public int getValSum() {
        return valSum;
    }
    public void setValSum(int valSum) {
        this.valSum = valSum;
    }
    public int getValPercentage() {
        return valPercentage;
    }
    public void setValPercentage(int valPercentage) {
        this.valPercentage = valPercentage;
    }
}
