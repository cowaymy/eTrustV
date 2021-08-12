package com.coway.trust.api.mobile.payment.fundTransferApi;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;


/**
 * @ClassName : FundTransferApiForm.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date            Author          Description
 * -------------   -----------     -------------
 * 2019. 10. 21.   KR-JAEMJAEM:)   First creation
 * </pre>
 */
@ApiModel(value = "FundTransferApiForm", description = "FundTransferApiForm")
public class FundTransferApiForm {



	public static Map<String, Object> createMap(FundTransferApiForm vo){
		Map<String, Object> params = new HashMap<>();
        params.put("salesOrdNo", vo.getSalesOrdNo());
        params.put("appTypeId", vo.getAppTypeId());
        params.put("srcGrpSeq", vo.getSrcGrpSeq());
        params.put("srcAmt", vo.getSrcAmt());
        params.put("srcOrdNo", vo.getSrcOrdNo());
        params.put("srcCustName", vo.getSrcCustName());
        params.put("srcPayId", vo.getSrcPayId());
        params.put("ftAmt", vo.getFtAmt());
        params.put("ftOrdNo", vo.getFtOrdNo());
        params.put("ftCustName", vo.getFtCustName());
        params.put("ftResn", vo.getFtResn());
        params.put("ftStusId", vo.getFtStusId());
        params.put("regId", vo.getRegId());
        params.put("orNo", vo.getOrNo());
        params.put("ftAttchImg", vo.getFtAttchImg());
        params.put("curPayTypeId", vo.getCurPayTypeId());
		return params;
	}



	private String salesOrdNo;
	private int appTypeId;
    private int srcGrpSeq;
	private int srcAmt;
    private String srcOrdNo;
    private String srcCustName;
    private int srcPayId;
    private int ftAmt;
    private String ftOrdNo;
    private String ftCustName;
    private int ftResn;
    private int ftStusId;
    private String regId;
    private String orNo;
    private String ftAttchImg;
    private String curPayTypeId;



    public String getCurPayTypeId() {
        return curPayTypeId;
    }
    public void setCurPayTypeId(String curPayTypeId) {
        this.curPayTypeId = curPayTypeId;
    }
    public String getFtAttchImg() {
        return ftAttchImg;
    }
    public void setFtAttchImg(String ftAttchImg) {
        this.ftAttchImg = ftAttchImg;
    }
    public String getOrNo() {
        return orNo;
    }
    public void setOrNo(String orNo) {
        this.orNo = orNo;
    }
    public String getSalesOrdNo() {
        return salesOrdNo;
    }
    public void setSalesOrdNo(String salesOrdNo) {
        this.salesOrdNo = salesOrdNo;
    }
    public int getAppTypeId() {
        return appTypeId;
    }
    public void setAppTypeId(int appTypeId) {
        this.appTypeId = appTypeId;
    }
    public int getSrcGrpSeq() {
        return srcGrpSeq;
    }
    public void setSrcGrpSeq(int srcGrpSeq) {
        this.srcGrpSeq = srcGrpSeq;
    }
    public int getSrcAmt() {
        return srcAmt;
    }
    public void setSrcAmt(int srcAmt) {
        this.srcAmt = srcAmt;
    }
    public String getSrcOrdNo() {
        return srcOrdNo;
    }
    public void setSrcOrdNo(String srcOrdNo) {
        this.srcOrdNo = srcOrdNo;
    }
    public String getSrcCustName() {
        return srcCustName;
    }
    public void setSrcCustName(String srcCustName) {
        this.srcCustName = srcCustName;
    }
    public int getSrcPayId() {
        return srcPayId;
    }
    public void setSrcPayId(int srcPayId) {
        this.srcPayId = srcPayId;
    }
    public int getFtAmt() {
        return ftAmt;
    }
    public void setFtAmt(int ftAmt) {
        this.ftAmt = ftAmt;
    }
    public String getFtOrdNo() {
        return ftOrdNo;
    }
    public void setFtOrdNo(String ftOrdNo) {
        this.ftOrdNo = ftOrdNo;
    }
    public String getFtCustName() {
        return ftCustName;
    }
    public void setFtCustName(String ftCustName) {
        this.ftCustName = ftCustName;
    }
    public int getFtResn() {
        return ftResn;
    }
    public void setFtResn(int ftResn) {
        this.ftResn = ftResn;
    }
    public int getFtStusId() {
        return ftStusId;
    }
    public void setFtStusId(int ftStusId) {
        this.ftStusId = ftStusId;
    }
    public String getRegId() {
        return regId;
    }
    public void setRegId(String regId) {
        this.regId = regId;
    }
}
