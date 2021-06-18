package com.coway.trust.api.mobile.payment.payment;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

/**
 * @ClassName : PaymentDto.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 9. 30.   KR-HAN        First creation
 * </pre>
 */
@ApiModel(value = "PaymentDto", description = "Payment Dto")
public class PaymentDto {

    @ApiModelProperty(value = "salesOrdNo")
    private String salesOrdNo;

    @ApiModelProperty(value = "custName")
    private String custName;

    @ApiModelProperty(value = "custTypeName")
    private String custTypeName;

    @ApiModelProperty(value = "salesOrdId")
    private int salesOrdId;

    @ApiModelProperty(value = "custId")
    private int custId;

    @ApiModelProperty(value = "billAmt")
    private Double billAmt;

    @ApiModelProperty(value = "billTypeId")
    private int billTypeId;

    @ApiModelProperty(value = "billTypeNm")
    private String billTypeNm;

    @ApiModelProperty(value = "installment")
    private int installment;

    @ApiModelProperty(value = "billDt")
    private String billDt;

    @ApiModelProperty(value = "targetAmt")
    private Double targetAmt;

    @ApiModelProperty(value = "megaDeal")
    private int megaDeal;

    @ApiModelProperty(value = "cnvrSchemeId")
    private int cnvrSchemeId;

    @ApiModelProperty(value = "mthRentAmt")
    private int mthRentAmt;

    @ApiModelProperty(value = "mobileNo")
    private String mobileNo;

    @ApiModelProperty(value = "email")
    private String email;

    @ApiModelProperty(value = "mobPayNo")
    private String mobPayNo;

    @ApiModelProperty(value = "payStusId")
    private String payStusId;

    @ApiModelProperty(value = "bankId")
    private int bankId;

    @ApiModelProperty(value = "bankNm")
    private String bankNm;

    @ApiModelProperty(value = "appTypeName")
    private String appTypeName;

    @ApiModelProperty(value = "appTypeId")
    private int appTypeId;

    @ApiModelProperty(value = "codeId")
    private int codeId;

    @ApiModelProperty(value = "code")
    private String code;

    @ApiModelProperty(value = "codeName")
    private String codeName;

    @ApiModelProperty(value = "accCode")
    private String accCode;

    @ApiModelProperty(value = "accDesc")
    private String accDesc;


	public int getAppTypeId() {
		return appTypeId;
	}

	public void setAppTypeId(int appTypeId) {
		this.appTypeId = appTypeId;
	}

	public String getAppTypeName() {
		return appTypeName;
	}

	public void setAppTypeName(String appTypeName) {
		this.appTypeName = appTypeName;
	}

	public String getMobPayNo() {
		return mobPayNo;
	}

	public void setMobPayNo(String mobPayNo) {
		this.mobPayNo = mobPayNo;
	}

	public String getPayStusId() {
		return payStusId;
	}

	public void setPayStusId(String payStusId) {
		this.payStusId = payStusId;
	}

	public String getMobileNo() {
		return mobileNo;
	}

	public void setMobileNo(String mobileNo) {
		this.mobileNo = mobileNo;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public int getMthRentAmt() {
		return mthRentAmt;
	}

	public void setMthRentAmt(int mthRentAmt) {
		this.mthRentAmt = mthRentAmt;
	}

	public int getMegaDeal() {
		return megaDeal;
	}

	public void setMegaDeal(int megaDeal) {
		this.megaDeal = megaDeal;
	}

	public int getCnvrSchemeId() {
		return cnvrSchemeId;
	}

	public void setCnvrSchemeId(int cnvrSchemeId) {
		this.cnvrSchemeId = cnvrSchemeId;
	}

	public int getInstallment() {
		return installment;
	}

	public void setInstallment(int installment) {
		this.installment = installment;
	}

	public String getBillDt() {
		return billDt;
	}

	public void setBillDt(String billDt) {
		this.billDt = billDt;
	}

	public Double getTargetAmt() {
		return targetAmt;
	}

	public void setTargetAmt(Double targetAmt) {
		this.targetAmt = targetAmt;
	}

	public Double getBillAmt() {
		return billAmt;
	}

	public void setBillAmt(Double billAmt) {
		this.billAmt = billAmt;
	}

	public int getBillTypeId() {
		return billTypeId;
	}

	public void setBillTypeId(int billTypeId) {
		this.billTypeId = billTypeId;
	}

	public String getBillTypeNm() {
		return billTypeNm;
	}

	public void setBillTypeNm(String billTypeNm) {
		this.billTypeNm = billTypeNm;
	}

	public int getCustId() {
		return custId;
	}

	public void setCustId(int custId) {
		this.custId = custId;
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

	public String getCustName() {
		return custName;
	}

	public void setCustName(String custName) {
		this.custName = custName;
	}

	public String getCustTypeName() {
		return custTypeName;
	}

	public void setCustTypeName(String custTypeName) {
		this.custTypeName = custTypeName;
	}

	public int getBankId() {
		return bankId;
	}

	public void setBankId(int bankId) {
		this.bankId = bankId;
	}

	public String getBankNm() {
		return bankNm;
	}

	public void setBankNm(String bankNm) {
		this.bankNm = bankNm;
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

	public String getAccCode() {
		return accCode;
	}

	public void setAccCode(String accCode) {
		this.accCode = accCode;
	}

	public String getAccDesc() {
		return accDesc;
	}

	public void setAccDesc(String accDesc) {
		this.accDesc = accDesc;
	}

	public static PaymentDto create(EgovMap egvoMap) {
		// TODO Auto-generated method stub
		return BeanConverter.toBean(egvoMap, PaymentDto.class);
	}

}
