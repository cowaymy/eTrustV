package com.coway.trust.biz.sales.order.vo;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;


/**
 * The persistent class for the CCR0006D database table.
 *
 */
public class CustCrcVO implements Serializable {
	private static final long serialVersionUID = 1L;

	private int custCrcId;

	private int custId;

	private String custCrcNo;

	private String custOriCrcNo;

	private String custEncryptCrcNo;

	private String custCrcOwner;

	private int custCrcTypeId;

	private int custCrcBankId;

	private int custCrcStusId;

	private String custCrcRem;

	private int custCrcUpdUserId;

	private Date custCrcUpdDt;

	private String custCrcExpr;

	private int custCrcIdOld;

	private int soId;

	private int custCrcIdcm;

	private int custCrcCrtUserId;

	private Date custCrcCrtDt;

	private int cardTypeId;

	private String crcToken;

	public int getCustCrcId() {
		return custCrcId;
	}

	public void setCustCrcId(int custCrcId) {
		this.custCrcId = custCrcId;
	}

	public int getCustId() {
		return custId;
	}

	public void setCustId(int custId) {
		this.custId = custId;
	}

	public String getCustCrcNo() {
		return custCrcNo;
	}

	public void setCustCrcNo(String custCrcNo) {
		this.custCrcNo = custCrcNo;
	}

	public String getCustOriCrcNo() {
		return custOriCrcNo;
	}

	public void setCustOriCrcNo(String custOriCrcNo) {
		this.custOriCrcNo = custOriCrcNo;
	}

	public String getCustEncryptCrcNo() {
		return custEncryptCrcNo;
	}

	public void setCustEncryptCrcNo(String custEncryptCrcNo) {
		this.custEncryptCrcNo = custEncryptCrcNo;
	}

	public String getCustCrcOwner() {
		return custCrcOwner;
	}

	public void setCustCrcOwner(String custCrcOwner) {
		this.custCrcOwner = custCrcOwner;
	}

	public int getCustCrcTypeId() {
		return custCrcTypeId;
	}

	public void setCustCrcTypeId(int custCrcTypeId) {
		this.custCrcTypeId = custCrcTypeId;
	}

	public int getCustCrcBankId() {
		return custCrcBankId;
	}

	public void setCustCrcBankId(int custCrcBankId) {
		this.custCrcBankId = custCrcBankId;
	}

	public int getCustCrcStusId() {
		return custCrcStusId;
	}

	public void setCustCrcStusId(int custCrcStusId) {
		this.custCrcStusId = custCrcStusId;
	}

	public String getCustCrcRem() {
		return custCrcRem;
	}

	public void setCustCrcRem(String custCrcRem) {
		this.custCrcRem = custCrcRem;
	}

	public int getCustCrcUpdUserId() {
		return custCrcUpdUserId;
	}

	public void setCustCrcUpdUserId(int custCrcUpdUserId) {
		this.custCrcUpdUserId = custCrcUpdUserId;
	}

	public Date getCustCrcUpdDt() {
		return custCrcUpdDt;
	}

	public void setCustCrcUpdDt(Date custCrcUpdDt) {
		this.custCrcUpdDt = custCrcUpdDt;
	}

	public String getCustCrcExpr() {
		return custCrcExpr;
	}

	public void setCustCrcExpr(String custCrcExpr) {
		this.custCrcExpr = custCrcExpr;
	}

	public int getCustCrcIdOld() {
		return custCrcIdOld;
	}

	public void setCustCrcIdOld(int custCrcIdOld) {
		this.custCrcIdOld = custCrcIdOld;
	}

	public int getSoId() {
		return soId;
	}

	public void setSoId(int soId) {
		this.soId = soId;
	}

	public int getCustCrcIdcm() {
		return custCrcIdcm;
	}

	public void setCustCrcIdcm(int custCrcIdcm) {
		this.custCrcIdcm = custCrcIdcm;
	}

	public int getCustCrcCrtUserId() {
		return custCrcCrtUserId;
	}

	public void setCustCrcCrtUserId(int custCrcCrtUserId) {
		this.custCrcCrtUserId = custCrcCrtUserId;
	}

	public Date getCustCrcCrtDt() {
		return custCrcCrtDt;
	}

	public void setCustCrcCrtDt(Date custCrcCrtDt) {
		this.custCrcCrtDt = custCrcCrtDt;
	}

	public int getCardTypeId() {
		return cardTypeId;
	}

	public void setCardTypeId(int cardTypeId) {
		this.cardTypeId = cardTypeId;
	}

	public String getCrcToken() {
        return crcToken;
    }

    public void setCrcToken(String crcToken) {
        this.crcToken = crcToken;
    }

}