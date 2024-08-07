package com.coway.trust.biz.sales.order.vo;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;


/**
 * The persistent class for the SVC0001D database table.
 *
 */
public class ASEntryVO implements Serializable {
	private static final long serialVersionUID = 1L;

	private int asId;

	private String asNo;

	private int asSoId;

	private int asMemId;

	private String asMemGrp;

	private Date asReqstDt;

	private String asReqstTm;

	private String asAppntDt;

	private String asAppntTm;

	private int asBrnchId;

	private int asMalfuncId;

	private int asMalfuncResnId;

	private String asRemReqster;

	private String asRemReqsterCntc;

	private int asCalllogId;

	private int asStusId;

	private int asSms;

	private int asCrtUserId;

	private Date asCrtDt;

	private int asUpdUserId;

	private Date asUpdDt;

	private int asEntryIsSynch;

	private int asEntryIsEdit;

	private int asTypeId;

	private int asReqsterTypeId;

	private int asIsBSWithin30days;

	private int asAllowComm;

	private int asPrevMemId;

	private String asRemAddCntc;

	private int asRemReqsterCntcSms;

	private int asRemAddCntcSms;

	private String asSesionCode;

	private String callMem;

	private String refReqst;

	private String prevCompSvc;

	private String nextCompSvc;

	private Date signDtTime;

	private int compDtSeq;

	private int distance;

	private String first;

	private String last;

	private String home;

	private String asMobileReqstId;

	private String asRqstRem;

	private String prevSvcArea;

	private String nextSvcArea;

	private String asIfFlag;

	public ASEntryVO() {
	}

	public int getAsId() {
		return asId;
	}

	public void setAsId(int asId) {
		this.asId = asId;
	}

	public String getAsNo() {
		return asNo;
	}

	public void setAsNo(String asNo) {
		this.asNo = asNo;
	}

	public int getAsSoId() {
		return asSoId;
	}

	public void setAsSoId(int asSoId) {
		this.asSoId = asSoId;
	}

	public int getAsMemId() {
		return asMemId;
	}

	public void setAsMemId(int asMemId) {
		this.asMemId = asMemId;
	}

	public String getAsMemGrp() {
		return asMemGrp;
	}

	public void setAsMemGrp(String asMemGrp) {
		this.asMemGrp = asMemGrp;
	}

	public Date getAsReqstDt() {
		return asReqstDt;
	}

	public void setAsReqstDt(Date asReqstDt) {
		this.asReqstDt = asReqstDt;
	}

	public String getAsReqstTm() {
		return asReqstTm;
	}

	public void setAsReqstTm(String asReqstTm) {
		this.asReqstTm = asReqstTm;
	}

	public String getAsAppntDt() {
		return asAppntDt;
	}

	public void setAsAppntDt(String asAppntDt) {
		this.asAppntDt = asAppntDt;
	}

	public String getAsAppntTm() {
		return asAppntTm;
	}

	public void setAsAppntTm(String asAppntTm) {
		this.asAppntTm = asAppntTm;
	}

	public int getAsBrnchId() {
		return asBrnchId;
	}

	public void setAsBrnchId(int asBrnchId) {
		this.asBrnchId = asBrnchId;
	}

	public int getAsMalfuncId() {
		return asMalfuncId;
	}

	public void setAsMalfuncId(int asMalfuncId) {
		this.asMalfuncId = asMalfuncId;
	}

	public int getAsMalfuncResnId() {
		return asMalfuncResnId;
	}

	public void setAsMalfuncResnId(int asMalfuncResnId) {
		this.asMalfuncResnId = asMalfuncResnId;
	}

	public String getAsRemReqster() {
		return asRemReqster;
	}

	public void setAsRemReqster(String asRemReqster) {
		this.asRemReqster = asRemReqster;
	}

	public String getAsRemReqsterCntc() {
		return asRemReqsterCntc;
	}

	public void setAsRemReqsterCntc(String asRemReqsterCntc) {
		this.asRemReqsterCntc = asRemReqsterCntc;
	}

	public int getAsCalllogId() {
		return asCalllogId;
	}

	public void setAsCalllogId(int asCalllogId) {
		this.asCalllogId = asCalllogId;
	}

	public int getAsStusId() {
		return asStusId;
	}

	public void setAsStusId(int asStusId) {
		this.asStusId = asStusId;
	}

	public int getAsSms() {
		return asSms;
	}

	public void setAsSms(int asSms) {
		this.asSms = asSms;
	}

	public int getAsCrtUserId() {
		return asCrtUserId;
	}

	public void setAsCrtUserId(int asCrtUserId) {
		this.asCrtUserId = asCrtUserId;
	}

	public Date getAsCrtDt() {
		return asCrtDt;
	}

	public void setAsCrtDt(Date asCrtDt) {
		this.asCrtDt = asCrtDt;
	}

	public int getAsUpdUserId() {
		return asUpdUserId;
	}

	public void setAsUpdUserId(int asUpdUserId) {
		this.asUpdUserId = asUpdUserId;
	}

	public Date getAsUpdDt() {
		return asUpdDt;
	}

	public void setAsUpdDt(Date asUpdDt) {
		this.asUpdDt = asUpdDt;
	}

	public int getAsEntryIsSynch() {
		return asEntryIsSynch;
	}

	public void setAsEntryIsSynch(int asEntryIsSynch) {
		this.asEntryIsSynch = asEntryIsSynch;
	}

	public int getAsEntryIsEdit() {
		return asEntryIsEdit;
	}

	public void setAsEntryIsEdit(int asEntryIsEdit) {
		this.asEntryIsEdit = asEntryIsEdit;
	}

	public int getAsTypeId() {
		return asTypeId;
	}

	public void setAsTypeId(int asTypeId) {
		this.asTypeId = asTypeId;
	}

	public int getAsReqsterTypeId() {
		return asReqsterTypeId;
	}

	public void setAsReqsterTypeId(int asReqsterTypeId) {
		this.asReqsterTypeId = asReqsterTypeId;
	}

	public int getAsIsBSWithin30days() {
		return asIsBSWithin30days;
	}

	public void setAsIsBSWithin30days(int asIsBSWithin30days) {
		this.asIsBSWithin30days = asIsBSWithin30days;
	}

	public int getAsAllowComm() {
		return asAllowComm;
	}

	public void setAsAllowComm(int asAllowComm) {
		this.asAllowComm = asAllowComm;
	}

	public int getAsPrevMemId() {
		return asPrevMemId;
	}

	public void setAsPrevMemId(int asPrevMemId) {
		this.asPrevMemId = asPrevMemId;
	}

	public String getAsRemAddCntc() {
		return asRemAddCntc;
	}

	public void setAsRemAddCntc(String asRemAddCntc) {
		this.asRemAddCntc = asRemAddCntc;
	}

	public int getAsRemReqsterCntcSms() {
		return asRemReqsterCntcSms;
	}

	public void setAsRemReqsterCntcSms(int asRemReqsterCntcSms) {
		this.asRemReqsterCntcSms = asRemReqsterCntcSms;
	}

	public int getAsRemAddCntcSms() {
		return asRemAddCntcSms;
	}

	public void setAsRemAddCntcSms(int asRemAddCntcSms) {
		this.asRemAddCntcSms = asRemAddCntcSms;
	}

	public String getAsSesionCode() {
		return asSesionCode;
	}

	public void setAsSesionCode(String asSesionCode) {
		this.asSesionCode = asSesionCode;
	}

	public String getCallMem() {
		return callMem;
	}

	public void setCallMem(String callMem) {
		this.callMem = callMem;
	}

	public String getRefReqst() {
		return refReqst;
	}

	public void setRefReqst(String refReqst) {
		this.refReqst = refReqst;
	}

	public String getPrevCompSvc() {
		return prevCompSvc;
	}

	public void setPrevCompSvc(String prevCompSvc) {
		this.prevCompSvc = prevCompSvc;
	}

	public String getNextCompSvc() {
		return nextCompSvc;
	}

	public void setNextCompSvc(String nextCompSvc) {
		this.nextCompSvc = nextCompSvc;
	}

	public Date getSignDtTime() {
		return signDtTime;
	}

	public void setSignDtTime(Date signDtTime) {
		this.signDtTime = signDtTime;
	}

	public int getCompDtSeq() {
		return compDtSeq;
	}

	public void setCompDtSeq(int compDtSeq) {
		this.compDtSeq = compDtSeq;
	}

	public int getDistance() {
		return distance;
	}

	public void setDistance(int distance) {
		this.distance = distance;
	}

	public String getFirst() {
		return first;
	}

	public void setFirst(String first) {
		this.first = first;
	}

	public String getLast() {
		return last;
	}

	public void setLast(String last) {
		this.last = last;
	}

	public String getHome() {
		return home;
	}

	public void setHome(String home) {
		this.home = home;
	}

	public String getAsMobileReqstId() {
		return asMobileReqstId;
	}

	public void setAsMobileReqstId(String asMobileReqstId) {
		this.asMobileReqstId = asMobileReqstId;
	}

	public String getAsRqstRem() {
		return asRqstRem;
	}

	public void setAsRqstRem(String asRqstRem) {
		this.asRqstRem = asRqstRem;
	}

	public String getPrevSvcArea() {
		return prevSvcArea;
	}

	public void setPrevSvcArea(String prevSvcArea) {
		this.prevSvcArea = prevSvcArea;
	}

	public String getNextSvcArea() {
		return nextSvcArea;
	}

	public void setNextSvcArea(String nextSvcArea) {
		this.nextSvcArea = nextSvcArea;
	}

	public String getAsIfFlag() {
		return asIfFlag;
	}

	public void setAsIfFlag(String asIfFlag) {
		this.asIfFlag = asIfFlag;
	}



}