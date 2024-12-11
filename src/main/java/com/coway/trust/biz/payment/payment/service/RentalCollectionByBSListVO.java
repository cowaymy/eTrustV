package com.coway.trust.biz.payment.payment.service;

import java.io.Serializable;

public class RentalCollectionByBSListVO implements Serializable {

	private String sID;
	private String tOrgCode;
	private String tGrpCode;
	private String tDeptCode;
	private String orgCode;
	private String grpCode;
	private String deptCode;
	private String memCode;
	private String sUnit;
	private String sLmos;
	private String sCmChg;
	private String sClCtg;
	private String sCol;
	private String sAdj;
	private String sOut;
	private String sOutRate;
	private String indOrd;
	private String corpOrd;
	private String corpRatio;
	private String rcPrct;
	private String adRatio;
	private String cmName;
	private String branch;
	private String region;
	private String srvType;

	public String getsID() {
		return sID;
	}
	public void setsID(String sID) {
		this.sID = sID;
	}
	public String gettOrgCode() {
		return tOrgCode;
	}
	public void settOrgCode(String tOrgCode) {
		this.tOrgCode = tOrgCode;
	}
	public String gettGrpCode() {
		return tGrpCode;
	}
	public void settGrpCode(String tGrpCode) {
		this.tGrpCode = tGrpCode;
	}
	public String gettDeptCode() {
		return tDeptCode;
	}
	public void settDeptCode(String tDeptCode) {
		this.tDeptCode = tDeptCode;
	}
	public String getOrgCode() {
		return orgCode;
	}
	public void setOrgCode(String orgCode) {
		this.orgCode = orgCode;
	}
	public String getGrpCode() {
		return grpCode;
	}
	public void setGrpCode(String grpCode) {
		this.grpCode = grpCode;
	}
	public String getDeptCode() {
		return deptCode;
	}
	public void setDeptCode(String deptCode) {
		this.deptCode = deptCode;
	}
	public String getMemCode() {
		return memCode;
	}
	public void setMemCode(String memCode) {
		this.memCode = memCode;
	}
	public String getsUnit() {
		return sUnit;
	}
	public void setsUnit(String sUnit) {
		this.sUnit = sUnit;
	}
	public String getsLmos() {
		return sLmos;
	}
	public void setsLmos(String sLmos) {
		this.sLmos = sLmos;
	}
	public String getsCmChg() {
		return sCmChg;
	}
	public void setsCmChg(String sCmChg) {
		this.sCmChg = sCmChg;
	}
	public String getsClCtg() {
		return sClCtg;
	}
	public void setsClCtg(String sClCtg) {
		this.sClCtg = sClCtg;
	}
	public String getsCol() {
		return sCol;
	}
	public void setsCol(String sCol) {
		this.sCol = sCol;
	}
	public String getsAdj() {
		return sAdj;
	}
	public void setsAdj(String sAdj) {
		this.sAdj = sAdj;
	}
	public String getsOut() {
		return sOut;
	}
	public void setsOut(String sOut) {
		this.sOut = sOut;
	}
	public String getsOutRate() {
		return sOutRate;
	}
	public void setsOutRate(String sOutRate) {
		this.sOutRate = sOutRate;
	}
	public String getindOrd() {
        return indOrd;
    }
    public void setindOrd(String indOrd) {
        this.indOrd = indOrd;
    }
    public String getcorpOrd() {
        return corpOrd;
    }
    public void setcorpOrd(String corpOrd) {
        this.corpOrd = corpOrd;
    }
    public String getcorpRatio() {
        return corpRatio;
    }
    public void setcorpRatio(String corpRatio) {
        this.corpRatio = corpRatio;
    }
    public String getrcPrct() {
        return rcPrct;
    }
    public void setrcPrct(String rcPrct) {
        this.rcPrct = rcPrct;
    }
    public String getadRatio() {
        return adRatio;
    }
    public void setadRatio(String adRatio) {
        this.adRatio = adRatio;
    }

	public String getCmName() {
        return cmName;
    }
    public void setCmName(String cmName) {
        this.cmName = cmName;
    }

	public String getBranch() {
        return branch;
    }
    public void setBranch(String branch) {
        this.branch = branch;
    }

	public String getRegion() {
        return region;
    }
    public void setRegion(String region) {
        this.region = region;
    }

    public String getSrvType(){
    	return srvType;
    }
    public void setSrvType(String srvType){
    	this.srvType = srvType;
    }

}
