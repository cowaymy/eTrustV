package com.coway.trust.api.mobile.payment.invoiceApi;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;


/**
 * @ClassName : InvoiceApiDto.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 09. 27.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
@ApiModel(value = "InvoiceApiDto", description = "InvoiceApiDto")
public class InvoiceApiDto {



	@SuppressWarnings("unchecked")
	public static InvoiceApiDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, InvoiceApiDto.class);
	}



	public static Map<String, Object> createMap(InvoiceApiDto vo){
		Map<String, Object> params = new HashMap<>();
		params.put("list", vo.getList());
        params.put("selectInvoiceType", vo.getSelectInvoiceType());
        params.put("appTypeId", vo.getAppTypeId());
        params.put("appTypeIdName", vo.getAppTypeIdName());
        params.put("custId", vo.getCustId());
        params.put("custIdName", vo.getCustIdName());
        params.put("salesOrdNo", vo.getSalesOrdNo());
        params.put("salesDt", vo.getSalesDt());
        params.put("stkCode", vo.getStkCode());
        params.put("stkDesc", vo.getStkDesc());
        params.put("email", vo.getEmail());
        params.put("email2", vo.getEmail2());
        params.put("mthRentAmt", vo.getMthRentAmt());
        params.put("typeId", vo.getTypeId());
        params.put("gu", vo.getGu());
        params.put("taxInvcRefNo", vo.getTaxInvcRefNo());
        params.put("invcItmId", vo.getInvcItmId());
        params.put("invcItmOrdNo", vo.getInvcItmOrdNo());
        params.put("invcType", vo.getInvcType());
        params.put("invcTypeName", vo.getInvcTypeName());
        params.put("taxInvcRefDt", vo.getTaxInvcRefDt());
        params.put("taxInvcId", vo.getTaxInvcId());
        params.put("regId", vo.getRegId());
        params.put("returnSaveCnt", vo.getReturnSaveCnt());
        params.put("invcItmPoNo", vo.getInvcItmPoNo());
        params.put("invcItmPoImg", vo.getInvcItmPoImg());
        params.put("invcAdvPrd", vo.getInvcAdvPrd());
        params.put("invcItmDiscRate", vo.getInvcItmDiscRate());
        params.put("invcItmRentalFee", vo.getInvcItmRentalFee());
        params.put("invcItmExgAmt", vo.getInvcItmExgAmt());
        params.put("invcItmTotAmt", vo.getInvcItmTotAmt());
        params.put("reqInvcYearMonth", vo.getReqInvcYearMonth());
        params.put("invcCntcPerson", vo.getInvcCntcPerson());
        params.put("custBillGrpNo", vo.getCustBillGrpNo());
		return params;
	}



	private List<InvoiceApiDto> list;
	private String selectInvoiceType;
	private int appTypeId;
	private String appTypeIdName;
	private int custId;
	private String custIdName;
	private String salesOrdNo;
	private String salesDt;
	private String stkCode;
	private String stkDesc;
	private String email;
	private String email2;
	private int mthRentAmt;
	private int typeId;
    private String gu;
    private String taxInvcRefNo;
    private int invcItmId;
    private String invcItmOrdNo;
    private int invcType;
    private String invcTypeName;
    private String taxInvcRefDt;
    private int taxInvcId;
    private String regId;
    private int returnSaveCnt;
    private String invcItmPoNo;
    private int invcItmPoImg;
    private int invcAdvPrd;
    private int invcItmDiscRate;
    private double invcItmRentalFee;
    private double invcItmExgAmt;
    private double invcItmTotAmt;
    private String reqInvcYearMonth;
    private String invcCntcPerson;
    private String custBillGrpNo;



    public String getCustBillGrpNo() {
        return custBillGrpNo;
    }

    public void setCustBillGrpNo(String custBillGrpNo) {
        this.custBillGrpNo = custBillGrpNo;
    }

    public List<InvoiceApiDto> getList() {
        return list;
    }

    public void setList(List<InvoiceApiDto> list) {
        this.list = list;
    }

    public String getSelectInvoiceType() {
        return selectInvoiceType;
    }

    public void setSelectInvoiceType(String selectInvoiceType) {
        this.selectInvoiceType = selectInvoiceType;
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

    public String getSalesOrdNo() {
        return salesOrdNo;
    }

    public void setSalesOrdNo(String salesOrdNo) {
        this.salesOrdNo = salesOrdNo;
    }

    public String getSalesDt() {
        return salesDt;
    }

    public void setSalesDt(String salesDt) {
        this.salesDt = salesDt;
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

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getEmail2() {
        return email2;
    }

    public void setEmail2(String email2) {
        this.email2 = email2;
    }

    public int getMthRentAmt() {
        return mthRentAmt;
    }

    public void setMthRentAmt(int mthRentAmt) {
        this.mthRentAmt = mthRentAmt;
    }

    public int getTypeId() {
        return typeId;
    }

    public void setTypeId(int typeId) {
        this.typeId = typeId;
    }

    public String getGu() {
        return gu;
    }

    public void setGu(String gu) {
        this.gu = gu;
    }

    public String getTaxInvcRefNo() {
        return taxInvcRefNo;
    }

    public void setTaxInvcRefNo(String taxInvcRefNo) {
        this.taxInvcRefNo = taxInvcRefNo;
    }

    public int getInvcItmId() {
        return invcItmId;
    }

    public void setInvcItmId(int invcItmId) {
        this.invcItmId = invcItmId;
    }

    public String getInvcItmOrdNo() {
        return invcItmOrdNo;
    }

    public void setInvcItmOrdNo(String invcItmOrdNo) {
        this.invcItmOrdNo = invcItmOrdNo;
    }

    public int getInvcType() {
        return invcType;
    }

    public void setInvcType(int invcType) {
        this.invcType = invcType;
    }

    public String getInvcTypeName() {
        return invcTypeName;
    }

    public void setInvcTypeName(String invcTypeName) {
        this.invcTypeName = invcTypeName;
    }

    public String getTaxInvcRefDt() {
        return taxInvcRefDt;
    }

    public void setTaxInvcRefDt(String taxInvcRefDt) {
        this.taxInvcRefDt = taxInvcRefDt;
    }

    public int getTaxInvcId() {
        return taxInvcId;
    }

    public void setTaxInvcId(int taxInvcId) {
        this.taxInvcId = taxInvcId;
    }

    public String getRegId() {
        return regId;
    }

    public void setRegId(String regId) {
        this.regId = regId;
    }

    public int getReturnSaveCnt() {
        return returnSaveCnt;
    }

    public void setReturnSaveCnt(int returnSaveCnt) {
        this.returnSaveCnt = returnSaveCnt;
    }

    public String getInvcItmPoNo() {
        return invcItmPoNo;
    }

    public void setInvcItmPoNo(String invcItmPoNo) {
        this.invcItmPoNo = invcItmPoNo;
    }

    public int getInvcItmPoImg() {
        return invcItmPoImg;
    }

    public void setInvcItmPoImg(int invcItmPoImg) {
        this.invcItmPoImg = invcItmPoImg;
    }

    public int getInvcAdvPrd() {
        return invcAdvPrd;
    }

    public void setInvcAdvPrd(int invcAdvPrd) {
        this.invcAdvPrd = invcAdvPrd;
    }

    public int getInvcItmDiscRate() {
        return invcItmDiscRate;
    }

    public void setInvcItmDiscRate(int invcItmDiscRate) {
        this.invcItmDiscRate = invcItmDiscRate;
    }

    public double getInvcItmRentalFee() {
        return invcItmRentalFee;
    }

    public void setInvcItmRentalFee(double invcItmRentalFee) {
        this.invcItmRentalFee = invcItmRentalFee;
    }

    public double getInvcItmExgAmt() {
        return invcItmExgAmt;
    }

    public void setInvcItmExgAmt(double invcItmExgAmt) {
        this.invcItmExgAmt = invcItmExgAmt;
    }

    public double getInvcItmTotAmt() {
        return invcItmTotAmt;
    }

    public void setInvcItmTotAmt(double invcItmTotAmt) {
        this.invcItmTotAmt = invcItmTotAmt;
    }

    public String getReqInvcYearMonth() {
        return reqInvcYearMonth;
    }

    public void setReqInvcYearMonth(String reqInvcYearMonth) {
        this.reqInvcYearMonth = reqInvcYearMonth;
    }

    public String getInvcCntcPerson() {
        return invcCntcPerson;
    }

    public void setInvcCntcPerson(String invcCntcPerson) {
        this.invcCntcPerson = invcCntcPerson;
    }
}
