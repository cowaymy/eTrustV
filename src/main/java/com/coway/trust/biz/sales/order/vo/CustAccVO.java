package com.coway.trust.biz.sales.order.vo;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;


/**
 * The persistent class for the CCR0006D database table.
 *
 */
public class CustAccVO implements Serializable {
	private static final long serialVersionUID = 1L;

	private int custAccId;

	private int custId;

	private String custAccNo;

	private String custEncryptAccNo;

	private String custAccOwner;

	private int custAccTypeId;

	private int custAccBankId;

	private String custAccBankBrnch;

	private String custAccRem;

	private int custAccStusId;

	private int custAccUpdUserId;

	private Date custAccUpdDt;

	private String custAccNric;

	private int custAccIdOld;

	private int soId;

	private int custAccIdcm;

	private int custHlbbId;

	private int custAccCrtUserId;

	private Date custAccCrtDt;

	private int ddtChnl;

	public int getCustAccId() {
		return custAccId;
	}

	public void setCustAccId(int custAccId) {
		this.custAccId = custAccId;
	}

	public int getCustId() {
		return custId;
	}

	public void setCustId(int custId) {
		this.custId = custId;
	}

	public String getCustAccNo() {
		return custAccNo;
	}

	public void setCustAccNo(String custAccNo) {
		this.custAccNo = custAccNo;
	}

	public String getCustEncryptAccNo() {
		return custEncryptAccNo;
	}

	public void setCustEncryptAccNo(String custEncryptAccNo) {
		this.custEncryptAccNo = custEncryptAccNo;
	}

	public String getCustAccOwner() {
		return custAccOwner;
	}

	public void setCustAccOwner(String custAccOwner) {
		this.custAccOwner = custAccOwner;
	}

	public int getCustAccTypeId() {
		return custAccTypeId;
	}

	public void setCustAccTypeId(int custAccTypeId) {
		this.custAccTypeId = custAccTypeId;
	}

	public int getCustAccBankId() {
		return custAccBankId;
	}

	public void setCustAccBankId(int custAccBankId) {
		this.custAccBankId = custAccBankId;
	}

	public String getCustAccBankBrnch() {
		return custAccBankBrnch;
	}

	public void setCustAccBankBrnch(String custAccBankBrnch) {
		this.custAccBankBrnch = custAccBankBrnch;
	}

	public String getCustAccRem() {
		return custAccRem;
	}

	public void setCustAccRem(String custAccRem) {
		this.custAccRem = custAccRem;
	}

	public int getCustAccStusId() {
		return custAccStusId;
	}

	public void setCustAccStusId(int custAccStusId) {
		this.custAccStusId = custAccStusId;
	}

	public int getCustAccUpdUserId() {
		return custAccUpdUserId;
	}

	public void setCustAccUpdUserId(int custAccUpdUserId) {
		this.custAccUpdUserId = custAccUpdUserId;
	}

	public Date getCustAccUpdDt() {
		return custAccUpdDt;
	}

	public void setCustAccUpdDt(Date custAccUpdDt) {
		this.custAccUpdDt = custAccUpdDt;
	}

	public String getCustAccNric() {
		return custAccNric;
	}

	public void setCustAccNric(String custAccNric) {
		this.custAccNric = custAccNric;
	}

	public int getCustAccIdOld() {
		return custAccIdOld;
	}

	public void setCustAccIdOld(int custAccIdOld) {
		this.custAccIdOld = custAccIdOld;
	}

	public int getSoId() {
		return soId;
	}

	public void setSoId(int soId) {
		this.soId = soId;
	}

	public int getCustAccIdcm() {
		return custAccIdcm;
	}

	public void setCustAccIdcm(int custAccIdcm) {
		this.custAccIdcm = custAccIdcm;
	}

	public int getCustHlbbId() {
		return custHlbbId;
	}

	public void setCustHlbbId(int custHlbbId) {
		this.custHlbbId = custHlbbId;
	}

	public int getCustAccCrtUserId() {
		return custAccCrtUserId;
	}

	public void setCustAccCrtUserId(int custAccCrtUserId) {
		this.custAccCrtUserId = custAccCrtUserId;
	}

	public Date getCustAccCrtDt() {
		return custAccCrtDt;
	}

	public void setCustAccCrtDt(Date custAccCrtDt) {
		this.custAccCrtDt = custAccCrtDt;
	}

    public int getDdtChnl() {
      return ddtChnl;
    }

    public void setDdtChnl(int ddtChnl) {
      this.ddtChnl = ddtChnl;
    }

}