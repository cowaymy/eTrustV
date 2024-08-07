package com.coway.trust.api.mobile.logistics.stockAudit;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;

/**
 * @ClassName : StockAuditApiDto.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 28.  KR-JAEMJAEM:) First creation
 * </pre>
 */
@ApiModel(value = "StockAuditApiDto", description = "공통코드 Dto")
public class StockAuditApiDto {



	@SuppressWarnings("unchecked")
	public static StockAuditApiDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, StockAuditApiDto.class);
	}



	private String stockAuditNo;                                                //Stock Audit Number
	private String docStartDt;                                                  //Stock Audit Start Date
	private String docEndDt;                                                    //Stock Audit End Date
	private int docStusCodeId;                                                  //Doc Status (SYS0013M - CODE_MASTER_ID : 436)
	private String reuploadYn;                                                  //Attachments file reupload yn
	private String appv3ReqstUserId;                                            //3rd Requester
	private String appv3ReqstDt;                                                //3rd Request Date
	private String appv3ReqstOpinion;                                           //3rd Request Opinion
	private int appvAtchFileGrpId;                                              //Approval Attach File Group Id
	private String appv3UserId;                                                 //3rd Approver
	private String appv3Dt;                                                     //3rd Approval Date
	private String appv3Opinion;                                                //3rd Approval Opinion
	private String stockAuditReason;                                            //Stock Audit Reason
	private String locType;                                                     //Location Type
	private String locTypeNm;                                                   //Location Type Name
	private String locStkGrad;                                                  //Location Grade
	private String ctgryType;                                                   //Category Type
	private String ctgryTypeNm;                                                 //Category Type Name
	private String itmType;                                                     //Items Type
	private String itmTypeNm;                                                   //Items Type Name
	private String rem;                                                         //Remark
	private String useYn;                                                       //Use YN
    private String docStusCodeIdNm;                                             //Doc Status (SYS0013M - ID CODE_MASTER_ID : 436)
    private String appv1ReqstUserId;
    private String appv1ReqstDt;
    private String appv1UserId;
    private String appv1Dt;
    private String appv1Opinion;
    private String appv2UserId;
    private String appv2Dt;
    private String appv2Opinion;
    private int locStusCodeId;
    private String locStusCodeIdNm;
    private String locStusCodeIdGu;
    private int whLocId;
    private int itmId;
    private String itmIdNm;
    private int stkTypeId;
    private String stkTypeIdNm;
    private int cntQty;
    private int sysQty;
    private int diffQty;
    private String regId;
    private String viewGu;
    private String stkCode;
    private String serialChkYn;
    private String serialChk;
    private String serialRequireChkYn;
    private String newSerialArr;
    private String delSerialArr;


    public String getSerialRequireChkYn() {
        return serialRequireChkYn;
    }
    public void setSerialRequireChkYn(String serialRequireChkYn) {
        this.serialRequireChkYn = serialRequireChkYn;
    }
    public String getNewSerialArr() {
        return newSerialArr;
    }
    public void setNewSerialArr(String newSerialArr) {
        this.newSerialArr = newSerialArr;
    }
    public String getSerialChkYn() {
        return serialChkYn;
    }
    public void setSerialChkYn(String serialChkYn) {
        this.serialChkYn = serialChkYn;
    }
    public String getStockAuditNo() {
        return stockAuditNo;
    }
    public void setStockAuditNo(String stockAuditNo) {
        this.stockAuditNo = stockAuditNo;
    }
    public String getDocStartDt() {
        return docStartDt;
    }
    public void setDocStartDt(String docStartDt) {
        this.docStartDt = docStartDt;
    }
    public String getDocEndDt() {
        return docEndDt;
    }
    public void setDocEndDt(String docEndDt) {
        this.docEndDt = docEndDt;
    }
    public int getDocStusCodeId() {
        return docStusCodeId;
    }
    public void setDocStusCodeId(int docStusCodeId) {
        this.docStusCodeId = docStusCodeId;
    }
    public String getReuploadYn() {
        return reuploadYn;
    }
    public void setReuploadYn(String reuploadYn) {
        this.reuploadYn = reuploadYn;
    }
    public String getAppv3ReqstUserId() {
        return appv3ReqstUserId;
    }
    public void setAppv3ReqstUserId(String appv3ReqstUserId) {
        this.appv3ReqstUserId = appv3ReqstUserId;
    }
    public String getAppv3ReqstDt() {
        return appv3ReqstDt;
    }
    public void setAppv3ReqstDt(String appv3ReqstDt) {
        this.appv3ReqstDt = appv3ReqstDt;
    }
    public String getAppv3ReqstOpinion() {
        return appv3ReqstOpinion;
    }
    public void setAppv3ReqstOpinion(String appv3ReqstOpinion) {
        this.appv3ReqstOpinion = appv3ReqstOpinion;
    }
    public int getAppvAtchFileGrpId() {
        return appvAtchFileGrpId;
    }
    public void setAppvAtchFileGrpId(int appvAtchFileGrpId) {
        this.appvAtchFileGrpId = appvAtchFileGrpId;
    }
    public String getAppv3UserId() {
        return appv3UserId;
    }
    public void setAppv3UserId(String appv3UserId) {
        this.appv3UserId = appv3UserId;
    }
    public String getAppv3Dt() {
        return appv3Dt;
    }
    public void setAppv3Dt(String appv3Dt) {
        this.appv3Dt = appv3Dt;
    }
    public String getAppv3Opinion() {
        return appv3Opinion;
    }
    public void setAppv3Opinion(String appv3Opinion) {
        this.appv3Opinion = appv3Opinion;
    }
    public String getStockAuditReason() {
        return stockAuditReason;
    }
    public void setStockAuditReason(String stockAuditReason) {
        this.stockAuditReason = stockAuditReason;
    }
    public String getLocType() {
        return locType;
    }
    public void setLocType(String locType) {
        this.locType = locType;
    }
    public String getLocTypeNm() {
        return locTypeNm;
    }
    public void setLocTypeNm(String locTypeNm) {
        this.locTypeNm = locTypeNm;
    }
    public String getLocStkGrad() {
        return locStkGrad;
    }
    public void setLocStkGrad(String locStkGrad) {
        this.locStkGrad = locStkGrad;
    }
    public String getCtgryType() {
        return ctgryType;
    }
    public void setCtgryType(String ctgryType) {
        this.ctgryType = ctgryType;
    }
    public String getCtgryTypeNm() {
        return ctgryTypeNm;
    }
    public void setCtgryTypeNm(String ctgryTypeNm) {
        this.ctgryTypeNm = ctgryTypeNm;
    }
    public String getItmType() {
        return itmType;
    }
    public void setItmType(String itmType) {
        this.itmType = itmType;
    }
    public String getItmTypeNm() {
        return itmTypeNm;
    }
    public void setItmTypeNm(String itmTypeNm) {
        this.itmTypeNm = itmTypeNm;
    }
    public String getRem() {
        return rem;
    }
    public void setRem(String rem) {
        this.rem = rem;
    }
    public String getUseYn() {
        return useYn;
    }
    public void setUseYn(String useYn) {
        this.useYn = useYn;
    }
    public String getDocStusCodeIdNm() {
        return docStusCodeIdNm;
    }
    public void setDocStusCodeIdNm(String docStusCodeIdNm) {
        this.docStusCodeIdNm = docStusCodeIdNm;
    }
    public String getAppv1ReqstUserId() {
        return appv1ReqstUserId;
    }
    public void setAppv1ReqstUserId(String appv1ReqstUserId) {
        this.appv1ReqstUserId = appv1ReqstUserId;
    }
    public String getAppv1ReqstDt() {
        return appv1ReqstDt;
    }
    public void setAppv1ReqstDt(String appv1ReqstDt) {
        this.appv1ReqstDt = appv1ReqstDt;
    }
    public String getAppv1UserId() {
        return appv1UserId;
    }
    public void setAppv1UserId(String appv1UserId) {
        this.appv1UserId = appv1UserId;
    }
    public String getAppv1Dt() {
        return appv1Dt;
    }
    public void setAppv1Dt(String appv1Dt) {
        this.appv1Dt = appv1Dt;
    }
    public String getAppv1Opinion() {
        return appv1Opinion;
    }
    public void setAppv1Opinion(String appv1Opinion) {
        this.appv1Opinion = appv1Opinion;
    }
    public String getAppv2UserId() {
        return appv2UserId;
    }
    public void setAppv2UserId(String appv2UserId) {
        this.appv2UserId = appv2UserId;
    }
    public String getAppv2Dt() {
        return appv2Dt;
    }
    public void setAppv2Dt(String appv2Dt) {
        this.appv2Dt = appv2Dt;
    }
    public String getAppv2Opinion() {
        return appv2Opinion;
    }
    public void setAppv2Opinion(String appv2Opinion) {
        this.appv2Opinion = appv2Opinion;
    }
    public int getLocStusCodeId() {
        return locStusCodeId;
    }
    public void setLocStusCodeId(int locStusCodeId) {
        this.locStusCodeId = locStusCodeId;
    }
    public String getLocStusCodeIdNm() {
        return locStusCodeIdNm;
    }
    public void setLocStusCodeIdNm(String locStusCodeIdNm) {
        this.locStusCodeIdNm = locStusCodeIdNm;
    }
    public String getLocStusCodeIdGu() {
        return locStusCodeIdGu;
    }
    public void setLocStusCodeIdGu(String locStusCodeIdGu) {
        this.locStusCodeIdGu = locStusCodeIdGu;
    }
    public int getWhLocId() {
        return whLocId;
    }
    public void setWhLocId(int whLocId) {
        this.whLocId = whLocId;
    }
    public int getItmId() {
        return itmId;
    }
    public void setItmId(int itmId) {
        this.itmId = itmId;
    }
    public String getItmIdNm() {
        return itmIdNm;
    }
    public void setItmIdNm(String itmIdNm) {
        this.itmIdNm = itmIdNm;
    }
    public int getStkTypeId() {
        return stkTypeId;
    }
    public void setStkTypeId(int stkTypeId) {
        this.stkTypeId = stkTypeId;
    }
    public String getStkTypeIdNm() {
        return stkTypeIdNm;
    }
    public void setStkTypeIdNm(String stkTypeIdNm) {
        this.stkTypeIdNm = stkTypeIdNm;
    }
    public int getCntQty() {
        return cntQty;
    }
    public void setCntQty(int cntQty) {
        this.cntQty = cntQty;
    }
    public int getSysQty() {
        return sysQty;
    }
    public void setSysQty(int sysQty) {
        this.sysQty = sysQty;
    }
    public int getDiffQty() {
        return diffQty;
    }
    public void setDiffQty(int diffQty) {
        this.diffQty = diffQty;
    }
    public String getRegId() {
        return regId;
    }
    public void setRegId(String regId) {
        this.regId = regId;
    }
    public String getViewGu() {
        return viewGu;
    }
    public void setViewGu(String viewGu) {
        this.viewGu = viewGu;
    }
    public String getStkCode() {
        return stkCode;
    }
    public void setStkCode(String stkCode) {
        this.stkCode = stkCode;
    }
    public String getSerialChk() {
        return serialChk;
    }
    public void setSerialChk(String serialChk) {
        this.serialChk = serialChk;
    }
    public String getDelSerialArr() {
        return delSerialArr;
    }
    public void setDelSerialArr(String delSerialArr) {
        this.delSerialArr = delSerialArr;
    }
}
