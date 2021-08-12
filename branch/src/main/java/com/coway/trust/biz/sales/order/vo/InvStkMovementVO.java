package com.coway.trust.biz.sales.order.vo;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;


/**
 * The persistent class for the LOG0013D database table.
 * 
 */
public class InvStkMovementVO implements Serializable {
	private static final long serialVersionUID = 1L;

	private int movId;
	
	private int installEntryId;
	
	private int movFromLocId;
	
	private int movToLocId;
	
	private int movTypeId;
	
	private int movStusId;
	
	private int movCnfm;
	
	private String movCrtDt;
	
	private String movUpdDt;
	
	private int movCrtUserId;
	
	private int movUpdUserId;
	
	private int stkCrdPost;
	
	private String stkCrdPostDt;
	
	private int stkCrdPostToWebOnTm;

	public int getMovId() {
		return movId;
	}

	public void setMovId(int movId) {
		this.movId = movId;
	}

	public int getInstallEntryId() {
		return installEntryId;
	}

	public void setInstallEntryId(int installEntryId) {
		this.installEntryId = installEntryId;
	}

	public int getMovFromLocId() {
		return movFromLocId;
	}

	public void setMovFromLocId(int movFromLocId) {
		this.movFromLocId = movFromLocId;
	}

	public int getMovToLocId() {
		return movToLocId;
	}

	public void setMovToLocId(int movToLocId) {
		this.movToLocId = movToLocId;
	}

	public int getMovTypeId() {
		return movTypeId;
	}

	public void setMovTypeId(int movTypeId) {
		this.movTypeId = movTypeId;
	}

	public int getMovStusId() {
		return movStusId;
	}

	public void setMovStusId(int movStusId) {
		this.movStusId = movStusId;
	}

	public int getMovCnfm() {
		return movCnfm;
	}

	public void setMovCnfm(int movCnfm) {
		this.movCnfm = movCnfm;
	}

	public String getMovCrtDt() {
		return movCrtDt;
	}

	public void setMovCrtDt(String movCrtDt) {
		this.movCrtDt = movCrtDt;
	}

	public String getMovUpdDt() {
		return movUpdDt;
	}

	public void setMovUpdDt(String movUpdDt) {
		this.movUpdDt = movUpdDt;
	}

	public int getMovCrtUserId() {
		return movCrtUserId;
	}

	public void setMovCrtUserId(int movCrtUserId) {
		this.movCrtUserId = movCrtUserId;
	}

	public int getMovUpdUserId() {
		return movUpdUserId;
	}

	public void setMovUpdUserId(int movUpdUserId) {
		this.movUpdUserId = movUpdUserId;
	}

	public int getStkCrdPost() {
		return stkCrdPost;
	}

	public void setStkCrdPost(int stkCrdPost) {
		this.stkCrdPost = stkCrdPost;
	}

	public String getStkCrdPostDt() {
		return stkCrdPostDt;
	}

	public void setStkCrdPostDt(String stkCrdPostDt) {
		this.stkCrdPostDt = stkCrdPostDt;
	}

	public int getStkCrdPostToWebOnTm() {
		return stkCrdPostToWebOnTm;
	}

	public void setStkCrdPostToWebOnTm(int stkCrdPostToWebOnTm) {
		this.stkCrdPostToWebOnTm = stkCrdPostToWebOnTm;
	}
	
}