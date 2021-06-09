package com.coway.trust.api.mobile.payment.paymentList;

import javax.annotation.Resource;

import com.coway.trust.biz.payment.payment.service.CashMatchingApiService;
import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;


/**
 * @ClassName : PaymentListDto.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 19.   KR-HAN        First creation
 * </pre>
 */
@ApiModel(value = "PaymentListDto", description = "Payment List Dto")
public class PaymentListDto {

//	@Resource(name = "cashMatchingApiService")
//	private CashMatchingApiService cashMatchingApiService;

	@ApiModelProperty(value = "mobPayNo")
	private int mobPayNo;

	@ApiModelProperty(value = "salesOrdNo")
	private String salesOrdNo;

	@ApiModelProperty(value = "payMode")
	private int payMode;

	@ApiModelProperty(value = "payModeNm")
	private String payModeNm;

	@ApiModelProperty(value = "payAmt")
	private Double payAmt;

	@ApiModelProperty(value = "serialNo")
	private String serialNo;

	@ApiModelProperty(value = "imgYn")
	private String imgYn;

	@ApiModelProperty(value = "slipNo")
	private String slipNo;

	@ApiModelProperty(value = "chequeNo")
	private String chequeNo;

	@ApiModelProperty(value = "codeId")
	private int codeId;

	@ApiModelProperty(value = "code")
	private String code;

	@ApiModelProperty(value = "codeName")
	private String codeName;

	@ApiModelProperty(value = "description")
	private String description;

	@ApiModelProperty(value = "stus")
	private String stus;

	public int getMobPayNo() {
		return mobPayNo;
	}

	public void setMobPayNo(int mobPayNo) {
		this.mobPayNo = mobPayNo;
	}

	public String getSalesOrdNo() {
		return salesOrdNo;
	}

	public void setSalesOrdNo(String salesOrdNo) {
		this.salesOrdNo = salesOrdNo;
	}

	public String getPayModeNm() {
		return payModeNm;
	}

	public void setPayModeNm(String payModeNm) {
		this.payModeNm = payModeNm;
	}

	public Double getPayAmt() {
		return payAmt;
	}

	public void setPayAmt(Double payAmt) {
		this.payAmt = payAmt;
	}

	public String getSerialNo() {
		return serialNo;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}

	public String getImgYn() {
		return imgYn;
	}

	public void setImgYn(String imgYn) {
		this.imgYn = imgYn;
	}

	public String getSlipNo() {
		return slipNo;
	}

	public void setSlipNo(String slipNo) {
		this.slipNo = slipNo;
	}

	public String getChequeNo() {
		return chequeNo;
	}

	public void setChequeNo(String chequeNo) {
		this.chequeNo = chequeNo;
	}

	public int getPayMode() {
		return payMode;
	}

	public void setPayMode(int payMode) {
		this.payMode = payMode;
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

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getStus() {
		return stus;
	}

	public void setStus(String stus) {
		this.stus = stus;
	}

	public static PaymentListDto create(EgovMap egvoMap) {
		// TODO Auto-generated method stub
		return BeanConverter.toBean(egvoMap, PaymentListDto.class);
	}

}
