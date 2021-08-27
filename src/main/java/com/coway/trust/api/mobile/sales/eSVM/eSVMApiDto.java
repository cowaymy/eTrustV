package com.coway.trust.api.mobile.sales.eSVM;

import java.util.List;

import com.coway.trust.api.mobile.sales.eKeyInApi.EKeyInApiDto;
import com.coway.trust.util.BeanConverter;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;

@ApiModel(value = "eSVMApiDto", description = "eSVMApiDto")
@JsonIgnoreProperties(ignoreUnknown = true)
public class eSVMApiDto {

    @SuppressWarnings("unchecked")
    public static eSVMApiDto create(EgovMap egvoMap) {
      return BeanConverter.toBean(egvoMap, eSVMApiDto.class);
    }

    private int svmQuotId;
    private int psmId;
    private int salesOrdId;
    private String regId;
    private String custName;
    private String salesOrdNo;
    private String reqstDt;
    private String quotNo;
    private String psmNo;
    private String orderType;
    private String custType;
    private String status;
    private int stkId;
    private String ordNo;
    private String nric;
    private int ordOtdstnd;
    private int asOtstnd;
    private String address;
    private String stkName;
    private String memExprDate;
    private int expint;
    private String coolingPrd;
    private String hsFreq;
    private String trm;

    /* Filter Listing */
    private int srvFilterId;
    private int srvFilterStkId;
    private String stkCode;
    private String stkDesc;
    private String c2;
    private String c3;
    private String srvFilterStusId;
    private String srvFilterPrvChgDt;
    private String srvFilterPriod;
    private String code;
    private String c5;
    private String c6;
    private String expiredateint;
    private String todaydateint;

    /* Type of Package */
    private int pkgComboId;
    private String pkgComboName;

    /* Package Promotion */
    private int packagePromoId;
    private String packagePromoName;
    private int promoDiscType;
    private int promoRpfDiscAmt;

    /* Filter Promotion */
    private int filterPromoId;
    private String filterPromoName;

    private List<eSVMApiDto> productFilterList;
    private List<eSVMApiDto> packageComboList;
    private List<eSVMApiDto> packagePromoList;
    private List<eSVMApiDto> filterPromoList;

    public int getSvmQuotId() {
        return svmQuotId;
    }

    public void setSvmQuotId(int svmQuotId) {
        this.svmQuotId = svmQuotId;
    }

    public int getPsmId() {
        return psmId;
    }

    public void setPsmId(int psmId) {
        this.psmId = psmId;
    }

    public int getSalesOrdId() {
        return salesOrdId;
    }

    public void setSalesOrdId(int salesOrdId) {
        this.salesOrdId = salesOrdId;
    }

    public String getRegId() {
        return regId;
    }

    public void setRegId(String regId) {
        this.regId = regId;
    }

    public String getCustName() {
        return custName;
    }

    public void setCustName(String custName) {
        this.custName = custName;
    }

    public String getSalesOrdNo() {
        return salesOrdNo;
    }

    public void setSalesOrdNo(String salesOrdNo) {
        this.salesOrdNo = salesOrdNo;
    }

    public String getReqstDt() {
        return reqstDt;
    }

    public void setReqstDt(String reqstDt) {
        this.reqstDt = reqstDt;
    }

    public String getQuotNo() {
        return quotNo;
    }

    public void setQuotNo(String quotNo) {
        this.quotNo = quotNo;
    }

    public String getPsmNo() {
        return psmNo;
    }

    public void setPsmNo(String psmNo) {
        this.psmNo = psmNo;
    }

    public String getOrderType() {
        return orderType;
    }

    public void setOrderType(String orderType) {
        this.orderType = orderType;
    }

    public String getCustType() {
        return custType;
    }

    public void setCustType(String custType) {
        this.custType = custType;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getStkId() {
        return stkId;
    }

    public void setStkId(int stkId) {
        this.stkId = stkId;
    }

    public String getOrdNo() {
        return ordNo;
    }

    public void setOrdNo(String ordNo) {
        this.ordNo = ordNo;
    }

    public String getNric() {
        return nric;
    }

    public void setNric(String nric) {
        this.nric = nric;
    }

    public int getOrdOtdstnd() {
        return ordOtdstnd;
    }

    public void setOrdOtdstnd(int ordOtdstnd) {
        this.ordOtdstnd = ordOtdstnd;
    }

    public int getAsOtstnd() {
        return asOtstnd;
    }

    public void setAsOtstnd(int asOtstnd) {
        this.asOtstnd = asOtstnd;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getStkName() {
        return stkName;
    }

    public void setStkName(String stkName) {
        this.stkName = stkName;
    }

    public String getMemExprDate() {
        return memExprDate;
    }

    public void setMemExprDate(String memExprDate) {
        this.memExprDate = memExprDate;
    }

    public int getExpint() {
        return expint;
    }

    public void setExpint(int expint) {
        this.expint = expint;
    }

    public String getCoolingPrd() {
        return coolingPrd;
    }

    public void setCoolingPrd(String coolingPrd) {
        this.coolingPrd = coolingPrd;
    }

    public String getHsFreq() {
        return hsFreq;
    }

    public void setHsFreq(String hsFreq) {
        this.hsFreq = hsFreq;
    }

    public String getTrm() {
        return trm;
    }

    public void setTrm(String trm) {
        this.trm = trm;
    }

    public int getSrvFilterId() {
        return srvFilterId;
    }

    public void setSrvFilterId(int srvFilterId) {
        this.srvFilterId = srvFilterId;
    }

    public int getSrvFilterStkId() {
        return srvFilterStkId;
    }

    public void setSrvFilterStkId(int srvFilterStkId) {
        this.srvFilterStkId = srvFilterStkId;
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

    public String getC2() {
        return c2;
    }

    public void setC2(String c2) {
        this.c2 = c2;
    }

    public String getC3() {
        return c3;
    }

    public void setC3(String c3) {
        this.c3 = c3;
    }

    public String getSrvFilterStusId() {
        return srvFilterStusId;
    }

    public void setSrvFilterStusId(String srvFilterStusId) {
        this.srvFilterStusId = srvFilterStusId;
    }

    public String getSrvFilterPrvChgDt() {
        return srvFilterPrvChgDt;
    }

    public void setSrvFilterPrvChgDt(String srvFilterPrvChgDt) {
        this.srvFilterPrvChgDt = srvFilterPrvChgDt;
    }

    public String getSrvFilterPriod() {
        return srvFilterPriod;
    }

    public void setSrvFilterPriod(String srvFilterPriod) {
        this.srvFilterPriod = srvFilterPriod;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getC5() {
        return c5;
    }

    public void setC5(String c5) {
        this.c5 = c5;
    }

    public String getC6() {
        return c6;
    }

    public void setC6(String c6) {
        this.c6 = c6;
    }

    public String getExpiredateint() {
        return expiredateint;
    }

    public void setExpiredateint(String expiredateint) {
        this.expiredateint = expiredateint;
    }

    public String getTodaydateint() {
        return todaydateint;
    }

    public void setTodaydateint(String todaydateint) {
        this.trm = todaydateint;
    }

    public List<eSVMApiDto> getProductFilterList() {
        return productFilterList;
    }

    public void setProductFilterList(List<eSVMApiDto> productFilterList) {
        this.productFilterList = productFilterList;
    }

    public int getPkgComboId() {
        return pkgComboId;
    }

    public void setPkgComboId(int pkgComboId) {
        this.pkgComboId = pkgComboId;
    }

    public String getPkgComboName() {
        return pkgComboName;
    }

    public void setPkgComboName(String pkgComboName) {
        this.pkgComboName = pkgComboName;
    }

    public List<eSVMApiDto> getPackageComboList() {
        return packageComboList;
    }

    public void setPackageComboList(List<eSVMApiDto> packageComboList) {
        this.packageComboList = packageComboList;
    }

    public int getPackagePromoId() {
        return packagePromoId;
    }

    public void setPackagePromoId(int packagePromoId) {
        this.packagePromoId = packagePromoId;
    }

    public String getPackagePromoName() {
        return packagePromoName;
    }

    public void setPackagePromoName(String packagePromoName) {
        this.packagePromoName = packagePromoName;
    }

    public int getPromoDiscType() {
        return promoDiscType;
    }

    public void setPromoDiscType(int promoDiscType) {
        this.promoDiscType = promoDiscType;
    }

    public int getPromoRpfDiscAmt() {
        return promoRpfDiscAmt;
    }

    public void setPromoRpfDiscAmt(int promoRpfDiscAmt) {
        this.promoRpfDiscAmt = promoRpfDiscAmt;
    }

    public List<eSVMApiDto> getPackagePromoList() {
        return packagePromoList;
    }

    public void setPackagePromoList(List<eSVMApiDto> packagePromoList) {
        this.packagePromoList = packagePromoList;
    }

    public int getFilterPromoId() {
        return filterPromoId;
    }

    public void setFilterPromoId(int filterPromoId) {
        this.filterPromoId = filterPromoId;
    }

    public String getFilterPromoName() {
        return filterPromoName;
    }

    public void setFilterPromoName(String filterPromoName) {
        this.filterPromoName = filterPromoName;
    }

    public List<eSVMApiDto> getFilterPromoList() {
        return filterPromoList;
    }

    public void setFilterPromoList(List<eSVMApiDto> filterPromoList) {
        this.filterPromoList = filterPromoList;
    }
}
