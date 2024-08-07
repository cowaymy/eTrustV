/**
 *
 */
package com.coway.trust.biz.services.onLoan.vo;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

/**
 * The persistent class for the SVC0116M database table.
 *
 * @author HQIT-HUIDING
 * @date Feb 17, 2020
 *
 */
@JsonIgnoreProperties(ignoreUnknown = true)
public class LoanOrderMVO implements Serializable{
	private static final long serialVersionUID = 1L;

	private long loanOrdId;
	private String loanOrdNo;
	private long salesOrdId;
	private String refNo;
	private Date loanDt;
	private int custId;
	private int custCntId;
	private int custAddId;
	private int memId;
	private int brnchId;
	private int appTypeId;
	private BigDecimal totAmt;
	private String rem;
	private String relateOrdNo;
	private String smoNo;
	private int stusCodeId;
	private int syncChk;
	private String custPoNo;
	private int custBillId;
	private int custCareCntId;
	private int salesHmId;
	private int salesSmId;
	private int salesGmId;
	private int srvPacId;
	private String bindingNo;
	private Date updDt;
    private int updUserId;
    private String billGroup;
    private int empChk;
    private BigDecimal taxAmt;
    private String deptCode;
	private int editTypeId;
	private int crtUserId;
	private Date crtDt;

	public Date getCrtDt() {
		return crtDt;
	}
	public void setCrtDt(Date crtDt) {
		this.crtDt = crtDt;
	}
	public int getCrtUserId() {
		return crtUserId;
	}
	public void setCrtUserId(int crtUserId) {
		this.crtUserId = crtUserId;
	}
	public int getEditTypeId() {
		return editTypeId;
	}
	public void setEditTypeId(int editTypeId) {
		this.editTypeId = editTypeId;
	}
	public long getLoanOrdId() {
		return loanOrdId;
	}
	public void setLoanOrdId(long loanOrdId) {
		this.loanOrdId = loanOrdId;
	}
	public String getLoanOrdNo() {
		return loanOrdNo;
	}
	public void setLoanOrdNo(String loanOrdNo) {
		this.loanOrdNo = loanOrdNo;
	}
	public long getSalesOrdId() {
		return salesOrdId;
	}
	public void setSalesOrdId(long salesOrdId) {
		this.salesOrdId = salesOrdId;
	}
	public String getRefNo() {
		return refNo;
	}
	public void setRefNo(String refNo) {
		this.refNo = refNo;
	}
	public Date getLoanDt() {
		return loanDt;
	}
	public void setLoanDt(Date loanDt) {
		this.loanDt = loanDt;
	}
	public int getCustId() {
		return custId;
	}
	public void setCustId(int custId) {
		this.custId = custId;
	}
	public int getCustCntId() {
		return custCntId;
	}
	public void setCustCntId(int custCntId) {
		this.custCntId = custCntId;
	}
	public int getCustAddId() {
		return custAddId;
	}
	public void setCustAddId(int custAddId) {
		this.custAddId = custAddId;
	}
	public int getMemId() {
		return memId;
	}
	public void setMemId(int memId) {
		this.memId = memId;
	}
	public int getBrnchId() {
		return brnchId;
	}
	public void setBrnchId(int brnchId) {
		this.brnchId = brnchId;
	}
	public int getAppTypeId() {
		return appTypeId;
	}
	public void setAppTypeId(int appTypeId) {
		this.appTypeId = appTypeId;
	}
	public BigDecimal getTotAmt() {
		return totAmt;
	}
	public void setTotAmt(BigDecimal totAmt) {
		this.totAmt = totAmt;
	}
	public String getRem() {
		return rem;
	}
	public void setRem(String rem) {
		this.rem = rem;
	}
	public String getSmoNo() {
		return smoNo;
	}
	public void setSmoNo(String smoNo) {
		this.smoNo = smoNo;
	}
	public int getStusCodeId() {
		return stusCodeId;
	}
	public void setStusCodeId(int stusCodeId) {
		this.stusCodeId = stusCodeId;
	}
	public int getSyncChk() {
		return syncChk;
	}
	public void setSyncChk(int syncChk) {
		this.syncChk = syncChk;
	}
	public String getCustPoNo() {
		return custPoNo;
	}
	public void setCustPoNo(String custPoNo) {
		this.custPoNo = custPoNo;
	}
	public int getCustBillId() {
		return custBillId;
	}
	public void setCustBillId(int custBillId) {
		this.custBillId = custBillId;
	}
	public int getCustCareCntId() {
		return custCareCntId;
	}
	public void setCustCareCntId(int custCareCntId) {
		this.custCareCntId = custCareCntId;
	}
	public int getSalesHmId() {
		return salesHmId;
	}
	public void setSalesHmId(int salesHmId) {
		this.salesHmId = salesHmId;
	}
	public int getSalesSmId() {
		return salesSmId;
	}
	public void setSalesSmId(int salesSmId) {
		this.salesSmId = salesSmId;
	}
	public int getSalesGmId() {
		return salesGmId;
	}
	public void setSalesGmId(int salesGmId) {
		this.salesGmId = salesGmId;
	}
	public int getSrvPacId() {
		return srvPacId;
	}
	public void setSrvPacId(int srvPacId) {
		this.srvPacId = srvPacId;
	}
	public String getBindingNo() {
		return bindingNo;
	}
	public void setBindingNo(String bindingNo) {
		this.bindingNo = bindingNo;
	}
	public Date getUpdDt() {
		return updDt;
	}
	public void setUpdDt(Date updDt) {
		this.updDt = updDt;
	}
	public int getUpdUserId() {
		return updUserId;
	}
	public void setUpdUserId(int updUserId) {
		this.updUserId = updUserId;
	}
	public String getBillGroup() {
		return billGroup;
	}
	public void setBillGroup(String billGroup) {
		this.billGroup = billGroup;
	}
	public int getEmpChk() {
		return empChk;
	}
	public void setEmpChk(int empChk) {
		this.empChk = empChk;
	}
	public BigDecimal getTaxAmt() {
		return taxAmt;
	}
	public void setTaxAmt(BigDecimal taxAmt) {
		this.taxAmt = taxAmt;
	}
	public String getDeptCode() {
		return deptCode;
	}
	public void setDeptCode(String deptCode) {
		this.deptCode = deptCode;
	}
	public String getRelateOrdNo() {
		return relateOrdNo;
	}
	public void setRelateOrdNo(String relateOrdNo) {
		this.relateOrdNo = relateOrdNo;
	}
}
